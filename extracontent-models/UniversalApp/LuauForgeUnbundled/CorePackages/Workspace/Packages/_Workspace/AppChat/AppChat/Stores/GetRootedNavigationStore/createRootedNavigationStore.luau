local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local function createRootedNavigationStore()
	local signal, v5 = Signals.createSignal(false)
	local count = 0
	local v6 = nil

	local function cancelNavigation()
		v6 = nil
		v5(false)
	end

	return {
		getIsNavigationPending = signal,
		beginNavigation = function()
			count += 1
			v6 = count
			v5(true)
			return count
		end,
		completeNavigation = function(p2)
			if signal(false) and p2 == v6 then
				v6 = nil
				v5(false)
			end
		end,
		cancelNavigation = cancelNavigation,
		reset = cancelNavigation
	}
end

return createRootedNavigationStore
