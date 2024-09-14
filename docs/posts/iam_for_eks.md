---
date: 2024-08-11
authors:
    - ssawadogo
categories: 
    - MLOps
    - Cloud
---

### Understanding IAM Roles and Users in AWS with a Practical Example: Running an Application on EKS

**AWS Identity and Access Management (IAM)** is a cornerstone of security and access control in AWS environments. IAM allows you to manage users, groups, and roles, and to specify their permissions to access AWS resources. In this article, we will explore the differences between IAM roles and IAM users, provide a practical scenario of deploying an application on Amazon EKS (Elastic Kubernetes Service), and clarify how IAM roles relate to specific AWS console options.
<!-- more -->

#### **1. IAM Role vs. IAM User**

**IAM User:**
- An IAM user is an entity that represents a person or application that interacts with AWS resources. Each IAM user has a unique set of credentials (username and password or access keys).
- IAM users are generally assigned permissions directly or through group memberships.
- Example: A developer who needs access to specific AWS resources and can authenticate using their IAM user credentials.

**IAM Role:**
- An IAM role is an AWS identity with specific permissions that can be assumed by entities like AWS services, EC2 instances, or even IAM users.
- Roles are temporary and are assumed by entities that need to perform specific actions. They do not have permanent credentials; instead, they provide temporary security credentials.
- Example: An EC2 instance running a containerized application that needs to pull images from Amazon ECR.

#### **2. Practical Scenario: Deploying an Application on EKS**

Let’s walk through an example of deploying an application, such as Gradio, on Amazon EKS. Gradio is a popular library for creating machine learning demos.

**Steps for Deployment:**

1. **Set Up IAM Roles for EKS:**
   - **Cluster Role:** Create an IAM role that the EKS cluster will use. This role allows EKS to manage the underlying EC2 instances and perform other operations.
   - **Node Instance Role:** Create another IAM role for EC2 instances that will run the Kubernetes worker nodes. This role allows the instances to interact with other AWS services, like pulling images from ECR or writing logs to CloudWatch.

   **Example IAM Policy for Node Instance Role:**

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Action": [
                   "ec2:DescribeInstances",
                   "ec2:DescribeTags",
                   "ecr:GetAuthorizationToken",
                   "ecr:BatchCheckLayerAvailability",
                   "ecr:GetDownloadUrlForLayer",
                   "ecr:BatchGetImage",
                   "logs:CreateLogStream",
                   "logs:PutLogEvents"
               ],
               "Resource": "*"
           }
       ]
   }
   ```

2. **Create an EKS Cluster:**
   - Go to the EKS Console.
   - Create a new EKS cluster and associate it with the IAM cluster role created earlier.

3. **Launch EC2 Instances for Kubernetes Nodes:**
   - Launch EC2 instances and associate them with the IAM node instance role. Ensure these instances are part of the EKS node group.

4. **Deploy Gradio Application:**
   - Package your Gradio application into a Docker container and push the image to Amazon ECR.
   - Create a Kubernetes deployment YAML file specifying the container image from ECR and deploy it to your EKS cluster.

   **Example Kubernetes Deployment YAML:**

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: gradio-app
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: gradio
     template:
       metadata:
         labels:
           app: gradio
       spec:
         containers:
           - name: gradio-container
             image: <your-ecr-repository-url>/gradio-app:latest
             ports:
               - containerPort: 7860
   ```

5. **Expose the Application:**
   - Create a Kubernetes Service to expose the Gradio application to the internet.

   **Example Service YAML:**

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: gradio-service
   spec:
     selector:
       app: gradio
     ports:
       - protocol: TCP
         port: 80
         targetPort: 7860
     type: LoadBalancer
   ```

#### **3. IAM Roles in AWS Console Options**

You mentioned having different console options: `DATAengROLE`, `DATASCIENC`, and `DATAANALYST`. These are IAM roles configured for various teams or purposes. Here’s how they might be used:

- **DATAengROLE:** This role could be configured to provide access to data engineering tools and resources, like Apache Airflow, for data engineers. If you have access to Airflow with this role, it means that `DATAengROLE` includes permissions to view and manage Airflow resources.

- **DATASCIENC:** This role might be tailored for data scientists, granting access to tools and resources pertinent to data analysis and modeling. The specific permissions and services available to this role would depend on the policies attached.

- **DATAANALYST:** This role could be for data analysts, providing access to reporting tools or datasets but not necessarily the same resources as the other roles.

**Role-Based Access:**
In your case, when using the `DATAengROLE`, you have access to Airflow because this role has the necessary permissions configured. Conversely, the `DATAANALYST` role might not have the same permissions, hence the lack of access to Airflow.

#### **Conclusion**

Understanding the difference between IAM roles and IAM users is fundamental for managing access and permissions in AWS. IAM roles are particularly useful for granting temporary access and managing permissions for AWS services and resources, while IAM users are suited for individuals requiring direct access.

In the context of deploying an application like Gradio on Amazon EKS, properly configuring IAM roles ensures that your EKS cluster and EC2 instances have the appropriate permissions to interact with other AWS services. Additionally, understanding IAM roles in relation to different AWS console options helps in managing access based on specific roles and responsibilities within your organization.