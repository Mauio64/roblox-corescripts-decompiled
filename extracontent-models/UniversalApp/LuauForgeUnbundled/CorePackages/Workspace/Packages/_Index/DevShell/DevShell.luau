local createShell = require("@game/CorePackages/Workspace/Packages/_Index/DevShell/DevShell/createShell")
local FFlagEnableDevShell = require("@game/CorePackages/Workspace/Packages/_Index/DevShell/DevShell/Flags/FFlagEnableDevShell")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/DevShell/DevShell/Flags/FFlagEnableMemoryShell")

local v5 = createShell({
	host = game:DefineFastString("DevShellHost", "ws://localhost:5013"),
	enabled = FFlagEnableDevShell or module3
})

return {
	start = v5.start,
	stop = v5.stop,
	isConnected = v5.isConnected,
	registerMethods = v5.registerMethods,
	FFlagEnableMemoryShell = module3
}
