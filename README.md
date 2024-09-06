# aws-static-website
A Simple Static Website Infrastructure in AWS

## Overview
This project is a static website designed to showcase a personal profile. It includes sections for an introduction, portfolio, contact information, and more.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Technologies Used](#technologies-used)
3. [Getting Started](#getting-started)
4. [Usage](#usage)
6. [License](#license)
7. [Contact](#contact)

## Getting Started

1. This project uses Terraform to provision the infrastructure in AWS. To get started, you will need to install Terraform and S3 backend and configure your AWS credentials.
2. This project assumes you have an existing Route 53 public hosted zone. If you do not have one, you can create one in the AWS console.
3. Add your backend configuration to `backend.tf`.
4. Change the contents of `terraform.tfvars` to match your desired configuration.

## Usage
1. Run `terraform init` to initialize the Terraform configuration.
2. Run `terraform plan` to see the changes that will be made.
3. Run `terraform apply` to apply the changes.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

For any inquiries, please contact [pedroborgesdebastos@gmail.com](mailto:pedroborgesdebastos@gmail.com).