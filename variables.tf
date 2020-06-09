variable "description" {
  description = "The name of your resource."
  default     = "Primary EBS lifecycle policy"
}

variable "schedule_interval" {
  description = "The number of hours between snapshots."
  default     = 24
}

variable "schedule_name" {
  description = "A name for the defined schedule."
  default     = "2 weeks of daily snapshots"
}

variable "schedule_times" {
  description = "UTC times to evaluate the lifecycle policy."
  default     = ["05:00"]
}

variable "schedule_retain_count" {
  description = "How many snapshots to retain."
  default     = 14
}
