local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fCn")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local inventorySorts = module.Enums.InventorySorts
local inventoryFilters = module.Enums.InventoryFilters
local useAvatarEditorStores = module.Context.useAvatarEditorStores
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module3 = require("@luauforge/deferred/heH")

require("@luauforge/deferred/hkt")
local fFlagAXAvatarEditorStoresContext = AvatarExperienceFlags.FFlagAXAvatarEditorStoresContext
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore

local function useInventorySortsAndFiltersProps(p2)
	local thumbnailLatencyStores = nil
	local sortAndFiltersStore, categoryInventoryStores

	if fFlagAXAvatarEditorStoresContext then
		local v5 = useAvatarEditorStores()
		sortAndFiltersStore = v5.sortAndFiltersStore
		categoryInventoryStores = v5.categoryInventoryStores

		if fFlagAXEditorEnableThumbnailLatencyStore then
			thumbnailLatencyStores = v5.thumbnailLatencyStores
		end
	else
		local slotBasedEditorContext = p2.slotBasedEditorContext
		sortAndFiltersStore = slotBasedEditorContext.sortAndFiltersStore
		categoryInventoryStores = slotBasedEditorContext.categoryInventoryStores

		if fFlagAXEditorEnableThumbnailLatencyStore then
			thumbnailLatencyStores = slotBasedEditorContext.thumbnailLatencyStores
		end
	end

	local v5 = useSignalState(sortAndFiltersStore.getSortAndFilters)
	local v6 = module3()

	local state, setState = React.useState(v5.sort)
	local state2, setState2

	if fFlagAXInventoryDurablesExpiredFilter then
		state2, setState2 = React.useState(v5.filter)
	else
		state2 = nil
		setState2 = nil
	end

	local v7

	if fFlagAXInventoryDurablesExpiredFilter then
		v7 = v5.sort ~= state or v5.filter ~= state2
	else
		v7 = v5.sort ~= state
	end

	local v8

	if fFlagAXInventoryDurablesExpiredFilter then
		v8 = state ~= inventorySorts.Newest or state2 ~= inventoryFilters.Active
	else
		v8 = state ~= inventorySorts.Newest
	end

	local useCallback = React.useCallback
	local function fn()
		for k, categoryInventoryStore in categoryInventoryStores do
			categoryInventoryStore.startNewSearch()

			if not (fFlagAXEditorEnableThumbnailLatencyStore and thumbnailLatencyStores) then
				continue
			end

			local thumbnailLatencyStore = thumbnailLatencyStores[k]

			if thumbnailLatencyStore then
				thumbnailLatencyStore.startTracking()
			end
		end

		sortAndFiltersStore.applySortAndFilters({
			sort = state,
			filter = if fFlagAXInventoryDurablesExpiredFilter then state2 else nil
		})

		v6:fire()
	end

	local applySortAndFilters = sortAndFiltersStore.applySortAndFilters
	local v11 = if fFlagAXInventoryDurablesExpiredFilter then state2 else nil
	return {
		canApply = v7,
		canReset = v8,
		onApply = useCallback(fn, {
			categoryInventoryStores,
			applySortAndFilters,
			state,
			v11,
			v6,
			if fFlagAXEditorEnableThumbnailLatencyStore then thumbnailLatencyStores else nil
		}),
		onReset = React.useCallback(function()
			setState(inventorySorts.Newest)

			if fFlagAXInventoryDurablesExpiredFilter then
				setState2(inventoryFilters.Active)
			end
		end, {}),
		currentSort = state,
		setCurrentSort = setState,
		currentFilter = if fFlagAXInventoryDurablesExpiredFilter then state2 else nil,
		setCurrentFilter = if fFlagAXInventoryDurablesExpiredFilter then setState2 else nil,
		closePeekViewSignal = v6
	}
end

return useInventorySortsAndFiltersProps
