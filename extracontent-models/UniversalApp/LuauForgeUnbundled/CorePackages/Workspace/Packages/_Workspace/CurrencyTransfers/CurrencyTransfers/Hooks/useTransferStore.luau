local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local TransferContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Contexts/TransferContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")

local function useTransferStore()
	local v5 = React.useContext(TransferContext)

	if v5 == nil then
		error("useTransferStore must be used within a TransferContext")
	end

	return v5
end

return useTransferStore
