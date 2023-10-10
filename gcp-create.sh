#!/bin/bash

zones=("us-central1-a" "us-west4-a" "us-south1-a", "us-west1-a")
# Set the target service name
target_service="compute.googleapis.com"

# Function to check if the service is enabled
function is_service_enabled() {
  # Use gcloud services list to check if the service is enabled
  enabled_services=$(gcloud services list --format="value(NAME)" --filter="NAME:${target_service}")

  # Check if the target service is in the list of enabled services
  [[ $enabled_services == *"${target_service}"* ]]
}


# 创建project
# 生成随机字符串作为Project ID后缀
project_id_suffix=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)

# 获取当前时间戳
timestamp=$(date +%s)

# 创建唯一的Project ID
unique_project_id="project-${timestamp}-${project_id_suffix}"

# 设置项目名称
project_name="Project A"

# 创建项目
gcloud projects create ${unique_project_id} --name="${project_name}"

# 配置gcloud使用新项目
gcloud config set project ${unique_project_id}

# Loop to periodically check if the service is enabled
while true; do
  if is_service_enabled; then
    echo "Service ${target_service} is api服务已激活."
    break
  else
    echo "Service ${target_service} is api服务还在激活中..."
  fi

  # Wait for 2 seconds before checking again
  sleep 2
done

#创建6台虚拟机
for i in {1..7}; do
  index=$((($i - 1) % 4))
  zone="${zones[index]}"
  gcloud compute instances create vm-instance-${i} \
    --zone=${zone} \
    --machine-type=e2-micro \
    --image-family=centos-7 \
    --image-project=centos-cloud \
    --metadata=startup-script="$(cat start.sh)" \
    --tags=foo,bar
done
for i in {1..7}; do
  index=$((($i - 1) % 4))
  zone="${zones[index]}"
  vm_name="vm-instance-${i}"

  # 获取虚拟机的公共 IP 地址
  public_ip=$(gcloud compute instances describe ${vm_name} --zone=${zone} --format='value(networkInterfaces[0].accessConfigs[0].natIP)')

  # 打印公共 IP 地址
  echo "VM ${vm_name} 的公共 IP 地址为: ${public_ip}"
done

gcloud compute firewall-rules create allow-http \
  --network=default \
  --allow=tcp:12555 \
  --source-ranges=0.0.0.0/0 \
  --description="Allow HTTP traffic"



# 创建project
# 生成随机字符串作为Project ID后缀
project_id_suffix=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)

# 获取当前时间戳
timestamp=$(date +%s)

# 创建唯一的Project ID
unique_project_id="project-${timestamp}-${project_id_suffix}"

# 设置项目名称
project_name="Project B"

# 创建项目
gcloud projects create ${unique_project_id} --name="${project_name}"

# 配置gcloud使用新项目
gcloud config set project ${unique_project_id}

# Loop to periodically check if the service is enabled
while true; do
  if is_service_enabled; then
    echo "Service ${target_service} is api服务已激活."
    break
  else
    echo "Service ${target_service} is api服务还在激活中..."
  fi

  # Wait for 2 seconds before checking again
  sleep 2
done

#创建6台虚拟机
for i in {1..7}; do
  index=$((($i - 1) % 4))
  zone="${zones[index]}"
  gcloud compute instances create vm-instance-${i} \
    --zone=${zone} \
    --machine-type=e2-micro \
    --image-family=centos-7 \
    --image-project=centos-cloud \
    --metadata=startup-script="$(cat start.sh)" \
    --tags=foo,bar
done
for i in {1..7}; do
  index=$((($i - 1) % 4))
  zone="${zones[index]}"
  vm_name="vm-instance-${i}"

  # 获取虚拟机的公共 IP 地址
  public_ip=$(gcloud compute instances describe ${vm_name} --zone=${zone} --format='value(networkInterfaces[0].accessConfigs[0].natIP)')

  # 打印公共 IP 地址
  echo "VM ${vm_name} 的公共 IP 地址为: ${public_ip}"
done

gcloud compute firewall-rules create allow-http \
  --network=default \
  --allow=tcp:12555 \
  --source-ranges=0.0.0.0/0 \
  --description="Allow HTTP traffic"
