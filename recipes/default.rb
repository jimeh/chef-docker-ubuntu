if node["platform"] == "ubuntu"
  package("curl") { action :install }

  bash "apt-key add docker" do
    code "curl https://get.docker.io/gpg | apt-key add -"
    not_if "apt-key list | grep Docker"
  end

  file '/etc/apt/sources.list.d/docker.list' do
    content "deb https://get.docker.io/ubuntu docker main"
    notifies :run, "execute[apt-get update]", :immediately
  end

  packages = []
  case node["platform_version"]
  when "12.04"
    packages << "linux-image-generic-lts-raring"
    packages << "linux-headers-generic-lts-raring"
  when "13.04"
    packages << "linux-image-extra-#{`uname -r`.strip}"
  end
  packages << "lxc-docker"

  packages.each do |pkgname|
    package(pkgname) { action :install }
  end
end
