local HttpService = game:GetService("HttpService")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceAnalytics")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags")

local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local constants = AvatarExperienceAnalytics.Constants
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceFlags")

local fFlagEditProfileImageV2Telemetry = SharedFlags.FFlagEditProfileImageV2Telemetry
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local v6 = { confirm = "R15_UPGRADE_CONFIRM", cancel = "R15_UPGRADE_CANCEL" }

local function buildSaveElementMetadata(data)
	local v7 = {
		mode = data.mode,
		is_plus_subscriber = tostring(data.isPlusSubscriber)
	}

	if data.emoteAssetId ~= nil then
		v7.emote_asset_id = data.emoteAssetId
	end

	if data.frameAssetId ~= nil then
		v7.frame_asset_id = tostring(data.frameAssetId)
	end

	return HttpService:JSONEncode(v7)
end

local function buildSubscribeElementMetadata(data)
	local v7 = {
		mode = data.mode,
		purchase_flow_uuid = data.purchaseFlowUuid,
		source = data.source
	}

	if data.frameAssetId ~= nil then
		v7.frame_asset_id = tostring(data.frameAssetId)
	end

	return HttpService:JSONEncode(v7)
end

return {
	logPageView = function(p2)
		if not fFlagEditProfileImageV2Telemetry then
			return
		end

		local v8 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.PAGE_VIEW,
			surface = unifiedLoggingSurface.EDIT_PROFILE_IMAGE,
			elementName = 0,
			elementMetadata = 0
		}

		local v9 = if fFlagAXUnifiedEventStrictPayloads then unifiedLoggingElementNameEnums.EDIT_PROFILE_IMAGE else nil
		v8.elementName = v9

		v8.elementMetadata = HttpService:JSONEncode({ mode = p2.mode })
		sendUnifiedEventLog(v8)

		sendAXCounterV2("EditProfileImagePageView", { mode = p2.mode })
	end,
	logSave = function(data)
		if not fFlagEditProfileImageV2Telemetry then
			return
		end

		sendAXCounterV2("EditProfileImageSave", {
			mode = data.mode,
			is_plus_subscriber = data.isPlusSubscriber and "true" or "false",
			result = tostring(data.result)
		})

		if data.result ~= "success" then
			return
		end

		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.EDIT_PROFILE_IMAGE,
			elementName = "SAVE",
			elementMetadata = buildSaveElementMetadata(data)
		})

		reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXUpdateProfilePicture)
	end,
	logSubscribe = function(p2)
		if not fFlagEditProfileImageV2Telemetry then
			return
		end

		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.EDIT_PROFILE_IMAGE,
			elementName = "SUBSCRIBE",
			elementMetadata = buildSubscribeElementMetadata(p2)
		})

		sendAXCounterV2("EditProfileImageSubscribe", {
			mode = p2.mode,
			source = tostring(p2.source)
		})
	end,
	logClose = function(p2)
		if not fFlagEditProfileImageV2Telemetry then
			return
		end

		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.EDIT_PROFILE_IMAGE,
			elementName = "CLOSE",
			elementMetadata = HttpService:JSONEncode({
				mode = p2.mode,
				active_view = p2.activeView
			})
		})

		sendAXCounterV2("EditProfileImageClose", { mode = p2.mode })
	end,
	logBack = function(data)
		if not fFlagEditProfileImageV2Telemetry then
			return
		end

		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.EDIT_PROFILE_IMAGE,
			elementName = "BACK",
			elementMetadata = HttpService:JSONEncode({
				mode = data.mode,
				active_view = data.activeView,
				outcome = data.outcome
			})
		})

		sendAXCounterV2("EditProfileImageBack", {
			mode = data.mode,
			outcome = tostring(data.outcome)
		})
	end,
	logFetchFailure = function(p2)
		if not fFlagEditProfileImageV2Telemetry then
			return
		end

		sendAXCounterV2("EditProfileImageFetchFailure", {
			asset_type = tostring(p2.assetType)
		})
	end,
	logRetry = function(p2)
		if not fFlagEditProfileImageV2Telemetry then
			return
		end

		sendAXCounterV2("EditProfileImageRetry", {
			mode = p2.mode,
			asset_type = tostring(p2.assetType)
		})
	end,
	logR15UpgradePromptShown = function()
		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
			surface = unifiedLoggingSurface.EDIT_PROFILE_IMAGE,
			elementName = "R15_UPGRADE_PROMPT"
		})

		sendAXCounterV2("EditProfileImageR15UpgradePromptShown")
	end,
	logR15UpgradePromptInteraction = function(p2)
		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.EDIT_PROFILE_IMAGE,
			elementName = v6[p2]
		})

		sendAXCounterV2("EditProfileImageR15UpgradePromptInteraction", {
			action = tostring(p2)
		})
	end
}
