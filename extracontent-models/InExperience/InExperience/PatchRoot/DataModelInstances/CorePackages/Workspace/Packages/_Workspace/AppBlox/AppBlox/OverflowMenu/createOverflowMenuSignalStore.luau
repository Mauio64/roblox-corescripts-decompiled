local parent = script:FindFirstAncestor("AppBlox").Parent
local Signals = require(parent.Signals)

local function createOverflowMenuSignalStore()
	local signal, v = Signals.createSignal(nil)

	return {
		getActiveMenuKey = signal,
		getIsMenuOpen = function(p: string): boolean
			return signal(false) == p
		end,
		openMenu = function(p: string)
			v(p)
		end,
		closeMenu = function(p: string)
			if signal(false) == p then
				v(nil)
			end
		end,
		toggleMenu = function(p: string)
			if signal(false) == p then
				if signal(false) == p then
					v(nil)
				end
			else
				v(p)
			end
		end
	}
end

return createOverflowMenuSignalStore
