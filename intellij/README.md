# IntelliJ IDEA Configuration

This folder contains configuration files for IntelliJ IDEA, tailored for this project, to ensure consistent code style, inspection profiles, and static analysis settings.

## Files

*   `detekt.yml`: Configuration file for [Detekt](https://detekt.github.io/detekt/), a static code analysis tool for Kotlin. This file defines the rules and thresholds for code quality checks.
*   `CodeStyle-XCP.xml`: An XML file containing the project-specific code style settings. Importing this ensures all developers adhere to the same formatting rules.
*   `inspection-settings.xml`: An XML file that defines the custom inspection profile for the project. This helps maintain code quality by highlighting potential issues.
*   `settings.zip`: A ZIP archive containing a collection of exported IntelliJ IDEA settings. This can include various IDE preferences, keymaps, and other configurations.

## How to Use / Apply Configurations

To apply these configuration files to your IntelliJ IDEA environment:

1.  **Code Style (`CodeStyle-XCP.xml`)**:
    *   Open IntelliJ IDEA.
    *   Go to `File > Settings` (or `IntelliJ IDEA > Preferences` on macOS).
    *   Navigate to `Editor > Code Style`.
    *   Click the gear icon next to the "Scheme" dropdown and select `Import Scheme > IntelliJ IDEA code style XML`.
    *   Browse to and select the `CodeStyle-XCP.xml` file from this directory.
    *   Click `Apply` and `OK`.

2.  **Inspections (`inspection-settings.xml`)**:
    *   Open IntelliJ IDEA.
    *   Go to `File > Settings` (or `IntelliJ IDEA > Preferences` on macOS).
    *   Navigate to `Editor > Inspections`.
    *   Click the gear icon next to the "Profile" dropdown and select `Import Profile...`.
    *   Browse to and select the `inspection-settings.xml` file from this directory.
    *   Click `Apply` and `OK`.

3.  **Detekt (`detekt.yml`)**:
    *   The `detekt.yml` file is typically integrated into your project's build system (e.g., Gradle or Maven) or used via the Detekt CLI.
    *   Refer to your project's build configuration or the [Detekt documentation](https://detekt.github.io/detekt/cli.html) for specific instructions on how to point Detekt to this configuration file.

4.  **Full Settings Import (`settings.zip`)**:
    *   Open IntelliJ IDEA.
    *   Go to `File > Manage IDE Settings > Import Settings...`.
    *   Browse to and select the `settings.zip` file from this directory.
    *   Follow the prompts to select which settings to import.

> **Important Note:** Importing `settings.zip` can overwrite your existing IntelliJ IDEA settings. It is highly recommended to back up your current settings before performing a full import.
