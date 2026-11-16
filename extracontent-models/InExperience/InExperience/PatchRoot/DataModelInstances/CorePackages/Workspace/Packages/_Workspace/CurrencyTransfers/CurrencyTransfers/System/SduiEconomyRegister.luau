local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)

local registerCurrencyTransferSduiActions = require(CurrencyTransfers.Actions.registerCurrencyTransferSduiActions)

local function SduiEconomyRegister(): nil
	React.useEffect(function()
		registerCurrencyTransferSduiActions()
	end, {})
	return nil
end

return React.memo(SduiEconomyRegister)
