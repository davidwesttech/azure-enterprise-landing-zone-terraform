# Design Decisions

This document outlines the key architectural decisions made when designing this Azure landing zone.

The goal of the project was to demonstrate how enterprise-style Azure infrastructure can be deployed using Infrastructure as Code while following cloud architecture best practices.

---

# Landing Zone Structure

The environment is organized using a layered architecture.

Layers

• Governance
• Platform Management
• Platform Connectivity
• Workload Landing Zone

This structure separates platform infrastructure from application workloads, which improves security, operational control, and scalability.

---

# Single Subscription Deployment

This implementation uses a single Azure subscription.

Reason

The environment was built using a personal Azure tenant with limited permissions, which prevented the creation of additional subscriptions and management groups.

Production environments would typically use:

• Management Groups
• Multiple subscriptions
• Platform and workload subscription separation

Despite this limitation, the Terraform modules were designed so the architecture could easily be expanded into a multi-subscription environment.

---

# Hub-and-Spoke Networking

A hub-and-spoke network topology was selected.

Hub Network

The hub virtual network contains shared connectivity infrastructure and reserved subnets for network services.

Reserved subnets

• AzureFirewallSubnet
• GatewaySubnet

Spoke Network

The spoke network hosts application workloads.

Benefits of hub-and-spoke architecture

• centralized network security
• workload isolation
• simplified connectivity management
• scalable architecture for additional workloads

This is one of the most commonly recommended network architectures for Azure environments.

---

# Subnet Design

Subnet ranges were intentionally segmented to allow future expansion.

Hub Network

• Shared Services Subnet
• Azure Firewall Subnet
• Gateway Subnet

Spoke Network

• Application Subnet
• Private Endpoints Subnet

The private endpoint subnet allows future implementation of private access to platform services.

---

# Governance Controls

Governance is implemented using Azure Policy.

Policies Implemented

Allowed Locations

Restricts resource deployments to approved Azure regions.

Require Environment Tag

Ensures resources contain an environment tag for organization and cost management.

These policies demonstrate how organizations can enforce standards across Azure environments.

---

# Role-Based Access Control

RBAC assignments follow the principle of least privilege.

Subscription Scope

Reader role is assigned at the subscription level to allow visibility without modification privileges.

Workload Resource Group Scope

Contributor role is assigned at the workload resource group to allow application-level resource management.

This model separates platform oversight from workload modification privileges.

---

# Centralized Logging

A Log Analytics workspace is deployed within the platform management resource group.

Purpose

Centralized logging allows diagnostics and monitoring data to be collected from both platform and workload resources.

Benefits

• improved troubleshooting
• centralized monitoring
• future integration with alerting systems

---

# Workload Deployment

A sample workload was deployed in the spoke network.

Resources

• Storage Account
• Key Vault

These services represent common application infrastructure components and demonstrate how workloads can be deployed within the landing zone architecture.

---

# Infrastructure as Code

Terraform was used to deploy all infrastructure components.

Benefits

• repeatable infrastructure deployment
• version-controlled infrastructure configuration
• modular architecture design

Terraform modules were used to separate infrastructure responsibilities.

Modules

• logging
• hub_network
• spoke_network
• network_peering
• policy_assignments
• role_assignments
• workload_landing_zone

This modular structure allows the landing zone to be extended or reused across multiple environments.

---

# Future Enhancements

The architecture can be expanded with additional enterprise capabilities.

Potential improvements

• Azure Firewall deployment in the hub network
• Private Endpoints for storage and Key Vault
• Diagnostic settings sending logs to Log Analytics
• CI/CD pipeline for Terraform deployments
• Multi-subscription landing zone architecture

These improvements would move the environment closer to a full enterprise landing zone implementation.
