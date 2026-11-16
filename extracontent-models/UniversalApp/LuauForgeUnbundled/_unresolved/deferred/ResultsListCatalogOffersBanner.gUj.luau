local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local catalogOffersBanner = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.CatalogOffersBanner

local module = require("@luauforge/deferred/gpi")

local function ResultsListCatalogOffersBanner()
	local v5 = React.useContext(module)

	return React.createElement(catalogOffersBanner, {
		Size = UDim2.new(1, 0, 0, 0),
		onOffersBannerVisibleChanged = v5.onPeekHeaderBackgroundActiveChanged
	})
end

return ResultsListCatalogOffersBanner
