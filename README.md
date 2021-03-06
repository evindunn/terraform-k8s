# terraform-k8s
Three ceph nodes, three kubernetes nodes on kvm using [a yaml file](./infra.yml). The setup assumes: 
- kvm is configured and a bridge interface named 'br0' has been set up
- the static mac addresses configured in [domains.tf](./domains.tf) have been assigned a static
IP in dhcp
- a public key called `terraform_rsa.pub` is available at `~/.ssh`
- the local network is 192.168.1.0/24 with dns search domain localdomain.net
- the k8s nodes are resolvable at k8s[0-2].localdomain.net
- the ceph nodes are resolvable at ceph[0-2].localdomain.net

## Example configuration
See [infra.yml](./infra.yml) for how the entire infrastructure is configured as a yaml file

Each set of nodes runs a [playbook](./files) to prepare them for their respective roles.
The playbooks log to /var/log/ansible-prepare.log on each node. This file can be tailed until the playbook
completes and the VM automatically reboots.

```shell
$ ssh ceph0 -i ~/.ssh/terraform-60bb59c0-ab3f-3eff-2ecf-230cf852348f tail -f /var/log/ansible-prepare.log
TASK [debug] *******************************************************************
ok: [localhost] => {
    "msg": "Playbook finished on 2021-11-07 at 06:33:06 UTC"
}

PLAY RECAP *********************************************************************
localhost                  : ok=17   changed=13   unreachable=0    failed=0   

Connection to ceph0 closed by remote host
```

## Ceph setup

Once the ceph playbook is complete, a new cluster can be bootstrapped by running the following in ceph0:
1. Deploy ceph0 as the initial ceph monitor: `sudo cephadm bootstrap --ssh-user debian --mon-ip 192.168.1.50 --config ceph_initial.conf` (Replace mon-ip with ceph0's static IP)
2. Copy the ceph public key to the remaining nodes: `for node in ceph1 ceph2; do ssh-copy-id -f -i /etc/ceph/ceph.pub debian@$node; done`
3. Add the remaining nodes to the cluster: `for node in ceph1 ceph2; do sudo ceph orch host add $node; done`
4. Make all of the nodes monitors: `sudo ceph orch apply mon 3`
5. Add all availables disks on all nodes as osds: `sudo ceph orch apply osd --all-available-devices`
6. Deploy two metadata servers for cephfs: `sudo ceph orch apply mds cephfs --placement=2`
7. Create a cephfs filesystem for the kubernetes cluster: `sudo ceph fs volume create kubernetes`

## Kubernetes Setup

Once the k8s playbooks are complete, a new kubernetes cluster can be bootstrapped by:
1. `rke up --config rke.yml`
2. Configure and install the [Ceph CSI driver](https://artifacthub.io/packages/helm/ceph-csi/ceph-csi-cephfs)

