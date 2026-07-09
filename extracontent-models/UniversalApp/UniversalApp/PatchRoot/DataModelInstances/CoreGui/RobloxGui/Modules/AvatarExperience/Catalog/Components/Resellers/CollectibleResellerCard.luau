local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ResellerCard = require(Modules.AvatarExperience.Catalog.Components.ResellerCard)
local v7 = Roact.PureComponent:extend("CollectibleResellerCard")

function v7.render(p1) -- line: 18
	-- upvalues: Roact (copy), ResellerCard (copy)
	local collectibleInstance = p1.props.collectibleInstance

	if not collectibleInstance then
		return
	end

	return Roact.createElement(ResellerCard, {
		LayoutOrder = p1.props.LayoutOrder,
		itemId = p1.props.itemId,
		itemType = p1.props.itemType,
		itemPrice = collectibleInstance.price,
		productId = collectibleInstance.collectibleProductId,
		sellerId = tostring(collectibleInstance.seller.sellerId),
		sellerName = collectibleInstance.seller.name,
		sellerHasVerifiedBadge = collectibleInstance.seller.hasVerifiedBadge,
		serialNumber = collectibleInstance.serialNumber,
		hasDivider = p1.props.hasDivider,
		horizontalPadding = p1.props.horizontalPadding,
		focusController = p1.props.focusController,
		collectibleInstanceId = collectibleInstance.collectibleInstanceId
	})
end

return RoactRodux.connect(function(p2, p3) -- line: 40
	local CollectiblesResellersInstances = p2.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances
	local v13 = if not p3.collectibleItemId then nil else CollectiblesResellersInstances[p3.collectibleItemId]

	return {
		collectibleInstance = if not v13 or not p3.collectibleInstanceId then nil else v13.Instances[p3.collectibleInstanceId]
	}
end)(v7)
