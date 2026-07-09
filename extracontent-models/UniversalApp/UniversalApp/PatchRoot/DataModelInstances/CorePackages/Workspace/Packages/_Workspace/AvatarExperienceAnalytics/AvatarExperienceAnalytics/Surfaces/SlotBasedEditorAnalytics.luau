local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local AnalyticsService = require(AvatarExperienceAnalytics.AnalyticsService)
local ImpressionEnums = require(AvatarExperienceAnalytics.Enums.ImpressionEnums)
local AvatarExperienceFlags = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags)
local FFlagAXExtendUndoRedoTracking = AvatarExperienceFlags.FFlagAXExtendUndoRedoTracking
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local AvatarScreen = require(AvatarExperienceAnalyticsParent.AvatarExperienceNavigation).Enums.AvatarScreen

function mapAvatarScreenToSurface(s1: string) -- line: 101
	-- upvalues: ImpressionEnums (copy), AvatarScreen (copy)
	local HOMEPAGE = ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE

	if s1 == AvatarScreen.Catalog then
		return ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE
	end

	if s1 == AvatarScreen.CatalogSearch then
		return ImpressionEnums.MarketplaceSurfaceType.SEARCH
	end

	if s1 == AvatarScreen.AvatarEditor then
		HOMEPAGE = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
	end

	return HOMEPAGE
end

local function trackUndoHistoryCount(s2: string, n1: number) -- line: 129
	-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
	local v36 = mapAvatarScreenToSurface(s2)
	local t1 = {
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		group = `UndoRedo_history_count_{ n1 }`,
		surface = v36
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t1)
end
local function trackAvatarRestoreClick(s3: string) -- line: 140
	-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
	local v39 = mapAvatarScreenToSurface(s3)
	local t2 = {
		group = "AvatarRestoreSaved",
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		surface = v39
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t2)
end
local function trackAvatarRemoveAllClick(s4: string) -- line: 151
	-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
	local v42 = mapAvatarScreenToSurface(s4)
	local t3 = {
		group = "AvatarRemoveAll",
		actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
		surface = v42
	}

	AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t3)
end

return {
	trackSlotClick = function(t4: {[any]: any}) -- line: 16
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t5 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			subcategory = t4.editorSubcategory,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t5)
	end,
	trackSaveClick = function() -- line: 27
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t6 = {
			group = "SaveAvatarButton",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t6)
	end,
	trackControlBarClick = function(s5: string) -- line: 72
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t7 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_{ s5 }`,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t7)
	end,
	trackAdvancedCustomizationControlBarClick = function(s6: string) -- line: 81
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t8 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_AdvancedCustomization_{ s6 }`,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t8)
	end,
	trackAdvancedCustomizationControlBarClickFromSurface = function(s7: string, s8: string) -- line: 90
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local v25 = mapAvatarScreenToSurface(s8)
		local t9 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `ControlBar_AdvancedCustomization_{ s7 }`,
			surface = v25
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t9)
	end,
	trackSaveBlockPromptLeaveClick = function() -- line: 54
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t10 = {
			group = "SaveAvatarBlockPrompt_Leave",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t10)
	end,
	trackSaveBlockPromptSaveClick = function() -- line: 63
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t11 = {
			group = "SaveAvatarBlockPrompt_Save",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t11)
	end,
	trackUndoRedoClick = function(b1: boolean, s9: string?) -- line: 113
		-- upvalues: FFlagAXExtendUndoRedoTracking (copy), ImpressionEnums (copy), AnalyticsService (copy)
		local v31 = not b1 and "Redo" or "Undo"
		local v32 = if not FFlagAXExtendUndoRedoTracking or not s9 then ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY else mapAvatarScreenToSurface(s9)
		local t12 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = `UndoRedo_{ v31 }`,
			surface = if not FFlagAXExtendUndoRedoTracking then ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY else v32
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t12)
	end,
	trackSlotsCustomizeFtuxPrompt = function() -- line: 36
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t13 = {
			group = "SlotsCustomizeFtuxPrompt",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t13)
	end,
	trackSlotsAvatarSwitcherFtuxPrompt = function() -- line: 45
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t14 = {
			group = "SlotsAvatarSwitcherFtuxPrompt",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t14)
	end,
	trackAddNewAvatarClick = function() -- line: 162
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t15 = {
			group = "AvatarSwitcher_AddNewAvatar",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t15)
	end,
	trackUpdateAvatarClick = function() -- line: 171
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t16 = {
			group = "AvatarSwitcher_UpdateAvatar",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t16)
	end,
	trackManageAvatarsClick = function() -- line: 180
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t17 = {
			group = "AvatarSwitcher_ManageAvatars",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t17)
	end,
	trackDeleteAvatarAttemptClick = function(b2: boolean) -- line: 189
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local v48 = not b2 and "AvatarSwitcher_DeleteAvatar_Attempt_Single" or "AvatarSwitcher_DeleteAvatar_Attempt_Mass"
		local t18 = {
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			group = v48,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t18)
	end,
	trackDeleteAvatarConfirm = function() -- line: 201
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t19 = {
			group = "AvatarSwitcher_DeleteAvatar_Confirm",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t19)
	end,
	trackSettingsTileClick = function() -- line: 210
		-- upvalues: ImpressionEnums (copy), AnalyticsService (copy)
		local t20 = {
			group = "AvatarSwitcher_SettingsTile",
			actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
		}

		AnalyticsService.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t20)
	end,
	trackUndoHistoryCount = if not FFlagAXExtendUndoRedoTracking then nil else trackUndoHistoryCount,
	trackAvatarRemoveAllClick = if not FFlagAXResetAvatarButton then nil else trackAvatarRemoveAllClick,
	trackAvatarRestoreClick = if not FFlagAXResetAvatarButton then nil else trackAvatarRestoreClick
}
