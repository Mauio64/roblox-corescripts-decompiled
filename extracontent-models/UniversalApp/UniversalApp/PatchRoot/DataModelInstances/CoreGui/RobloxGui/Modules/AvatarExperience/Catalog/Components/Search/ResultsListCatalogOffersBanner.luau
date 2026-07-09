local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local CatalogOffersBanner = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.CatalogOffersBanner
local AdaptiveScrollingViewPeekHeaderBackgroundContext = require(Modules.AvatarExperience.Common.Components.AdaptiveScrollingViewPeekHeaderBackgroundContext)

local function ResultsListCatalogOffersBanner() -- line: 12
	-- upvalues: React (copy), AdaptiveScrollingViewPeekHeaderBackgroundContext (copy), CatalogOffersBanner (copy)
	local v8 = React.useContext(AdaptiveScrollingViewPeekHeaderBackgroundContext)

	return React.createElement(CatalogOffersBanner, {
		Size = UDim2.new(1, 0, 0, 0),
		onOffersBannerVisibleChanged = v8.onPeekHeaderBackgroundActiveChanged
	})
end

return ResultsListCatalogOffersBanner
