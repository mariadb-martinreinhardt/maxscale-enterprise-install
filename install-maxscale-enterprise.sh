# How to install MaxScale Enterprise
# ----------------------------------
#
# Includes notes/instructions on how to solve the accept agreement terms issue which existing enterprise customers
# randomly run into. And notes/instructions about the install package being renamed from maxscale to maxscale-enterprise in 
# the two latest versions 25.01.1 and 25.01.2
#
# By Martin Reinhardt for MariaDB Support
#
# Note this is a text file, NOT an executalble script (using .sh extention to highlight code in editor)

Ref. https://mariadb.com/docs/server/architecture/topologies/galera-cluster/step-4-install-mariadb-maxscale

# !!! first get the latest mariadb_es_repo_setup script
curl -LsSO https://dlm.mariadb.com/enterprise-release-helpers/mariadb_es_repo_setup
echo "4d483b4df193831a0101d3dfa7fb3e17411dda7fc06c31be4f9e089c325403c0 mariadb_es_repo_setup" | sha256sum -c -
chmod +x mariadb_es_repo_setup
# replace CUSTOMER_DOWNLOAD_TOKEN with token
sudo ./mariadb_es_repo_setup --token="CUSTOMER_DOWNLOAD_TOKEN" --apply --skip-server --skip-tools --mariadb-maxscale-version="25.01"

# The install command changed since the introduction, but MaxScale 25.01.3 according to our product manager it may go back to using maxscale, 
# For now the two latest versions 25.01.1 and 25.01.2 currently use maxscale-enterprise
'
yum install maxscale
Error: Unable to find a match: maxscale
'
# for now it needs to be installed per:
yum install maxscale-enterprise 

# then start maxscale
systemctl start maxscale

# and review the error log and correct any possible issues such as depreciated parameters or values,
maxscale --version
cat /var/log/maxscale/maxscale.log


# NOTES !!!

# If you encounter errors such as 403  Forbidden  and "... repository 'https://dlm.mariadb.com/repo/...' is not signe.d " ,
# the customer needs to accept our MariaDB Subscription Agreement first and re-run the mariadb_es_repo_setup to configure the repo successfully.
# This generally occurs with existing enterprise customers, as they may have not accepted the newly introduced maxscale enterprise agreement 
# (but have accepted only the mariadb server enterprise agreement)

# To accept agreement terms, copy/paste the following url into a browser, login and accecpt the agreement terms
https://id.mariadb.com/tc/accept/20/ 
# or 
https://id.mariadb.com/account/

# then run the mariadb_es_repo_setup again it should succeed as per example below
sudo ./mariadb_es_repo_setup --token="CUSTOMER_DOWNLOAD_TOKEN" --apply --skip-server --skip-tools --mariadb-maxscale-version="25.01"
# [warning] Found existing file at /etc/apt/sources.list.d/mariadb.list. Moving to /etc/apt/sources.list.d/mariadb.list.old_4.disable
# [info] Repository file successfully written to /etc/apt/sources.list.d/mariadb.list

# If the above doesn't work, take the URL from the errormsg (including token),copy paste it in a browser (example URL your may be different)
https://dlm.mariadb.com/repo/CUSTOMER_TOKEN_HERE/maxscale-enterprise/latest/apt/dists/bullseye/InRelease
# copy/paste the new generated URL into the browser and login which should prompt to accept the agreement terms
https://id.mariadb.com/tc/accept/19/?callback=https://dlm.mariadb.com/repo/CUSTOMER_TOKEN_HERE/maxscale-enterprise/latest/apt/dists/noble/InRelease
