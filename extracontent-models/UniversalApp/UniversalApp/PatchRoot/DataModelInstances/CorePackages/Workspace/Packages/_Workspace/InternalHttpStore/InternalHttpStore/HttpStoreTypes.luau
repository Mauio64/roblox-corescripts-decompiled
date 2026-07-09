local ParentParent = script.Parent.Parent

require(ParentParent.Signals)
require(ParentParent.HttpSignals)

return {
	HttpResponseStatus = table.freeze({
		NotStarted = "NotStarted",
		Fetching = "Fetching",
		Success = "Success",
		Failed = "Failed"
	})
}
