local module = require("@luauforge/bundled/hTW")

local module2 = require("@luauforge/bundled/hTX")
local module3 = require("@luauforge/bundled/hUi")

local fFlagLuaAppSduiGameTileFeedback = require("@luauforge/bundled/hTZ").FFlagLuaAppSduiGameTileFeedback
local fFlagSduiPlayWithRewardRefactor = require("@luauforge/bundled/hTZ").FFlagSduiPlayWithRewardRefactor

local function SduiAdsRegister(): nil
	module.useEffect(function()
		if fFlagLuaAppSduiGameTileFeedback or fFlagSduiPlayWithRewardRefactor then
			module2()
		end

		module3()
	end, {})

	return nil
end

return module.memo(SduiAdsRegister)
