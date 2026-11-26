local module = require("@luauforge/bundled/idW")
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry
local sduiActionType = module.SduiActionType

local fFlagLuaAppSduiGameTileFeedback = require("@luauforge/bundled/idX").FFlagLuaAppSduiGameTileFeedback
local fFlagSduiPlayWithRewardRefactor = require("@luauforge/bundled/idX").FFlagSduiPlayWithRewardRefactor

local function registerAdsActions()
	local v5 = {
		[sduiActionType.OpenWhyThisAd] = fFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require("@luauforge/bundled/idY")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.PlayWithRewardAd] = fFlagSduiPlayWithRewardRefactor and {
			lazyHandler = function()
				return require("@luauforge/bundled/iec")
			end,
			skipUnifiedLogging = true
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerAdsActions
