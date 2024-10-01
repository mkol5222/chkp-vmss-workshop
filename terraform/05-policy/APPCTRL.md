```shell
# before
[Expert@cpman:0]# mgmt_cli -r true show access-layers details-level full  --format json | jq -r '."access-layers"[] | [.name, ."applications-and-url-filtering", .uid]'
[
  "Azure Network",
  false,
  "9cb21823-75c3-4c4c-b226-d1589591fa1b"
]
[
  "Azure URLF",
  true,
  "a0bfa048-c445-434d-91df-a8db802748eb"
]
[
  "HA Network",
  false,
  "66a0d5d5-8303-4b11-85c2-f77b8310702b"
]
[
  "Network",
  false,
  "38271c2f-ab44-4e25-9aa4-e219cb6e12cf"
]
# after enable APPCTRL on Azure Network in GUI
mgmt_cli -r true show access-layers details-level full  --format json | jq -r '."access-layers"[] | [.name, ."applications-and-url-filtering", .uid]'
[
  "Azure Network",
  true,
  "9cb21823-75c3-4c4c-b226-d1589591fa1b"
]
[
  "Azure URLF",
  true,
  "a0bfa048-c445-434d-91df-a8db802748eb"
]
[
  "HA Network",
  false,
  "66a0d5d5-8303-4b11-85c2-f77b8310702b"
]
[
  "Network",
  false,
  "38271c2f-ab44-4e25-9aa4-e219cb6e12cf"
]

# CLI
mgmt_cli -r true set access-layer name "Azure Network" applications-and-url-filtering true --format json
mgmt_cli -r true set access-layer name "Azure Network" applications-and-url-filtering false --format json
mgmt_cli --help
```