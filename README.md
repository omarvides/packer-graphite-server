# Packer Graphite Server

This is a Packer repository that automates creation of linux images for graphite, will all packages installed for the platforms below

* AWS - Produces an ami image

## AWS

This uses ubuntu 16.04 on the latest version found on AWS ami marketplace, the known ami to work with this packer is

```ami-04169656fea786776```

It also expects variables to customize your graphite installation and configuration, you can pass those variables by
running your packer buid like below

``` bash
packer build -var-file=variables.json aws/ubuntu/ami.json
```

Expected variables (That should be defined inside your variables.json file)

```
secret_text
timezone
database_name
database_user
database_password
graphite_port
mysql_root_password
```

```variables.json file example```

``` json
{
  "secret_text": "YOUR_SUPER_SECRET_TEXT_HERE_123",
  "timezone": "Denver",
  "database_name": "graphite_db",
  "database_user": "graphite_user",
  "database_password": "graphite_password",
  "graphite_port": "8080",
  "mysql_root_password": "root"
}
```

This repository also installs statsd under ```/opt/statsd``` directory and configures it to listen on port ```8125``` 

## Pending

This won't create your graphite web superuser, you would need to manually run inside your server

``` bash
graphite-manage createsuperuser
```

to create and enable an admin user for your graphite web ui

## Known issues

When building with t2.micro image, ubuntu could not be able to install some packages, this is been happening randomly and I haven't been able to figure out why yet, if that happens, try re running the packer build command.

```
amazon-ebs: E: Could not open file /var/lib/apt/lists/archive.ubuntu.com_ubuntu_dists_xenial_main_binary-amd64_Packages - open (2: No such file or directory)
```

## Key concepts

* [Hashicorp Packer](https://www.packer.io/)