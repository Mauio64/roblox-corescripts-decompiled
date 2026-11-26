local CorePackages = game:GetService("CorePackages")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local module2 = require("@luauforge/bundled/dFu")
local module3 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module4 = require("@luauforge/deferred/gJy")

local module5 = require("@luauforge/deferred/gJP")

local module6 = require("@luauforge/deferred/gJV")

local module7 = require("@luauforge/deferred/gJY")

local module8 = require("@luauforge/deferred/gKc")

local module9 = require("@luauforge/deferred/gKj")

local module10 = require("@luauforge/deferred/gKl")

local module11 = require("@luauforge/deferred/gKq")
local module12 = require("@luauforge/deferred/gKr")
local module13 = require("@luauforge/deferred/gKB")

local module14 = require("@luauforge/deferred/gKF")
local module15 = require("@luauforge/deferred/gKI")

local module16 = require("@luauforge/deferred/gKJ")

local module17 = require("@luauforge/deferred/gKM")

local module18 = require("@luauforge/deferred/gKP")

local module19 = require("@luauforge/deferred/gKQ")

local module20 = require("@luauforge/deferred/gLc")
local module21 = require("@luauforge/deferred/gLd")
local module22 = require("@luauforge/deferred/gLt")
local module23 = require("@luauforge/deferred/gLu")
local module24 = require("@luauforge/deferred/gLw")
local module25 = require("@luauforge/deferred/gLx")
local module26 = require("@luauforge/deferred/gLy")
local module27 = require("@luauforge/deferred/gLz")
local module28 = require("@luauforge/deferred/gLP")
local module29 = require("@luauforge/deferred/gLR")

local module30 = require("@luauforge/deferred/gLX")

local module31 = require("@luauforge/deferred/gLY")
local module32 = require("@luauforge/deferred/gLZ")

local module33 = require("@luauforge/deferred/gMa")
local module34 = require("@luauforge/deferred/gMd")
local module35 = require("@luauforge/deferred/gML")

local module36 = require("@luauforge/deferred/gMU")

local module37 = require("@luauforge/deferred/gMV")
local module38 = require("@luauforge/deferred/gMW")
local module39 = require("@luauforge/deferred/gMX")

local AttributionTraversal = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Components/AttributionTraversal")

local module41 = require("@luauforge/deferred/gMZ")

local module42 = require("@luauforge/deferred/gNb")

local module43 = require("@luauforge/deferred/gNc")

local module44 = require("@luauforge/deferred/gNd")

local module45 = require("@luauforge/deferred/gNe")

local module46 = require("@luauforge/deferred/gNf")

local enhancedAvatarHeadsFtuxPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.Prompts.EnhancedAvatarHeadsFtuxPrompt
local module47 = require("@luauforge/deferred/gNg")

local wearAvatarReplaceAllItemsPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.WearAvatarReplaceAllItemsPrompt

local clearAllItemsOnAvatarPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.ClearAllItemsOnAvatarPrompt

local cartUnavailableItemsPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.CartUnavailableItemsPrompt

local itemReplacedOnAvatarPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.ItemReplacedOnAvatarPrompt

local itemsUnavailablePrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.ItemsUnavailablePrompt
local module48 = require("@luauforge/deferred/gNh")

local timeoutStatusPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.TimeoutStatusPrompt
local module49 = require("@luauforge/deferred/gNi")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module51 = require("@luauforge/deferred/gNj")
local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints

local module52 = require("@luauforge/deferred/gNk")
local fFlagAXEnableManualSavingBlockingPrompt = AvatarExperienceFlags.FFlagAXEnableManualSavingBlockingPrompt
local fFlagAXItemDetailsDescriptionLinks = AvatarExperienceFlags.FFlagAXItemDetailsDescriptionLinks

local module53 = require("@luauforge/deferred/gNl")
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local v5 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/gNm") else nil

local v6 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/gNr") else nil

local v7 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/gNv") else nil

local v8 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/gNx") else nil

local v9 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/gNz") else nil

local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled

local v10 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOp") else nil

local v11 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOr") else nil

local v12 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOt") else nil

local v13 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOv") else nil

local v14 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOx") else nil

local v15 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOz") else nil

local v16 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOB") else nil

local v17 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOD") else nil

local v18 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOG") else nil

local v19 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gOI") else nil

