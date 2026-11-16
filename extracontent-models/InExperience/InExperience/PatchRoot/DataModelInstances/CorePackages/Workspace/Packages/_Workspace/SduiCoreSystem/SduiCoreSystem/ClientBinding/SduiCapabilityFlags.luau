local parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)

local function isPinShortcutServiceEnabled() -- 1 equivalent call inferred from this helper
	return game:GetEngineFeature("PinShortcutServiceEnabled")
end

local function isPinShortcutAvailable(): boolean
	if not (SharedFlags.FFlagSduiPinShortcutAction and isPinShortcutServiceEnabled()) then -- inferred equivalent call
		return false
	end

	local v = nil

	pcall(function()
		local PinShortcutService = game:GetService("PinShortcutService")
		v = PinShortcutService
	end)

	if v == nil then
		return false
	end

	local success, result = pcall(function()
		return v:IsAvailable()
	end)

	if success then
		return result == true
	end

	return false
end

return {
	CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS = true,
	["CAPABILITY_SUPPORTS_MULTI_SIZE_POOL"] = SharedFlags.FFlagSduiPerSectionPoolSizing,
	CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton,
	CAPABILITY_SUPPORTS_EDP_COMMUNITY_SECTION = SharedFlags.FFlagSduiCommunitySectionSupport,
	CAPABILITY_SUPPORTS_EDP_BUILD_TAG = SharedFlags.FFlagLuaAppEdpShowBuildTag,
	CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION = SharedFlags.FFlagSduiCapabilityDevStoreSeeAllWebviewFallback,
	CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION = isPinShortcutAvailable(),
	CAPABILITY_SUPPORTS_EVENT_RSVP_FACE_PILE = SharedFlags.FFlagSduiEventRsvpFacePile,
	CAPABILITY_SUPPORTS_SCALED_PLAY_BUTTON_AND_IMAGE_SIZES = SharedFlags.FFlagSduiScalePlayButtonAndImageSizes,
	CAPABILITY_SUPPORTS_EXTENDED_CLIENT_CAPABILITIES = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets,
	CAPABILITY_SUPPORTS_PREFERRED_TEXT_SIZE_LINE_BUDGETS = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets,
	CAPABILITY_SUPPORTS_CONTAINER_QUERIES = SharedFlags.FFlagSduiContainerQueries,
	CAPABILITY_SUPPORTS_EDP_EARLY_ACCESS_UPSELL = SharedFlags.FFlagEnableGameJoinEarlyAccess,
	CAPABILITY_SUPPORTS_LEADERBOARD = SharedFlags.FFlagSduiLeaderboardCapability,
	CAPABILITY_SUPPORTS_EDP_INFO_TABLE_STABLE_ITEM_KEYS = SharedFlags.FFlagInfoTableStableItemKeys,
	CAPABILITY_SUPPORTS_VIDEO_PLAYER_ACCESS_CONTEXT = SharedFlags.FFlagLuaAppHomeMomentVideoFallback and SharedFlags.FFlagLuaAppVideoPlayerTrimAndMusic,
	CAPABILITY_SUPPORTS_GROUP_ANNOUNCEMENTS = SharedFlags.FFlagGroupAnnouncementsSdui,
	CAPABILITY_SUPPORTS_GROUP_CONTENT_REACTIONS = SharedFlags.FFlagSduiReactionsComponent,
	CAPABILITY_SUPPORTS_FOUNDATION_BADGE_OVERMEDIA_LIGHT = Foundation.Utility.Flags.FoundationBadgeOverMediaAdaptive,
	CAPABILITY_SUPPORTS_EDP_MEDIA_GALLERY_MOMENT_VIDEO = SharedFlags.FFlagLuaAppEdpMomentVideo and SharedFlags.FFlagLuaAppVideoPlayerTrimAndMusic,
	CAPABILITY_SUPPORTS_SAFETY_RESOURCE_BANNER = SharedFlags.FFlagSafetyResourceBannerTelemetry and SharedFlags.FFlagLuaAppSduiOpenExternalLinkAction,
	CAPABILITY_SUPPORTS_LAUNCH_EXPERIENCE_PLAYABILITY_CHECK = SharedFlags.FFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch
}
