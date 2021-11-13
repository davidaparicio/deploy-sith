-- sith-ingress-template.dhall

let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall sha256:9d07ad4eff6d388aaf7c4715d3b83812a7eee8a6281a5e64098aaddb3551ce6a

let ConfigIngress = ../types/sith-config-ingress.dhall

let ingress =
  λ(config : ConfigIngress.Type) →
  kubernetes.Ingress::{
    , metadata = kubernetes.ObjectMeta::{
      , labels = Some (toMap { app = config.app })
      , name = Some config.name
      }
    , spec = Some kubernetes.IngressSpec::{
      , rules = Some [ kubernetes.IngressRule::{ 
            host = Some config.rule.host
          , http = Some { 
              paths =
              [ kubernetes.HTTPIngressPath::{ 
                  backend = kubernetes.IngressBackend::{ 
                    service = Some kubernetes.IngressServiceBackend::
                    { name = config.rule.serviceName
                    , port = Some kubernetes.ServiceBackendPort::{ number = config.rule.servicePort.number, name = config.rule.servicePort.name }
                    }
                  }
                , path = config.rule.path
                , pathType = Some "ImplementationSpecific"
                }
              ]
            }
          }
        ]
      }
    }

in ingress