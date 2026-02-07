# IntelliJ IDEA Configuration

This folder contains configuration files for IntelliJ IDEA, tailored for this project.

## Files

*   `detekt.yml`: Configuration file for [Detekt](https://detekt.github.io/detekt/), a static code analysis tool for Kotlin.
*   `CodeStyle-XCP.xml`: An XML file containing the code style settings for the project.
*   `inspection-settings.xml`: An XML file that defines the inspection profile for the project.
*   `settings.zip`: A ZIP file containing exported IntelliJ IDEA settings.

## Usage

To use these configuration files, import them into IntelliJ IDEA:

1.  **Code Style**:
    *   Go to `File > Settings > Editor > Code Style`.
    *   Click the gear icon and select `Import Scheme > IntelliJ IDEA code style XML`.
    *   Select the `CodeStyle-XCP.xml` file.

2.  **Inspections**:
    *   Go to `File > Settings > Editor > Inspections`.
    *   Click the gear icon and select `Import Profile...`.
    *   Select the `inspection-settings.xml` file.

3.  **Detekt**:
    *   The `detekt.yml` file is used by the Detekt tool. Refer to the [Detekt documentation](https://detekt.github.io/detekt/cli.html) for instructions on how to integrate it with your build process.

4.  **Settings**:
    *   Go to `File > Manage IDE Settings > Import Settings...`.
    *   Select the `settings.zip` file.

> **Note:** Importing `settings.zip` will overwrite your existing IntelliJ IDEA settings. It is recommended to back up your settings before importing.
