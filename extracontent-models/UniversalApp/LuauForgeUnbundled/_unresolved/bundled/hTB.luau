local module = require("@luauforge/bundled/hTC")

local module2 = require("@luauforge/bundled/hTD")

local function SduiVerificationUpsellRegister(): nil
	module.useEffect(function()
		module2()
	end, {})

	return nil
end

return module.memo(SduiVerificationUpsellRegister)
