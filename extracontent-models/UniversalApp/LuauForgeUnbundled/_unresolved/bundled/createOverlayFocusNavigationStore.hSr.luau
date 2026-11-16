local module = require("@luauforge/bundled/hSq")

local function createOverlayFocusNavigationStore()
	local signal, v5 = module.createSignal(nil)

	return {
		getRegistration = signal,
		register = function(p2)
			v5(p2)

			return function()
				if signal(false) == p2 then
					v5(nil)
				end
			end
		end,
		reset = function()
			v5(nil)
		end
	}
end

return createOverlayFocusNavigationStore
