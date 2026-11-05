# Azure Enterprise Landing Zone with Terraform

A modular Azure landing-zone foundation built with Terraform, demonstrating **hub-and-spoke networking, centralized platform management, governance, role-based access control, and workload resource provisioning**.

> **Implementation scope:** The repository provisions **one hub VNet and one development spoke VNet**, bidirectional VNet peering, a Log Analytics workspace, subscription-level Azure Policy assignments, RBAC assignments, a Storage account, and a Key Vault. It reserves subnets for Azure Firewall and a future gateway, but **does not currently deploy Azure Firewall, Azure Bastion, network security groups (NSGs), user-defined routes (UDRs), or a production spoke**. Those controls are discussed below as enterprise design requirements—not claimed as deployed features.

## 1. Problem: What real-world scenario does this solve?

An organization expanding its Azure footprint may initially deploy applications, infrastructure, and networking independently. This can lead to inconsistent resource naming and governance, duplicated shared infrastructure, excessive permissions, and limited visibility across environments. As development and production workloads grow, a flat network can also increase the risk of unintended access between environments.

This project addresses the **landing-zone foundation** of that problem by using Infrastructure as Code to establish a repeatable platform layout:

- A **hub VNet** provides a centralized network location for shared connectivity and, in a more complete deployment, services such as a firewall and secure administrative access.
- A **spoke VNet** provides a separate network boundary for application workloads and private endpoints.
- **VNet peering** connects the hub and development spoke without putting every workload into a single flat VNet.
- **Azure Policy** applies subscription-level controls for approved regions and required environment tags.
- **Azure RBAC** demonstrates access assignments at different scopes.
- **Log Analytics** provides a centrally managed workspace that resources can use as a logging destination once diagnostic settings are configured.
- **Terraform modules and an Azure Storage backend** support consistent infrastructure provisioning and shared state management.

**Business value:** This creates a reusable starting point for platform teams onboarding new workloads. It separates platform responsibilities from workload responsibilities and makes governance and infrastructure changes reviewable as code. It is an architectural foundation, not a claim that production-grade network isolation has already been completed.

## 2. Architecture: How is it designed?

![Azure landing zone architecture](docs/architecture.png)

### Deployed architecture

| Layer | Azure resources | Purpose |
| --- | --- | --- |
| Platform connectivity (hub) | `vnet-hub-dev` (`10.0.0.0/16`), shared-services subnet (`10.0.1.0/24`), `AzureFirewallSubnet` (`10.0.2.0/24`), `GatewaySubnet` (`10.0.3.0/24`) | Establish shared network address space and reserve subnet capacity for future services. |
| Workload (development spoke) | `vnet-spoke-dev` (`10.1.0.0/16`), application subnet (`10.1.1.0/24`), private-endpoints subnet (`10.1.2.0/24`) | Separate application and potential private endpoint placement from the platform network. |
| Connectivity | Bidirectional hub-to-spoke VNet peering with virtual network access and forwarded traffic enabled | Provide private network connectivity between the two VNets. |
| Platform monitoring | `law-lz-dev` Log Analytics workspace, configured for 30-day retention | Centralize a logging destination for future diagnostic integrations. |
| Governance | Subscription-level Allowed Locations and Require Environment Tag policy assignments | Constrain deployment regions and standardize resource metadata. |
| Identity and authorization | Subscription Reader, workload resource-group Contributor, Key Vault Administrator assignments | Demonstrate Azure RBAC scopes and resource-specific administrative access. |
| Workload foundation | Azure Storage account (Standard LRS, minimum TLS 1.2), Azure Key Vault | Provide example workload resources managed by Terraform. |

The deployment entry point is [`environments/dev/main.tf`](environments/dev/main.tf). Its modules live under [`modules/`](modules/).

### How traffic flows today

The hub and development spoke have **bidirectional VNet peering**. Both peering directions set `allow_virtual_network_access = true` and `allow_forwarded_traffic = true`. The latter permits forwarded traffic across the peering; **it does not, by itself, force traffic through a firewall or inspect packets**.

