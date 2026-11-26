local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").FFlagLuaAppDefaultHttpRetry
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/LuaSocialLibrariesDeps")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/HttpRequest")

local config = HttpRequest.config
local v5 = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }
local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("FriendsMenuHttpRetryCount", 4) else nil
v5.maxRetryCount = v6
return {
	networkImpl = config(v5),
	sortFriendsByCorrectedPresenceAndRank = LuaSocialLibrariesDeps.SocialLibraries.config({}).User.sortFriendsByCorrectedPresenceAndRank
}
