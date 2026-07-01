{pkgs}:
{
  postgresql = {
    enable = true;
    package = pkgs.postgresql;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
      '';
  };
apache-kafka = {
    enable = true;
    # Replace with a randomly generated uuid. You can get one by running:
    # kafka-storage.sh random-uuid
    clusterId = "xxxxxxxxxxxxxxxxxxxxxx";
    formatLogDirs = true;
    settings = {
      listeners = [
        "PLAINTEXT://:9092"
        "CONTROLLER://:9093"
      ];
      # Adapt depending on your security constraints
      "listener.security.protocol.map" = [
        "PLAINTEXT:PLAINTEXT"
        "CONTROLLER:PLAINTEXT"
      ];
      "controller.quorum.voters" = [
        "1@127.0.0.1:9093"
      ];
      "controller.listener.names" = ["CONTROLLER"];

      "node.id" = 1;
      "process.roles" = ["broker" "controller"];

      # I prefer to use this directory, because /tmp may be erased
      "log.dirs" = ["/var/lib/apache-kafka"];
      "offsets.topic.replication.factor" = 1;
      "transaction.state.log.replication.factor" = 1;
      "transaction.state.log.min.isr" = 1;
    };
  };

}
