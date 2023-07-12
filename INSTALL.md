# Atmosphere Autopilot /L Unleashed

Plugin for Kerbal Space Program.

[Unleashed](https://ksp.lisias.net/add-ons-unleashed/) fork by Lisias.


## Installation Instructions

To install, place the GameData folder inside your Kerbal Space Program folder. Optionally, you can also do the same for the PluginData (be careful to do not overwrite your custom settings):

* **REMOVE ANY OLD VERSIONS OF THE PRODUCT BEFORE INSTALLING**, including any other fork:
	+ Delete `<KSP_ROOT>/GameData/net.lisias.ksp/AtmosphereAutopilot `
	+ Delete `<KSP_ROOT>/GameData/AtmosphereAutopilot `
* Extract the package's `GameData` folder into your KSP's root:
	+ `<PACKAGE>/GameData` --> `<KSP_ROOT>/`
* Extract the package's `PluginData` folder (if available) into your KSP's root, taking precautions to do not overwrite your custom settings if this is not what you want to.
	+ `<PACKAGE>/PluginData` --> `<KSP_ROOT>/`
	+ You can safely ignore this step if you already had installed it previously and didn't deleted your custom configurable files.
* This one is unorthodox: depending of what KSP you are using, you will need to remove one of the following DLL files from your GameData:
	+ If you are using KSP until 1.7.3:
		- delete `<KSP_ROOT>/GameData/net.lisias.ksp/AtmosphereAutopilot/Plugins/AtmosphereAutopilot180.dll`
	+ If you are using KSP from 1.8.0 to the newest:
		- delete `<KSP_ROOT>/GameData/net.lisias.ksp/AtmosphereAutopilot/Plugins/AtmosphereAutopilot.dll`

The following file layout must be present after installation:

```
<KSP_ROOT>
	[GameData]
		[net.lisias.ksp]
			[AtmosphereAutopilot]
				[Plugins]
					[PluginData]
						...
					AtmosphereAutopilot.dll		-- Only for KSP < 1.8.0
					AtmosphereAutopilot180.dll -- Only for KSP >= 1.8.0
					...
				CHANGE_LOG.md
				LICENSE
				NOTICE
				README.md
				AtmosphereAutopilot.version
		000_KSPe.dll
		ModuleManager.dll
		KSPUpgradeScriptFix.dll (only on KSP >= 1.8)
		...
	[PluginData]
			[net.lisias.ksp]
				[AtmosphereAutopilot]
					Global_settings.txt
	KSP.log
	PastDatabase.cfg
	...
```


### Dependencies

* [KSP Extended](https://github.com/net-lisias-ksp/KSPe)
	+ Not Included
* [KSPUpgradeScriptFix](https://github.com/net-lisias-ksph/KSPUpgradeScriptFix)
	+ Only for KSP >= 1.8
	+ Not Included
