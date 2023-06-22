-- staging.dhall
-- config for staging env

-- schemas
let ConfigDeploy = ../types/sith-config-deploy.dhall

let ConfigSvc = ../types/sith-config-svc.dhall
let Port : Type = < Int : Integer | String : Text >

let ConfigSecret = ../types/sith-config-secret.dhall

let Config = ../types/sith-config.dhall

-- create ingress from svc
let Converters = ../tools/converters.dhall 

-- common
let common = {
  name = "hello",
  app = "hello",
  secretName = "james-secrets",
}

-- deployment
let deployment = ConfigDeploy::{
  name = common.name,
  app = common.app,
  replicas = +1,
  -- FIXME (version à déployer)
  image = "registry.gitlab.com/gitops-heros/sith:0.1",
  containerPort = +8080,
  portName = Some "web",
  environnement = Some "secret",
  resources = {
    requests = { cpu = "0.1", memory = "8Mi" },
    limits = { cpu = "0.5", memory = "16Mi" }
  },
  livenessProbe = { path = "/", port = Port.String "web" },
  secretName = Some common.secretName
}

-- svc
let service = ConfigSvc::{
  name = common.name,
  app = common.app,
  port = +80,
  portName = Some "front",
  targetPort = Some (Port.String "web")
}

-- ingress (from svc)
let ingress = Converters.configServiceToconfigIngress service "secret.34.110.153.191.sslip.io"


-- secret
-- FIXME: Configure
-- 1. les annotations pour l'injection du secret via l'operator vault
-- Exemple de map dhall:
-- toMap {
--   `key` = "value"
-- }
-- 2. le "path" et la clef du secret dans vault
let secret = ConfigSecret::{
  name = common.secretName,
  app = "hello",
  -- FIXME (1)
  annotations = Some (toMap {}),
  data = Some (toMap {
    -- FIXME (2)
    `secret` = "VE9ETwo="
  })
}

let config : Config ={deploy = deployment, svc = service, ing = ingress}

in config∧ { sec = secret }
