local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local Signals = require(parent.Signals)

local InventoryFilters = require(script.Parent.Parent.Enums.InventoryFilters)
local InventorySorts = require(script.Parent.Parent.Enums.InventorySorts)

local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function createSortAndFiltersStore()
	local createSignal = Signals.createSignal
	local v

	if FFlagAXInventoryDurablesExpiredFilter then
		v = { filter = InventoryFilters.Active, sort = InventorySorts.Newest }
	else
		v = { sort = InventorySorts.Newest }
	end

	local signal, v2 = createSignal(v)

	return {
		getSortAndFilters = signal,
		getFiltersCount = Signals.createComputed(function(p)
			if FFlagAXInventoryDurablesExpiredFilter then
				local v3 = signal(p)
				local count = 0

				if v3.sort ~= InventorySorts.Newest then
					count += 1
				end

				if v3.filter ~= InventoryFilters.Active then
					count += 1
				end

				return count
			elseif signal(p).sort == InventorySorts.Newest then
				return 0
			else
				return 1
			end
		end),
		applySortAndFilters = function(p)
			v2(p)
		end
	}
end

return createSortAndFiltersStore
