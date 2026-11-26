local module = require("@luauforge/bundled/hId")
local sduiActionType = module.SduiActionType
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry

local function registerBuyRobuxSduiActions()
	local v5 = {
		[sduiActionType.PurchaseBuyRobuxProduct] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hJL")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.PurchaseBuyRobuxSubscription] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hJY")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.OpenRobloxPlusSheet] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hKc")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.OpenSendRobux] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hKd")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.ReviewTransfer] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hKe")
			end,
			skipUnifiedLogging = true
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerBuyRobuxSduiActions
