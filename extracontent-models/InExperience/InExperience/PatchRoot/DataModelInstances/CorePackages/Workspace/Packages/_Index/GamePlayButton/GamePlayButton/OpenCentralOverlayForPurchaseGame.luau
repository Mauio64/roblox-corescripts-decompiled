local parent = script:FindFirstAncestor("GamePlayButton").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(universeId, gameName, price, productId, sellerId, pageFilter)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.PurchaseGame, {
			universeId = universeId,
			gameName = gameName,
			price = price,
			productId = productId,
			sellerId = sellerId,
			pageFilter = pageFilter
		}))
	end
end
