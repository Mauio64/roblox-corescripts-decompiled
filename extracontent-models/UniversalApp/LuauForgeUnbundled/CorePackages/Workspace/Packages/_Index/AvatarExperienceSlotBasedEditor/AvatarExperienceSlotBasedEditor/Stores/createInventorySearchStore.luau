local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Signals")

local function createInventorySearchStore()
	local signal, v5 = Signals.createSignal("")
	return {
		getQuery = signal,
		getIsSearchActive = Signals.createComputed(function(p2): boolean
			return signal(p2) ~= ""
		end),
		setQuery = function(p2)
			v5(p2)
		end,
		clearQuery = function()
			v5("")
		end
	}
end

return createInventorySearchStore
