local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local EquipOutfitConfirmation = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.EquipOutfitConfirmation)
local CreateOrUpdateOutfitMenu = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.CreateOrUpdateOutfitMenu)
local CommunityAvatarEntryMenu = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.CommunityAvatarEntryMenu)
local LeaveCatalogToAvatarPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.LeaveCatalogToAvatarPrompt)
local CommunityAvatarSharePrompt = require(Modules.AvatarExperience.Catalog.Components.LookDetails.CommunityAvatarSharePrompt)
local DeleteAvatarConfirmationPrompt = require(Modules.AvatarExperience.Catalog.Components.LookDetails.DeleteAvatarConfirmationPrompt)
local InsufficientRobuxPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.InsufficientRobuxPrompt)
local PremiumSellOnlyPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PremiumSellOnlyPrompt)
local PurchasePrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PurchasePrompt)
local SellItemPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.SellItemPrompt)
local RemoveCurrentlySellingItemPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.RemoveCurrentlySellingItemPrompt)
local RemoveItemPrompt = require(Modules.AvatarExperience.LayeredClothingSort.Components.Prompts.RemoveItemPrompt)
local ResetLayeredItemsSortPrompt = require(Modules.AvatarExperience.LayeredClothingSort.Components.Prompts.ResetLayeredItemsSortPrompt)
local ResetToNewCharacterPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.ResetToNewCharacterPrompt)
local OutfitIncompletePrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.OutfitIncompletePrompt)
local PurchaseLookPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PurchaseLookPrompt)
local PurchaseLookPromptMIS = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PurchaseLookPromptMIS)
local PurchaseOutfitPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PurchaseOutfitPrompt)
local CatalogContextFrame = require(Modules.AvatarExperience.Common.Components.ItemDetails.CatalogContextFrame)
local ContextFrame = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.ContextFrame)
local LCSortContextFrame = require(Modules.AvatarExperience.LayeredClothingSort.Components.Prompts.LCSortContextFrame)
local AvatarExperienceQuickMenu = require(Modules.AvatarExperience.Common.Components.AvatarExperienceQuickMenu)
local AXTransitionContextualMenu = require(Modules.AvatarExperience.Common.Components.AXTransitionContextualMenu)
local CatalogReport = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.CatalogReport)
local SaveOutfitPrompt = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.SaveOutfitPrompt)
local RenameOutfitPrompt = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.RenameOutfitPrompt)
local DeleteOutfitPrompt = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.DeleteOutfitPrompt)
local DuplicateOutfitNamePrompt = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.DuplicateOutfitNamePrompt)
local DuplicateOutfitInfoPrompt = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.DuplicateOutfitInfoPrompt)
local R15UpgradePrompt = require(Modules.AvatarExperience.Common.Components.Prompts.R15UpgradePrompt)
local LayeredClothingR6SwitchPrompt = require(Modules.AvatarExperience.AvatarEditor.Components.Prompts.LayeredClothingR6SwitchPrompt)
local CatalogReportContainer = require(Modules.LuaApp.Components.AbuseReporting.CatalogReportContainer)
local PremiumUpsellContainer = require(Modules.LuaApp.Components.PremiumUpsell.PremiumUpsellContainer)
local RobuxUpsellContainer = require(Modules.LuaApp.Components.RobuxUpsell.RobuxUpsellContainer)
local CollectiblesInfoPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.CollectiblesInfoPrompt)
local ResaleFeePolicyPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.ResaleFeePolicyPrompt)
local GenericPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.GenericPrompt)
local ItemToExperienceModal = require(Modules.AvatarExperience.Catalog.Components.ItemToExperienceModal)
local OpenExperienceTraversalPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.OpenExperienceTraversalPrompt)
local ProfilePictureEditorRevertToDefaultPrompt = require(Modules.AvatarExperience.ProfilePictureEditor.Components.ProfilePictureEditorRevertToDefaultPrompt)
local AccessoryAdjustmentUnsavedPrompt = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AccessoryAdjustmentUnsavedPrompt)
local AccessoryAdjustmentResetPrompt = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AccessoryAdjustmentResetPrompt)
local LooksConfirmationPrompt = require(Modules.AvatarExperience.AvatarEditor.Components.LookComposer.LooksConfirmationPrompt)
local SlotEditorClearAllConfirmationPrompt = require(Modules.AvatarExperience.SlotBasedEditor.Components.Prompts.SlotEditorClearAllConfirmationPrompt)
local SaveAvatarOnLeaveAvatarExperiencePrompt = require(Modules.AvatarExperience.SlotBasedEditor.Components.SaveAvatarOnLeaveAvatarExperiencePrompt)
local EnhancedAvatarHeadsFtuxPrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.Prompts.EnhancedAvatarHeadsFtuxPrompt
local ItemInfoRowPrompt = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.ItemInfoRowPrompt)
local WearAvatarReplaceAllItemsPrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Prompts.WearAvatarReplaceAllItemsPrompt
local ClearAllItemsOnAvatarPrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Prompts.ClearAllItemsOnAvatarPrompt
local CartUnavailableItemsPrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Prompts.CartUnavailableItemsPrompt
local ItemReplacedOnAvatarPrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Prompts.ItemReplacedOnAvatarPrompt
local ItemsUnavailablePrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Prompts.ItemsUnavailablePrompt
local MakeupMax6LayersPrompt = require(Modules.AvatarExperience.Catalog.Components.Prompts.MakeupMax6LayersPrompt)
local TimeoutStatusPrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Prompts.TimeoutStatusPrompt
local MakeupReleaseFtuxPrompt = require(Modules.AvatarExperience.Catalog.Components.Prompts.MakeupReleaseFtuxPrompt)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local GetFFlagEnableCollectiblesInfoPrompt = require(Modules.AvatarExperience.Flags.GetFFlagEnableCollectiblesInfoPrompt)
local GetFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local FFlagAXEnableClearAllConfirmationPrompt = require(Modules.AvatarExperience.Flags.FFlagAXEnableClearAllConfirmationPrompt)
local FFlagAXEnableManualSavingBlockingPrompt = AvatarExperienceFlags.FFlagAXEnableManualSavingBlockingPrompt
local FFlagAXEnableEnhancedAvatarHeadsFtux = AvatarExperienceFlags.FFlagAXEnableEnhancedAvatarHeadsFtux
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXAvatarTimeoutFlow = AvatarExperienceFlags.FFlagAXAvatarTimeoutFlow
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local v78 = if not FFlagAXOutfitPageRevamp then nil else require(Modules.AvatarExperience.OutfitSwitcher.Dialogs.AddOutfitDialog.AddOutfitDialogContainer)
local v79 = if not FFlagAXOutfitPageRevamp then nil else require(Modules.AvatarExperience.OutfitSwitcher.Dialogs.DuplicateOutfitDialog.DuplicateOutfitDialogContainer)
local v80 = if not FFlagAXOutfitPageRevamp then nil else require(Modules.AvatarExperience.OutfitSwitcher.Dialogs.DuplicateOutfitNameDialog.DuplicateOutfitNameDialogContainer)
local t1 = {
	{
		[AvatarScreen.PremiumUpsellPrompt] = PremiumUpsellContainer
	},
	{
		[AvatarScreen.CatalogReport] = CatalogReport
	},
	{
		[AvatarScreen.SaveOutfitPrompt] = SaveOutfitPrompt
	},
	{
		[AvatarScreen.RenameOutfitPrompt] = RenameOutfitPrompt
	},
	{
		[AvatarScreen.DeleteOutfitPrompt] = DeleteOutfitPrompt
	},
	{
		[AvatarScreen.DuplicateOutfitNamePrompt] = DuplicateOutfitNamePrompt
	},
	{
		[AvatarScreen.DuplicateOutfitInfoPrompt] = DuplicateOutfitInfoPrompt
	},
	{
		[AvatarScreen.LayeredClothingR6SwitchPrompt] = LayeredClothingR6SwitchPrompt
	},
	{
		[AvatarScreen.EquipOutfitConfirmation] = EquipOutfitConfirmation
	},
	{
		[AvatarScreen.LeaveCatalogToAvatarPrompt] = LeaveCatalogToAvatarPrompt
	},
	{
		[AvatarScreen.InsufficientRobuxPrompt] = InsufficientRobuxPrompt
	},
	{
		[AvatarScreen.RobuxUpsellPrompt] = RobuxUpsellContainer
	},
	{
		[AvatarScreen.PremiumSellOnlyPrompt] = PremiumSellOnlyPrompt
	},
	{
		[AvatarScreen.SellItemPrompt] = SellItemPrompt
	},
	{
		[AvatarScreen.RemoveCurrentlySellingItemPrompt] = RemoveCurrentlySellingItemPrompt
	},
	{
		[AvatarScreen.RemoveItemPrompt] = RemoveItemPrompt
	},
	{
		[AvatarScreen.ResetLayeredItemsSortPrompt] = ResetLayeredItemsSortPrompt
	},
	{
		[AvatarScreen.ResetToNewCharacterPrompt] = ResetToNewCharacterPrompt
	},
	{
		[AvatarScreen.OutfitIncompletePrompt] = OutfitIncompletePrompt
	},
	{
		[AvatarScreen.PurchaseOutfitPrompt] = PurchaseOutfitPrompt
	},
	{
		[AvatarScreen.PurchaseCatalogItem] = PurchasePrompt
	},
	{
		[AvatarScreen.CreateOrUpdateOutfitMenu] = CreateOrUpdateOutfitMenu
	},
	{
		[AvatarScreen.AvatarExperienceQuickMenu] = AvatarExperienceQuickMenu
	},
	{
		[AvatarScreen.CatalogContextMenu] = {
			screen = CatalogContextFrame,
			navigationOptions = {
				overlayTransparency = 1
			}
		}
	},
	{
		[AvatarScreen.LCSortContextMenu] = {
			screen = LCSortContextFrame,
			navigationOptions = {
				overlayTransparency = 1
			}
		}
	},
	{
		[AvatarScreen.AXTransitionContextualMenu] = {
			screen = AXTransitionContextualMenu,
			navigationOptions = {
				overlayTransparency = 1
			}
		}
	},
	{
		[AvatarScreen.R15UpgradePrompt] = R15UpgradePrompt
	},
	{
		[AvatarScreen.AccessoryAdjustmentResetPrompt] = AccessoryAdjustmentResetPrompt
	},
	{
		[AvatarScreen.AccessoryAdjustmentUnsavedPrompt] = AccessoryAdjustmentUnsavedPrompt
	},
	{
		[AvatarScreen.ItemExperiencesMenu] = ItemToExperienceModal
	},
	{
		[AvatarScreen.CommunityAvatarEntryMenu] = CommunityAvatarEntryMenu
	},
	{
		[AvatarScreen.ResaleFeePolicyPrompt] = ResaleFeePolicyPrompt
	},
	{
		[AvatarScreen.GenericPrompt] = GenericPrompt
	},
	{
		[AvatarScreen.ContextMenu] = {
			screen = ContextFrame,
			navigationOptions = {
				overlayTransparency = 1
			}
		}
	},
	{
		[AvatarScreen.PurchaseLookPrompt] = if not FFlagAXMISEnableMultiShopping then PurchaseLookPrompt else PurchaseLookPromptMIS
	},
	{
		[AvatarScreen.OpenExperienceTraversalPrompt] = OpenExperienceTraversalPrompt
	},
	{
		[AvatarScreen.CommunityAvatarSharePrompt] = CommunityAvatarSharePrompt
	},
	{
		[AvatarScreen.DeleteAvatarConfirmationPrompt] = DeleteAvatarConfirmationPrompt
	},
	{
		[AvatarScreen.ProfilePictureEditorRevertToDefaultPrompt] = ProfilePictureEditorRevertToDefaultPrompt
	},
	{
		[AvatarScreen.ItemInfoRowPrompt] = ItemInfoRowPrompt
	},
	{
		[AvatarScreen.LooksConfirmationPrompt] = LooksConfirmationPrompt
	}
}

