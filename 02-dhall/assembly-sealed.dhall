-- assembly-secret.dhall

-- schemas

let SealedSecret = ./types/sealed-secret.dhall

let ManifestUnion = ./types/unionType.dhall

--- config env
let config = ./configs/secret.dhall

let configSubSet = { deploy = config.deploy, svc = config.svc,ing = config.ing }

--- templating for {deploy, svc, ingress}
let all = ./templates/sith-all-template.dhall

let sealed = ./templates/sith-sealed-secret.dhall

in (all configSubSet) # [ ManifestUnion.Sealed (sealed config.sealed) ]