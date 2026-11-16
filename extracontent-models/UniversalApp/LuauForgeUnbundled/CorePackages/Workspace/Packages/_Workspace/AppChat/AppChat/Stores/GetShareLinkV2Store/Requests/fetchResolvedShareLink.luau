local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NetworkingShareLinks")

local FFlagAppChatPlusReferralAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralAssetCard")

local v5 = Http.Url.APIS_URL .. "deeplinks/v2/resolve"

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

local function fetchResolvedShareLink(p2, p3)
	return HttpClient.fetch({
		method = "POST",
		url = v5,
		body = { linkId = p2 },
		analyticsKey = "app-chat.resolve-share-link-v2",
		network = p3,
		decode = decodeResolvedShareLink
	})
end

return fetchResolvedShareLink
