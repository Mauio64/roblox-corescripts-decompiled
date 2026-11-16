local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local registerCurrencyTransferSduiActions = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/registerCurrencyTransferSduiActions")

local function SduiEconomyRegister(): nil
	React.useEffect(function()
		registerCurrencyTransferSduiActions()
	end, {})
	return nil
end

return React.memo(SduiEconomyRegister)
