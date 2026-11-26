local module = require("@luauforge/bundled/idC")
local sduiActionType = module.SduiActionType
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry

local fFlagLuaAppSduiVerificationUpsellActions = require("@luauforge/bundled/idD").FFlagLuaAppSduiVerificationUpsellActions

local function registerVerificationUpsellActions()
	if not fFlagLuaAppSduiVerificationUpsellActions then
		return
	end

	local v5 = {
		[sduiActionType.OpenPhoneUpsellModal] = {
			lazyHandler = function()
				return require("@luauforge/bundled/idE")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenEmailUpsellModal] = {
			lazyHandler = function()
				return require("@luauforge/bundled/idM")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenFacialAgeEstimation] = {
			lazyHandler = function()
				return require("@luauforge/bundled/idN")
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerVerificationUpsellActions
