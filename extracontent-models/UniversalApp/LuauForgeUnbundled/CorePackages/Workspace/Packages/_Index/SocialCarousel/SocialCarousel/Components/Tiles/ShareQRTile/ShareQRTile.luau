local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization")
local FFlagSocialCarouselXXSmallTiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXXSmallTiles")

local useLocalization = Localization.Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local Tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/BaseComponents/Tile")

local function ShareQRTile(props)
	local v5 = FFlagSocialCarouselXXSmallTiles and props.isCompact == true
	local v6 = useLocalization({
		shareQRHeading = Constants.LOCALIZATION.SHARE_QR_HEADING
	})

	local createElement = React.createElement
	local v8 = {
		testId = props.testId or `--social-social-carousel-view-share-qr-{props.index}`,
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v6.shareQRHeading,
		icon = v5 and "squares-grid-qr" or "icons/actions/friend_sort/qr_code",
		iconScale = 0,
		selectionOrder = 0
	}

	local v9 = if v5 then Constants.TILE_ICON_SCALE else nil
	v8.iconScale = v9
	v8.selectionOrder = props.selectionOrder
	return createElement(Tile, v8)
end

return ShareQRTile
