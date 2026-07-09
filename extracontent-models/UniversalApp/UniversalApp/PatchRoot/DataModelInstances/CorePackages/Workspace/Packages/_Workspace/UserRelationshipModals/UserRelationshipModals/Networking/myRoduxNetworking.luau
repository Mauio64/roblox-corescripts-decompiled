local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local UserRelationshipModalsParent = UserRelationshipModals.Parent
local RoduxNetworking = require(UserRelationshipModalsParent.RoduxNetworking)
local HttpRequest = require(UserRelationshipModalsParent.HttpRequest)
local v5 = game:DefineFastInt("AddFriendsHttpRetryCount", 3)
local RODUX_KEY = require(UserRelationshipModals.Rodux.RODUX_KEY)
local v7 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 12
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	maxRetryCount = v5
})

return (RoduxNetworking.config({
	keyPath = `{ RODUX_KEY }.NetworkStatus`,
	networkImpl = v7
}))
