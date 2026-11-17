local createShell = require(script.createShell)
local FFlagEnableDevShell = require(script.Flags.FFlagEnableDevShell)
local FFlagEnableMemoryShell = require(script.Flags.FFlagEnableMemoryShell)

local shell = createShell({
	host = game:DefineFastString("DevShellHost", "ws://localhost:5013"),
	enabled = FFlagEnableDevShell or FFlagEnableMemoryShell
})

return {
	["jest.config"] = script["jest.config"],
	start = shell.start,
	stop = shell.stop,
	isConnected = shell.isConnected,
	registerMethods = shell.registerMethods,
	FFlagEnableMemoryShell = FFlagEnableMemoryShell
}
