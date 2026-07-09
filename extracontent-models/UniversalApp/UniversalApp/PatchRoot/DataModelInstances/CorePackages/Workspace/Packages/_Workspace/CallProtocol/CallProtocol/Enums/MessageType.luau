local Parent = script:FindFirstAncestor("CallProtocol").Parent

return require(Parent.enumerate)(script.Name, {
	CallError = "CallError"
})
