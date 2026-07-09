local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local useLocalization = require(SocialCarouselParent.Localization).Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local Tile = require(SocialCarousel.BaseComponents.Tile)

local function ShareQRTile(t1: {[any]: any}) -- line: 19
	-- upvalues: useLocalization (copy), Constants (copy), React (copy), Tile (copy)
	local v9 = useLocalization({
		shareQRHeading = Constants.LOCALIZATION.SHARE_QR_HEADING
	})

	return React.createElement(Tile, {
		icon = "icons/actions/friend_sort/qr_code",
		index = t1.index,
		itemSize = t1.itemSize,
		onActivated = t1.onActivated,
		title = v9.shareQRHeading,
		selectionOrder = t1.selectionOrder
	})
end

return ShareQRTile
