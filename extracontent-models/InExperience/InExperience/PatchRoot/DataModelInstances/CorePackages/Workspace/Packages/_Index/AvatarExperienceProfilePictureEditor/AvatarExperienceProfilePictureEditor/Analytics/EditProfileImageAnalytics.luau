local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local SharedFlags = require(parent.SharedFlags)

local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local Constants = AvatarExperienceAnalytics.Constants
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local FFlagEditProfileImageV2Telemetry = SharedFlags.FFlagEditProfileImageV2Telemetry
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local v = { confirm = "R15_UPGRADE_CONFIRM", cancel = "R15_UPGRADE_CANCEL" }

local function buildSaveElementMetadata(data)
	local v2 = {
		mode = data.mode,
		is_plus_subscriber = tostring(data.isPlusSubscriber)
	}

	if data.emoteAssetId ~= nil then
		v2.emote_asset_id = data.emoteAssetId
	end

	if data.frameAssetId ~= nil then
		v2.frame_asset_id = tostring(data.frameAssetId)
	end

	return HttpService:JSONEncode(v2)
end

local function buildSubscribeElementMetadata(data)
	local v2 = {
		mode = data.mode,
		purchase_flow_uuid = data.purchaseFlowUuid,
		source = data.source
	}

	if data.frameAssetId ~= nil then
		v2.frame_asset_id = tostring(data.frameAssetId)
	end

	return HttpService:JSONEncode(v2)
end

local EditProfileImageAnalytics = {}

function EditProfileImageAnalytics.logPageView(p)
	if not FFlagEditProfileImageV2Telemetry then
		return
	end

	local v2 = {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PAGE_VIEW,
		surface = UnifiedLoggingSurface.EDIT_PROFILE_IMAGE,
		elementName = 0,
		elementMetadata = 0
	}
	local elementName

	if FFlagAXUnifiedEventStrictPayloads then
		elementName = UnifiedLoggingElementNameEnums.EDIT_PROFILE_IMAGE
	end

	v2.elementName = elementName

	v2.elementMetadata = HttpService:JSONEncode({ mode = p.mode })
	sendUnifiedEventLog(v2)

	sendAXCounterV2("EditProfileImagePageView", { mode = p.mode })
end

function EditProfileImageAnalytics.logSave(data)
	if not FFlagEditProfileImageV2Telemetry then
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
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = UnifiedLoggingSurface.EDIT_PROFILE_IMAGE,
		elementName = "SAVE",
		elementMetadata = buildSaveElementMetadata(data)
	})

	reportAvatarEventCounterV1(Constants.AVATAR_EVENT_COUNTER_NAME.AXUpdateProfilePicture)
end

function EditProfileImageAnalytics.logSubscribe(p)
	if not FFlagEditProfileImageV2Telemetry then
		return
	end

	sendUnifiedEventLog({
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = UnifiedLoggingSurface.EDIT_PROFILE_IMAGE,
		elementName = "SUBSCRIBE",
		elementMetadata = buildSubscribeElementMetadata(p)
	})

	sendAXCounterV2("EditProfileImageSubscribe", { mode = p.mode, source = tostring(p.source) })
end

function EditProfileImageAnalytics.logClose(p)
	if not FFlagEditProfileImageV2Telemetry then
		return
	end

	sendUnifiedEventLog({
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = UnifiedLoggingSurface.EDIT_PROFILE_IMAGE,
		elementName = "CLOSE",
		elementMetadata = HttpService:JSONEncode({ mode = p.mode, active_view = p.activeView })
	})

	sendAXCounterV2("EditProfileImageClose", { mode = p.mode })
end

function EditProfileImageAnalytics.logBack(data)
	if not FFlagEditProfileImageV2Telemetry then
		return
	end

	sendUnifiedEventLog({
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = UnifiedLoggingSurface.EDIT_PROFILE_IMAGE,
		elementName = "BACK",
		elementMetadata = HttpService:JSONEncode({
			mode = data.mode,
			active_view = data.activeView,
			outcome = data.outcome
		})
	})

	sendAXCounterV2("EditProfileImageBack", { mode = data.mode, outcome = tostring(data.outcome) })
end

function EditProfileImageAnalytics.logFetchFailure(p)
	if not FFlagEditProfileImageV2Telemetry then
		return
	end

	sendAXCounterV2("EditProfileImageFetchFailure", { asset_type = tostring(p.assetType) })
end

function EditProfileImageAnalytics.logRetry(p)
	if not FFlagEditProfileImageV2Telemetry then
		return
	end

	sendAXCounterV2("EditProfileImageRetry", { mode = p.mode, asset_type = tostring(p.assetType) })
end

function EditProfileImageAnalytics.logR15UpgradePromptShown()
	sendUnifiedEventLog({
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
		surface = UnifiedLoggingSurface.EDIT_PROFILE_IMAGE,
		elementName = "R15_UPGRADE_PROMPT"
	})

	sendAXCounterV2("EditProfileImageR15UpgradePromptShown")
end

function EditProfileImageAnalytics.logR15UpgradePromptInteraction(p: string)
	sendUnifiedEventLog({
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = UnifiedLoggingSurface.EDIT_PROFILE_IMAGE,
		elementName = v[p]
	})

	sendAXCounterV2("EditProfileImageR15UpgradePromptInteraction", { action = tostring(p) })
end

return EditProfileImageAnalytics
