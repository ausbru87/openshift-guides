# OpenShift 4.18 Air-Gapped Deployment (FIPS-Compliant)

This repository contains a comprehensive guide and assets to deploy an OpenShift 4.18 cluster in a fully air-gapped, FIPS-compliant environment. It supports Platform Plus features including Virtualization, ACM, and ODF.

## 📚 Deployment Phases

| Phase | Description | Link |
|-------|-------------|------|
| 01    | Pre-deployment checklist and requirements | [View](deployment/01_prereqs.md) |
| 02    | External mirroring with `oc-mirror` | [View](deployment/02_external-mirroring.md) |
| 03    | Infrastructure and vSphere prep | [View](deployment/03_infra-prep.md) |
| 04    | Supporting services: DNS, NTP, NFS | [View](deployment/04_services.md) |
| 05    | Transfer images to internal registry | [View](deployment/05_image-transfer.md) |
| 06    | OpenShift install (ignition, FIPS configs) | [View](deployment/06_install.md) |
| 07    | Platform Plus component install | [View](deployment/07_post-install.md) |
| 08    | Validation and testing | [View](deployment/08_validation.md) |
| 99    | Troubleshooting and known issues | [View](deployment/99_troubleshooting.md) |

## 📊 Diagrams

- [OpenShift Architecture (draw.io)](diagrams/openshift_arch.drawio)
- ![Architecture Preview](diagrams/openshift_arch.svg)

## 🔐 Security

- All hosts must have FIPS mode enabled _before_ running any OpenShift commands.
- See [`scripts/fips-check.sh`](scripts/fips-check.sh) for validation.

## 🧪 Testing

- Validation jobs and sample manifests are provided in `manifests/` and `scripts/`.

## 📄 License

MIT or internal-use-only as applicable.
