# Rainmeter Skins and Management

This folder contains custom skins for the [Rainmeter](https://www.rainmeter.net/) desktop customization tool, along with a PowerShell script to manage their deployment.

## Skins (`trump-skins` folder)

The `trump-skins` subfolder contains the following Rainmeter skins:

*   `eu_Clock.ini`: A clock skin that displays the time in the EU timezone.
*   `in_Clock.ini`: A clock skin that displays the time in the IN timezone.
*   `us_Clock.ini`: A clock skin that displays the time in the US timezone.
*   `HalfHourReminder.ini`: A skin that displays a reminder every 30 minutes.

## `copy.skins.ps1`

This PowerShell script is responsible for copying the Rainmeter skins from the `trump-skins` folder within this repository to the appropriate Rainmeter skins directory on your system.

### How to run

1.  **Via `fire.ps1`**:
    The `fire.ps1` script (located in the repository root) is configured to call `copy.skins.ps1` as part of its startup sequence, ensuring your custom skins are deployed automatically.

2.  **Manually from PowerShell**:
    Open a PowerShell terminal, navigate to this `rainmeter` directory, and execute:
    ```powershell
    .\copy.skins.ps1
    ```
    This will copy the skins to your Rainmeter installation.

## Usage (After Skins are Copied)

1.  Make sure you have [Rainmeter](https://www.rainmeter.net/) installed and running.
2.  Open the Rainmeter application (usually by right-clicking the Rainmeter icon in the system tray and selecting "Manage").
3.  In the Rainmeter manager, you should see the `trump-skins` folder listed under "Skins".
4.  Expand the `trump-skins` folder, select the desired `.ini` files (e.g., `eu_Clock.ini`), and click "Load" to activate them on your desktop.
5.  You can then position and customize the skins as desired.
