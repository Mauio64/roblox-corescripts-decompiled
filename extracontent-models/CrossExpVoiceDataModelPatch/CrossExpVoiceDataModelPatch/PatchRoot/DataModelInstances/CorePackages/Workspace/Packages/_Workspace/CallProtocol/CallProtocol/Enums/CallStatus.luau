local parent = script:FindFirstAncestor("CallProtocol").Parent

local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	Idle = "Idle",
	Ringing = "Ringing",
	Accepting = "Accepting",
	Initializing = "Initializing",
	Connecting = "Connecting",
	Active = "Active"
})
