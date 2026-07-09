local Parent = script:FindFirstAncestor("GameInvite").Parent
local HttpRequest = require(Parent.HttpRequest)
local Url = require(Parent.Http).Url
local FFlagLuaAppDefaultHttpRetry = require(Parent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v5 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("GetRewardMetadataHttpRetryCount", 4)
})
local Promise = require(Parent.Promise)

return function() -- line: 14
	-- upvalues: Promise (copy), Url (copy), v5 (copy)
	if game.GameId == nil or game.GameId == 0 then
		return Promise.reject("GameId is nil or 0")
	end

	local v7 = Url:makeQueryString({
		UniverseId = game.GameId
	})
	local v8 = string.format("%sreferral-reward-metadata/v1/get-reward-metadata?%s", Url.APIS_URL, v7)

	return v5(v8, "GET")
end
