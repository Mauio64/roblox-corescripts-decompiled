local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FFlagLuaAppDefaultHttpRetry = require(AppChatParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local Http = require(AppChatParent.Http)
local HttpRequest = require(AppChatParent.HttpRequest)
local Promise = require(AppChatParent.Promise)

require(AppChatParent.LuauPolyfill)

local SendTextMessage = require(script.Parent.SendTextMessage)
local v8 = require(AppChat.Logger):new(script.Name)
local Url = Http.Url
local v10 = HttpRequest.config({
	requestFunction = function(s1: string, s2: string, p1) -- line: 25
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(s1, s2, p1)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("SendGameLinkMessageHttpRetryCount", 4)
})

local function fetchRootPlaceId(n1: number) -- line: 33
	-- upvalues: Url (copy), v10 (copy)
	local v16 = `{ Url.GAME_URL }v1/games?universeIds={ n1 }`

	return v10(v16, "GET"):andThen(function(p2) -- line: 36
		local v20 = p2 and (p2.responseBody and p2.responseBody.data)
		local v21 = v20 and v20[1]

		return v21 and v21.rootPlaceId or nil
	end)
end

return function(s3: string, n2: number) -- line: 43
	-- upvalues: Url (copy), v10 (copy), Promise (copy), SendTextMessage (copy), v8 (copy)
	return function(p3) -- line: 44
		-- upvalues: n2 (copy), Url (copy), v10 (copy), Promise (copy), SendTextMessage (copy), s3 (copy), v8 (copy)
		local v23 = n2
		local v24 = `{ Url.GAME_URL }v1/games?universeIds={ v23 }`

		return v10(v24, "GET"):andThen(function(p4) -- line: 36
			local v26 = p4 and (p4.responseBody and p4.responseBody.data)
			local v27 = v26 and v26[1]

			return v27 and v27.rootPlaceId or nil
		end):andThen(function(n3: number?) -- line: 46
			-- upvalues: Promise (copy), n2 (copy), Url (copy), p3 (copy), SendTextMessage (copy), s3 (copy)
			if not n3 then
				return Promise.reject(`no root place id for universe { n2 }`)
			end

			local v29 = `{ Url.BASE_URL }games/{ n3 }`

			return p3:dispatch(SendTextMessage(s3, v29, nil))
		end):catch(function(p5) -- line: 55
			-- upvalues: v8 (copy), n2 (copy), Promise (copy)
			v8:warning(`SendGameLinkMessage failed for universe { n2 }: { tostring(p5) }`)

			return Promise.reject(p5)
		end)
	end
end
