local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local FFlagSocialCarouselXXSmallTiles = require(SocialCarousel.Flags.FFlagSocialCarouselXXSmallTiles)

local useLocalization = Localization.Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local Tile = require(SocialCarousel.BaseComponents.Tile)

local function ShareQRTile(props)
	local v = FFlagSocialCarouselXXSmallTiles and props.isCompact == true
	local v2 = useLocalization({ shareQRHeading = Constants.LOCALIZATION.SHARE_QR_HEADING })

	local createElement = React.createElement
	local v3 = {
		testId = props.testId or `--social-social-carousel-view-share-qr-{props.index}`,
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v2.shareQRHeading,
		icon = v and "squares-grid-qr" or "icons/actions/friend_sort/qr_code",
		iconScale = 0,
		selectionOrder = 0
	}
	local iconScale

	if v then
		iconScale = Constants.TILE_ICON_SCALE
	end

	v3.iconScale = iconScale
	v3.selectionOrder = props.selectionOrder
	return createElement(Tile, v3)
end

return ShareQRTile
