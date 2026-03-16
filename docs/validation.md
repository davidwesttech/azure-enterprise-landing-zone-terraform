# Deployment Validation

This document describes how to verify that the Azure Landing Zone infrastructure was successfully deployed.

The validation steps confirm that networking, governance, platform services, and workload resources were created correctly.

---

# Resource Groups

Verify that the following resource groups exist.

Expected Resource Groups

• rg-platform-management-dev
• rg-platform-connectivity-dev
• rg-workload-dev

Azure CLI command:

```
az group list --output table
```

---

# Virtual Networks

Verify that both hub and spoke networks were created.

Expected Networks

Hub Network
• vnet-hub-dev

Spoke Network
• vnet-spoke-dev

Azure CLI command:

```
az network vnet list --output table
```

---

# Subnet Configuration

Verify that the correct subnets exist within each network.

Hub Network Subnets

• snet-shared-services – 10.0.1.0/24
• AzureFirewallSubnet – 10.0.2.0/24
• GatewaySubnet – 10.0.3.0/24

Spoke Network Subnets

• snet-app – 10.1.1.0/24
• snet-private-endpoints – 10.1.2.0/24

Azure CLI command:

```
az network vnet subnet list \
--resource-group rg-platform-connectivity-dev \
--vnet-name vnet-hub-dev
```

---

# Hub-Spoke VNet Peering

Verify that the hub and spoke networks are connected.

Expected Peering

• hub-to-spoke
• spoke-to-hub

Azure CLI command:

```
az network vnet peering list \
--resource-group rg-platform-connectivity-dev \
--vnet-name vnet-hub-dev \
--output table
```

---

# Governance Policies

Verify that Azure Policy assignments exist.

Expected Policies

• Allowed Locations
• Require
