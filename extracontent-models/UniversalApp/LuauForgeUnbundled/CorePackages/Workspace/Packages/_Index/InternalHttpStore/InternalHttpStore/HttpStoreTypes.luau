require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/HttpSignals")

return {
	HttpResponseStatus = table.freeze({
		NotStarted = "NotStarted",
		Fetching = "Fetching",
		Success = "Success",
		Failed = "Failed"
	})
}
