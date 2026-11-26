local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local defineFastInt = game:DefineFastInt("ProfileCTAHttpRetryCount", 3)

return (HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end,
	maxRetryCount = defineFastInt
}))
