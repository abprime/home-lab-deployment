## Installation Guide

https://github.com/HarbourHeading/KVM-GPU-Passthrough


## find the pci device

```bash
lspci | grep -i "VGA"
lspci | grep -i "pci_id"
```


```bash
sudo virt-install \
--name=Windows11 \
--vcpus=4 \
--memory=4096 \
--os-variant=win11 \
--features kvm_hidden=on \
--machine q35 \
--cdrom=/var/lib/libvirt/images/win11/Win11_24H2_English_x64.iso \
--disk path=/var/lib/libvirt/images/win11/win11.qcow2,size=40,bus=virtio,format=qcow2 \
--disk path=/var/lib/libvirt/images/win11/virtio-win.iso,device=cdrom,bus=sata \
--graphics spice \
--video virtio \
--network bridge=br0,model=virtio \
--hostdev pci_0000_26_00_0 \
--hostdev pci_0000_26_00_1 \
--hostdev pci_0000_26_00_2 \
--hostdev pci_0000_26_00_3 \
--hostdev pci_0000_26_00_4 \
--hostdev pci_0000_26_00_6 \
--wait -1
```


## Spice server setup

```bash
sudo apt install git python3-websockify
cd /opt
git clone https://gitlab.freedesktop.org/spice/spice-html5.git

```
