-- assembly-vault.dhall

-- schemas

let ManifestUnion = ./types/unionType.dhall

--- config env
let config = ./configs/vault-csi.dhall

let configSubSet = { deploy = config.deploy, svc = config.svc, ing = config.ing }

--- templating for {deploy, svc, ingress}
let all = ./templates/sith-all-template.dhall

let secretProviderClassTemplate = ./templates/sith-secret-provider-class.dhall

in (all configSubSet) # [ ManifestUnion.SPC (secretProviderClassTemplate config.spc) ]