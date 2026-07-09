local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)

require(Parent.Foundation)

local CatalogOffersBannerView = require(script.Parent.CatalogOffersBannerView)
local useCatalogOffersBannerViewModel = require(script.Parent.useCatalogOffersBannerViewModel)

local function CatalogOffersBanner(t1: {[any]: any}) -- line: 17
	-- upvalues: useCatalogOffersBannerViewModel (copy), React (copy), CatalogOffersBannerView (copy)
	local v7 = useCatalogOffersBannerViewModel({
		Size = t1.Size,
		Position = t1.Position,
		onBannerVisibleChanged = t1.onOffersBannerVisibleChanged
	})

	if v7.status == "hidden" then
		return nil
	end

	if v7.modals then
		return React.createElement(React.Fragment, nil, {
			Banner = React.createElement(CatalogOffersBannerView, v7.viewProps),
			Modals = v7.modals
		})
	end

	return React.createElement(CatalogOffersBannerView, v7.viewProps)
end

return CatalogOffersBanner
