local CorePackages = game:GetService("CorePackages")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local module2 = require("@luauforge/bundled/dCp")
local module3 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module4 = require("@luauforge/deferred/geS")

local module5 = require("@luauforge/deferred/gfj")

local module6 = require("@luauforge/deferred/gfp")

local module7 = require("@luauforge/deferred/gfs")

local module8 = require("@luauforge/deferred/gfw")

local module9 = require("@luauforge/deferred/gfD")

local module10 = require("@luauforge/deferred/gfF")

local module11 = require("@luauforge/deferred/gfK")
local module12 = require("@luauforge/deferred/gfL")
local module13 = require("@luauforge/deferred/gfV")

local module14 = require("@luauforge/deferred/gfZ")
local module15 = require("@luauforge/deferred/ggc")

local module16 = require("@luauforge/deferred/ggd")

local module17 = require("@luauforge/deferred/ggg")

local module18 = require("@luauforge/deferred/ggj")

local module19 = require("@luauforge/deferred/ggk")

local module20 = require("@luauforge/deferred/ggw")
local module21 = require("@luauforge/deferred/ggx")
local module22 = require("@luauforge/deferred/ggN")
local module23 = require("@luauforge/deferred/ggO")
local module24 = require("@luauforge/deferred/ggQ")
local module25 = require("@luauforge/deferred/ggR")
local module26 = require("@luauforge/deferred/ggS")
local module27 = require("@luauforge/deferred/ggT")
local module28 = require("@luauforge/deferred/ghj")
local module29 = require("@luauforge/deferred/ghl")

local module30 = require("@luauforge/deferred/ghr")

local module31 = require("@luauforge/deferred/ghs")
local module32 = require("@luauforge/deferred/ght")

local module33 = require("@luauforge/deferred/ghu")
local module34 = require("@luauforge/deferred/ghx")
local module35 = require("@luauforge/deferred/gif")

local module36 = require("@luauforge/deferred/gio")

local module37 = require("@luauforge/deferred/gip")
local module38 = require("@luauforge/deferred/giq")
local module39 = require("@luauforge/deferred/gir")

local AttributionTraversal = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Components/AttributionTraversal")

local module41 = require("@luauforge/deferred/git")

local module42 = require("@luauforge/deferred/giv")

local module43 = require("@luauforge/deferred/giw")

local module44 = require("@luauforge/deferred/gix")

local module45 = require("@luauforge/deferred/giy")

local module46 = require("@luauforge/deferred/giz")

local enhancedAvatarHeadsFtuxPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.Prompts.EnhancedAvatarHeadsFtuxPrompt
local module47 = require("@luauforge/deferred/giA")

local wearAvatarReplaceAllItemsPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.WearAvatarReplaceAllItemsPrompt

local clearAllItemsOnAvatarPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.ClearAllItemsOnAvatarPrompt

local cartUnavailableItemsPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.CartUnavailableItemsPrompt

local itemReplacedOnAvatarPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.ItemReplacedOnAvatarPrompt

local itemsUnavailablePrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.ItemsUnavailablePrompt
local module48 = require("@luauforge/deferred/giB")

local timeoutStatusPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.TimeoutStatusPrompt
local module49 = require("@luauforge/deferred/giC")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module51 = require("@luauforge/deferred/giD")
local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints

local module52 = require("@luauforge/deferred/giE")
local fFlagAXEnableManualSavingBlockingPrompt = AvatarExperienceFlags.FFlagAXEnableManualSavingBlockingPrompt
local fFlagAXItemDetailsDescriptionLinks = AvatarExperienceFlags.FFlagAXItemDetailsDescriptionLinks

local module53 = require("@luauforge/deferred/giF")
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local v5 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/giG") else nil

local v6 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/giL") else nil

local v7 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/giP") else nil

local v8 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/giR") else nil

local v9 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/giT") else nil

local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled

local v10 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjJ") else nil

local v11 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjL") else nil

local v12 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjN") else nil

local v13 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjP") else nil

local v14 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjR") else nil

local v15 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjT") else nil

local v16 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjV") else nil

local v17 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gjX") else nil

local v18 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gka") else nil

local v19 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gkc") else nil

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
