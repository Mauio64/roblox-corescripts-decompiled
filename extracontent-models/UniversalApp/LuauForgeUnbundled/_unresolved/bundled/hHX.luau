local module = require("@luauforge/bundled/hHY")

return {
	getOneTimeProduct = function(p2)
		return module.BuyRobux.getOneTimeProductStore(false).getInfo(p2).data(false)
	end,
	getSubscriptionProduct = function(p2)
		return module.BuyRobux.getSubscriptionProductStore(false).getInfo(p2).data(false)
	end,
	getPendingTransfer = function(p2)
		return module.BuyRobux.getPendingTransferStore(false).getInfo(p2).data(false)
	end,
	getBonusItem = function(p2)
		return module.BuyRobux.getBonusItemStore(false).getInfo(p2).data(false)
	end
}
