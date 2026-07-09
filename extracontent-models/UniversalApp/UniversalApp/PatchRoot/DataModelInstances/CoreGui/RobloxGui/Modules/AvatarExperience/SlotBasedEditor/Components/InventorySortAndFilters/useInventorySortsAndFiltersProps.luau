local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local InventorySorts = AvatarExperienceSlotBasedEditor.Enums.InventorySorts
local InventoryFilters = AvatarExperienceSlotBasedEditor.Enums.InventoryFilters
local useAvatarEditorStores = AvatarExperienceSlotBasedEditor.Context.useAvatarEditorStores
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useCloseFiltersSignal = require(Modules.AvatarExperience.Catalog.Hooks.useCloseFiltersSignal)

require(Modules.AvatarExperience.SlotBasedEditor.Components.InventorySortAndFilters.InventorySortAndFilters)

local FFlagAXAvatarEditorStoresContext = AvatarExperienceFlags.FFlagAXAvatarEditorStoresContext
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function useInventorySortsAndFiltersProps(t1: {[any]: any}) -- line: 27
	-- upvalues: FFlagAXAvatarEditorStoresContext (copy), useAvatarEditorStores (copy), useSignalState (copy), useCloseFiltersSignal (copy), React (copy), FFlagAXInventoryDurablesExpiredFilter (copy), InventorySorts (copy), InventoryFilters (copy)
	local sortAndFiltersStore, categoryInventoryStores

	if FFlagAXAvatarEditorStoresContext then
		local v15 = useAvatarEditorStores()

		sortAndFiltersStore = v15.sortAndFiltersStore
		categoryInventoryStores = v15.categoryInventoryStores
	else
		local slotBasedEditorContext = t1.slotBasedEditorContext

		sortAndFiltersStore = slotBasedEditorContext.sortAndFiltersStore
		categoryInventoryStores = slotBasedEditorContext.categoryInventoryStores
	end

	local v19 = useSignalState(sortAndFiltersStore.getSortAndFilters)
	local v20 = useCloseFiltersSignal()
	local v21, v22 = React.useState(v19.sort)
	local u23 = nil
	local u24 = nil

	if FFlagAXInventoryDurablesExpiredFilter then
		local v25, v26 = React.useState(v19.filter)

		u23 = v25
		u24 = v26
	end

	local v27 = if not FFlagAXInventoryDurablesExpiredFilter then v21 ~= v19.sort else v21 ~= v19.sort or v19.filter ~= u23
	local v28 = if not FFlagAXInventoryDurablesExpiredFilter then v21 ~= InventorySorts.Newest else v21 ~= InventorySorts.Newest or u23 ~= InventoryFilters.Active
	local v29 = React.useCallback(function() -- line: 57
		-- upvalues: categoryInventoryStores (ref), sortAndFiltersStore (ref), v21 (copy), FFlagAXInventoryDurablesExpiredFilter (copy), u23 (ref), v20 (copy)
		for _, v32 in categoryInventoryStores do
			v32.startNewSearch()
		end

		sortAndFiltersStore.applySortAndFilters({
			sort = v21,
			filter = if not FFlagAXInventoryDurablesExpiredFilter then nil else u23
		})
		v20:fire()
	end, {
		categoryInventoryStores,
		sortAndFiltersStore.applySortAndFilters,
		v21,
		if not FFlagAXInventoryDurablesExpiredFilter then nil else u23,
		v20
	})
	local v30 = React.useCallback(function() -- line: 79
		-- upvalues: v22 (copy), InventorySorts (copy), FFlagAXInventoryDurablesExpiredFilter (copy), u24 (ref), InventoryFilters (copy)
		v22(InventorySorts.Newest)

		if FFlagAXInventoryDurablesExpiredFilter then
			u24(InventoryFilters.Active)
		end
	end, {})

	return {
		canApply = v27,
		canReset = v28,
		onApply = v29,
		onReset = v30,
		currentSort = v21,
		setCurrentSort = v22,
		currentFilter = if not FFlagAXInventoryDurablesExpiredFilter then nil else u23,
		setCurrentFilter = if not FFlagAXInventoryDurablesExpiredFilter then nil else u24,
		closePeekViewSignal = v20
	}
end

return useInventorySortsAndFiltersProps
