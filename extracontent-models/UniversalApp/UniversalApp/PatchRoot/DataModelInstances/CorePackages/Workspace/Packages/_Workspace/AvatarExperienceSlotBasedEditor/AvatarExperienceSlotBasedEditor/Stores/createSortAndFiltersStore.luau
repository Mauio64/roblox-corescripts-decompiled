local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local Signals = require(Parent.Signals)
local InventoryFilters = require(script.Parent.Parent.Enums.InventoryFilters)
local InventorySorts = require(script.Parent.Parent.Enums.InventorySorts)
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function createSortAndFiltersStore() -- line: 36
	-- upvalues: Signals (copy), FFlagAXInventoryDurablesExpiredFilter (copy), InventoryFilters (copy), InventorySorts (copy)
	local v8, v9 = Signals.createSignal(if not FFlagAXInventoryDurablesExpiredFilter then {
		sort = InventorySorts.Newest
	} else {
		filter = InventoryFilters.Active,
		sort = InventorySorts.Newest
	})
	local v10 = Signals.createComputed(function(p1) -- line: 42
		-- upvalues: FFlagAXInventoryDurablesExpiredFilter (copy), v8 (copy), InventorySorts (copy), InventoryFilters (copy)
		if FFlagAXInventoryDurablesExpiredFilter then
			local v12 = v8(p1)
			local n1 = 0

			if v12.sort ~= InventorySorts.Newest then
				n1 += 1
			end

			if v12.filter ~= InventoryFilters.Active then
				n1 += 1
			end

			return n1
		end

		if v8(p1).sort == InventorySorts.Newest then
			return 0
		end

		return 1
	end)

	return {
		getSortAndFilters = v8,
		getFiltersCount = v10,
		applySortAndFilters = function(t1: {[any]: any}) -- line: 58
			-- upvalues: v9 (copy)
			v9(t1)
		end
	}
end

return createSortAndFiltersStore
