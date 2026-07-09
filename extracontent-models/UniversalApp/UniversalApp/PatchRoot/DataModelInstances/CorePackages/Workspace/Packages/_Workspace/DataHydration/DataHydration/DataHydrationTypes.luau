local Parent = script:FindFirstAncestor("DataHydration").Parent

require(Parent.Signals)

return {
	DataStatus = {
		NotReady = "NotReady",
		Ready = "Ready",
		Failed = "Failed"
	}
}
