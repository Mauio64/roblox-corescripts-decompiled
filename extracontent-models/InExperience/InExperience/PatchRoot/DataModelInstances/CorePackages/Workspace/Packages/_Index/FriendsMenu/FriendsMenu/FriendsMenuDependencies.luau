local parent = script.Parent.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local HttpRequest = require(parent.HttpRequest)

local config = HttpRequest.config
local v = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("FriendsMenuHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
return {
	networkImpl = config(v),
	sortFriendsByCorrectedPresenceAndRank = LuaSocialLibrariesDeps.SocialLibraries.config({}).User.sortFriendsByCorrectedPresenceAndRank
}
