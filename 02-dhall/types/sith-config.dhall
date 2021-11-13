-- config for env

-- sith-config.dhall

let ConfigDeploy = ./sith-config-deploy.dhall

let ConfigSvc = ./sith-config-svc.dhall

let ConfigIngress = ./sith-config-ingress.dhall

let Config = {
  deploy: ConfigDeploy.Type,
  svc: ConfigSvc.Type,
  ing: ConfigIngress.Type
}

in Config