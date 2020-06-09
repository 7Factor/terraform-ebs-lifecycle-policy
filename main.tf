resource "aws_iam_role" "ebs_lifecycle_policy_role" {
  name = "ebs-lifecycle-policy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dlm.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ebs_lifecycle_policy" {
  name = "ebs-lifecycle-policy"
  role = aws_iam_role.ebs_lifecycle_policy_role.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateSnapshot",
            "ec2:DeleteSnapshot",
            "ec2:DescribeVolumes",
            "ec2:DescribeSnapshots"
         ],
         "Resource": "*"
      },
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateTags"
         ],
         "Resource": "arn:aws:ec2:*::snapshot/*"
      }
   ]
}
EOF
}

resource "aws_dlm_lifecycle_policy" "policy" {
  description        = var.description
  execution_role_arn = aws_iam_role.ebs_lifecycle_policy_role.arn

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = var.schedule_name

      create_rule {
        interval      = var.schedule_interval
        interval_unit = "HOURS"
        times         = var.schedule_times
      }

      retain_rule {
        count = var.schedule_retain_count
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = false
    }

    target_tags = {
      Snapshot = true
    }
  }
}
