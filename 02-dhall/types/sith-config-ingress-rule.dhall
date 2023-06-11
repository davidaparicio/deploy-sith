--- sith-config-ingress-rule.dhall
{
  Type =
  { 
    
    path: Optional Text,
    host: Text,
    serviceName: Text,
    servicePort: (./sith-config-ingress-service-port.dhall).Type ,
  },
  default =
  {
      path = Some "/",
  }
}
