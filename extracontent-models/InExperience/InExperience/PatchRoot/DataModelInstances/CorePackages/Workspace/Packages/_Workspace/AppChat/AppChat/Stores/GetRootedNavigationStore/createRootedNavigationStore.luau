local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)

local function createRootedNavigationStore() -- line: 14
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(false)
	local n1 = 0
	local u7 = nil

	local function cancelNavigation() -- line: 19
		-- upvalues: u7 (ref), v5 (copy)
		u7 = nil
		v5(false)
	end

	return {
		getIsNavigationPending = v4,
		beginNavigation = function() -- line: 26
			-- upvalues: n1 (ref), u7 (ref), v5 (copy)
			n1 += 1
			u7 = n1
			v5(true)

			return n1
		end,
		completeNavigation = function(n2: number?) -- line: 32
			-- upvalues: v4 (copy), u7 (ref), v5 (copy)
			if v4(false) and n2 == u7 then
				u7 = nil
				v5(false)
			end
		end,
		cancelNavigation = cancelNavigation,
		reset = cancelNavigation
	}
end

return createRootedNavigationStore
