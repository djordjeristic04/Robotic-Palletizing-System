# Robotic Palletizing System

This project contains the implementation of an automated palletizing system for the ABB IRB 120-3/0.58 industrial robot. The system was developed as part of the "Robotics and Automation" course at the School of Electrical Engineering, University of Belgrade (2025/26).

## Overview
The goal of this project is to simulate a pick-and-place palletizing process where an ABB robot organizes colored cubes (Red, Yellow, Green) onto a 3x3 pallet based on a user-defined layout. The system integrates HMI interaction, sensor simulation, and coordinate system management to handle pallet positioning offsets.

## Key Features
- **HMI Integration:** A custom ScreenMaker application allows operators to define the pallet layout, initiate the process, and monitor system status directly from the IRC5 FlexPendant.
- **Dynamic Calibration:** The system uses a simulated camera to detect pallet position offsets (X, Y, and rotation around Z). It dynamically updates the active `WorkObject` (`wobjPaleta`), ensuring precise palletizing even if the physical pallet position shifts.
- **Modular RAPID Architecture:** The code is organized into dedicated modules (`PalletLogic`, `CameraSimulation`, `PickPaths`, `PlacePaths`, etc.), ensuring maintainability and clean separation of concerns.
- **Process Logic & Validation:** Includes robust input validation (e.g., preventing duplicate placements, ensuring all colors are represented in the layout) and status reporting.

## System Components
- **Robot:** ABB IRB 120-3/0.58 (6-axis manipulator).
- **Tooling:** Vacuum gripper (simulated via `AttachCube` I/O signal).
- **Environment:** RobotStudio 2026, RobotWare 6.12.4008.
- **Coordinate Systems:**
    - `wobjPostolje`: Fixed reference for magazine positions.
    - `wobjPaletaNominal`: Initial reference for the pallet.
    - `wobjPaleta`: Active WorkObject updated by camera data.

## Project Structure
- `RAPID/`: Contains the modular source code.
  - `MainModule.mod`: Main execution cycle.
  - `PalletLogic.mod`: HMI handler, validation, and process sequencing.
  - `CameraSimulation.mod`: Simulation of camera offset detection.
  - `PickPaths.mod` & `PlacePaths.mod`: Defined robot trajectories.
- `SYSPAR/`: System configuration files.
- `HMI/`: ScreenMaker project files for the FlexPendant interface.

## How to Run
1. Open the project solution in **ABB RobotStudio 2026**.
2. Ensure the Virtual Controller (IRC5) is correctly configured with the provided system parameters.
3. Load the HMI application onto the Virtual FlexPendant.
4. Start the controller and use the HMI interface to define your pallet layout.
5. Use the `StartProces` digital input signal to trigger the sequence once the layout is validated.

## Documentation
For a detailed technical description of the algorithms, coordinate transformations, and logic flow, please refer to the `Report.pdf` included in this repository.

---
*Developed by Đorđe Ristić and Viktor Trmčić (2026).*
