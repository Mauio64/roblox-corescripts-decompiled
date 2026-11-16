local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local function createStaleInventoryGrantStore()
	local signal, v = Signals.createSignal({})

	local v2 = {}

	local function isSearchUuidStale(p: string): boolean -- 2 equivalent calls inferred from this helper
		return signal(false)[p] == true
	end

	return {
		getStaleSearchUuids = signal,
		getRemovedItemIds = function(p: string)
			return v2[p]
		end,
		isSearchUuidStale = isSearchUuidStale,
		markSearchUuidStale = function(p: string, items)
			if items then
				local v3 = v2[p]

				if v3 then
					for _, item in items do
						if not Cryo.List.find(v3, item) then
							v3[#v3 + 1] = item
						end
					end
				else
					v2[p] = table.clone(items)
				end
			end

			if isSearchUuidStale(p) then -- inferred equivalent call
				return
			end

			v(Cryo.Dictionary.join(signal(false), { [p] = true }))
		end,
		clearSearchUuidStale = function(p: string)
			v2[p] = nil

			if not isSearchUuidStale(p) then -- inferred equivalent call
				return
			end

			v(Cryo.Dictionary.join(signal(false), { [p] = Cryo.None }))
		end
	}
end

return createStaleInventoryGrantStore
