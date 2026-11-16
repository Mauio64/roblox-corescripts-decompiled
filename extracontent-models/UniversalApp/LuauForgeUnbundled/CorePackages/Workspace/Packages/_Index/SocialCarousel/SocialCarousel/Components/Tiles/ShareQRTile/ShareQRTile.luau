local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization").Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local Tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/BaseComponents/Tile")

local function ShareQRTile(props)
	local v5 = useLocalization({
		shareQRHeading = Constants.LOCALIZATION.SHARE_QR_HEADING
	})

	return React.createElement(Tile, {
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v5.shareQRHeading,
		icon = "icons/actions/friend_sort/qr_code",
		selectionOrder = props.selectionOrder
	})
end

return ShareQRTile
