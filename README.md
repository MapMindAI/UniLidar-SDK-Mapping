# UniLidar SDK Mapping

Run [LiDAR-Inertial Odometry](README_LIO.md) on RK3588 with Unitree UniLidar L2.

This repository provides a lightweight deployment package for running UniLidar L2 data acquisition and LiDAR-Inertial Odometry on an ARM64 embedded platform, especially RK3588-based boards. It is designed for mobile robot mapping experiments using a low-cost 3D mechanical scanning LiDAR.

The project focuses on making the full mapping pipeline easy to deploy, start, monitor, and debug on an embedded device.

## Overview

UniLidar L2 is a compact 3D LiDAR that outputs point cloud and IMU data. In this project, the LiDAR is connected to an RK3588 computing board, and the mapping pipeline runs locally on the embedded device.

![System Architecture](assets/system_architecture.svg)

The system is intended for real robot data collection and mapping experiments, including:

* UniLidar L2 data acquisition
* ROS / ROS2-based point cloud and IMU streaming
* LiDAR-Inertial Odometry mapping
* Embedded deployment on RK3588 ARM64
* Docker-based runtime environment
* CPU frequency control for stable performance
* Web-based data collection and monitoring workflow

## Hardware Setup

The typical hardware setup is:

```text
UniLidar L2
    ↓
RK3588 ARM64 board
    ↓
LiDAR SDK / Mapping runtime
    ↓
Point cloud + IMU data
    ↓
LiDAR-Inertial Odometry
    ↓
Real-time mapping result
```

In my test setup, the RK3588 board is mounted on a mobile robot platform. The LiDAR is fixed on the robot and connected directly to the RK3588 board. The robot uses a 12V electric chassis as the mobile base.

## Repository Structure

```text
UniLidar-SDK-Mapping/
├── docker_compose/
│   └── Docker Compose runtime files
├── download_arm64_app_package.sh
├── set_cpu_freq_max.sh
├── check_current_cpu_freq.sh
├── README.md
└── .gitignore
```

### Main scripts

| Script                          | Description                                                 |
| ------------------------------- | ----------------------------------------------------------- |
| `download_arm64_app_package.sh` | Download and extract the ARM64 mapping runtime package      |
| `set_cpu_freq_max.sh`           | Set CPU frequency to maximum for stable mapping performance |
| `check_current_cpu_freq.sh`     | Check current CPU frequency on the embedded board           |

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/MapMindAI/UniLidar-SDK-Mapping.git
cd UniLidar-SDK-Mapping
```

### 2. Download the ARM64 mapping package

```bash
bash download_arm64_app_package.sh
```

This will download the prebuilt mapping package and extract it into the local `mapping/` directory.

### 3. Check CPU frequency

```bash
bash check_current_cpu_freq.sh
```

For real-time LiDAR mapping, it is recommended to keep the CPU running at maximum frequency.

### 4. Set CPU frequency to maximum

```bash
sudo bash set_cpu_freq_max.sh
```

This helps reduce frame drops, mapping instability, and latency spikes on embedded devices.

### 5. Start the mapping runtime

If you are using Docker Compose, enter the Docker Compose directory and start the services:

```bash
bash docker_compose/unilidar_mapping/arm64_start_unilidar.sh
```

Check running containers:

```bash
docker ps
```

View logs:

```bash
docker logs -f <container_name>
```

Replace `<container_name>` with the actual container name shown by `docker ps`.

## LiDAR Connection

Check [UniLidar-SDK-Collection](https://github.com/MapMindAI/UniLidar-SDK-Collection)

## Runtime Data Flow

The runtime pipeline is shown below:

![Data Flow](assets/data_flow.svg)

```text
UniLidar L2
    ↓ raw data
UniLidar SDK
    ↓
PointCloud2 + IMU
    ↓
LIO mapping backend
    ↓
Odometry + map
    ↓
Visualization / recording / web monitoring
```

The mapping backend uses the LiDAR point cloud and IMU stream to estimate robot motion and build a local 3D map.

## Recommended RK3588 Settings

For better real-time performance:

1. Use a stable power supply.
2. Set CPU frequency to maximum.
3. Avoid running unnecessary background processes.
4. Use a high-quality USB cable for the LiDAR.
5. Make sure the LiDAR is rigidly mounted.
6. Keep the LiDAR and IMU timestamp stream stable.
7. Monitor CPU temperature during long mapping sessions.

Check CPU frequency:

```bash
bash check_current_cpu_freq.sh
```

Set maximum frequency:

```bash
sudo bash set_cpu_freq_max.sh
```

## License

Please check the licenses of the included third-party components, including the UniLidar SDK and the LIO backend. This repository is intended for research, development, and robotics prototyping.

## Acknowledgements

This project is built for low-cost mobile robot mapping experiments using UniLidar L2 and RK3588. Thanks to the open-source robotics and SLAM communities.
