local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")

local CatalogOffersBannerView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogOffersBanner/CatalogOffersBannerView")
local useCatalogOffersBannerViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogOffersBanner/useCatalogOffersBannerViewModel")

local function CatalogOffersBanner(props)
	local v5 = useCatalogOffersBannerViewModel({
		Size = props.Size,
		Position = props.Position,
		onBannerVisibleChanged = props.onOffersBannerVisibleChanged
	})

	if v5.status == "hidden" then
		return nil
	end

	if v5.modals then
		return React.createElement(React.Fragment, nil, {
			Banner = React.createElement(CatalogOffersBannerView, v5.viewProps),
			Modals = v5.modals
		})
	end

	return React.createElement(CatalogOffersBannerView, v5.viewProps)
end

return CatalogOffersBanner