Because the current Terraform does not create an Azure Firewall or route tables directing traffic to it, it would be inaccurate to say that all application traffic is centrally inspected. Likewise, there is no production spoke in the current deployment to test cross-environment isolation.

### Intended enterprise hub-and-spoke security model

In a hardened multi-environment implementation, **shared security and connectivity services belong in the hub**, while workloads remain in separate spokes:

- **Azure Firewall in the hub:** A centralized policy enforcement and inspection point for explicitly routed outbound and inter-spoke flows.
- **Azure Bastion in the hub:** Controlled administrative connectivity to private VMs without assigning public IPs to workload hosts.
- **Central monitoring:** A shared Log Analytics workspace and diagnostic settings for firewalls, infrastructure, and workloads. The workspace can live in a dedicated management resource group or management subscription; it does not need to reside inside a VNet.
- **NSGs at spoke subnet boundaries:** Workload-specific allow/deny rules limiting inbound and outbound flows. For example, a development application subnet should not have a broad allow rule to production services.
- **UDRs and firewall policy:** Routes send selected spoke traffic through Azure Firewall. Firewall rule collections specify which sources, destinations, ports, and protocols are permitted. Route design must explicitly cover **inter-spoke** traffic as well as internet-bound traffic; a default route alone is not proof of complete east-west inspection.

A useful target traffic path is **Dev Spoke → NSG → UDR → Azure Firewall (hub) → permitted destination**, subject to return-path routing and policies. The firewall and NSGs play complementary roles: NSGs provide subnet/NIC-level filtering, while the firewall can provide centralized inspection and policy enforcement for traffic actually routed through it.

#### Why development-to-production isolation matters

Imagine a development VM becomes compromised or a developer deploys an overly permissive service. If an NSG, route, firewall rule, or peering configuration mistakenly permits development traffic to reach production, an attacker or faulty workload could potentially probe production endpoints, connect to exposed application ports, or attempt lateral movement. Whether access succeeds would still depend on destination services, identities, host firewalls, and additional controls.

**Expected enterprise behavior:** Development-to-production connectivity is denied by default unless there is an explicitly approved business need. That requirement must be implemented and verified with the appropriate NSGs, routes, firewall rules, identity controls, and connectivity tests. **It is not currently enforced by this one-spoke Terraform deployment.**

## 3. Architecture decisions and tradeoffs

| Decision | Why it was selected | Tradeoff / limitation |
| --- | --- | --- |
| Hub-and-spoke topology | Keeps a shared connectivity layer separate from application address space and supports onboarding more spokes. | More peering, routing, and policy coordination than a single VNet; centralized inspection requires additional resources and configuration. |
| Modular Terraform | Separates networking, peering, logging, governance, access control, and workload resources for easier reuse and review. | More variable/output wiring and dependencies than a single Terraform file. |
| Separate hub and workload resource groups | Makes platform and workload ownership easier to distinguish. | Requires disciplined RBAC, tagging, and cross-resource references. |
| Explicit address planning | Non-overlapping `10.0.0.0/16` and `10.1.0.0/16` ranges simplify initial peering and leave space for subnet segmentation. | Address space must be coordinated with future Azure spokes and on-premises networks to prevent overlap. |
| Bidirectional VNet peering | Enables private connectivity between the development spoke and hub. | Peering is not a transit firewall; forwarded-traffic settings do not enforce security or automatically create routing paths. |
| Log Analytics workspace | Establishes a central place to collect operational/security logs. | A workspace alone does not ingest all resource logs; diagnostic settings, data collection, alerting, and retention/cost decisions are separate work. |
| Built-in Azure Policies | Uses established definitions for location restrictions and tagging rather than custom policy logic. | Subscription-scoped assignments can affect other resources; definition effects, exemptions, and compliance behavior require validation. |
| Scoped RBAC assignments | Demonstrates differences between read-only subscription visibility and workload resource-group contribution. | Current assignment targets the identity running Terraform; this is educational but should be replaced with defined groups/managed identities and least-privilege roles in an enterprise. |
| Azure Storage + Key Vault | Provides a realistic example of workload resource provisioning and baseline secure configuration, including Storage TLS 1.2 minimum. | The code does not establish private endpoints or disable every public network path; Key Vault purge protection is disabled in this development example. |
| Azure Storage Terraform backend | Allows remote state rather than relying on local state for collaborative infrastructure workflows. | The backend storage account/container and authentication must be configured separately; state access and locking deserve special protection. |

