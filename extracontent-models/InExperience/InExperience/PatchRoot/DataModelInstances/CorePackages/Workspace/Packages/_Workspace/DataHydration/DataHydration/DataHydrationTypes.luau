local parent = script:FindFirstAncestor("DataHydration").Parent
require(parent.Signals)

return {
	DataStatus = { NotReady = "NotReady", Ready = "Ready", Failed = "Failed" }
}
