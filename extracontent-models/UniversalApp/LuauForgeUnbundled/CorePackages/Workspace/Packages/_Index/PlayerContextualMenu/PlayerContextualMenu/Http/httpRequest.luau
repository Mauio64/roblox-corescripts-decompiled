local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/HttpRequest")

return HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = 0
})
