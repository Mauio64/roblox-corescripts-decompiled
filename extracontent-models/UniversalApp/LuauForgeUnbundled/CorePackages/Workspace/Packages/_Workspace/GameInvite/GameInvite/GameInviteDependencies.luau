local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/HttpRequest")

local defineFastInt = game:DefineFastInt("GameInviteHttpRetryCount", 0)

return {
	networkImpl = HttpRequest.config({
		requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
		maxRetryCount = defineFastInt
	})
}
