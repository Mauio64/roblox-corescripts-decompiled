local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
require(parent.ShareLinksNetworking)

local FFlagAppChatPlusReferralAssetCard = require(AppChat.Flags.FFlagAppChatPlusReferralAssetCard)

local url = Http.Url.APIS_URL .. "deeplinks/v2/resolve"

local function decodeResolvedShareLink(state)
	if
		type(state) ~= "table"
		or type(state.linkType) ~= "string"
		or type(state.targetId) ~= "string"
		or type(state.status) ~= "string"
	then
		error("Malformed deeplinks/v2/resolve response")
	end

	if FFlagAppChatPlusReferralAssetCard then
		if state.customData ~= nil and type(state.customData) ~= "string" then
			error("Malformed deeplinks/v2/resolve response")
		end

		state.customData = state.customData or ""
	elseif type(state.customData) ~= "string" then
		error("Malformed deeplinks/v2/resolve response")
	end

	return state
end

local function fetchResolvedShareLink(linkId: string, network)
	return HttpClient.fetch({
		method = "POST",
		url = url,
		body = { linkId = linkId },
		analyticsKey = "app-chat.resolve-share-link-v2",
		network = network,
		decode = decodeResolvedShareLink
	})
end

return fetchResolvedShareLink
