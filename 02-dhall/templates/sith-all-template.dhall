-- sith-all-template.dhall

let Config = ../types/sith-config.dhall

let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall sha256:9d07ad4eff6d388aaf7c4715d3b83812a7eee8a6281a5e64098aaddb3551ce6a


let deployment = ./sith-deploy-template.dhall

let service = ./sith-svc-template.dhall

let ingress = ./sith-ingress-template.dhall

let ManifestUnion = ../types/unionType.dhall

let items =
  λ(config : Config) → 
    [ 
      ManifestUnion.Deploy (deployment config.deploy)
    , ManifestUnion.Svc (service config.svc)
    , ManifestUnion.Ing (ingress config.ing)
    ]

in items
