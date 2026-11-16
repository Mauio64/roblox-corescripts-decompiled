local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local Tile = require(SocialCarousel.BaseComponents.Tile)

local function ShareQRTile(props)
	local v = useLocalization({ shareQRHeading = Constants.LOCALIZATION.SHARE_QR_HEADING })

	return React.createElement(Tile, {
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v.shareQRHeading,
		icon = "icons/actions/friend_sort/qr_code",
		selectionOrder = props.selectionOrder
	})
end

return ShareQRTile
