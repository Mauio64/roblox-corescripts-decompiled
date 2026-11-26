local module = require("@luauforge/bundled/idc")

local module2 = require("@luauforge/bundled/idd")

local function SduiGroupsRegister(): nil
	module.useEffect(function()
		module2()
	end, {})
	return nil
end

return module.memo(SduiGroupsRegister)
