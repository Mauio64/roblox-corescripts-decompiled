local Parent = script:FindFirstAncestor("CallProtocol").Parent

return require(Parent.enumerate)(script.Name, {
	Idle = "Idle",
	Ringing = "Ringing",
	Accepting = "Accepting",
	Initializing = "Initializing",
	Connecting = "Connecting",
	Active = "Active"
})
