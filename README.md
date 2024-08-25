[
](https://gist.github.com/darinpope/4e46fad6d823ae249dec625bff3a2d82)

Gist for https://youtu.be/5-RMu9M_Anc

Install Vault on CentOS 7.9

For more details, refer to https://learn.hashicorp.com/tutorials/vault/getting-started-install

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vault
Copy the following to /etc/vault.d/vault.hcl
storage "raft" {
  path    = "/opt/vault/data"
  node_id = "raft_node_1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true
sudo systemctl stop vault
sudo systemctl start vault
Commands to run to configure Vault and create AppRole

export VAULT_ADDR='http://127.0.0.1:8200'
vault operator init
vault operator unseal
vault operator unseal
vault operator unseal
vault login <Initial_Root_Token>
<Initial_Root_Token> is found in the output of vault operator init
vault auth enable approle
https://www.vaultproject.io/docs/auth/approle
vault write auth/approle/role/jenkins-role token_num_uses=0 secret_id_num_uses=0 policies="jenkins"
vault read auth/approle/role/jenkins-role/role-id
vault write -f auth/approle/role/jenkins-role/secret-id
Commands to create vagrant secret

vault secrets enable -path=secrets kv
https://www.vaultproject.io/docs/secrets/kv
vault write secrets/creds/vagrant username=vagrant password=vagrant
Create jenkins-policy.hcl
path "secrets/creds/vagrant" {
 capabilities = ["read"]
}
vault policy write jenkins jenkins-policy.hcl
Commands to create my-secret-text

vault write secrets/creds/my-secret-text secret=abc123
Update jenkins-policy.hcl
path "secrets/creds/*" {
 capabilities = ["read"]
}
vault policy write jenkins jenkins-policy.hcl
