# Https

## Create a ssl certificate

1. Go to https://www.startssl.com

2. Create an account

3. After verify the account with email code, go to control panel, to the tab "Validations Wizard", choose "Domain Name Validation" on "Type", click "Continue" and follow the steps.

4. After that, go to the tab "Certificates Wizard" and on "Certificate Target" choose "Web Server SSL/TSL Certificate" and follow the steps (choose SHA2 on "Secure Hash Algorithm"; set the staging sub-domain as as sub-domain when it asks)

5. Follow this steps https://www.startssl.com/?app=42

6. `scp <project>.decrypted.key <user>@<host>:/etc/nginx/ssl.key`

7. `scp ssl.unified.crt <user>@<host>:/etc/nginx`

8. login on the server

9. `chmod 600 /etc/nginx/ssl.key`

10. `cat ssl.key ssl.unified.crt > server.pem`

11. `chmod 0600 /etc/nginx/server.pem`

12. On staging and production environment, uncomment the line `config.force_ssl = true`

13. Monit and Nginx on deploy are already configured to use ssl =)