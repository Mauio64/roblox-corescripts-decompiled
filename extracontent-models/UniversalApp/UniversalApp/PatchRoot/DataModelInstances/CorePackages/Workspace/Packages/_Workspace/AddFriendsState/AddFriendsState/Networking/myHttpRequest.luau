local Parent = script:FindFirstAncestor("AddFriendsState").Parent
local HttpRequest = require(Parent.HttpRequest)
local v3 = game:DefineFastInt("AddFriendsHttpRetryCount", 3)

return (HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 8
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	maxRetryCount = v3
}))
