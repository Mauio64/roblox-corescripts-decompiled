local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Signals")

local function createStaleInventoryGrantStore()
	local signal, v5 = Signals.createSignal({})

	local v6 = {}

	return {
		getStaleSearchUuids = signal,
		getRemovedItemIds = function(p2)
			return v6[p2]
		end,
		isSearchUuidStale = function(p2): boolean
			return signal(false)[p2] == true
		end,
		markSearchUuidStale = function(p2, items)
			if items then
				local v7 = v6[p2]

				if v7 then
					for k, item in items do
						if not Cryo.List.find(v7, item) then
							v7[#v7 + 1] = item
						end
					end
				else
					v6[p2] = table.clone(items)
				end
			end

			if signal(false)[p2] == true then
				return
			end

			v5(Cryo.Dictionary.join(signal(false), { [p2] = true }))
		end,
		clearSearchUuidStale = function(p2)
			v6[p2] = nil

			if signal(false)[p2] ~= true then
				return
			end

			v5(Cryo.Dictionary.join(signal(false), { [p2] = Cryo.None }))
		end
	}
end

return createStaleInventoryGrantStore
