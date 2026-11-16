local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local Constants = require(UserSearch.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking

local myHttpRequest = require(script.Parent.myHttpRequest)
local GenericChallenges = require(parent.GenericChallenges)
local ChallengeRequestWrapper = GenericChallenges.Middleware.ChallengeRequestWrapper
local defineFastFlag = game:DefineFastFlag("EnableUserSearchChallengeInterceptor", false)

local config = RoduxNetworking.config
local v = {
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = 0
}

if defineFastFlag then
	myHttpRequest = ChallengeRequestWrapper(myHttpRequest)
end

v.networkImpl = myHttpRequest
return (config(v))
