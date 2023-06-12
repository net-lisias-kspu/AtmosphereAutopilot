# AtmosphereAutopilot /L Unleashed :: Changes

* 2023-0612: 1.6.0.1 (LisiasT) for KSP >= 1.3.1
	+ Catches up with upstream:
		- 1.5.17
			- handle multiple ModuleSurfaceFX modules in some engines during gimbal module order rearrangement.
		- 1.5.18
			- Fix errors when saving configs for vessel with peculiar names 
		- 1.5.19
			- Make use_breaks globally serializable.
			- Do not override manual breaks usage under target speed in 		- 1.6.0  
			- Introduce AoA-Hold controller that holds desired AoA setpoint. Can be controlled by pitch hotkeys.
	+ Prevents the thing to go 737 MAX when mistyping something on a numeric field
		- Fix proposal on https://github.com/Boris-Barboris/AtmosphereAutopilot/pull/39
	+ Making good use of KSPe's UI Facilities
		- Toolbar
		- Transparent CTB support when installed.
	+ Resurrects KSP 1.3.1 Support (Experimental)
	+ Implements KSP >= 1.8 Support (Experimental)