### Why not put everything into one VNet?

A flat VNet may be faster to create for a single small workload. For organizations running multiple applications and environments, however, it complicates ownership and makes it harder to apply consistent connectivity and security controls at environment boundaries. Hub-and-spoke adds complexity, but offers a clearer organizational model and a path to centralized services. **The separation alone is not a security guarantee**; routing and security rules must enforce the intended boundaries.

## 4. Challenges, troubleshooting, and lessons learned

> **Evidence note:** The repository documents the final Terraform configuration, not a verified history of failed deployments or troubleshooting incidents. The cases below are **engineering risks and validation checks**, not claims that these exact failures happened during the original build.

| Potential challenge | What would go wrong | How to diagnose it | Resolution / prevention |
| --- | --- | --- | --- |
| Peering appears connected but communication fails | Workloads cannot reach expected private destinations. | Inspect both peering directions, effective routes, Network Watcher connection troubleshooting, and applicable NSGs. | Validate address spaces, bidirectional peering, and actual path permissions. |
| Assumed firewall inspection without forced routing | Spoke traffic takes a route that bypasses the intended inspection point. | Use Network Watcher **Next hop** and inspect effective routes/UDRs and firewall logs. | Deploy Azure Firewall plus explicit routing and policy; test actual traffic paths before claiming inspection. |
| Overly permissive dev-to-prod access | Development workloads may be able to initiate unexpected connections to production. | Test approved and denied source/destination/port combinations; inspect NSG rules, effective security rules, UDRs, and firewall decisions. | Default-deny cross-environment flows, scope exceptions narrowly, and continuously validate isolation. |
| Logging exists but telemetry is missing | The workspace has been provisioned, but expected resource events are absent. | Inspect diagnostic settings, data collection configuration, workspace tables, and ingestion status. | Connect target resources to the workspace and define useful alerts and retention. |
| Policy or RBAC unexpectedly blocks deployments | A permitted deployment fails authorization or policy checks. | Review Azure Activity Log, policy compliance/deny details, role assignments, and role scope. | Correct policy parameters or approved exemptions; grant the minimal appropriate permissions. |
| Terraform state or backend initialization issues | Plans/applies cannot initialize or may encounter access problems. | Run `terraform init`, inspect backend parameters, Azure identity permissions, and state storage access. | Bootstrap and protect the backend before environment deployment; keep credentials and state out of Git. |

### Lessons demonstrated by the implementation

1. **Modularity helps scale:** Each platform concern has a defined Terraform module, so expansion can be planned without putting all resources into one configuration.
2. **Network structure is not network enforcement:** Peering and reserved firewall subnets provide a foundation, but neither guarantees traffic inspection or spoke isolation.
3. **Governance and access management are part of the landing zone:** Policy and RBAC belong in the platform baseline, not as afterthoughts.
4. **Observability requires wiring:** Creating Log Analytics is the first step; sending and validating diagnostic data is what makes monitoring operational.
5. **Claims should be testable:** Production-readiness requires evidence from effective routes, firewall logs, NSG rules, deployment validation, and security testing.

## Repository structure

