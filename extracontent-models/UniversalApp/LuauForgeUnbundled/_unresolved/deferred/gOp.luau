local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/deferred/gOf")
local module4 = require("@luauforge/deferred/gOq")
local module5 = require("@luauforge/deferred/gkm")

local module6 = require("@luauforge/deferred/gmZ")

local module7 = require("@luauforge/deferred/gVK")

local module8 = require("@luauforge/deferred/gkf")
local module9 = require("@luauforge/deferred/goP")
local module10 = require("@luauforge/deferred/gVM")
local module11 = require("@luauforge/deferred/gny")
local module12 = require("@luauforge/deferred/gnE")
local module13 = require("@luauforge/deferred/gnH")

local module14 = require("@luauforge/deferred/gWO")
local module15 = require("@luauforge/deferred/gWQ")
local module16 = require("@luauforge/deferred/gno")
local module17 = require("@luauforge/deferred/gWT")
local module18 = require("@luauforge/deferred/gWU")
local module19 = require("@luauforge/deferred/gWV")

local module20 = require("@luauforge/deferred/gWX")

local module21 = require("@luauforge/deferred/gWZ")
local module22 = require("@luauforge/deferred/gXd")

local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local v5 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/gXe") else require("@luauforge/deferred/gXo")
local module23 = require("@luauforge/deferred/gXs")
local v6 = require("@luauforge/deferred/gXu")

local module24 = require("@luauforge/deferred/gXv")
local module25 = require("@luauforge/deferred/gXy")

local module26 = require("@luauforge/deferred/gXJ")

local module27 = require("@luauforge/deferred/gWp")
local module28 = require("@luauforge/deferred/gWD")

local v7 = if require("@luauforge/deferred/gOR")() then require("@luauforge/deferred/gXP") else require("@luauforge/deferred/gYj")

local module29 = require("@luauforge/deferred/gYk")
local module30 = require("@luauforge/deferred/gYn")

local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local module31 = require("@luauforge/deferred/gYu")

local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration

local v8 = if fFlagAXBackgroundGeneration then require("@luauforge/deferred/gYC") else nil

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local module32 = require("@luauforge/bundled/dOc")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation

local fFlagEnableBottomNavOnMarketplace = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBottomNavOnMarketplace

local fFlagRemoveBottomNavOnLookDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveBottomNavOnLookDetails
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting

local v10 = {
	[avatarScreen.LandingPageSwitchNavigator] = {
		screen = module4,
		navigationOptions = function(p2)
			local navigation = p2.navigation
			local activeChildNavigationOptions = RoactNavigation.getActiveChildNavigationOptions(navigation)
			return {
				tabBarVisible = activeChildNavigationOptions.tabBarVisible,
				backButtonAction = activeChildNavigationOptions.backButtonAction
			}
		end
	}
}

local v11 = {
	[avatarScreen.AvatarBackground] = {
		screen = module9,
		navigationOptions = { backButtonAction = module3.NoOp }
	}
}

local modulesByItemDetails = { [avatarScreen.ItemDetails] = module5 }

local modulesByCatalogSearch = { [avatarScreen.CatalogSearch] = module14 }

local modulesBySellItemPage = { [avatarScreen.SellItemPage] = module11 }

local modulesByResellersPage = { [avatarScreen.ResellersPage] = module16 }

local v12 = { [avatarScreen.UpdateOutfitPage] = v5 }

local manageOutfitPage = avatarScreen.ManageOutfitPage

if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	v6 = module23
end

