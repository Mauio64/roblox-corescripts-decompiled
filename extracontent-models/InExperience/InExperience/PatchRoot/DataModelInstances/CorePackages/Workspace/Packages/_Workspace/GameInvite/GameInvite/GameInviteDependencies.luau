local parent = script.Parent.Parent

local HttpRequest = require(parent.HttpRequest)

local defineFastInt = game:DefineFastInt("GameInviteHttpRetryCount", 0)

return {
	networkImpl = HttpRequest.config({
		requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
		maxRetryCount = defineFastInt
	})
}
