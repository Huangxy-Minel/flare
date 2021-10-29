
CREATE DATABASE IF NOT EXISTS fate_flow;
CREATE USER 'fate'@'%' IDENTIFIED BY 'fate_dev';
GRANT ALL ON *.* TO 'fate'@'%';
USE `fate_flow`;
INSERT INTO server_node (host, port, node_type, status) values ('clustermanager', '9460', 'CLUSTER_MANAGER', 'HEALTHY');
INSERT INTO server_node (host, port, node_type, status) values ('nodemanager', '9461', 'NODE_MANAGER', 'HEALTHY');
show tables;
select * from server_node;
