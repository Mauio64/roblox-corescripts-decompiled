local module = require("@luauforge/bundled/idA")

local module2 = require("@luauforge/bundled/idB")

local function SduiVerificationUpsellRegister(): nil
	module.useEffect(function()
		module2()
	end, {})

	return nil
end

return module.memo(SduiVerificationUpsellRegister)
