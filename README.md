## to run the playbook

provide the `db_endpoint` and `db_password` variables, for example like this -

```bash
ansible-playbook web-server-provision.yaml --extra-vars "db_endpoint=<your-db-name>.<random-string>.<your-region>.rds.amazonaws.com db_password=1231231231232 GITHUB_ACCESS_TOKEN=github_token_with_write_public_key_access"
```


`GITHUB_ACCESS_TOKEN` is needed to automatically add the Ansible-generated key into your github account