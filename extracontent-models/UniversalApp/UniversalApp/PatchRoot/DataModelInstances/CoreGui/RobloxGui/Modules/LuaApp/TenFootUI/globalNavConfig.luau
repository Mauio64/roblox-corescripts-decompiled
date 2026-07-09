local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppPage = require(Modules.LuaApp.AppPage)

require(CorePackages.Workspace.Packages.TenFootUiCommon)

local Images = UIBlox.App.ImageSet.Images

return {
	tabs = require(Modules.LuaApp.Components.AppNav.GetIABottomBarItems)(),
	options = {
		{
			titleLocalizationKey = "Feature.Catalog.Label.Search",
			actionType = nil,
			page = AppPage.SearchPage,
			icon = Images["icons/common/search"]
		},
		{
			titleLocalizationKey = "Feature.Home.Robux",
			actionType = nil,
			page = AppPage.PurchaseRobux,
			icon = Images["icons/common/goldrobux"]
		},
		{
			titleLocalizationKey = "CommonUI.Features.Label.More",
			actionType = nil,
			page = AppPage.More,
			icon = Images["icons/common/more"]
		}
	}
}
