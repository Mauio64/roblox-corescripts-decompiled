local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useInitializedValue = ReactUtils.useInitializedValue

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local FilterSection = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterSection)
local Filters = require(Modules.AvatarExperience.Catalog.Components.Filters.Filters)
local Sorts = require(Modules.AvatarExperience.Catalog.Components.Filters.Sorts)
local useFiltersController = require(Modules.AvatarExperience.Catalog.Hooks.useFiltersController)
local useSortsController = require(Modules.AvatarExperience.Catalog.Hooks.useSortsController)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local useCloseFiltersSignal = require(Modules.AvatarExperience.Catalog.Hooks.useCloseFiltersSignal)
local FormPeekview = require(Modules.AvatarExperience.Common.Components.FormPeekview)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local SendApplySortAndFiltersAnalytics = require(Modules.AvatarExperience.Catalog.Thunks.SendApplySortAndFiltersAnalytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)

require(Modules.AvatarExperience.Catalog.SearchTypes)

local NavigateToSearch = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToSearch)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function getTotalSectionHeight(n1: number) -- line: 47
	return n1 + 24 + 24
end
local function useSearchParameters() -- line: 51
	-- upvalues: useAvatarRoute (copy), AvatarScreen (copy), useSelector (copy), getUseSelectorDeepEquals (copy)
	local v33 = useAvatarRoute()
	local v34 = if v33.opaque.name ~= AvatarScreen.CatalogSearch then nil else v33.opaque.params.detail

	return (useSelector(function(p1) -- line: 56
		-- upvalues: v34 (copy)
		if v34 then
			return p1.SearchesParameters[v34]
		end

		return nil
	end, getUseSelectorDeepEquals()))
end
local function SortAndFiltersScreen(_: {[any]: any}) -- line: 65
	-- upvalues: useFiltersController (copy), useSortsController (copy), useNavigation (copy), RoactGamepad (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), useCloseFiltersSignal (copy), useSearchParameters (copy), SendApplySortAndFiltersAnalytics (copy), NavigateToSearch (copy), useLocalization (copy), React (copy), FilterUtils (copy), useInitializedValue (copy), FormPeekview (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FilterSection (copy), Filters (copy), Sorts (copy)
	local v36 = useFiltersController()
	local v37 = useSortsController()
	local v38 = useNavigation()
	local v39 = RoactGamepad.useRefCache()
	local v40 = v36.canApply or v37.canApply
	local v41 = v36.canReset or v37.canReset
	local v42 = useDispatch()
	local v43 = useRoactService(Analytics)
	local v44 = useCloseFiltersSignal()
	local v45 = useSearchParameters()

	local function apply() -- line: 82
		-- upvalues: v36 (copy), v37 (copy), v44 (copy), v42 (copy), SendApplySortAndFiltersAnalytics (copy), v43 (copy), v45 (copy), NavigateToSearch (copy), v38 (copy)
		v36.apply()
		v37.apply()
		v44:fire()
		v42(SendApplySortAndFiltersAnalytics(v43))

		if v45 then
			v42(NavigateToSearch(v38, v45))
		end
	end
	local function reset() -- line: 93
		-- upvalues: v36 (copy), v37 (copy)
		v36.reset()
		v37.reset()
	end

	local v48 = useLocalization({
		sorts = "Feature.Catalog.Label.Filter.Sorts",
		filters = "Feature.Catalog.Label.Filter.Filters"
	})
	local v49, v50 = React.useBinding(0)
	local v51 = v49:map(FilterUtils.mapHeightToSize)
	local v52, v53 = React.useBinding(0)
	local v54 = v52:map(FilterUtils.mapHeightToSize)
	local v55 = useInitializedValue(function() -- line: 109
		-- upvalues: React (copy), v49 (copy), v52 (copy)
		return React.joinBindings({
			v49,
			v52
		}):map(function(t2: {[any]: any}) -- line: 113
			local v60 = t2[1]
			local v61 = t2[2]
			local v62 = v60 + 24 + 24 + (v61 + 24 + 24)

			return UDim2.new(1, 0, 0, v62)
		end)
	end)

	return React.createElement(FormPeekview, {
		canApply = v40,
		canReset = v41,
		onApply = apply,
		onReset = reset,
		closePeekViewSignal = v44,
		totalSize = v55,
		shouldCaptureFocus = not FFlagAXMigrateAXToGlobalAutofocus and nil
	}, {
		FiltersSection = React.createElement(FilterSection, {
			title = v48.filters,
			Size = v49:map(function(n2: number) -- line: 132
				return UDim2.new(1, 0, 0, n2 + 24 + 24)
			end),
			contentSize = v51
		}, {
			Filters = React.createElement(Filters, {
				Size = v51,
				filtersController = v36,
				frameRef = v39.Filters,
				NextSelectionDown = v39.Sorts,
				onHeightChanged = v50
			})
		}),
		SortsSection = React.createElement(FilterSection, {
			title = v48.sorts,
			Size = v52:map(function(n3: number) -- line: 147
				return UDim2.new(1, 0, 0, n3 + 24 + 24)
			end),
			contentSize = v54
		}, {
			Sorts = React.createElement(Sorts, {
				Size = v54,
				sortsController = v37,
				frameRef = v39.Sorts,
				NextSelectionUp = v39.Filters,
				onHeightChanged = v53
			})
		})
	})
end

return SortAndFiltersScreen
