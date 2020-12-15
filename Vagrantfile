Vagrant.configure("2") do |config|
  config.vm.define "demo" do |demo|
    demo.vm.box = "bento/ubuntu-20.04"
    demo.vm.provision "file", source: "daemon.json", destination: "/tmp/daemon.json"
    demo.vm.provision "shell", path: "init.sh"
    demo.vm.provider "virtualbox" do |vb|
      vb.name = "demo"
      vb.cpus = 2
      vb.memory = 4096
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end
  end
end
