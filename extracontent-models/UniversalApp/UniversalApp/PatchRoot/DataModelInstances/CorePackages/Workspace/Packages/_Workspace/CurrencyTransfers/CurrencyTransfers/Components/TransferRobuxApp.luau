local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local TransferRobuxContainer = require(CurrencyTransfers.Components.TransferRobuxContainer)
local TransferContext = require(CurrencyTransfers.Contexts.TransferContext)

require(CurrencyTransfers.Stores.createTransferStore)

local function TransferRobuxApp(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), TransferContext (copy), TransferRobuxContainer (copy)
	return React.createElement(TransferContext.Provider, {
		value = t1.transferStore
	}, {
		TransferRobuxSheet = React.createElement(TransferRobuxContainer, {})
	})
end

return TransferRobuxApp
