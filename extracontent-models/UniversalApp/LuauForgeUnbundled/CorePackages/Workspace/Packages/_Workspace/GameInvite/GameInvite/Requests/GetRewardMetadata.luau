local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/HttpRequest")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Http").Url

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagLuaAppDefaultHttpRetry
local config = HttpRequest.config
local v5 = {
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("GetRewardMetadataHttpRetryCount", 4) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Promise")
return function()
	if game.GameId == nil or game.GameId == 0 then
		return Promise.reject("GameId is nil or 0")
	end

	local queryString = url:makeQueryString({ UniverseId = game.GameId })

	return v7(
		string.format("%sreferral-reward-metadata/v1/get-reward-metadata?%s", url.APIS_URL, queryString),
		"GET"
	)
end
