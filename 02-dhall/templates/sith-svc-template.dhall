-- sith-svc-template.dhall

let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall sha256:9d07ad4eff6d388aaf7c4715d3b83812a7eee8a6281a5e64098aaddb3551ce6a

let ConfigSvc = ../types/sith-config-svc.dhall

let svc =
  λ(config : ConfigSvc.Type) →
  kubernetes.Service::{
    , metadata = kubernetes.ObjectMeta::{ 
      name = Some config.name, labels = Some (toMap { app = config.app }) 
      }
    , spec = Some kubernetes.ServiceSpec::{
      , ports = Some
        [ kubernetes.ServicePort::{
          , name = config.portName
          , targetPort = config.targetPort
          , port = config.port
          }
        ]
      , selector = Some (toMap { app = config.app })
    }
  }

in svc