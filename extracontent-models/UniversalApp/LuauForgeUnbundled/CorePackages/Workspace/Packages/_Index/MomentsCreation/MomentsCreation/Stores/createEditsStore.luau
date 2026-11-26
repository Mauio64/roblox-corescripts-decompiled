local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals").createSignal

local function createEditsStore()
	local signal, v5 = createSignal({})

	return {
		getMap = signal,
		setCommitted = function(p2, p3)
			local clone = table.clone(signal(false))
			clone[p2] = p3
			v5(clone)
		end,
		clear = function()
			v5({})
		end
	}
end

return createEditsStore
