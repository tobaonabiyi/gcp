terraform {
  backend "gcs" {
    bucket  = "stack-armor-toba"
    prefix  = "compute"
    credentials = "keys.json"
  }
  
}
