# microk8s-homelab

Expose your MicroK8s homelab to the Internet

## Developing

Fork and clone this repository, then navigate to the project root and follow the instructions below.

### Install pre-commit hook \(optional\)

The pre-commit hook runs formatting and sanity checks such as `tofu fmt` to reduce the chance of accidentally submitting badly formatted code that would fail CI.

```bash
ln -s ../../hooks/pre-commit ./.git/hooks/pre-commit
```

### Prerequisites

#### AWS

If deploying the resources to AWS, you'll need to install and set up [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) with a valid access key and secret key corresponding to an [IAM administrator account](https://docs.aws.amazon.com/streams/latest/dev/setting-up.html).

#### OpenTofu

Install the latest version of [OpenTofu](https://opentofu.org/docs/intro/install/standalone/). The version used is `1.6.1` at the time of writing \(2024-02-10\).

You'll also need an SSH key pair for remoting into your instance - generate this with `ssh-keygen` if you haven't already.

_N.B. It is strongly advised to use a dedicated `microk8s-homelab` SSH key pair for remoting into your instance and reverse tunneling instead of your default SSH key pair \(if exists\)._

### Deploy

#### OpenTofu

```bash
export CLOUD_PROVIDER="aws"
export TF_VAR_email="webmaster@example.com" # replace me!
tofu -chdir="opentofu/${CLOUD_PROVIDER}/" init
tofu -chdir="opentofu/${CLOUD_PROVIDER}/" plan
tofu -chdir="opentofu/${CLOUD_PROVIDER}/" apply
```

The following OpenTofu variables are supported for AWS.

| Variable | Required | Type | Default | Description |
| --- | --- | --- | --- | --- |
| `email` | Y | `string` | `"webmaster@example.com"` | Required. Email address to use for Let's Encrypt notifications |
| `profile` | - | `string` | `"default"` | AWS profile to assume for AWS CLI v2 and OpenTofu |
| `region` | - | `string` | `"ap-east-1"` | AWS region to deploy the resources into |
| `vpc_cidr` | - | `string` | `"10.0.0.0/16"` | VPC CIDR block. Should be a valid [RFC 1918](https://datatracker.ietf.org/doc/html/rfc1918) private subnet |
| `subnet_cidr` | - | `string` | `"10.0.1.0/24"` | Subnet CIDR block. Should be a valid subnet of the VPC CIDR block |
| `ssh_pubkey_path` | - | `string` | `"~/.ssh/microk8s-homelab.pub"` | Path to SSH public key. Evaluated with `pathexpand()` before use |
| `instance_type` | - | `string` | `"t3.micro"` | Instance type of MicroK8s reverse tunnel proxy |

## License

[MIT](./LICENSE)
