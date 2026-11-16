local parent = script:FindFirstAncestor("GameDetail").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiCapabilityBindings = SharedFlags.FFlagSduiCapabilityBindings
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiEdpClientTemplateCache = SharedFlags2.FFlagSduiEdpClientTemplateCache
local SharedFlags3 = require(parent.SharedFlags)
local FFlagInfoTableStableItemKeys = SharedFlags3.FFlagInfoTableStableItemKeys
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEdpMomentVideo = SharedFlags4.FFlagLuaAppEdpMomentVideo

local function getExperienceDetailsUrl(universeId: string)
	local experienceDetailsUrl = urlBuilder.new({
		base = Url.APIS_URL,
		path = "experience-details-api/v2/universes/{universeId}/experience-details"
	})({ universeId = universeId })

	if not FFlagSduiCapabilityBindings or FFlagSduiEdpClientTemplateCache then
		return experienceDetailsUrl
	end

	require(parent.ServiceContractsProto)

	local v = {
		"CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON",
		"CAPABILITY_SUPPORTS_EDP_COMMUNITY_SECTION",
		"CAPABILITY_SUPPORTS_EDP_BUILD_TAG",
		"CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION",
		"CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION",
		"CAPABILITY_SUPPORTS_SCALED_PLAY_BUTTON_AND_IMAGE_SIZES",
		"CAPABILITY_SUPPORTS_CONTAINER_QUERIES",
		"CAPABILITY_SUPPORTS_EDP_EARLY_ACCESS_UPSELL",
		FFlagLuaAppEdpMomentVideo and "CAPABILITY_SUPPORTS_EDP_MEDIA_GALLERY_MOMENT_VIDEO" or nil
	}

	if FFlagInfoTableStableItemKeys then
		table.insert(v, "CAPABILITY_SUPPORTS_EDP_INFO_TABLE_STABLE_ITEM_KEYS")
	end

	local v2 = {}

	SduiCapabilities.addToQueryParams(v2, v)

	if next(v2) ~= nil then
		experienceDetailsUrl = urlBuilder.addQueryString(experienceDetailsUrl, v2)
	end

	return experienceDetailsUrl
end

return getExperienceDetailsUrl
