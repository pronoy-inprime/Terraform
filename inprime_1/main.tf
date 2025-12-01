module "vpc" {
    source = "./modules/vpc"
    vpc_inprime_01 = var.vpc_inprime_01
    public_subnet_01_vpc01 = var.public_subnet_01_vpc01
    public_subnet_02_vpc01 = var.public_subnet_02_vpc01
    private_subnet_01_vpc01 = var.private_subnet_01_vpc01
    private_subnet_02_vpc01 = var.private_subnet_02_vpc01
}

module "sg" {
    source = "./modules/sg"
    vpc_inprime_01_id = module.vpc.vpc_inprime_01_id
}
module "alb" {
    source = "./modules/alb"
    vpc_inprime_01_id = module.vpc.vpc_inprime_01_id
    public_subnet_01_vpc01_id = module.vpc.public_subnet_01_vpc01_id
    public_subnet_02_vpc01_id = module.vpc.public_subnet_02_vpc01_id
    sg_alb_id = module.sg.sg_alb_id
}

module "ecs" {  
    source = "./modules/ecs"
    private_subnet_01_vpc01_id = module.vpc.private_subnet_01_vpc01_id
    private_subnet_02_vpc01_id = module.vpc.private_subnet_02_vpc01_id
    tgt_grp_ecs_cluster_arn = module.alb.tgt_grp_ecs_cluster_arn
    sg_01_id = module.sg.sg_01_id
    alb_vpc01_listener_arn = module.alb.alb_vpc01_listener_arn
  
}

module "docdb" {
    source = "./modules/docdb"
    private_subnet_01_vpc01 = module.vpc.private_subnet_01_vpc01_id
    private_subnet_02_vpc01 = module.vpc.private_subnet_02_vpc01_id
    vpc_id = module.vpc.vpc_inprime_01_id
    vpc_cidr_block = var.vpc_inprime_01
}

module "aurora_rds_postgress" {
    source = "./modules/aurora__rds_postgress"
    subnetgrp1dev_name = module.docdb.aws_docdb_subnet_group_name
    sg_alb_id = module.sg.sg_alb_id
    sg_01_id = module.sg.sg_01_id
}