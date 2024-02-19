# Ball and Beam

Ball and Beam is a 3D neuro-rehabilitation game where players control the rotation of the beam. The goal is to control the position of the ball on the beam and settle it on the target while the target is moving on the beam.

## Getting Started

### Prerequisites

- Unity 2021.3.13f1 or later
- Virtual Reality setup (in this project we used HTC Vive pro)



### Installation

1. Clone the repository:
[https://github.com/sahand2ajami/BallAndBeam.git](https://github.com/sahand2ajami/BallAndBeam.git)
2. Open the project in Unity by selecting `Open` and navigating to the cloned project folder.

### Unity Packages

Before running the project, ensure that the following Unity packages are installed:

- TextMeshPro
- Test Framework
- Timeline
- Unity UI
- Version Control
- Visual Scripting
- OpenVR XR Plugin

and the editor packages such as:
- JetBrains Rider Editor
- Visual Studio Code Editor
- Visual Studio Editor

You can install these packages via the Unity Package Manager by navigating to `Window` > `Package Manager` in the Unity Editor.

### Running the Project

- Open the `MainScene` in the Unity Editor.
- Press the Play button to start the game.

## Project Structure

- `Assets/`
- `Scripts/`: Contains all the C# scripts for the game mechanics.
- `Materials/`: Contains materials used for the game objects.
- `Prefabs/`: Contains prefabricated objects like the player spaceship and enemies.
- `Scenes/`: Contains the Unity scenes for the game.
- `ProjectSettings/`: Contains settings for the Unity project.

## Usage

- Pull the VR controller triggers to start the trials.

# User Study Analysis
This folder contains the code used to analyze the user study for the ball and beam system. The analysis includes the kinematic data of the hand and the EMG analysis for motor learning purposes.
**Please note that the 'data' folder will be shared after the study is published.**

### Prerequisites
Before running the analysis scripts, ensure that you have the following software and libraries installed:

- MATLAB R2022b or later

### File Structure
- `csv2mat.m` and `csv22mat.m` : Script for converting the .csv files of kinematic data into .mat files.
- `csvEMGmat.m`: Script for converting the .csv files of the EMG data into .mat files.
- `mat2struct.m`: Script for combining all the .mat files into a structure.
- `emg_preprocess.m`: Script for preprocessing the EMG signals.
- `emg_metric_calculator.m`: Script for analyzing the EMG signals and extract features from them.
- `traj_analysis.m`: Script for analyzing the trajectory of the hand.
- `ball_on_target_time_extractor.m`: Script for calculating the time that the ball stayed on the target for each trial.
- `main.m`: Script for the pipeline analysis.

### Usage
You only need to run `main.m` for the analysis pipeline. 

# Questions
If you have any questions about the project, feel free to reach out. You can send an email to [sahand.ajami@gmail.com](mailto:sahand.ajami@gmail.com), and we'll get back to you as soon as possible.

