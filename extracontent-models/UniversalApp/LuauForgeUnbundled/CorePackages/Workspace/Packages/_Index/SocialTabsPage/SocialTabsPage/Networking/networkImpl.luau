local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/HttpRequest")

local defineFastInt = game:DefineFastInt("SocialTabsPageHttpRetryCount", 3)

return HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = defineFastInt
})
