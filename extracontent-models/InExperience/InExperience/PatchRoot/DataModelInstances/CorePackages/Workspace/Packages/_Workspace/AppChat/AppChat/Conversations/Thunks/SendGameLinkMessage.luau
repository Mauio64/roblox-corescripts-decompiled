local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
require(parent.LuauPolyfill)

local SendTextMessage = require(script.Parent.SendTextMessage)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local Url = Http.Url

local config = HttpRequest.config
local v2 = {
	requestFunction = function(p: string, p2: string, p3)
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("SendGameLinkMessageHttpRetryCount", 4)
end

v2.maxRetryCount = maxRetryCount
local v3 = config(v2)

local function fetchRootPlaceId(p: number)
	return v3(`{Url.GAME_URL}v1/games?universeIds={p}`, "GET"):andThen(function(p2)
		local data = p2 and p2.responseBody and p2.responseBody.data
		local v4 = data and data[1]
		return v4 and v4.rootPlaceId or nil
	end)
end

return function(p: string, p2: number)
	return function(object)
		return v3(`{Url.GAME_URL}v1/games?universeIds={p2}`, "GET"):andThen(function(p3)
			local data = p3 and p3.responseBody and p3.responseBody.data
			local v4 = data and data[1]
			return v4 and v4.rootPlaceId or nil
		end):andThen(function(p3: number?)
			if p3 then
				return object:dispatch(SendTextMessage(p, `{Url.BASE_URL}games/{p3}`, nil))
			end

			return Promise.reject(`no root place id for universe {p2}`)
		end):catch(function(p3)
			v:warning(`SendGameLinkMessage failed for universe {p2}: {tostring(p3)}`)
			return Promise.reject(p3)
		end)
	end
end
