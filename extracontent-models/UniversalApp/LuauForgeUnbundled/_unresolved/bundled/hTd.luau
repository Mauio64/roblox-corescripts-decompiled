local module = require("@luauforge/bundled/hTe")

local module2 = require("@luauforge/bundled/hTf")

local function SduiGroupsRegister(): nil
	module.useEffect(function()
		module2()
	end, {})
	return nil
end

return module.memo(SduiGroupsRegister)
