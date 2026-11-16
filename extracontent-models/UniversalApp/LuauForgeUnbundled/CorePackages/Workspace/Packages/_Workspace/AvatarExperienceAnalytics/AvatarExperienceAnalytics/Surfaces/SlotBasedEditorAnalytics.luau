local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AnalyticsService")
local ImpressionEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Enums/ImpressionEnums")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXExtendUndoRedoTracking = AvatarExperienceFlags.FFlagAXExtendUndoRedoTracking
local fFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.AvatarScreen

function LUAUFORGE_MODULE_GLOBALS_axr_mapAvatarScreenToSurface(p2)
	local v5 = ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE

	if p2 == avatarScreen.Catalog then
		return ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE
	end

	if p2 == avatarScreen.CatalogSearch then
		return ImpressionEnums.MarketplaceSurfaceType.SEARCH
	end

	if p2 == avatarScreen.AvatarEditor then
		v5 = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
	end

	return v5
end

local function trackUndoHistoryCount(p2, p3)
	local v5 = LUAUFORGE_MODULE_GLOBALS_axr_mapAvatarScreenToSurface(p2)

	local v6 = {
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		group = `UndoRedo_history_count_{p3}`,
		surface = v5
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
end

local function trackAvatarRestoreClick(p2)
	local v5 = LUAUFORGE_MODULE_GLOBALS_axr_mapAvatarScreenToSurface(p2)

	local v6 = {
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		group = "AvatarRestoreSaved",
		surface = v5
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
end

local function trackAvatarRemoveAllClick(p2)
	local v5 = LUAUFORGE_MODULE_GLOBALS_axr_mapAvatarScreenToSurface(p2)

	local v6 = {
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		group = "AvatarRemoveAll",
		surface = v5
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
end

local v5 = {
	trackSlotClick = function(p2)
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			subcategory = p2.editorSubcategory,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackSaveClick = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SaveAvatarButton",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackControlBarClick = function(p2)
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_{p2}`,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackAdvancedCustomizationControlBarClick = function(p2)
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_AdvancedCustomization_{p2}`,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackAdvancedCustomizationControlBarClickFromSurface = function(p2, p3)
		local v6 = LUAUFORGE_MODULE_GLOBALS_axr_mapAvatarScreenToSurface(p3)

		local v7 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_AdvancedCustomization_{p2}`,
			surface = v6
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v7)
	end,
	trackSaveBlockPromptLeaveClick = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SaveAvatarBlockPrompt_Leave",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackSaveBlockPromptSaveClick = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SaveAvatarBlockPrompt_Save",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackUndoRedoClick = function(p2, p3)
		local v7

		if fFlagAXExtendUndoRedoTracking and p3 then
			v7 = LUAUFORGE_MODULE_GLOBALS_axr_mapAvatarScreenToSurface(p3)
		else
			v7 = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		end

		local v8 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `UndoRedo_{p2 and "Undo" or "Redo"}`,
			surface = 0
		}

		if not fFlagAXExtendUndoRedoTracking then
			v7 = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		end

		v8.surface = v7

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v8)
	end,
	trackSlotsCustomizeFtuxPrompt = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SlotsCustomizeFtuxPrompt",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackSlotsAvatarSwitcherFtuxPrompt = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SlotsAvatarSwitcherFtuxPrompt",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackAddNewAvatarClick = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_AddNewAvatar",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackUpdateAvatarClick = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_UpdateAvatar",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackManageAvatarsClick = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_ManageAvatars",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackDeleteAvatarAttemptClick = function(p2)
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = p2 and "AvatarSwitcher_DeleteAvatar_Attempt_Mass" or "AvatarSwitcher_DeleteAvatar_Attempt_Single",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackDeleteAvatarConfirm = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_DeleteAvatar_Confirm",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackSettingsTileClick = function()
		local v6 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_SettingsTile",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v6)
	end,
	trackUndoHistoryCount = 0,
	trackAvatarRemoveAllClick = 0,
	trackAvatarRestoreClick = 0
}

if not fFlagAXExtendUndoRedoTracking then
	trackUndoHistoryCount = nil
end

v5.trackUndoHistoryCount = trackUndoHistoryCount

if not fFlagAXResetAvatarButton then
	trackAvatarRemoveAllClick = nil
end

v5.trackAvatarRemoveAllClick = trackAvatarRemoveAllClick

if not fFlagAXResetAvatarButton then
	trackAvatarRestoreClick = nil
end

v5.trackAvatarRestoreClick = trackAvatarRestoreClick
return v5
