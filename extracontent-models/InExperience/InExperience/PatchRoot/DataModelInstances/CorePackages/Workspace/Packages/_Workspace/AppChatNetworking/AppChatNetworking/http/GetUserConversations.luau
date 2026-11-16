local HttpService = game:GetService("HttpService")

local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags2.GetFFlagEnableSocialCards

local function appendQueryArgs(p: string, items)
	local v = {}

	for k, item in items do
		if item ~= nil then
			table.insert(v, `{HttpService:UrlEncode(k)}={HttpService:UrlEncode((tostring(item)))}`)
		end
	end

	if #v == 0 then
		return p
	end

	return `{p}?{table.concat(v, "&")}`
end

return function(p, cursor: string?)
	if cursor == nil or cursor == "" then
		cursor = nil
	end

	local v = {
		cursor = cursor,
		include_cards = GetFFlagEnableSocialCards() and true or false,
		include_user_data = true,
		check_for_group_up = GetFFlagIsSquadEnabled() and true or false
	}

	return (p or default)(appendQueryArgs(`{CHAT_PLATFORM_BASE_URL}/v1/get-user-conversations`, v), "GET")
end
