--- ConfigDeploy
{
  Type =
  { 
    name: Text,
    app: Text,
    replicas: Integer,
    image: Text,
    -- TODO use a List of ports instead of this basic only one port
    containerPort: Integer,
    portName: Optional Text,
    environnement: Optional Text,
    resources: {
      requests: {cpu: Text, memory: Text},
      limits: {cpu: Text, memory: Text},
    },
    livenessProbe: {path: Text, port: < Int: Integer | String: Text >},
    secretName: Optional Text
  },
  default =
  {
    portName = None Text,
    environnement = None Text,
    secretName = None Text
  }
}