resource "aws_iam_role" "this" {
  name               = local.iam_ecr_role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "this" {
  name = local.iam_ecr_role_profile
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy" "this" {
  name   = local.iam_ecr_role_policy
  role   = aws_iam_role.this.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action":[
              "ecr:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}