#  👋 Hi, I'm Jenkins

A preconfigured jenkins with a node and ssh keys.

### Quickstart

Usage: start.sh <REMOTE_HOST> <SSH_PRIVATE_KEY_FILE> <SSH_PUBLIC_KEY_FILE> [SSH_KEY_PASSWORD]

This script sets up SSH keys, deploys Docker services using docker-compose, and retrieves the initial admin password for Jenkins.
It requires the following arguments:
- The `<REMOTE_HOST>` parameter should be the hostname or IP address of the remote host.
- The `<SSH_PRIVATE_KEY_FILE>` parameter should be the path to a file containing the SSH private key.
- The `<SSH_PUBLIC_KEY_FILE>` parameter should be the path to a file containing the SSH public key.
- The `[SSH_KEY_PASSWORD]` parameter is optional and can be used if the SSH private key is password-protected.

Example usage:

```shell
./start.sh github.com ~/.ssh/id_rsa ~/.ssh/id_rsa.pub mypassword123
```

Please make sure to provide valid paths to your SSH key files and specify a valid remote host.
The script assumes that you have Docker and docker-compose installed on your system.

