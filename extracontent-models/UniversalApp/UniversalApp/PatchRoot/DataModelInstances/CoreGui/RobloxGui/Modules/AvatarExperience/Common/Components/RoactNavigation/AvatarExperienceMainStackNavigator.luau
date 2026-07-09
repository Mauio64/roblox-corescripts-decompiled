local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Components = Modules.AvatarExperience.Common.Components
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local BackButtonAction = require(Components.RoactNavigation.BackButtonAction)
local LandingPageSwitchNavigator = require(Components.RoactNavigation.LandingPageSwitchNavigator)
local ItemDetailsScreen = require(Components.ItemDetails.ItemDetailsScreen)
local OutfitDetailsScreen = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitDetailsScreen)
local MySharedAvatarsPage = require(Modules.AvatarExperience.AvatarEditor.Components.MySharedAvatars.MySharedAvatarsPage)
local createAvatarExperienceStackNavigator = require(Components.RoactNavigation.createAvatarExperienceStackNavigator)
local AvatarBackground = require(Components.AvatarBackground)
local AvatarRefinementSwitchNavigator = require(Components.RoactNavigation.AvatarRefinementSwitchNavigator)
local SellPage = require(Components.ItemDetails.SellPage.SellPage)
local ItemOwnershipPage = require(Components.ItemDetails.ItemOwnershipPage.ItemOwnershipPage)
local SellItemPeekView = require(Components.ItemDetails.SellPage.SellItemPeekView)
local Components2 = Modules.AvatarExperience.Catalog.Components
local CatalogSearchPage = require(Components2.Search.CatalogSearchPage)
local CatalogSearchLandingPage = require(Components2.Search.CatalogSearchLandingPage)
local ResellersPage = require(Components2.Resellers.ResellersPage)
local LookDetailsScreen = require(Components2.LookDetails.LookDetailsScreen)
local CheckoutScreen = require(Components.RoactNavigation.CheckoutScreen)
local ExpiredUserLookActionBarScreen = require(Components.RoactNavigation.ExpiredUserLookActionBarScreen)
local SearchLandingFocusedWidgetPage = require(Modules.AvatarExperience.Catalog.Components.Search.LandingPage.SearchLandingFocusedWidgetPage)
local Components3 = Modules.AvatarExperience.ProfilePictureEditor.Components
local ProfilePictureEditorCameraPage = require(Components3.ProfilePictureEditorCameraPage)
local ProfilePictureEditorFinalPage = require(Components3.ProfilePictureEditorFinalPage)
local Components4 = Modules.AvatarExperience.AvatarEditor.Components
local UpdateOutfitPage = require(Components4.AssetManagement.UpdateOutfitPage)
local ManageOutfitPage = require(Components4.AssetManagement.ManageOutfitPage)
local ManageOutfitPage_DEPRECATED = require(Components4.AssetManagement.ManageOutfitPage_DEPRECATED)
local ManageOutfitsPageContainer = require(Modules.AvatarExperience.OutfitSwitcher.ManageOutfitsPage.ManageOutfitsPageContainer)
local LookComposerPage = require(Components4.LookComposer.LookComposerPage)
local SubcategoryFiltersDropdown = require(Modules.AvatarExperience.SlotBasedEditor.Components.SubcategoryFilters.SubcategoryFiltersDropdown)
local LayeredClothingSortPage = require(Modules.AvatarExperience.LayeredClothingSort.Components.LayeredClothingSortPage)
local LayeredMakeupSortScreen = require(Modules.AvatarExperience.LayeredMakeupSort.Components.LayeredMakeupSortScreen)
local v40 = if not require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)() then require(Components2.Filters.SortAndFiltersScreen) else require(Components2.Filters.SortAndFiltersScreenV2)
local AvatarSwitcherPageContainer = require(Modules.AvatarExperience.AvatarSwitcher.AvatarSwitcherPageContainer)
local EditEmotesPageContainer = require(Modules.AvatarExperience.EditEmotes.EditEmotesPageContainer)
local PhotoboothPageContainer = require(Modules.AvatarExperience.Photobooth.PhotoboothPageContainer)
local FFlagAXPhotoboothFunctionality = AvatarExperienceFlags.FFlagAXPhotoboothFunctionality
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagEnableBottomNavOnMarketplace = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBottomNavOnMarketplace
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local t1 = {
	{
		[AvatarScreen.LandingPageSwitchNavigator] = {
			screen = LandingPageSwitchNavigator,
			navigationOptions = function(p1) -- line: 97
				-- upvalues: RoactNavigation (copy)
				local navigation = p1.navigation
				local v61 = RoactNavigation.getActiveChildNavigationOptions(navigation)

				return {
					tabBarVisible = v61.tabBarVisible,
					backButtonAction = v61.backButtonAction
				}
			end
		}
	},
	{
		[AvatarScreen.AvatarBackground] = {
			screen = AvatarBackground,
			navigationOptions = {
				backButtonAction = BackButtonAction.NoOp
			}
		}
	},
	{
		[AvatarScreen.ItemDetails] = ItemDetailsScreen
	},
	{
		[AvatarScreen.CatalogSearch] = CatalogSearchPage
	},
	{
		[AvatarScreen.SellItemPage] = SellPage
	},
	{
		[AvatarScreen.ResellersPage] = ResellersPage
	},
	{
		[AvatarScreen.UpdateOutfitPage] = UpdateOutfitPage
	},
	{
		[AvatarScreen.ManageOutfitPage] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then ManageOutfitPage_DEPRECATED else ManageOutfitPage
	},
	{
		[AvatarScreen.ProfilePictureEditorCamera] = ProfilePictureEditorCameraPage
	},
	{
		[AvatarScreen.ProfilePictureEditorFinal] = ProfilePictureEditorFinalPage
	},
	{
		[AvatarScreen.SortAndFilters] = v40
	},
	{
		[AvatarScreen.ItemOwnershipPage] = ItemOwnershipPage
	},
	{
		[AvatarScreen.SellItemPeekView] = SellItemPeekView
	},
	{
		[AvatarScreen.LookDetails] = if not FFlagEnableBottomNavOnMarketplace then LookDetailsScreen else {
			screen = LookDetailsScreen,
			navigationOptions = {
				tabBarVisible = true
			}
		}
	},
	{
		[AvatarScreen.AvatarRefinementSwitchNavigator] = {
			screen = AvatarRefinementSwitchNavigator
		}
	},
	{
		[AvatarScreen.OutfitDetails] = OutfitDetailsScreen
	},
	{
		[AvatarScreen.CatalogSearchLanding] = CatalogSearchLandingPage
	}
}

