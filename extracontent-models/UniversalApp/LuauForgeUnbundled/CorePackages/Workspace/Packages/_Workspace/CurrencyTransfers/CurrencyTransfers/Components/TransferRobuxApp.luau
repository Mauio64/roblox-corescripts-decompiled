local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local TransferRobuxContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/TransferRobuxContainer")
local TransferContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Contexts/TransferContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")

local function TransferRobuxApp(p2)
	return React.createElement(TransferContext.Provider, { value = p2.transferStore }, {
		TransferRobuxSheet = React.createElement(TransferRobuxContainer, {})
	})
end

return TransferRobuxApp
