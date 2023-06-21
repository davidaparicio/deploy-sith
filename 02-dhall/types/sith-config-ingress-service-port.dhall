--- sith-config-ingress-service-port.dhall
{
  Type =
  { 
    name: Optional Text,
    number: Optional Integer,
  },
  default =
  {
    name = None Text,
    number = None Integer,
  }
}
