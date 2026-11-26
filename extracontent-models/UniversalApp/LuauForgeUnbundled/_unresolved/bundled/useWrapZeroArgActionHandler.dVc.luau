local module = require("@luauforge/bundled/dTk")
local module2 = require("@luauforge/bundled/dVa")

local function useWrapZeroArgActionHandler(p2)
	return module.useMemo(function()
		return module2(p2)
	end, { p2 })
end

return useWrapZeroArgActionHandler
