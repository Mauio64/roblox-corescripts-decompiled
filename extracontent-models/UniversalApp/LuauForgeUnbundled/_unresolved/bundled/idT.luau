local module = require("@luauforge/bundled/idU")

local module2 = require("@luauforge/bundled/idV")
local module3 = require("@luauforge/bundled/ieg")

local fFlagLuaAppSduiGameTileFeedback = require("@luauforge/bundled/idX").FFlagLuaAppSduiGameTileFeedback
local fFlagSduiPlayWithRewardRefactor = require("@luauforge/bundled/idX").FFlagSduiPlayWithRewardRefactor

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
