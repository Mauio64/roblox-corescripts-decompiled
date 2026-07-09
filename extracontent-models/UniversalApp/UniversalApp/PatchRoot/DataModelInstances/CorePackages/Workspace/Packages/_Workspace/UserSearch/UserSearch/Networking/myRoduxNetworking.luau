local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local LuaSocialLibrariesDeps = require(UserSearchParent.LuaSocialLibrariesDeps)
local RODUX_KEY = require(UserSearch.Common.Constants).RODUX_KEY
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local myHttpRequest = require(script.Parent.myHttpRequest)
local ChallengeRequestWrapper = require(UserSearchParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local v8 = game:DefineFastFlag("EnableUserSearchChallengeInterceptor", false)

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = if not v8 then myHttpRequest else ChallengeRequestWrapper(myHttpRequest)
}))
