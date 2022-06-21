-- staging.dhall
-- config for staging env

-- schemas
let ConfigDeploy = ../types/sith-config-deploy.dhall

let ConfigSvc = ../types/sith-config-svc.dhall
let Port : Type = < Int : Integer | String : Text >

let ConfigSealedSecret = ../types/sith-config-sealed-secret.dhall
let ConfigSealedSecretType = ../types/sith-config-sealed-secret-type.dhall


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
  image = "registry.gitlab.com/gitops-heros/sith:1.3",
  containerPort = +8080,
  portName = Some "web",
  environnement = Some "secret",
  resources = {
    requests = { cpu = "0.2", memory = "8Mi" },
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
let ingress = Converters.configServiceToconfigIngress service "secret.127.0.0.1.sslip.io"


-- sealed secret
let sealedSecret = ConfigSealedSecret::{
  name = common.secretName,
  app = "hello",
  encryptSecret =
      "AgB+H4pi1C+yFG//mp4naXQncquvX7uaXc8g5kRDfboDHXa5O7icLg+THOb5bBQAZE034Bgkhaeirgyc4Vj+DFbUQh/Q257bjtD6Ad6fToSsIToc/RM1ciVHdiLPDp9Wp/iZtFj3bLTbrnW+I53mQSxgDQE55DkI8DbZJCVlsZ8dDFUacCeKCCZ6P0SqWPGzI715P8OWSpxSaHp0/e+RzeDrWmCnoyVhkEQk4mLFhui+99YfBjzlre8+gWYqd7JO1xhj4xyNHRhtMmZcTIWJZUCUHtb9bmJkepDFc34wA0L1+3rokK9qkCC3/f6b9yTzZGw49Ue2/8mXTzAeIQZFivV/4Tfuru1F6AWSrwpgkz5IVYtAIunVNX6UBK6zD5GWKY/xV/aaijlSgJrZbWDKy6WmWHLPjFN8ZXNVlu6NzjqPtKRaiNdYHi+LehiZ7fRwdLObCJbWLO41liE9TDVdh2kdBilgiDVsC+MDgP7i79fHFh+8r8jlncSYm7TULFk+ifxcnW2edHjsPlf2AXLzhtp+9+kB+cAIjjJ4WABvg+RbOBbPn2tq7S6Dl9OouojyBrZhFot1kFsC7slfw9TS04tjxTjI7iKCt8tkA6NCaRlsYFhH47xcmwQ2bI4NCFNcMtGoUV3SKEy2QPbKNcc4HU2rQTkyt8mfTnflFnyJOLlTvONDHD7Yn0yBTDn7G+wjuvbGWqWTQ5AVz+j2gwFM250iAEa7"
  -- annotations = ConfigSealedSecretType.namespaceWide,
  -- namespace = Some "namespace"
}

let config : Config ={deploy = deployment, svc = service, ing = ingress}
--, sealed = sealedSecret}

in config ∧ { sealed = sealedSecret}
