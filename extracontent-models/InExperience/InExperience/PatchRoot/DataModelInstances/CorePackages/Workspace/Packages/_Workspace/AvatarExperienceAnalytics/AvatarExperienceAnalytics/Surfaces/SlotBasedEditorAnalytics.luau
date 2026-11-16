local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent
local AnalyticsService = require(AvatarExperienceAnalytics.AnalyticsService)
local ImpressionEnums = require(AvatarExperienceAnalytics.Enums.ImpressionEnums)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXExtendUndoRedoTracking = AvatarExperienceFlags.FFlagAXExtendUndoRedoTracking
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

function mapAvatarScreenToSurface(p: string)
	local homepage = ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE

	if p == AvatarScreen.Catalog then
		return ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE
	end

	if p == AvatarScreen.CatalogSearch then
		return ImpressionEnums.MarketplaceSurfaceType.SEARCH
	end

	if p == AvatarScreen.AvatarEditor then
		return ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
	end

	return homepage
end

local function trackUndoHistoryCount(p: string, p2: number)
	local surface = mapAvatarScreenToSurface(p)

	local v = {
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		group = `UndoRedo_history_count_{p2}`,
		surface = surface
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
end

local function trackAvatarRestoreClick(p: string)
	local surface = mapAvatarScreenToSurface(p)

	local v = {
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		group = "AvatarRestoreSaved",
		surface = surface
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
end

local function trackAvatarRemoveAllClick(p: string)
	local surface = mapAvatarScreenToSurface(p)

	local v = {
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		group = "AvatarRemoveAll",
		surface = surface
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
end

local SlotBasedEditorAnalytics = {
	trackSlotClick = function(p)
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			subcategory = p.editorSubcategory,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackSaveClick = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SaveAvatarButton",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackControlBarClick = function(p: string)
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_{p}`,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackAdvancedCustomizationControlBarClick = function(p: string)
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_AdvancedCustomization_{p}`,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackAdvancedCustomizationControlBarClickFromSurface = function(p: string, p2: string)
		local surface = mapAvatarScreenToSurface(p2)

		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_AdvancedCustomization_{p}`,
			surface = surface
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackSaveBlockPromptLeaveClick = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SaveAvatarBlockPrompt_Leave",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackSaveBlockPromptSaveClick = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SaveAvatarBlockPrompt_Save",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackUndoRedoClick = function(flag: boolean, p: string?)
		local surface

		if FFlagAXExtendUndoRedoTracking and p then
			surface = mapAvatarScreenToSurface(p)
		else
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		end

		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `UndoRedo_{flag and "Undo" or "Redo"}`,
			surface = 0
		}

		if not FFlagAXExtendUndoRedoTracking then
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		end

		v.surface = surface

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackSlotsCustomizeFtuxPrompt = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SlotsCustomizeFtuxPrompt",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackSlotsAvatarSwitcherFtuxPrompt = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "SlotsAvatarSwitcherFtuxPrompt",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackAddNewAvatarClick = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_AddNewAvatar",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackUpdateAvatarClick = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_UpdateAvatar",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackManageAvatarsClick = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_ManageAvatars",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackDeleteAvatarAttemptClick = function(flag: boolean)
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = flag and "AvatarSwitcher_DeleteAvatar_Attempt_Mass" or "AvatarSwitcher_DeleteAvatar_Attempt_Single",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackDeleteAvatarConfirm = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_DeleteAvatar_Confirm",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackSettingsTileClick = function()
		local v = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = "AvatarSwitcher_SettingsTile",
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v)
	end,
	trackUndoHistoryCount = 0,
	trackAvatarRemoveAllClick = 0,
	trackAvatarRestoreClick = 0
}

if not FFlagAXExtendUndoRedoTracking then
	trackUndoHistoryCount = nil
end

SlotBasedEditorAnalytics.trackUndoHistoryCount = trackUndoHistoryCount

if not FFlagAXResetAvatarButton then
	trackAvatarRemoveAllClick = nil
end

SlotBasedEditorAnalytics.trackAvatarRemoveAllClick = trackAvatarRemoveAllClick

if not FFlagAXResetAvatarButton then
	trackAvatarRestoreClick = nil
end

SlotBasedEditorAnalytics.trackAvatarRestoreClick = trackAvatarRestoreClick
return SlotBasedEditorAnalytics
