terraform {
  backend "gcs" {
    bucket  = "stack-armor-toba"
    prefix  = "network"
    credentials = "keys.json"
  }
  
}
