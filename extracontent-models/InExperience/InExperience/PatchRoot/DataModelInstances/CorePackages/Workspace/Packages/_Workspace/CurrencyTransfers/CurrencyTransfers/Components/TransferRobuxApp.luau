local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)

local TransferRobuxContainer = require(CurrencyTransfers.Components.TransferRobuxContainer)
local TransferContext = require(CurrencyTransfers.Contexts.TransferContext)
require(CurrencyTransfers.Stores.createTransferStore)

local function TransferRobuxApp(p)
	return React.createElement(TransferContext.Provider, { value = p.transferStore }, {
		TransferRobuxSheet = React.createElement(TransferRobuxContainer, {})
	})
end

return TransferRobuxApp
