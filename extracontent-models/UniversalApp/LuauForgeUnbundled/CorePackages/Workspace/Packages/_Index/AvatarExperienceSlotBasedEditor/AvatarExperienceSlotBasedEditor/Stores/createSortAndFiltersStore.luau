local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Signals")

local InventoryFilters = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventoryFilters")
local InventorySorts = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventorySorts")

local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function createSortAndFiltersStore()
	local createSignal = Signals.createSignal
	local v5

	if fFlagAXInventoryDurablesExpiredFilter then
		v5 = { filter = InventoryFilters.Active, sort = InventorySorts.Newest }
	else
		v5 = { sort = InventorySorts.Newest }
	end

	local signal, v6 = createSignal(v5)

	return {
		getSortAndFilters = signal,
		getFiltersCount = Signals.createComputed(function(p2)
			if fFlagAXInventoryDurablesExpiredFilter then
				local v7 = signal(p2)
				local count = 0

				if v7.sort ~= InventorySorts.Newest then
					count += 1
				end

				if v7.filter ~= InventoryFilters.Active then
					count += 1
				end

				return count
			elseif signal(p2).sort == InventorySorts.Newest then
				return 0
			else
				return 1
			end
		end),
		applySortAndFilters = function(p2)
			v6(p2)
		end
	}
end

return createSortAndFiltersStore
