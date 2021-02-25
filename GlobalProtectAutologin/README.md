# Script for GlobalProtect automatic login
- [Script for GlobalProtect automatic login](#script-for-globalprotect-automatic-login)
  - [Low secure script - globalprotect.sh](#low-secure-script---globalprotectsh)
    - [Quick Start](#quick-start)
      - [Install Terminal Google Authentication](#install-terminal-google-authentication)
      - [Install Expect](#install-expect)
      - [Download setup and run GlobalProtect script](#download-setup-and-run-globalprotect-script)
- [High secure script - gprotect.sh](#high-secure-script---gprotectsh)
    - [Quick Start](#quick-start-1)
      - [Install terminal 1Password application](#install-terminal-1password-application)
      - [Install Expect](#install-expect-1)
      - [Download setup and run GlobalProtect script](#download-setup-and-run-globalprotect-script-1)

---
## Low secure script - globalprotect.sh
`!!!!! This script has full automate login into Globalprotect but include bad practice saving password. !!!!!`

Dependency:
- [Terminal Google authentication](https://github.com/arcanericky/ga-cmd)
- [Terminal application - Expect](https://core.tcl-lang.org/expect/index)

### Quick Start

#### Install Terminal Google Authentication
- [Download](https://github.com/arcanericky/ga-cmd/releases) the current release of `ga-cmd`
- Make it executable: `chmod 755 ga-cmd`
- Add to Okta Google Authentication key:
    - open user settings - `Edit profile`
    - find `Extra Verification` -> `Google Authenticator` -> press `Set up`
    - now you need to find secret from get url in the qrcode like `DE3MKSGADH43M2PRRL`
- Create and populate a `$HOME/.ga-cmd` file: `echo gp=DE3MKSGADH43M2PRRL > $HOME/.ga-cmd`
- Set the configuration file permissions: `chmod 600 $HOME/.ga-cmd`
- ...and execute: `./ga-cmd gp` and finish add Google Authenticator Verification with response code

#### Install Expect

```shell
sudo apt-get install expect -y
```

#### Download setup and run GlobalProtect script

```shell
wget -O globalprotect.sh https://raw.githubusercontent.com/gryniv/BashAutomation/master/GlobalProtectAutologin/globalprotect.sh
```
Now open globalprotect.sh and input your data into next variables:
``` bash
export PORTAL="mfa-portal.amwayconnect.com"
export NICKNAME="RUVNAME"
export PASSWORD="VERY_SECURE_PASSWORD"
```
Run:
```shell
. ./globalprotect.sh
```
Script check vpn connection and if vpn is `Connected` after secondary use run disconnect command

---
# High secure script - gprotect.sh
`!!!!! This script use 1password as sucere storege. Every time you need to input master massword !!!!!`

Dependency:
- [Terminal 1password application](https://1password.com/downloads/command-line/)
- [Terminal application - Expect](https://core.tcl-lang.org/expect/index)

### Quick Start

#### Install terminal 1Password application 
- Install [1password](https://support.1password.com/command-line-getting-started/) terminal application 
- Add to Okta Google Authentication key:
    - open user settings - `Edit profile`
    - find `Extra Verification` -> `Google Authenticator` -> press `Set up`
    - now you need add one time password into 1password and finish add Google Authenticator Verification with response code

#### Install Expect

```shell
sudo apt-get install expect -y
```

#### Download setup and run GlobalProtect script

```shell
wget -O gprotect.sh https://raw.githubusercontent.com/gryniv/BashAutomation/master/GlobalProtectAutologin/gprotect.sh
```
Now open globalprotect.sh and input your data into next variables:
``` bash
GP_ITEM="gscmu3ibzgf4ucovrjwjny2cqq"
```
Run:
```shell
. ./gprotect.sh
```
Script check vpn connection and if vpn is `Connected` after secondary use run disconnect command