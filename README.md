# wiroai

This project started with the intention of healing people who are tired from their daily life with **music**. It uses generative AI to generate music that matches the day's vibe.


## Setting up Quokka Flutter Project

### Windows

1. **Install Flutter SDK:**
   - Download the [Flutter SDK](https://flutter.dev/docs/get-started/install/windows) for Windows.
   - Extract the downloaded file to a preferred location on your system.
   - Add the Flutter bin directory to your system PATH.
     ```bash
     set PATH=%PATH%;<flutter_installation_directory>\flutter\bin
     ```

2. **Install Visual Studio Code (VSCode):**
   - Download and install [Visual Studio Code](https://code.visualstudio.com/).
   - Install the Flutter and Dart plugins in VSCode.

3. **Clone Quokka Repository:**
   - Clone the Quokka repository from [GitHub](https://github.com/WiroArtificialIntelligence/wiroai.git) using Git or download the ZIP file and extract it.
     ```bash
     git clone https://github.com/WiroArtificialIntelligence/wiroai.git
     ```

4. **Install Dependencies:**
   - Open a terminal and navigate to the Quokka project directory.
   - Run the following command to install all project dependencies.
     ```bash
     flutter pub get
     ```

5. **Run the App:**
   - Connect your device or start an emulator.
   - Run the following command in the terminal to launch the Quokka app.
     ```bash
     flutter run
     ```

6. **Running with Emulator:**
   - To run the app with an emulator, start Android Studio and launch the AVD Manager.
   - Create a new virtual device and start it.
   - Once the emulator is running, execute `flutter run` command in the terminal to deploy the app.

### macOS

1. **Install Flutter SDK:**
   - Download the [Flutter SDK](https://flutter.dev/docs/get-started/install/macos) for macOS.
   - Extract the downloaded file to a preferred location on your system.
   - Add the Flutter bin directory to your system PATH by updating your `.bash_profile` or `.zshrc` file.
     ```bash
     export PATH="$PATH:<flutter_installation_directory>/flutter/bin"
     ```

2. **Install Xcode:**
   - Install Xcode from the Mac App Store.
   - Launch Xcode and accept the license agreement.
     ```bash
     sudo xcodebuild -license accept
     ```

3. **Install Visual Studio Code (VSCode):**
   - Download and install [Visual Studio Code](https://code.visualstudio.com/).
   - Install the Flutter and Dart plugins in VSCode.

4. **Clone Quokka Repository:**
   - Clone the Quokka repository from [GitHub](https://github.com/WiroArtificialIntelligence/wiroai.git) using Git or download the ZIP file and extract it.
     ```bash
     git clone https://github.com/WiroArtificialIntelligence/wiroai.git
     ```

5. **Install Dependencies:**
   - Open a terminal and navigate to the Quokka project directory.
   - Run the following command to install all project dependencies.
     ```bash
     flutter pub get
     ```

6. **Run the App:**
   - Connect your device or start an emulator.
   - Run the following command in the terminal to launch the Quokka app.
     ```bash
     flutter run
     ```

7. **Running with Emulator:**
   - To run the app with an emulator, open Xcode and navigate to `Xcode > Open Developer Tool > Simulator`.
   - Start the desired simulator.
   - Once the simulator is running, execute `flutter run` command in the terminal to deploy the app.