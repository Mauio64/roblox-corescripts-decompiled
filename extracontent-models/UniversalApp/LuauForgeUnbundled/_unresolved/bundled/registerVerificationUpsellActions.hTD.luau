local module = require("@luauforge/bundled/hTE")
local sduiActionType = module.SduiActionType
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry

local fFlagLuaAppSduiVerificationUpsellActions = require("@luauforge/bundled/hTF").FFlagLuaAppSduiVerificationUpsellActions

local function registerVerificationUpsellActions()
	if not fFlagLuaAppSduiVerificationUpsellActions then
		return
	end

	local v5 = {
		[sduiActionType.OpenPhoneUpsellModal] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hTG")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenEmailUpsellModal] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hTO")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenFacialAgeEstimation] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hTP")
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerVerificationUpsellActions
