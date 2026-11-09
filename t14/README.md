## `terraform plan` helps to figure out what resource to be destroyed or add or change
## state management

### `terraform show`,`terraform state show <rid>`,`terraform show list` are three main commands for terraform state management 

# Theory Questions
## 1. What is IaC and its advantages?

Infrastructure as Code (IaC) means describing infrastructure using machine-readable files that are version-controlled and applied by a tool.

### Advantages:
1. **Consistency:** Same code creates the same environment every time and prevents configuration drift.
2. **Speed and Automation:** Creates or destroys complete environments within minutes.
3. **Version Control and Audit Trail:** Git history, code reviews, and easy rollback of infrastructure changes.
4. **Repeatability and Scalability:** Easily replicate environments across Dev, Test, and Production.
5. **Less Human Error:** Reduces manual configuration mistakes.
6. **Documentation:** Infrastructure code itself acts as documentation.
7. **Cost Control:** Easily destroy unused resources to reduce costs.

---

## 2. Purpose of `terraform init`, `terraform plan`, and `terraform apply`

1. **terraform init:** Initializes the Terraform working directory, configures the backend, downloads required providers and plugins, and creates the dependency lock file (`.terraform.lock.hcl`).

2. **terraform plan:** Previews the infrastructure changes and tells us which resources will be created, modified, or destroyed.

3. **terraform apply:** Executes the planned changes and creates, updates, or destroys infrastructure resources after user approval.