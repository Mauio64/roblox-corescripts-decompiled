local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Http").Url
local sduiCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities").SduiCapabilities
local fFlagSduiCapabilityBindings = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagSduiCapabilityBindings
local fFlagSduiEdpClientTemplateCache = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagSduiEdpClientTemplateCache
local fFlagInfoTableStableItemKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagInfoTableStableItemKeys
local fFlagLuaAppEdpMomentVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagLuaAppEdpMomentVideo

local function getExperienceDetailsUrl(p2)
	local experienceDetailsUrl = urlBuilder.new({
		base = url.APIS_URL,
		path = "experience-details-api/v2/universes/{universeId}/experience-details"
	})({ universeId = p2 })

	if not fFlagSduiCapabilityBindings or fFlagSduiEdpClientTemplateCache then
		return experienceDetailsUrl
	end

	require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/ServiceContractsProto")

	local v5 = {
		"CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON",
		"CAPABILITY_SUPPORTS_EDP_COMMUNITY_SECTION",
		"CAPABILITY_SUPPORTS_EDP_BUILD_TAG",
		"CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION",
		"CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION",
		"CAPABILITY_SUPPORTS_SCALED_PLAY_BUTTON_AND_IMAGE_SIZES",
		"CAPABILITY_SUPPORTS_CONTAINER_QUERIES",
		"CAPABILITY_SUPPORTS_EDP_EARLY_ACCESS_UPSELL",
		fFlagLuaAppEdpMomentVideo and "CAPABILITY_SUPPORTS_EDP_MEDIA_GALLERY_MOMENT_VIDEO" or nil
	}

	if fFlagInfoTableStableItemKeys then
		table.insert(v5, "CAPABILITY_SUPPORTS_EDP_INFO_TABLE_STABLE_ITEM_KEYS")
	end

	local v6 = {}

	sduiCapabilities.addToQueryParams(v6, v5)

	if next(v6) ~= nil then
		experienceDetailsUrl = urlBuilder.addQueryString(experienceDetailsUrl, v6)
	end

	return experienceDetailsUrl
end

return getExperienceDetailsUrl
