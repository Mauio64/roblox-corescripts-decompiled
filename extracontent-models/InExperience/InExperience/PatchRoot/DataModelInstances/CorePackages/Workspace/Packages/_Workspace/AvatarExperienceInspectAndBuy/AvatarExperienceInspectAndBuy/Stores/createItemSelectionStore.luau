local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local Signals = require(parent.Signals)
require(parent.AXCommon)

local function createItemSelectionStore()
	local signal, v = Signals.createSignal({})

	local v2 = {}

	return {
		getItemDataMap = signal,
		getItemData = function(p: string)
			if v2[p] == nil then
				v2[p] = Signals.createComputed(function(p2)
					return signal(p2)[p]
				end)
			end

			return v2[p]
		end,
		setItemData = function(p: string, p2)
			local clone = table.clone(signal(false))
			clone[p] = p2
			v(clone)
		end,
		clearItemData = function(p: string)
			local clone = table.clone(signal(false))
			clone[p] = nil
			v(clone)
		end,
		clearAll = function()
			v({})
		end
	}
end

return createItemSelectionStore
