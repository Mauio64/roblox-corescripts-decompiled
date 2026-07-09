local Parent = script:FindFirstAncestor("AppBlox").Parent
local Signals = require(Parent.Signals)

local function createOverflowMenuSignalStore() -- line: 14
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(nil)

	return {
		getActiveMenuKey = v4,
		getIsMenuOpen = function(s1: string) -- line: 17
			-- upvalues: v4 (copy)
			return s1 == v4(false)
		end,
		openMenu = function(s2: string) -- line: 22
			-- upvalues: v5 (copy)
			v5(s2)
		end,
		closeMenu = function(s3: string) -- line: 26
			-- upvalues: v4 (copy), v5 (copy)
			if s3 == v4(false) then
				v5(nil)
			end
		end,
		toggleMenu = function(s4: string) -- line: 32
			-- upvalues: v4 (copy), v5 (copy)
			if s4 == v4(false) then
				if s4 == v4(false) then
					v5(nil)

					return
				end
			else
				v5(s4)
			end
		end
	}
end

return createOverflowMenuSignalStore
