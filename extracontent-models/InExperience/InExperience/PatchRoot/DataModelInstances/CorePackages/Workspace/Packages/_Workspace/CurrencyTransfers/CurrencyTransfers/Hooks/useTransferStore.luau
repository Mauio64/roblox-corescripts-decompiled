local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local TransferContext = require(CurrencyTransfers.Contexts.TransferContext)
require(CurrencyTransfers.Stores.createTransferStore)

local function useTransferStore()
	local v = React.useContext(TransferContext)

	if v == nil then
		error("useTransferStore must be used within a TransferContext")
	end

	return v
end

return useTransferStore
