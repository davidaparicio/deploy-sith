-- assembly-staging.dhall

--- config env
let config = ./configs/prod.dhall


--- templating for {deploy, svc, ingress}
let all = ./templates/sith-all-template.dhall


in all config
