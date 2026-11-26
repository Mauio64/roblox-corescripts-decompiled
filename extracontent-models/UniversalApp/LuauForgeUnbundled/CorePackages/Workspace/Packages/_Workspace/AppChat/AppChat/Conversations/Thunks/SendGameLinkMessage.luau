local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagLuaAppDefaultHttpRetry
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")

local SendTextMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendTextMessage")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("SendGameLinkMessage")

local url = Http.Url

local config = HttpRequest.config
local v6 = {
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = 0
}

local v7 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("SendGameLinkMessageHttpRetryCount", 4) else nil
v6.maxRetryCount = v7
local v8 = config(v6)

local function fetchRootPlaceId(p2)
	return v8(`{url.GAME_URL}v1/games?universeIds={p2}`, "GET"):andThen(function(p3)
		local data = p3 and p3.responseBody and p3.responseBody.data
		local v9 = data and data[1]
		return v9 and v9.rootPlaceId or nil
	end)
end

return function(p2, p3)
	return function(object)
		return v8(`{url.GAME_URL}v1/games?universeIds={p3}`, "GET"):andThen(function(p4)
			local data = p4 and p4.responseBody and p4.responseBody.data
			local v10 = data and data[1]
			return v10 and v10.rootPlaceId or nil
		end):andThen(function(p4)
			if not p4 then
				return Promise.reject(`no root place id for universe {p3}`)
			end

			return object:dispatch(SendTextMessage(p2, `{url.BASE_URL}games/{p4}`, nil))
		end):catch(function(p4)
			v5:warning(`SendGameLinkMessage failed for universe {p3}: {tostring(p4)}`)
			return Promise.reject(p4)
		end)
	end
end
