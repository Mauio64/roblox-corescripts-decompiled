local module = require("@luauforge/bundled/dTk")

local fFlagAXFixSduiCatalogRowJump = require("@luauforge/bundled/dTp").FFlagAXFixSduiCatalogRowJump

local function useTrackedRowWidth(p2)
	local v5 = not (fFlagAXFixSduiCatalogRowJump and p2 and p2 > 0) and 0 or p2
	local state, setState = module.useState(v5)
	local ref = module.useRef(v5)
	return state, (module.useCallback(function(p3)
		local x = p3.AbsoluteSize.X

		if ref.current == x then
			return
		end

		ref.current = x
		setState(x)
	end, {}))
end

return useTrackedRowWidth
