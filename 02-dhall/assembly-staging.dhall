-- assembly-staging.dhall

--- config env
let config = ./configs/staging.dhall


--- templating for {deploy, svc, ingress}
let all = ./templates/sith-all-template.dhall


in all config
