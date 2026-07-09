local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local ItemDetailsScreen = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemDetailsScreen)
local OutfitDetailsScreen = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitDetailsScreen)
local ResellersPage = require(Modules.AvatarExperience.Catalog.Components.Resellers.ResellersPage)
local SellPage = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.SellPage)
local ItemOwnershipPage = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemOwnershipPage.ItemOwnershipPage)
local SellItemPeekView = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.SellItemPeekView)
local TryOnItemScreen = require(Modules.AvatarExperience.Common.Components.ItemDetails.TryOnItemScreen)
local AvatarBackground = require(Modules.AvatarExperience.Common.Components.AvatarBackground)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)

return {
	[AvatarScreen.ItemDetails] = ItemDetailsScreen,
	[AvatarScreen.ResellersPage] = ResellersPage,
	[AvatarScreen.SellItemPage] = SellPage,
	[AvatarScreen.TryOnItem] = TryOnItemScreen,
	[AvatarScreen.ItemOwnershipPage] = ItemOwnershipPage,
	[AvatarScreen.SellItemPeekView] = SellItemPeekView,
	[AvatarScreen.AvatarBackground] = withStackVisibilityWrapper(AvatarBackground),
	[AvatarScreen.OutfitDetails] = OutfitDetailsScreen
}
