local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(parent.React)
require(parent.Foundation)

local CatalogOffersBannerView = require(script.Parent.CatalogOffersBannerView)
local useCatalogOffersBannerViewModel = require(script.Parent.useCatalogOffersBannerViewModel)

local function CatalogOffersBanner(props)
	local v = useCatalogOffersBannerViewModel({
		Size = props.Size,
		Position = props.Position,
		onBannerVisibleChanged = props.onOffersBannerVisibleChanged
	})

	if v.status == "hidden" then
		return nil
	end

	if v.modals then
		return React.createElement(React.Fragment, nil, {
			Banner = React.createElement(CatalogOffersBannerView, v.viewProps),
			Modals = v.modals
		})
	end

	return React.createElement(CatalogOffersBannerView, v.viewProps)
end

return CatalogOffersBanner
