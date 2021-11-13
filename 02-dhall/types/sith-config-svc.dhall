--- sith-config-svc.dhall
{
  Type =
  { 
    name: Text,
    app: Text,
    -- TODO use a map of ports instead of this basic only one port
    port: Integer,
    targetPort: Optional <Int: Integer | String: Text>,
    portName: Optional Text,
  },
  default =
  {
    portName = None Text,
    targetPort = None <Int: Integer | String: Text>,
  }
}

