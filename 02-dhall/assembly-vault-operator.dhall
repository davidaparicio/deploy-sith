-- assembly-vault-operator.dhall

-- schemas

let ManifestUnion = ./types/unionType.dhall

--- config env
let config = ./configs/vault-operator.dhall

let configSubSet = { deploy = config.deploy, svc = config.svc, ing = config.ing }

--- templating for {deploy, svc, ingress}
let all = ./templates/sith-all-template.dhall

let secret = ./templates/sith-secret-template.dhall

in (all configSubSet) # [ ManifestUnion.Sec (secret config.sec) ]