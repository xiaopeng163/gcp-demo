# 创建project
gcloud projects create project-a --name "ProjectA" --set-as-default
gcloud config set project project-a
gcloud services enable compute.googleapis.com

#创建6台虚拟机
for i in {1..6}; do
  zone="us-central1-$(echo abc | cut -c $((($i - 1) % 3 + 1)))"
  gcloud compute instances create vm-instance-${i} \
    --zone=${zone} \
    --machine-type=e2-micro \
    --image-family=centos-7 \
    --image-project=centos-cloud \
    --metadata=startup-script="$(cat start.sh)" \
    --tags=foo,bar
done
for i in {1..6}; do
  zone="us-central1-$(echo abc | cut -c $((($i - 1) % 3 + 1)))"
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
gcloud projects create project-b --name "ProjectB" --set-as-default
gcloud config set project project-b
gcloud services enable compute.googleapis.com

#创建6台虚拟机
for i in {1..6}; do
  zone="us-central1-$(echo abc | cut -c $((($i - 1) % 3 + 1)))"
  gcloud compute instances create vm-instance-${i} \
    --zone=${zone} \
    --machine-type=e2-micro \
    --image-family=centos-7 \
    --image-project=centos-cloud \
    --metadata=startup-script="$(cat start.sh)" \
    --tags=foo,bar
done
for i in {1..6}; do
  zone="us-central1-$(echo abc | cut -c $((($i - 1) % 3 + 1)))"
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