local v24 = {
	{ [avatarScreen.PremiumUpsellPrompt] = module35 },
	{ [avatarScreen.CatalogReport] = module26 },
	{ [avatarScreen.SaveOutfitPrompt] = module27 },
	{ [avatarScreen.RenameOutfitPrompt] = module28 },
	{ [avatarScreen.DeleteOutfitPrompt] = module29 },
	{ [avatarScreen.DuplicateOutfitNamePrompt] = module30 },
	{ [avatarScreen.DuplicateOutfitInfoPrompt] = module31 },
	{ [avatarScreen.LayeredClothingR6SwitchPrompt] = module33 },
	{ [avatarScreen.EquipOutfitConfirmation] = module4 },
	{ [avatarScreen.LeaveCatalogToAvatarPrompt] = module7 },
	{ [avatarScreen.InsufficientRobuxPrompt] = module10 },
	{ [avatarScreen.PremiumSellOnlyPrompt] = module11 },
	{ [avatarScreen.SellItemPrompt] = module13 },
	{ [avatarScreen.RemoveCurrentlySellingItemPrompt] = module14 },
	{ [avatarScreen.RemoveItemPrompt] = module15 },
	{ [avatarScreen.ResetLayeredItemsSortPrompt] = module16 },
	{ [avatarScreen.ResetToNewCharacterPrompt] = module17 },
	{ [avatarScreen.OutfitIncompletePrompt] = module18 },
	{ [avatarScreen.PurchaseOutfitPrompt] = module20 },
	{ [avatarScreen.PurchaseCatalogItem] = module12 },
	{ [avatarScreen.CreateOrUpdateOutfitMenu] = module5 },
	{ [avatarScreen.AvatarExperienceQuickMenu] = module24 },
	{
		[avatarScreen.CatalogContextMenu] = {
			screen = module21,
			navigationOptions = { overlayTransparency = 1 }
		}
	},
	{
		[avatarScreen.LCSortContextMenu] = {
			screen = module23,
			navigationOptions = { overlayTransparency = 1 }
		}
	},
	{
		[avatarScreen.AXTransitionContextualMenu] = {
			screen = module25,
			navigationOptions = { overlayTransparency = 1 }
		}
	},
	{ [avatarScreen.R15UpgradePrompt] = module32 },
	{ [avatarScreen.AccessoryAdjustmentResetPrompt] = module43 },
	{ [avatarScreen.AccessoryAdjustmentUnsavedPrompt] = module42 },
	{ [avatarScreen.ItemExperiencesMenu] = module39 },
	{ [avatarScreen.CommunityAvatarEntryMenu] = module6 },
	{ [avatarScreen.ResaleFeePolicyPrompt] = module37 },
	{ [avatarScreen.GenericPrompt] = module38 },
	{
		[avatarScreen.ContextMenu] = {
			screen = module22,
			navigationOptions = { overlayTransparency = 1 }
		}
	},
	{ [avatarScreen.PurchaseLookPrompt] = module19 },
	{ [avatarScreen.OpenExperienceTraversalPrompt] = AttributionTraversal },
	{ [avatarScreen.CommunityAvatarSharePrompt] = module8 },
	{ [avatarScreen.DeleteAvatarConfirmationPrompt] = module9 },
	{ [avatarScreen.ProfilePictureEditorRevertToDefaultPrompt] = module41 },
	{ [avatarScreen.ItemInfoRowPrompt] = module47 },
	{ [avatarScreen.LooksConfirmationPrompt] = module44 }
}

if module51() then
	local modulesByCollectiblesInfoPrompt = {
		[avatarScreen.CollectiblesInfoPrompt] = module36
	}
	table.insert(v24, modulesByCollectiblesInfoPrompt)
end

if getFFlagLuafiedReportEntryPoints() then
	local modulesByReportDialog = { [avatarScreen.ReportDialog] = module34 }
	table.insert(v24, modulesByReportDialog)
end

if module52 then
	local modulesBySlotEditorClearAllConfirmationPrompt = {
		[avatarScreen.SlotEditorClearAllConfirmationPrompt] = module45
	}
	table.insert(v24, modulesBySlotEditorClearAllConfirmationPrompt)
end

if fFlagAXEnableManualSavingBlockingPrompt then
	local modulesBySaveAvatarOnLeaveAvatarExperiencePrompt = {
		[avatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt] = module46
	}
	table.insert(v24, modulesBySaveAvatarOnLeaveAvatarExperiencePrompt)
end

if fFlagAXItemDetailsDescriptionLinks then
	local modulesByDescriptionLinkSearchPrompt = {
		[avatarScreen.DescriptionLinkSearchPrompt] = module53
	}
	table.insert(v24, modulesByDescriptionLinkSearchPrompt)
end

local enhancedAvatarHeadsFtuxPromptsByEnhancedAvatarHeadsFtuxPrompt = {
	[avatarScreen.EnhancedAvatarHeadsFtuxPrompt] = enhancedAvatarHeadsFtuxPrompt
}
table.insert(v24, enhancedAvatarHeadsFtuxPromptsByEnhancedAvatarHeadsFtuxPrompt)