table.insert(t1, {
	[AvatarScreen.LayeredClothingSort] = LayeredClothingSortPage
})

if FFlagAXCustomizeMakeupSupport then
	table.insert(t1, {
		[AvatarScreen.LayeredMakeupSort] = LayeredMakeupSortScreen
	})
end

if FFlagAXEnableExpiredUserLookCheckout then
	table.insert(t1, {
		[AvatarScreen.ExpiredUserLookActionBar] = ExpiredUserLookActionBarScreen
	})
	table.insert(t1, {
		[AvatarScreen.ExpiredUserLookCheckout] = CheckoutScreen
	})
end

table.insert(t1, {
	[AvatarScreen.LookComposerPage] = LookComposerPage
})
table.insert(t1, {
	[AvatarScreen.MySharedAvatars] = MySharedAvatarsPage
})

if FFlagAXPhotoboothFunctionality then
	table.insert(t1, {
		[AvatarScreen.Photobooth] = PhotoboothPageContainer
	})
end

if AXRecentlyViewedSearchItemsIXPTest.isEnabled() then
	table.insert(t1, {
		[AvatarScreen.SearchLandingFocusedWidgetPage] = SearchLandingFocusedWidgetPage
	})
end

if FFlagAXOutfitPageRevamp then
	table.insert(t1, {
		[AvatarScreen.ManageOutfitsPage] = ManageOutfitsPageContainer
	})
end

if GetFFlagAXEnableSlotBasedEditor() then
	table.insert(t1, {
		[AvatarScreen.AvatarSwitcher] = AvatarSwitcherPageContainer
	})
	table.insert(t1, {
		[AvatarScreen.EditEmotes] = EditEmotesPageContainer
	})
end

if FFlagAXEditorSubcategoryFilters then
	table.insert(t1, {
		[AvatarScreen.SubcategoryFiltersDropdown] = SubcategoryFiltersDropdown
	})
end

if FFlagAXMISEnableMultiShopping then
	table.insert(t1, {
		[AvatarScreen.Checkout] = CheckoutScreen
	})
end

return createAvatarExperienceStackNavigator(t1, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		screenKind = ScreenKind.FullScreen,
		globalNavDisplayOption = GlobalNavDisplayOption.HideAll,
		hasSelectionGroup = not FFlagAXMigrateAXToGlobalAutofocus and nil
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
