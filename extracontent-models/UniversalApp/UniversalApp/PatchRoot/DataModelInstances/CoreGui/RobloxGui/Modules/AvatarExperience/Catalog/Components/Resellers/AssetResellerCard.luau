local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ResellerCard = require(Modules.AvatarExperience.Catalog.Components.ResellerCard)
local v7 = Roact.PureComponent:extend("AssetResellerCard")

function v7.render(p1) -- line: 17
	-- upvalues: Roact (copy), ResellerCard (copy)
	local userAssetInfo = p1.props.userAssetInfo

	if not userAssetInfo then
		return
	end

	return Roact.createElement(ResellerCard, {
		LayoutOrder = p1.props.LayoutOrder,
		itemId = p1.props.itemId,
		itemType = p1.props.itemType,
		itemPrice = userAssetInfo.priceInRobux,
		productId = p1.props.productId,
		sellerId = userAssetInfo.userId,
		sellerName = userAssetInfo.userName,
		sellerHasVerifiedBadge = userAssetInfo.sellerHasVerifiedBadge,
		serialNumber = userAssetInfo.serialNumber,
		userAssetId = p1.props.userAssetId,
		hasDivider = p1.props.hasDivider,
		horizontalPadding = p1.props.horizontalPadding,
		focusController = p1.props.focusController
	})
end

return RoactRodux.connect(function(p2, p3) -- line: 39
	return {
		userAssetInfo = p2.AvatarExperience.Catalog.UserAssets[p3.userAssetId]
	}
end)(v7)
