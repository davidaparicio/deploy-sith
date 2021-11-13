-- converters.dhall

let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall sha256:9d07ad4eff6d388aaf7c4715d3b83812a7eee8a6281a5e64098aaddb3551ce6a

let ConfigIngress = ../types/sith-config-ingress.dhall
let ConfigRule = ../types/sith-config-ingress-rule.dhall
let ConfigServicePort = ../types/sith-config-ingress-service-port.dhall
let ConfigSvc = ../types/sith-config-svc.dhall

let configServiceToconfigIngress =
  λ(svc : ConfigSvc.Type) → λ(dnsName : Text) → 
  ConfigIngress::{
        name = svc.name,
        app = svc.app,
        rule = ConfigRule::{
          host = dnsName,
          serviceName = svc.name,
          servicePort = ConfigServicePort::{ number = Some svc.port }
        }
  }


in {configServiceToconfigIngress}