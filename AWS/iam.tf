resource "aws_iam_role" "ssosec_role" {
  name               = "${var.prefix}-iam-role"
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

resource "aws_iam_instance_profile" "ssosec_iam_instance_profile" {
  name = "${var.prefix}-iam-role-profile"
  role = aws_iam_role.ssosec_role.name
}

resource "aws_iam_role_policy" "ssosec_instance_role_profile" {
  name   = "${var.prefix}-iam-role-policy"
  role   = aws_iam_role.ssosec_role.id
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