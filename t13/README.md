# Steps

### 1.`terraform init`
### 2.`terraform plan`
### 3.`terraform apply`
### 4.`terraform destroy`

### Here these steps will help to create or detroy a resource 

# Theory Questions

## 1. What is IaC and its advantages? Infrastructure as Code means describing infrastructure in machine-readable files
### that are version controlled and applied by a tool. Advantages: consistency (same code gives the same environment every time, no configuration drift), speed and automation (create or destroy full environments in minutes), version control and audit trail (Git history, code review for infrastructure changes, easy rollback), repeatability and scalability (copy to dev, test and prod), less human error, documentation (the code is the documentation), and cost control (easy to tear down unused resources)

## 2. Purpose of terraform init, plan, apply:
### basically gettting to know for initializing backend,plugins provided along with a lock file for tfstate is init and plan tells what resources to create and how to create and whether to change,add or destroy a resource and apply applies the plan provided under user authority to provide resource

