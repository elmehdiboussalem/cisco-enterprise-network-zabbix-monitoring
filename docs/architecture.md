# Architecture details

All values below come from the project report. The lab was built in GNS3.

## Layers

| Layer | Role |
|---|---|
| Access | Connects end users (VLAN 10 / 20 / 30) |
| Distribution | Aggregates access links, EtherChannel uplinks to the core |
| Core | High-speed backbone; Core Principal + Core Standby, inter-VLAN routing (SVI), GLBP |
| Edge | R1 (router) and Cisco ASA (perimeter security, NAT, DMZ) |

## VLANs and SVI redundancy

| VLAN | Network | Core Principal | Core Standby | GLBP virtual IP |
|---|---|---|---|---|
| 10 (Management) | 192.168.10.0/24 | 192.168.10.1 | 192.168.10.2 | 192.168.10.254 |
| 20 (Users A) | 192.168.20.0/24 | 192.168.20.1 | 192.168.20.2 | 192.168.20.254 |
| 30 (Users B) | 192.168.30.0/24 | 192.168.30.1 | 192.168.30.2 | 192.168.30.254 |

VLANs are created on the Core Principal and propagated with **VTP**.

## Redundancy and high availability

- **EtherChannel (Port-Channel)** — link aggregation between Distribution and Core, port-channel groups 1, 2, 3 and 10, 11, 12
- **GLBP** — all gateways forward traffic at the same time (unlike HSRP / VRRP active/standby); Core Principal is the AVG (Active Virtual Gateway), Core Standby is an AVF (Active Virtual Forwarder)
- **EIGRP** — dynamic routing over the whole backbone, chosen for fast convergence

## Services

| Service | Host | Notes |
|---|---|---|
| Zabbix server | 12.0.0.2 (Ubuntu 22.04 LTS) | monitoring, dashboards, alerts, reports |
| Web server | DMZ, 14.0.0.0/8 (Ubuntu 24.04 LTS) | Nginx, Bind9 DNS, Zabbix agent |
| Firewall | Cisco ASA | NAT + filtering towards the DMZ |

## Monitoring strategy

| Target | Protocol | Security mode |
|---|---|---|
| Switches (L2 / L3) | SNMPv3 | authNoPriv, SHA |
| Router, ASA | SNMPv3 | authPriv, SHA + AES-128 |
| DMZ server | Zabbix agent | system and application metrics |

SNMP polls over UDP/161 and reads OIDs from the device MIB. The agent complements it on servers, where it can run local checks and see deeper system metrics.
