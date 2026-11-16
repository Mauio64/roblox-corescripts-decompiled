local module = require("@luauforge/bundled/hwV")
local sduiActionType = module.SduiActionType
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry

local function registerBuyRobuxSduiActions()
	local v5 = {
		[sduiActionType.PurchaseBuyRobuxProduct] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyy")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.PurchaseBuyRobuxSubscription] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyJ")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.OpenRobloxPlusSheet] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyM")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.OpenSendRobux] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyN")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.ReviewTransfer] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyO")
			end,
			skipUnifiedLogging = true
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerBuyRobuxSduiActions
