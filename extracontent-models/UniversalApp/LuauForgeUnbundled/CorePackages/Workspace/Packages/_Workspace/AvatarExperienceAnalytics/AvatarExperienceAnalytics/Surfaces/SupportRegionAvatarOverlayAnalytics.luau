local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Signals")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SignalsUtils")
local fFlagSplitPaneAvatarMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags").FFlagSplitPaneAvatarMetrics
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Constants")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local UnifiedLoggingElementNameEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Enums/UnifiedLoggingElementNameEnums")

local marketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local v5, v6

if fFlagSplitPaneAvatarMetrics then
	v5, v6 = SignalsUtils.createSessionScopedSignal(false)
else
	v5 = nil
	v6 = nil
end

local v7 = {
	unsaved_changes = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG,
	no_additional_avatars = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NO_ADDITIONAL_AVATARS_DIALOG
}

local v8 = {
	previous = UnifiedLoggingElementNameEnums.SUPPORT_PANE_PREVIOUS_AVATAR_BUTTON,
	next = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NEXT_AVATAR_BUTTON
}

local v9 = {
	save = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG_SAVE_BUTTON,
	switch_anyway = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG_SWITCH_ANYWAY_BUTTON,
	close = UnifiedLoggingElementNameEnums.SUPPORT_PANE_UNSAVED_DIALOG_CLOSE_BUTTON
}

local v10 = {
	create_avatar = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NO_ADDITIONAL_AVATARS_DIALOG_CREATE_BUTTON,
	cancel = UnifiedLoggingElementNameEnums.SUPPORT_PANE_NO_ADDITIONAL_AVATARS_DIALOG_CANCEL_BUTTON
}

local function sendUnifiedClick(p2, p3)
	local v12 = {
		action = marketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = unifiedLoggingSurface.SUPPORT_PANE_AVATAR_OVERLAY,
		elementName = p2,
		elementMetadata = 0
	}

	local v13 = if p3 then HttpService:JSONEncode(p3) else nil
	v12.elementMetadata = v13
	sendUnifiedEventLog(v12)

	if fFlagSplitPaneAvatarMetrics then
		sendAXCounterV2(Constants.AVATAR_EVENT_COUNTER_NAME.SupportRegionAvatarOverlayControlPressed, {
			control = p2
		})
	end
end

local v11 = {
	Dialog = {
		UnsavedChanges = "unsaved_changes",
		NoAdditionalAvatars = "no_additional_avatars"
	}
}

function v11.logDialogShown(p2)
	local v12 = v7[p2]

	sendUnifiedEventLog({
		action = marketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
		surface = unifiedLoggingSurface.SUPPORT_PANE_AVATAR_OVERLAY,
		elementName = v12
	})
	sendAXCounterV2(Constants.AVATAR_EVENT_COUNTER_NAME.SupportRegionAvatarOverlayDialogShown, {
		dialog = v12
	})
end

function v11.logPageView()
	if fFlagSplitPaneAvatarMetrics then
		if v5(false) then
			return
		end

		v6(true)
		sendAXCounterV2(Constants.AVATAR_EVENT_COUNTER_NAME.SupportRegionAvatarOverlayPageView)
	end

	sendUnifiedEventLog({
		action = marketplaceUnifiedAction.PAGE_VIEW,
		surface = unifiedLoggingSurface.SUPPORT_PANE_AVATAR_OVERLAY,
		elementName = UnifiedLoggingElementNameEnums.SUPPORT_PANE_AVATAR_OVERLAY
	})
end

function v11.logProfileChipClick()
	sendUnifiedClick(UnifiedLoggingElementNameEnums.SUPPORT_PANE_PROFILE_CHIP)
end

function v11.logEditAvatarClick()
	sendUnifiedClick(UnifiedLoggingElementNameEnums.SUPPORT_PANE_EDIT_AVATAR_BUTTON)
end

function v11.logChevronClick(p2, p3)
	sendUnifiedClick(v8[p2], { direction = p2, target_data_ready = p3 })
end

function v11.logUnsavedDialogClick(p2)
	sendUnifiedClick(v9[p2])
end

function v11.logNoAdditionalAvatarsDialogClick(p2)
	sendUnifiedClick(v10[p2])
end

return v11
