local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Signals")

local function createOverflowMenuSignalStore()
	local signal, v5 = Signals.createSignal(nil)

	return {
		getActiveMenuKey = signal,
		getIsMenuOpen = function(p2): boolean
			return signal(false) == p2
		end,
		openMenu = function(p2)
			v5(p2)
		end,
		closeMenu = function(p2)
			if signal(false) == p2 then
				v5(nil)
			end
		end,
		toggleMenu = function(p2)
			if signal(false) == p2 then
				if signal(false) == p2 then
					v5(nil)
				end
			else
				v5(p2)
			end
		end
	}
end

return createOverflowMenuSignalStore
