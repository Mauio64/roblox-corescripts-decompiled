local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default
local GetFFlagIsSquadEnabled = require(AppChatNetworkingParent.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagEnableSocialCards = require(AppChatNetworkingParent.SharedFlags).GetFFlagEnableSocialCards

local function appendQueryArgs(s1: string, t1: {[any]: any}) -- line: 11
	-- upvalues: HttpService (copy)
	local t2 = {}

	for v12, v13 in t1 do
		if v13 ~= nil then
			table.insert(t2, `{ HttpService:UrlEncode(v12) }={ HttpService:UrlEncode((tostring(v13))) }`)
		end
	end

	if #t2 == 0 then
		return s1
	end

	return `{ s1 }?{ table.concat(t2, "&") }`
end

return function(p1, s2: string?) -- line: 26
	-- upvalues: default (copy), GetFFlagEnableSocialCards (copy), GetFFlagIsSquadEnabled (copy), appendQueryArgs (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v16 = p1 or default
	local t3 = {
		include_user_data = true,
		cursor = if s2 == nil or s2 == "" then nil else s2,
		include_cards = not not GetFFlagEnableSocialCards(),
		check_for_group_up = not not GetFFlagIsSquadEnabled()
	}

	return v16(appendQueryArgs(`{ CHAT_PLATFORM_BASE_URL }/v1/get-user-conversations`, t3), "GET")
end
