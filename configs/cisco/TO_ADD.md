# Cisco configurations still to add

The original report shows the campus configuration (VLANs/VTP, SVIs, port-channels, GLBP, EIGRP, ASA NAT/DMZ) as screenshots only, so no text version was extracted. Re-open the GNS3 project and export each device:

```
show running-config
```

Save one file per device, for example:

| File | Device |
|---|---|
| `core-principal.txt` | Core Principal (VLANs, VTP server, SVIs, GLBP AVG, EtherChannel, EIGRP) |
| `core-standby.txt` | Core Standby (GLBP AVF) |
| `distribution-*.txt` | Distribution switches (port-channels) |
| `access-*.txt` | Access switches |
| `r1.txt` | Edge router (EIGRP, SNMPv3) |
| `asa.txt` | Cisco ASA (NAT, DMZ rules, SNMPv3) |

**Before committing:** search each file for `password`, `secret`, `snmp-server user` and replace real values with placeholders.
