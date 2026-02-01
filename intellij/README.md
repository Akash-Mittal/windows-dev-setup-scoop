# IntelliJ IDEA Configuration

This folder contains configuration files for IntelliJ IDEA, tailored for this project.

## Files

*   `detekt.yml`: Configuration file for [Detekt](https://detekt.github.io/detekt/), a static code analysis tool for Kotlin. This file defines the rules and settings for code analysis.
*   `CodeStyle-XCP.xml`: An XML file containing the code style settings for the project. This can be imported into IntelliJ to ensure consistent code formatting.
*   `inspection-settings.xml`: An XML file that defines the inspection profile for the project. This file configures which inspections are enabled and their severity levels.
*   `settings.zip`: A ZIP file containing exported IntelliJ IDEA settings. This can be imported to quickly set up an IDE with the project's recommended settings.

## Usage

To use these configuration files:

1.  **Code Style**: In IntelliJ, go to `File > Settings > Editor > Code Style`, click the gear icon, and select `Import Scheme > IntelliJ IDEA code style XML`. Select the `CodeStyle-XCP.xml` file.
2.  **Inspections**: Go to `File > Settings > Editor > Inspections`, click the gear icon, and select `Import Profile...`. Select the `inspection-settings.xml` file.
3.  **Detekt**: The `detekt.yml` file is used by the Detekt tool. Refer to the Detekt documentation for instructions on how to integrate it with your build process.
4.  **Settings**: To import the settings from `settings.zip`, go to `File > Manage IDE Settings > Import Settings...` and select the `settings.zip` file.
