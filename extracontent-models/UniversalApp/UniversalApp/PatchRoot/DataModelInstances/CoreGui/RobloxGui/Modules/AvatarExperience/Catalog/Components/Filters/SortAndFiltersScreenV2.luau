local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)

local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local CatalogSortAndFilters = require(Modules.AvatarExperience.Catalog.Components.Filters.CatalogSortAndFilters)
local InventorySortsAndFiltersContainer = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventorySortAndFilters.InventorySortsAndFiltersContainer)

local function SortAndFiltersScreen() -- line: 28
	-- upvalues: useNavigation (copy), React (copy), InventorySortsAndFiltersContainer (copy), CatalogSortAndFilters (copy)
	local params = useNavigation().state.params

	if params.slotBasedEditorContext then
		return (React.createElement(InventorySortsAndFiltersContainer, {
			slotBasedEditorContext = params.slotBasedEditorContext
		}))
	end

	return (React.createElement(CatalogSortAndFilters))
end

return SortAndFiltersScreen
