CREATE USER synapse_user;
ALTER USER "synapse_user" WITH PASSWORD 'synapse_user';
CREATE DATABASE synapse
 ENCODING 'UTF8'
 LC_COLLATE='C'
 LC_CTYPE='C'
 template=template0
 OWNER synapse_user;
