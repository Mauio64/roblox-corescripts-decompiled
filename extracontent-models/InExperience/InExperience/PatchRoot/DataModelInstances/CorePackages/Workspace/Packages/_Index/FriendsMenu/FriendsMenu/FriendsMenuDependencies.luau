local ParentParent = script.Parent.Parent
local FFlagLuaAppDefaultHttpRetry = require(ParentParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local HttpRequest = require(ParentParent.HttpRequest)
local v5 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("FriendsMenuHttpRetryCount", 4)
})
local sortFriendsByCorrectedPresenceAndRank = LuaSocialLibrariesDeps.SocialLibraries.config({}).User.sortFriendsByCorrectedPresenceAndRank

return {
	networkImpl = v5,
	sortFriendsByCorrectedPresenceAndRank = sortFriendsByCorrectedPresenceAndRank
}