if GetFFlagEnableCollectiblesInfoPrompt() then
	table.insert(t1, {
		[AvatarScreen.CollectiblesInfoPrompt] = CollectiblesInfoPrompt
	})
end

if GetFFlagLuafiedReportEntryPoints() then
	table.insert(t1, {
		[AvatarScreen.ReportDialog] = CatalogReportContainer
	})
end

if FFlagAXEnableClearAllConfirmationPrompt then
	table.insert(t1, {
		[AvatarScreen.SlotEditorClearAllConfirmationPrompt] = SlotEditorClearAllConfirmationPrompt
	})
end

if FFlagAXEnableManualSavingBlockingPrompt then
	table.insert(t1, {
		[AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt] = SaveAvatarOnLeaveAvatarExperiencePrompt
	})
end

if FFlagAXEnableEnhancedAvatarHeadsFtux then
	table.insert(t1, {
		[AvatarScreen.EnhancedAvatarHeadsFtuxPrompt] = EnhancedAvatarHeadsFtuxPrompt
	})
end

if FFlagAXMISEnableMultiShopping then
	table.insert(t1, {
		[AvatarScreen.WearAvatarReplaceAllItemsPrompt] = WearAvatarReplaceAllItemsPrompt
	})
	table.insert(t1, {
		[AvatarScreen.ClearAllItemsOnAvatarPrompt] = ClearAllItemsOnAvatarPrompt
	})
	table.insert(t1, {
		[AvatarScreen.CartUnavailableItemsPrompt] = CartUnavailableItemsPrompt
	})
	table.insert(t1, {
		[AvatarScreen.ItemReplacedOnAvatarPrompt] = ItemReplacedOnAvatarPrompt
	})
