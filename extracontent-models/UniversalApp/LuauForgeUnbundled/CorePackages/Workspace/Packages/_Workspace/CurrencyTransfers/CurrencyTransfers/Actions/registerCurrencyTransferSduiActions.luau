local fFlagSduiOpenIncomingTransferUpsellAction = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags").FFlagSduiOpenIncomingTransferUpsellAction

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerCurrencyTransferSduiActions()
	if not fFlagSduiOpenIncomingTransferUpsellAction then
		return
	end

	local v5 = {
		[sduiActionType.OpenIncomingTransferUpsell] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/SduiOpenIncomingTransferUpsellAction")
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerCurrencyTransferSduiActions
