## Download the image

```bash
curl -L https://github.com/home-assistant/operating-system/releases/download/15.2/haos_ova-15.2.qcow2.xz -o haos_ova-15.2.qcow2.xz
```

unzip the image
```bash
unxz haos_ova-15.2.qcow2.xz
```

## Create a pool
```bash
mkdir -vp /var/lib/libvirt/images/haos
cp haos_ova-15.2.qcow2 /var/lib/libvirt/images/haos/
cd /var/lib/libvirt/images/haos
```

```bash
virsh pool-create-as --name haos --type dir --target /var/lib/libvirt/images/haos
```

## Create a brigde network for the virtual machine

```bash
vim /etc/netplan/01-netcfg.yaml
```

- for dhcp
```yaml
network:
  version: 2
  ethernets:
    enp34s0:
      dhcp4: true
  bridges:
    br0:
        dhcp4: yes
        interfaces:
            - enp34s0
        parameters:
          stp: true
```

- for static ip
```yaml
network:
  version: 2
  ethernets:
    enp34s0:
      dhcp4: false
      dhcp6: false
  bridges:
    br0:
      interfaces: [ enp34s0 ]
      addresses: [192.168.1.51/24] # static ip of the host
      routes:
        - to: default
          via: 192.168.1.1 # gateway of the host
      nameservers:
        addresses: [192.168.1.15]  # dns of the host
      parameters:
        stp: true
        forward-delay: 4
      dhcp4: false
      dhcp6: false
```


```bash
netplan apply
brctl show
```

## Create a virtual machine

```bash
virt-install --import --name haos \
--memory 4096 --vcpus 2 --cpu host \
--disk haos_ova-15.2.qcow2,format=qcow2,bus=virtio \
--network bridge=br0,model=virtio \
--osinfo detect=on,require=off \
--graphics none \
# --noautoconsole \
--boot uefi
```

## Login to the virtual machine

```bash
virsh console haos
```
homeassistant login: root
no password

```bash
ha network info
```
if no ip address, assign a static ip address
```bash
nmcli connection show
nmcli con edit "id of the connection"
print ipv4
set ipv4.addresses 192.168.1.52/24 # different from the host
set ipv4.gateway 192.168.1.1 # gateway of the host
set ipv4.dns 192.168.1.15 # dns of the host
save
q
nmcli connection up "id of the connection"
```
restart the virtual machine


### Update the firewall
```bash
sudo ufw route allow in on br0 out on br0
sudo ufw allow in on br0 to any port 8123 proto tcp
sudo ufw reload
```