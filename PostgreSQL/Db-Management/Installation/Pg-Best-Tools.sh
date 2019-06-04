printf Package List
printf PostgreSQL Online Bloat Check -> pg_repack
printf PostgreSQL Session Check -> pg_activity
printf Server CPU Session and Status -> htop
printf PostgreSQL Backup Tool -> pgBackRest
printf PostgreSQL High Availability -> Patroni


yum install -y pg_repack11
yum install -y pg_activity
yum install -y htop
yum install -y pgbackrest
yum install -y gcc python-devel epel-release
yum install -y python-psycopg2 python-pip PyYAML
yum install -y python2-pip
pip install --upgrade pip
pip install --upgrade setuptools
pip install patroni
pip install python-etcd
pip install --ignore-installed psycopg2-binary
