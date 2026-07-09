local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local SocialLibraries = require(ParentParentParent.SocialLibraries)
local RoduxNetworking = require(ParentParentParent.RoduxNetworking)
local httpRequest = SocialLibraries.httpRequest
local RODUX_KEY = require(ParentParent.Common.Constants).RODUX_KEY
local v7 = game:DefineFastInt("FriendRequestNicknamesMaxHttpRetries", 5)
local v8 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 11
		-- upvalues: httpRequest (copy)
		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	maxRetryCount = v7
})

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v8
}))
