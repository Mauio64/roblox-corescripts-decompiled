local module = require("@luauforge/bundled/dPU")

local module2 = require("@luauforge/bundled/dPX")

local module3 = require("@luauforge/bundled/dRn")

local function SduiAvatarExperienceRegister(): nil
	module.useEffect(function()
		module2()
		module3()
	end, {})
	return nil
end

return module.memo(SduiAvatarExperienceRegister)
