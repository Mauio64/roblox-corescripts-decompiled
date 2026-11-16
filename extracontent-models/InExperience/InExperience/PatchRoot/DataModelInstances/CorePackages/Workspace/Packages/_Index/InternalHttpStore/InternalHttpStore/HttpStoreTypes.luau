local parent = script.Parent.Parent

require(parent.Signals)
require(parent.HttpSignals)

return {
	HttpResponseStatus = table.freeze({
		NotStarted = "NotStarted",
		Fetching = "Fetching",
		Success = "Success",
		Failed = "Failed"
	})
}
