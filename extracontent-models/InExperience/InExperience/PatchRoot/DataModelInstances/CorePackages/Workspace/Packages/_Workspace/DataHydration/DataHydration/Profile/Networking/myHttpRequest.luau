local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(Parent.HttpRequest)
local v3 = game:DefineFastInt("ProfileCTAHttpRetryCount", 3)

return (HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 7
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	maxRetryCount = v3
}))
