# IBM WebSphere Application Server 7.0

Building an IBM WebSphere Application Server 7.0 for Developers image.

## Prerequisites

You have to download WebSphere Application Server v7.0 installation package and updates from IBM as following.

### Download installation files into `source` folder

1. Download `was.7000.wasdev.nocharge.linux.amd64.tar.gz` form [IBM WebSphere Application for Developers](https://www14.software.ibm.com/webapp/iwm/web/preLogin.do?lang=en_US&source=swg-wsasfd&S_CMP=web_dw_rt_swd) page (link from this [StackOverflow answer](https://stackoverflow.com/a/17523649/3440376)), and place into `source` folder.

2. Download IBM Update Installer for WebSphere Software for Linux form [IBM web site](http://www-01.ibm.com/support/docview.wss?rs=180&uid=swg24020212) (IBMid required), or direct download from [IBM's FTP](ftp://public.dhe.ibm.com/software/websphere/appserv/support/tools/UpdateInstaller/7.0.x/LinuxAMD64/). Place the download file `7.0.0.*-WS-UPDI-LinuxAMD64.tar.gz` into `source` folder.

### Download updates into `udpate` folder

Choose desired fix pick version and download from [IBM web site](http://www-01.ibm.com/support/docview.wss?rs=180&uid=swg27014463) (IBMid required), or link to [IBM's FTP](ftp://public.dhe.ibm.com/software/websphere/appserv/support/fixpacks/was70/cumulative/) navigate to `cf700*/LinuxX64/` and download WAS and WASSDK fix pack.

Take Fix Pack 21 for example, the direct download location is:

- <ftp://public.dhe.ibm.com/software/websphere/appserv/support/fixpacks/was70/cumulative/cf70021/LinuxX64/7.0.0-WS-WAS-LinuxX64-FP0000021.pak>
- <ftp://public.dhe.ibm.com/software/websphere/appserv/support/fixpacks/was70/cumulative/cf70021/LinuxX64/7.0.0-WS-WASSDK-LinuxX64-FP0000021.pak>

### Resulting directory structure

If you choose to build image for Fix Pack 21, make sure your diretory structure looks like:

```text
├── source
│   ├── 7.0.0.21-WS-UPDI-LinuxAMD64.tar.gz
│   └── was.7000.wasdev.nocharge.linux.amd64.tar.gz
└── update
    ├── 7.0.0-WS-WAS-LinuxX64-FP0000021.pak
    └── 7.0.0-WS-WASSDK-LinuxX64-FP0000021.pak
```

## Build image
