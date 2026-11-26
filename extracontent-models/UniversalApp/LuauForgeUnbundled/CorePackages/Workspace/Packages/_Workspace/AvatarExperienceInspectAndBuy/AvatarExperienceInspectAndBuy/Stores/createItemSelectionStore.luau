local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")

local function createItemSelectionStore()
	local signal, v5 = Signals.createSignal({})

	local v6 = {}

	return {
		getItemDataMap = signal,
		getItemData = function(p2)
			if v6[p2] == nil then
				v6[p2] = Signals.createComputed(function(p3)
					return signal(p3)[p2]
				end)
			end

			return v6[p2]
		end,
		setItemData = function(p2, p3)
			local clone = table.clone(signal(false))
			clone[p2] = p3
			v5(clone)
		end,
		clearItemData = function(p2)
			local clone = table.clone(signal(false))
			clone[p2] = nil
			v5(clone)
		end,
		clearAll = function()
			v5({})
		end
	}
end

return createItemSelectionStore
