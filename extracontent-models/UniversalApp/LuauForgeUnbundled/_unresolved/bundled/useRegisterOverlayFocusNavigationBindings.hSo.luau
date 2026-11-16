local module = require("@luauforge/bundled/hRF")

local module2 = require("@luauforge/bundled/hSp")

local function useRegisterOverlayFocusNavigationBindings(current)
	local ref = module.useRef(current)
	ref.current = current

	module.useEffect(function()
		return module2(false).register({
			getBindings = function()
				return ref.current
			end
		})
	end, {})
end

return useRegisterOverlayFocusNavigationBindings
