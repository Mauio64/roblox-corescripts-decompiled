local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/deferred/gnu")

local extended = Roact.PureComponent:extend("CollectibleResellerCard")

function extended.render(p2)
	local collectibleInstance = p2.props.collectibleInstance

	if collectibleInstance then
		return Roact.createElement(module, {
			LayoutOrder = p2.props.LayoutOrder,
			itemId = p2.props.itemId,
			itemType = p2.props.itemType,
			itemPrice = collectibleInstance.price,
			productId = collectibleInstance.collectibleProductId,
			sellerId = tostring(collectibleInstance.seller.sellerId),
			sellerName = collectibleInstance.seller.name,
			sellerHasVerifiedBadge = collectibleInstance.seller.hasVerifiedBadge,
			serialNumber = collectibleInstance.serialNumber,
			hasDivider = p2.props.hasDivider,
			horizontalPadding = p2.props.horizontalPadding,
			focusController = p2.props.focusController,
			collectibleInstanceId = collectibleInstance.collectibleInstanceId
		})
	end
end

return RoactRodux.connect(function(p2, p3)
	local collectiblesResellersInstances = p2.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances
	local v5 = if p3.collectibleItemId then collectiblesResellersInstances[p3.collectibleItemId] else nil

	local v7 = if v5 and p3.collectibleInstanceId then v5.Instances[p3.collectibleInstanceId] else nil
	return { collectibleInstance = v7 }
end)(extended)