local v9 = {
	v10,
	v11,
	modulesByItemDetails,
	modulesByCatalogSearch,
	modulesBySellItemPage,
	modulesByResellersPage,
	v12,
	{ [manageOutfitPage] = v6 },
	{ [avatarScreen.ProfilePictureEditorCamera] = module21 },
	{ [avatarScreen.ProfilePictureEditorFinal] = module22 },
	{ [avatarScreen.SortAndFilters] = v7 },
	{ [avatarScreen.ItemOwnershipPage] = module12 },
	{ [avatarScreen.SellItemPeekView] = module13 },
	{
		[avatarScreen.LookDetails] = fFlagEnableBottomNavOnMarketplace and not fFlagRemoveBottomNavOnLookDetails and {
			screen = module17,
			navigationOptions = { tabBarVisible = true }
		} or module17
	},
	{
		[avatarScreen.AvatarRefinementSwitchNavigator] = { screen = module10 }
	},
	{ [avatarScreen.OutfitDetails] = module6 },
	{ [avatarScreen.CatalogSearchLanding] = module15 }
}

local modulesByLayeredClothingSort = { [avatarScreen.LayeredClothingSort] = module27 }
table.insert(v9, modulesByLayeredClothingSort)

local modulesByLayeredMakeupSort = { [avatarScreen.LayeredMakeupSort] = module28 }
table.insert(v9, modulesByLayeredMakeupSort)

if fFlagAXEnableExpiredUserLookCheckout then
	local modulesByExpiredUserLookActionBar = {
		[avatarScreen.ExpiredUserLookActionBar] = module19
	}
	table.insert(v9, modulesByExpiredUserLookActionBar)

	local modulesByExpiredUserLookCheckout = {
		[avatarScreen.ExpiredUserLookCheckout] = module18
	}
	table.insert(v9, modulesByExpiredUserLookCheckout)
end

local modulesByLookComposerPage = { [avatarScreen.LookComposerPage] = module25 }
table.insert(v9, modulesByLookComposerPage)

local modulesByMySharedAvatars = { [avatarScreen.MySharedAvatars] = module7 }
table.insert(v9, modulesByMySharedAvatars)

if fFlagAXPhotoboothMomentsPage then
	local modulesByPhotoboothMomentsPage = {
		[avatarScreen.PhotoboothMomentsPage] = module31
	}
	table.insert(v9, modulesByPhotoboothMomentsPage)
end

if fFlagAXBackgroundGeneration then
	local v17 = { [avatarScreen.BackgroundGeneration] = v8 }
	table.insert(v9, v17)
end

if axRecentlyViewedSearchItemsIXPTest.isEnabled() then
	local modulesBySearchLandingFocusedWidgetPage = {
		[avatarScreen.SearchLandingFocusedWidgetPage] = module20
	}
	table.insert(v9, modulesBySearchLandingFocusedWidgetPage)
end

if fFlagAXOutfitPageRevamp then
	local modulesByManageOutfitsPage = { [avatarScreen.ManageOutfitsPage] = module24 }
	table.insert(v9, modulesByManageOutfitsPage)
end

if module32() then
	local modulesByAvatarSwitcher = { [avatarScreen.AvatarSwitcher] = module29 }
	table.insert(v9, modulesByAvatarSwitcher)

	local modulesByEditEmotes = { [avatarScreen.EditEmotes] = module30 }
	table.insert(v9, modulesByEditEmotes)
end

if fFlagAXEditorSubcategoryFilters then
	local modulesBySubcategoryFiltersDropdown = {
		[avatarScreen.SubcategoryFiltersDropdown] = module26
	}
	table.insert(v9, modulesBySubcategoryFiltersDropdown)
end

local modulesByCheckout = { [avatarScreen.Checkout] = module18 }
table.insert(v9, modulesByCheckout)

if fFlagAXGifting then
	local components = require("@luauforge/deferred/gmv").Components
	local avatarItemGiftRecipientPickersBySendGiftRecipientPicker = {
		[avatarScreen.SendGiftRecipientPicker] = components.AvatarItemGiftRecipientPicker
	}
	table.insert(v9, avatarItemGiftRecipientPickersBySendGiftRecipientPicker)

	local avatarItemGiftReviewSheetsBySendGiftReview = {
		[avatarScreen.SendGiftReview] = components.AvatarItemGiftReviewSheet
	}
	table.insert(v9, avatarItemGiftReviewSheetsBySendGiftReview)
end

return module8(v9, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		hasSelectionGroup = false
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
