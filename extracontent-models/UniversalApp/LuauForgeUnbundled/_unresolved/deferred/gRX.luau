local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/deferred/gRY")

local extended = Roact.PureComponent:extend("AssetResellerCard")

function extended.render(p2)
	local userAssetInfo = p2.props.userAssetInfo

	if userAssetInfo then
		return Roact.createElement(module, {
			LayoutOrder = p2.props.LayoutOrder,
			itemId = p2.props.itemId,
			itemType = p2.props.itemType,
			itemPrice = userAssetInfo.priceInRobux,
			productId = p2.props.productId,
			sellerId = userAssetInfo.userId,
			sellerName = userAssetInfo.userName,
			sellerHasVerifiedBadge = userAssetInfo.sellerHasVerifiedBadge,
			serialNumber = userAssetInfo.serialNumber,
			userAssetId = p2.props.userAssetId,
			hasDivider = p2.props.hasDivider,
			horizontalPadding = p2.props.horizontalPadding,
			focusController = p2.props.focusController
		})
	end
end

return RoactRodux.connect(function(p2, p3)
	return { userAssetInfo = p2.AvatarExperience.Catalog.UserAssets[p3.userAssetId] }
end)(extended)