```text
.
├── README.md
├── docs/
│   └── architecture.png          # Existing architecture diagram
├── environments/
│   └── dev/
│       ├── main.tf               # Development environment module composition
│       └── providers.tf          # Terraform, AzureRM provider, remote backend
└── modules/
    ├── hub_network/              # Hub VNet and reserved service subnets
    ├── spoke_network/            # Development VNet and workload subnets
    ├── network_peering/          # Two-way hub/spoke peerings
    ├── logging/                  # Log Analytics workspace
    ├── policy_assignments/       # Allowed regions and required tagging
    ├── role_assignments/         # Subscription and resource-group roles
    └── workload_landing_zone/    # Storage account and Key Vault
```

Other variables, outputs, documentation, and deployment artifacts may be present in the repository; this tree highlights the core entry points and modules.

## Deployment overview

**Prerequisites:** An Azure subscription, a suitably authorized Azure identity, Azure CLI, and Terraform **1.6 or newer**. The configuration uses the `hashicorp/azurerm` provider `~> 4.0`.

1. Authenticate with Azure and select the intended subscription.
2. Provision/configure a suitable Azure Storage backend for Terraform state, then supply its backend settings at initialization.
3. Review the variables, subscription ID, deployment region, role assignments, and resource naming in `environments/dev`.
4. From the development environment directory, initialize, review, and apply:

```bash
cd environments/dev
az login
az account set --subscription "<subscription-id>"
terraform init -backend-config="<backend-config-file>"
terraform validate
terraform plan
terraform apply
```

The backend config file is an example placeholder, **not** a file this README claims already exists. Supply backend settings using your own method and keep secrets out of source control. Azure Policy and RBAC operations may require permissions beyond ordinary resource-group Contributor.

> **Cost/security note:** Review subscription-level Azure Policy scope and RBAC changes before applying. This is a reference deployment; do not assume the development workload configuration is production hardened.

## Suggested validation

These checks help confirm what the Terraform provisions; they are not presented as historical test results.

- [ ] `terraform validate` passes and the expected plan matches the target subscription and region.
- [ ] Hub (`10.0.0.0/16`) and spoke (`10.1.0.0/16`) VNets and their subnet ranges are created.
- [ ] Hub-to-spoke and spoke-to-hub peerings show **Connected**.
- [ ] Log Analytics workspace exists with its configured retention.
- [ ] Subscription policy assignments for allowed regions and the `environment` tag exist.
- [ ] RBAC assignments exist at the intended subscription/resource-group/Key Vault scopes.
- [ ] Storage account and Key Vault are created with expected settings.
- [ ] Remote state is stored in the intended secured Azure backend.

**Additional checks required before describing this as an enforced, multi-spoke security design:** Deploy and validate NSGs, hub firewall, UDRs, Bastion, diagnostic settings, and a separate production spoke; confirm forbidden dev-to-prod traffic fails and authorized flows work as designed.

## Current scope vs. future hardening

| Implemented in Terraform | Additional production-hardening work |
| --- | --- |
| Hub and development spoke VNets | Separate production spoke and environment isolation tests |
| Bidirectional VNet peering | Azure Firewall deployment, policies, and verified inspection routes |
| Reserved `AzureFirewallSubnet` and `GatewaySubnet` | Firewall/gateway resources as needed; Azure Bastion and its required subnet |
| Log Analytics workspace | Diagnostic settings, log ingestion validation, dashboards/alerts |
| Azure Policy and RBAC assignments | Least-privilege identity model, policy compliance/exemption review |
| Storage account and Key Vault | Private endpoints/private DNS, public access restrictions, stronger Key Vault recovery controls |
| Remote-state backend declaration | Secured, pre-provisioned state backend and delivery pipeline |

## Key takeaway

This project shows how to assemble the **foundational building blocks of an Azure enterprise landing zone using reusable Terraform modules**. The architecture separates shared connectivity from workload networking and introduces governance, centralized logging infrastructure, RBAC, and remote state. The natural next security milestone is to **enforce and prove** hub inspection and spoke isolation with Azure Firewall, Bastion, NSGs, UDRs, and explicit dev-to-production connectivity tests.
