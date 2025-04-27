{ ... }@_haumeaArgs:
{ config, pkgs, ... }@_nixosModuleArgs: {
  services.ollama.enable = true;
  services.ollama.acceleration = "cuda";
  services.ollama.host = "0.0.0.0";
  services.ollama.loadModels = [
    "gemma3:27b-it-qat"
    "qwen2.5-coder:32b"
    "qwq"
  ];

  services.open-webui.enable = true;
  services.open-webui.environment = {
    ANONYMIZED_TELEMETRY = "False";
    DO_NOT_TRACK = "True";
    OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    SCARF_NO_ANALYTICS = "True";
    WEBUI_AUTH = "False";
  };
  services.open-webui.host = "0.0.0.0";
}
