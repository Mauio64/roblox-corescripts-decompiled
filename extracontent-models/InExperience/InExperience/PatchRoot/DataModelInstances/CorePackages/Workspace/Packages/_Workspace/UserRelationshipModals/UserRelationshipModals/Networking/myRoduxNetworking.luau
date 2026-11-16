local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local parent = UserRelationshipModals.Parent

local RoduxNetworking = require(parent.RoduxNetworking)

local HttpRequest = require(parent.HttpRequest)
local defineFastInt = game:DefineFastInt("AddFriendsHttpRetryCount", 3)

local RODUX_KEY = require(UserRelationshipModals.Rodux.RODUX_KEY)

local config = HttpRequest.config({
	requestFunction = function(p, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	maxRetryCount = defineFastInt
})

return (RoduxNetworking.config({ keyPath = `{RODUX_KEY}.NetworkStatus`, networkImpl = config }))
