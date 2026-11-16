local parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(parent.HttpRequest)
local defineFastInt = game:DefineFastInt("PresenceHttpRetryCount", 3)

return (HttpRequest.config({
	requestFunction = function(p, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	maxRetryCount = defineFastInt
}))
