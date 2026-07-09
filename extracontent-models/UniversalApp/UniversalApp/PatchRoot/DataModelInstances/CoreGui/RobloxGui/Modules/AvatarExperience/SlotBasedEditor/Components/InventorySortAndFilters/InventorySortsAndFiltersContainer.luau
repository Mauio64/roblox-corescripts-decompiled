local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local InventorySortAndFilters = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventorySortAndFilters.InventorySortAndFilters)
local useInventorySortsAndFiltersProps = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventorySortAndFilters.useInventorySortsAndFiltersProps)

local function InventorySortsAndFiltersContainer(p1) -- line: 14
	-- upvalues: useInventorySortsAndFiltersProps (copy), React (copy), InventorySortAndFilters (copy)
	local v8 = useInventorySortsAndFiltersProps(p1)

	return React.createElement(InventorySortAndFilters, v8)
end

return React.memo(InventorySortsAndFiltersContainer)
