local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local Rodux = require(parent.Rodux)

require(BulkPurchaseApp.Store.Types)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)

return Rodux.makeActionCreator(
	"BulkPurchaseRequested",
	function(itemData, orderRequest, balance: number, totalCost: number, options, discountInformation, offerData)
		if not FFlagAXAddOffersToBulkPurchase then
			offerData = nil
		end

		return {
			itemData = itemData,
			balance = balance,
			totalCost = totalCost,
			orderRequest = orderRequest,
			options = options,
			discountInformation = discountInformation,
			offerData = offerData
		}
	end
)
