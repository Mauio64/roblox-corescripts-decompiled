local ParentParent = script.Parent.Parent
local HttpRequest = require(ParentParent.HttpRequest)
local v3 = game:DefineFastInt("GameInviteHttpRetryCount", 0)

return {
	networkImpl = HttpRequest.config({
		requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
		maxRetryCount = v3
	})
}
