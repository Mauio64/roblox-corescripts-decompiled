local module = require("@luauforge/bundled/dTk")

local module2 = require("@luauforge/bundled/dTn")

local module3 = require("@luauforge/bundled/dUH")

local function SduiAvatarExperienceRegister(): nil
	module.useEffect(function()
		module2()
		module3()
	end, {})
	return nil
end

return module.memo(SduiAvatarExperienceRegister)
