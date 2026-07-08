local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local TransferContext = require(CurrencyTransfers.Contexts.TransferContext)

require(CurrencyTransfers.Stores.createTransferStore)

local function useTransferStore() -- line: 9
	-- upvalues: React (copy), TransferContext (copy)
	local v6 = React.useContext(TransferContext)

	if v6 == nil then
		error("useTransferStore must be used within a TransferContext")
	end

	return v6
end

return useTransferStore