end

if FFlagAXMakeupReleaseFTUX then
	table.insert(t1, {
		[AvatarScreen.MakeupReleaseFtuxPrompt] = MakeupReleaseFtuxPrompt
	})
end

local v82 = RoactRodux.connect(nil, function(p1) -- line: 343
	-- upvalues: AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy)
	return {
		navigateDown = function() -- line: 345
			-- upvalues: AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), p1 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.GenericWebPage,
				detail = UrlBuilder.UrlBuilder.static.messages(),
				extraProps = {
					titleKey = "CommonUI.Features.Label.Messages"
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v10.down(v10.fromLegacyPage(t2))

				return
			end

			return p1(NavigateDown(t2))
		end
	}
end)(ItemsUnavailablePrompt)

table.insert(t1, {
	[AvatarScreen.ItemsUnavailablePrompt] = v82
})

if FFlagAXCatalogMakeupSupport then
	table.insert(t1, {
		[AvatarScreen.MakeupMax6LayersPrompt] = MakeupMax6LayersPrompt
	})
end

if FFlagAXAvatarTimeoutFlow then
	table.insert(t1, {
		[AvatarScreen.TimeoutStatusPrompt] = TimeoutStatusPrompt
	})
end

if FFlagAXOutfitPageRevamp then
	table.insert(t1, {
		[AvatarScreen.AddOutfitDialog] = v78
	})
	table.insert(t1, {
		[AvatarScreen.DuplicateOutfitDialog] = v79
	})
	table.insert(t1, {
		[AvatarScreen.DuplicateOutfitNameDialog] = v80
	})
end

return t1
