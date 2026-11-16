local HttpService = game:GetService("HttpService")

local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local SharedFlags = require(parent.SharedFlags)
local FFlagSplitPaneAvatarMetrics = SharedFlags.FFlagSplitPaneAvatarMetrics
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local sendUnifiedEventLog = require(AvatarExperienceAnalytics.sendUnifiedEventLog)
local sendAXCounterV2 = require(AvatarExperienceAnalytics.sendAXCounterV2)
local Constants = require(AvatarExperienceAnalytics.Constants)
local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)
local UnifiedLoggingElementNameEnums = require(AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums)

local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local v, v2

if FFlagSplitPaneAvatarMetrics then
	v, v2 = SignalsUtils.createSessionScopedSignal(false)
else
	v = nil
	v2 = nil
end

local v3 = {
	unsaved_changes = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG,
	no_additional_avatars = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NO_ADDITIONAL_AVATARS_DIALOG
}

local v4 = {
	previous = UnifiedLoggingElementNameEnums.SUPPORT_PANE_PREVIOUS_AVATAR_BUTTON,
	next = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NEXT_AVATAR_BUTTON
}

local v5 = {
	save = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG_SAVE_BUTTON,
	switch_anyway = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG_SWITCH_ANYWAY_BUTTON,
	close = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG_CLOSE_BUTTON
}

local v6 = {
	create_avatar = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NO_ADDITIONAL_AVATARS_DIALOG_CREATE_BUTTON,
	cancel = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NO_ADDITIONAL_AVATARS_DIALOG_CANCEL_BUTTON
}

local function sendUnifiedClick(p: string, p2)
	local v7 = {
		action = MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = UnifiedLoggingSurface.SUPPORT_PANE_AVATAR_OVERLAY,
		elementName = p,
		elementMetadata = 0
	}
	local elementMetadata

	if p2 then
		elementMetadata = HttpService:JSONEncode(p2)
	end

	v7.elementMetadata = elementMetadata
	sendUnifiedEventLog(v7)

	if FFlagSplitPaneAvatarMetrics then
		sendAXCounterV2(Constants.AVATAR_EVENT_COUNTER_NAME.SupportRegionAvatarOverlayControlPressed, {
			control = p
		})
	end
end

local SupportRegionAvatarOverlayAnalytics = {
	Dialog = { UnsavedChanges = "unsaved_changes", NoAdditionalAvatars = "no_additional_avatars" }
}

function SupportRegionAvatarOverlayAnalytics.logDialogShown(p: string)
	local v7 = v3[p]

	sendUnifiedEventLog({
		action = MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
		surface = UnifiedLoggingSurface.SUPPORT_PANE_AVATAR_OVERLAY,
		elementName = v7
	})
	sendAXCounterV2(Constants.AVATAR_EVENT_COUNTER_NAME.SupportRegionAvatarOverlayDialogShown, {
		dialog = v7
	})
end

function SupportRegionAvatarOverlayAnalytics.logPageView()
	if FFlagSplitPaneAvatarMetrics then
		if v(false) then
			return
		end

		v2(true)
		sendAXCounterV2(Constants.AVATAR_EVENT_COUNTER_NAME.SupportRegionAvatarOverlayPageView)
	end

	sendUnifiedEventLog({
		action = MarketplaceUnifiedAction.PAGE_VIEW,
		surface = UnifiedLoggingSurface.SUPPORT_PANE_AVATAR_OVERLAY,
		elementName = UnifiedLoggingElementNameEnums.SUPPORT_PANE_AVATAR_OVERLAY
	})
end

function SupportRegionAvatarOverlayAnalytics.logProfileChipClick()
	sendUnifiedClick(UnifiedLoggingElementNameEnums.SUPPORT_PANE_PROFILE_CHIP)
end

function SupportRegionAvatarOverlayAnalytics.logEditAvatarClick()
	sendUnifiedClick(UnifiedLoggingElementNameEnums.SUPPORT_PANE_EDIT_AVATAR_BUTTON)
end

function SupportRegionAvatarOverlayAnalytics.logChevronClick(direction: string, target_data_ready: boolean)
	sendUnifiedClick(v4[direction], { direction = direction, target_data_ready = target_data_ready })
end

function SupportRegionAvatarOverlayAnalytics.logUnsavedDialogClick(p: string)
	sendUnifiedClick(v5[p])
end

function SupportRegionAvatarOverlayAnalytics.logNoAdditionalAvatarsDialogClick(p: string)
	sendUnifiedClick(v6[p])
end

return SupportRegionAvatarOverlayAnalytics
