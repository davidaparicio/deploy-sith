-- vault-csi.dhall
-- config for secret env

-- schemas
let ConfigDeploy = ../types/sith-config-deploy.dhall

let ConfigSvc = ../types/sith-config-svc.dhall
let Port : Type = < Int : Integer | String : Text >

let ConfigSecretProviderClass = ../types/sith-config-secret-provider-class.dhall

let Config = ../types/sith-config.dhall

-- create ingress from svc
let Converters = ../tools/converters.dhall 

-- common
let common = {
  name = "hello",
  app = "hello",
  secretName = "vault-james-secret"
}

-- deployment
let deployment = ConfigDeploy::{
  name = common.name,
  app = common.app,
  replicas = +2,
  image = "registry.gitlab.com/gitops-heros/sith:1.3",
  containerPort = +8080,
  portName = Some "web",
  environnement = Some "secret",
  resources = {
    requests = { cpu = "0.1", memory = "16Mi" },
    limits = { cpu = "1", memory = "32Mi" }
  },
  livenessProbe = { path = "/", port = Port.String "web" },
  secretName = Some common.secretName,
  secretTypeCsi = True
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
let ingress = Converters.configServiceToconfigIngress service "secret.127.0.0.1.sslip.io"

-- secretProviderClass
-- FIXME: Configure
-- 1. le nom du fichier contenant le secret qui sera monté dans le pod
-- 2. le "path" du secret dans vault
-- 3. la clef du secret dans vault
let secretProviderClass = ConfigSecretProviderClass::{
  name = common.secretName,
  objects = 
    ''
    - objectName: "FIXME (1)"
      secretPath: "FIXME (2)"
      secretKey: "FIXME (3)"
    ''
}

let config : Config = {deploy = deployment, svc = service, ing = ingress}

in config∧ { spc = secretProviderClass }