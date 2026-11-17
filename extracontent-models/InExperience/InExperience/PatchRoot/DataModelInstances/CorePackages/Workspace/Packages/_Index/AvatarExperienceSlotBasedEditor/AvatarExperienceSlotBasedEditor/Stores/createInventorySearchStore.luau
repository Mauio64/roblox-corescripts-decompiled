local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local Signals = require(parent.Signals)

local function createInventorySearchStore()
	local signal, v = Signals.createSignal("")
	return {
		getQuery = signal,
		getIsSearchActive = Signals.createComputed(function(p): boolean
			return signal(p) ~= ""
		end),
		setQuery = function(p: string)
			v(p)
		end,
		clearQuery = function()
			v("")
		end
	}
end

return createInventorySearchStore
