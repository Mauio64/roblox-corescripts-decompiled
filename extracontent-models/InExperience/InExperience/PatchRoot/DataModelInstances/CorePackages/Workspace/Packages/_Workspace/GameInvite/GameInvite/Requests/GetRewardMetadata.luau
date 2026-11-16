local parent = script:FindFirstAncestor("GameInvite").Parent
local HttpRequest = require(parent.HttpRequest)
local Http = require(parent.Http)
local Url = Http.Url

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local config = HttpRequest.config
local v = { requestFunction = HttpRequest.requestFunctions.RequestInternal, maxRetryCount = 0 }
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("GetRewardMetadataHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local v2 = config(v)

local Promise = require(parent.Promise)
return function()
	if game.GameId == nil or game.GameId == 0 then
		return Promise.reject("GameId is nil or 0")
	end

	local queryString = Url:makeQueryString({ UniverseId = game.GameId })

	return v2(string.format("%sreferral-reward-metadata/v1/get-reward-metadata?%s", Url.APIS_URL, queryString), "GET")
end
