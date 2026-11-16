local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiOpenIncomingTransferUpsellAction = SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerCurrencyTransferSduiActions()
	if not FFlagSduiOpenIncomingTransferUpsellAction then
		return
	end

	local v = {
		[SduiActionType.OpenIncomingTransferUpsell] = {
			lazyHandler = function()
				return require(CurrencyTransfers.Actions.SduiOpenIncomingTransferUpsellAction)
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerCurrencyTransferSduiActions
