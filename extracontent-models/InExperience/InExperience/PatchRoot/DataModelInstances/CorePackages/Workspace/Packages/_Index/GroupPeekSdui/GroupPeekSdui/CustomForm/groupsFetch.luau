local parent = script:FindFirstAncestor("GroupPeekSdui").Parent

local HttpRequest = require(parent.HttpRequest)

return HttpRequest.config({
	requestFunction = function(p: string, p2: string, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end
})
