local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local function createRootedNavigationStore()
	local signal, v = Signals.createSignal(false)
	local count = 0
	local v2 = nil

	local function cancelNavigation() -- 1 equivalent call inferred from this helper
		v2 = nil
		v(false)
	end

	return {
		getIsNavigationPending = signal,
		beginNavigation = function()
			count += 1
			v2 = count
			v(true)
			return count
		end,
		completeNavigation = function(p: number?)
			if signal(false) and p == v2 then
				cancelNavigation() -- inferred equivalent call
			end
		end,
		cancelNavigation = cancelNavigation,
		reset = cancelNavigation
	}
end

return createRootedNavigationStore
