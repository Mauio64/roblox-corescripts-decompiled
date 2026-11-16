local module = require("@luauforge/bundled/dPU")
local module2 = require("@luauforge/bundled/dRF")

local function useWrapZeroArgActionHandler(p2)
	return module.useMemo(function()
		return module2(p2)
	end, { p2 })
end

return useWrapZeroArgActionHandler
