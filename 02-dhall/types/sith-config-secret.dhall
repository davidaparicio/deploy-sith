--- sith-config-secret.dhall
{
  Type =
  { 
    name: Text,
    app: Text,
    annotations: Optional (List { mapKey : Text, mapValue : Text }),
    data: Optional (List { mapKey : Text, mapValue : Text })
  },
  default = 
  {=}
}