local wearAvatarReplaceAllItemsPromptsByWearAvatarReplaceAllItemsPrompt = {
	[avatarScreen.WearAvatarReplaceAllItemsPrompt] = wearAvatarReplaceAllItemsPrompt
}
table.insert(v24, wearAvatarReplaceAllItemsPromptsByWearAvatarReplaceAllItemsPrompt)

local clearAllItemsOnAvatarPromptsByClearAllItemsOnAvatarPrompt = {
	[avatarScreen.ClearAllItemsOnAvatarPrompt] = clearAllItemsOnAvatarPrompt
}
table.insert(v24, clearAllItemsOnAvatarPromptsByClearAllItemsOnAvatarPrompt)

local cartUnavailableItemsPromptsByCartUnavailableItemsPrompt = {
	[avatarScreen.CartUnavailableItemsPrompt] = cartUnavailableItemsPrompt
}
table.insert(v24, cartUnavailableItemsPromptsByCartUnavailableItemsPrompt)

local itemReplacedOnAvatarPromptsByItemReplacedOnAvatarPrompt = {
	[avatarScreen.ItemReplacedOnAvatarPrompt] = itemReplacedOnAvatarPrompt
}
table.insert(v24, itemReplacedOnAvatarPromptsByItemReplacedOnAvatarPrompt)

if fFlagAXMakeupReleaseFTUX then
	local modulesByMakeupReleaseFtuxPrompt = {
		[avatarScreen.MakeupReleaseFtuxPrompt] = module49
	}
	table.insert(v24, modulesByMakeupReleaseFtuxPrompt)
end

local v25 = RoactRodux.connect(nil, function(callback)
	return {
		navigateDown = function()
			local v26 = {
				name = module2.GenericWebPage,
				detail = UrlBuilder.UrlBuilder.static.messages(),
				extraProps = { titleKey = "CommonUI.Features.Label.Messages" }
			}

			if not fFlagSignalsNavP3Dispatch then
				return callback(module3(v26))
			end

			navigationCommands.down(navigationCommands.fromLegacyPage(v26))
		end
	}
end)(itemsUnavailablePrompt)

local v26 = { [avatarScreen.ItemsUnavailablePrompt] = v25 }
table.insert(v24, v26)

if fFlagAXCatalogMakeupSupport then
	local modulesByMakeupMax6LayersPrompt = {
		[avatarScreen.MakeupMax6LayersPrompt] = module48
	}
	table.insert(v24, modulesByMakeupMax6LayersPrompt)
end

local timeoutStatusPromptsByTimeoutStatusPrompt = {
	[avatarScreen.TimeoutStatusPrompt] = timeoutStatusPrompt
}
table.insert(v24, timeoutStatusPromptsByTimeoutStatusPrompt)

if fFlagAXOutfitPageRevamp then
	local v27 = { [avatarScreen.AddOutfitDialog] = v5 }
	table.insert(v24, v27)

	local v28 = { [avatarScreen.DuplicateOutfitDialog] = v6 }
	table.insert(v24, v28)

	local v29 = { [avatarScreen.DuplicateOutfitNameDialog] = v7 }
	table.insert(v24, v29)

	local v30 = { [avatarScreen.RenameOutfitDialog] = v8 }
	table.insert(v24, v30)

	local v31 = { [avatarScreen.DeleteOutfitDialog] = v9 }
	table.insert(v24, v31)

	local v32 = { [avatarScreen.BulkDeleteOutfitDialog] = v9 }
	table.insert(v24, v32)
end

if not fFlagAXAvatarFoldersEnabled then
	return v24
end

local v27 = { [avatarScreen.CreateFolderDialog] = v10 }
table.insert(v24, v27)

local v28 = { [avatarScreen.RenameFolderDialog] = v11 }
table.insert(v24, v28)

local v29 = { [avatarScreen.DuplicateFolderNameDialog] = v12 }
table.insert(v24, v29)

local v30 = { [avatarScreen.FolderNameNotAllowedDialog] = v13 }
table.insert(v24, v30)

local v31 = { [avatarScreen.FolderLimitReachedDialog] = v14 }
table.insert(v24, v31)

local v32 = { [avatarScreen.FolderErrorDialog] = v15 }
table.insert(v24, v32)

local v33 = { [avatarScreen.DeleteFolderPrompt] = v16 }
table.insert(v24, v33)

local v34 = { [avatarScreen.SelectFolderMenu] = v17 }
table.insert(v24, v34)

local v35 = { [avatarScreen.RemoveFromFolderDialog] = v18 }
table.insert(v24, v35)

local v36 = { [avatarScreen.FolderItemsErrorDialog] = v19 }
table.insert(v24, v36)

return v24
