# vagrant-kube-ovn
OVN 테스트환경 구성 Repository

## 사전 준비사항

### 소프트웨어 설치
테스트환경 구성을 위해서는 아래의 소프트웨어가 설치되어야 합니다.
- VMWare Fusion (가상화도구)
- Vagrant (자동설치도구)
- Tabby (터미널도구)

### VNET 구성
아래의 명령어를 통해 가상머신에 할당할 네트워크를 생성합니다.

```bash
sh ./vagrant-kube-ovn/common/vf_net_create_vnet2.sh
```

### tabby 설정
아래의 명령어를 통해 tabby 터미널 설정파일을 복사합니다.

```bash
cd ./vagrant-kube-ovn/common/tabby/
cp ./vagrant-kube-ovn/config.yaml ~/Library/Application\ Support/tabby
```

## ovn cluster 테스트 환경 구성

```bash
cd ./vagrant-kube-ovn/ovn-cluster
vagrant up
```