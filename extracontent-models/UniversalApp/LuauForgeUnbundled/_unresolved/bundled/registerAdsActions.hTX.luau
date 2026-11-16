local module = require("@luauforge/bundled/hTY")
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry
local sduiActionType = module.SduiActionType

local fFlagLuaAppSduiGameTileFeedback = require("@luauforge/bundled/hTZ").FFlagLuaAppSduiGameTileFeedback
local fFlagSduiPlayWithRewardRefactor = require("@luauforge/bundled/hTZ").FFlagSduiPlayWithRewardRefactor

local function registerAdsActions()
	local v5 = {
		[sduiActionType.OpenWhyThisAd] = fFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require("@luauforge/bundled/hUa")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.PlayWithRewardAd] = fFlagSduiPlayWithRewardRefactor and {
			lazyHandler = function()
				return require("@luauforge/bundled/hUe")
			end,
			skipUnifiedLogging = true
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerAdsActions
