local CorePackages = game:GetService("CorePackages")
local ReactUtils = require(CorePackages.Packages.ReactUtils)

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useInitializedValue = ReactUtils.useInitializedValue
require("@luauforge/bundled/dKT")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local module2 = require("@luauforge/deferred/hkd")
local module3 = require("@luauforge/deferred/hke")
local module4 = require("@luauforge/deferred/hkn")
local module5 = require("@luauforge/deferred/hkk")
local module6 = require("@luauforge/deferred/hko")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module7 = require("@luauforge/bundled/fCm")
local module8 = require("@luauforge/deferred/heH")
local module9 = require("@luauforge/deferred/hjX")

local module10 = require("@luauforge/deferred/hkq")

local fFlagAXFilterAndSortViewExposureLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFilterAndSortViewExposureLogging

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module11 = require("@luauforge/deferred/hkr")
local module12 = require("@luauforge/bundled/eie")
local module13 = require("@luauforge/bundled/fDf")
require("@luauforge/bundled/dXi")
local module14 = require("@luauforge/deferred/fDP")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function getTotalSectionHeight(p2)
	return p2 + 24 + 24
end

local function useSearchParameters()
	local v5 = useAvatarRoute()
	local detail = if v5.opaque.name == avatarScreen.CatalogSearch then v5.opaque.params.detail else nil

	return (useSelector(function(p2)
		if detail then
			return p2.SearchesParameters[detail]
		end

		return nil
	end, getUseSelectorDeepEquals()))
end

local function SortAndFiltersScreen(p2)
	local v5 = module5()
	local v6 = module6()
	local v7 = useNavigation()

	local v8 = RoactGamepad.useRefCache()

	local canApply = v5.canApply or v6.canApply
	local canReset = v5.canReset or v6.canReset

	local v9 = useDispatch()
	local v10 = module12(module13)

	local v11 = module8()

	local v12 = useSearchParameters()

	local function apply()
		v5.apply()
		v6.apply()
		v11:fire()
		v9(module11(v10))

		if v12 then
			v9(module14(v7, v12))
		end
	end

	local function reset()
		v5.reset()
		v6.reset()
	end

	local v13 = useLocalization({
		sorts = "Feature.Catalog.Label.Filter.Sorts",
		filters = "Feature.Catalog.Label.Filter.Filters"
	})

	local v14, v15 = React.useBinding(0)
	local mapped = v14:map(module7.mapHeightToSize)

	local v16, v17 = React.useBinding(0)
	local mapped2 = v16:map(module7.mapHeightToSize)

	local v18 = useInitializedValue(function()
		return React.joinBindings({ v14, v16 }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			local v19 = item + 24 + 24 + (item2 + 24 + 24)

			return UDim2.new(1, 0, 0, v19)
		end)
	end)

	local createElement = React.createElement

	local v21 = if fFlagAXFilterAndSortViewExposureLogging then React.createElement(module10) else nil
	return createElement(module9, {
		canApply = canApply,
		canReset = canReset,
		onApply = apply,
		onReset = reset,
		closePeekViewSignal = v11,
		totalSize = v18,
		shouldCaptureFocus = false
	}, {
		FilterAndSortViewExposureLogger = v21,
		FiltersSection = React.createElement(module2, {
			title = v13.filters,
			Size = v14:map(function(p3)
				return UDim2.new(1, 0, 0, p3 + 24 + 24)
			end),
			contentSize = mapped
		}, {
			Filters = React.createElement(module3, {
				Size = mapped,
				filtersController = v5,
				frameRef = v8.Filters,
				NextSelectionDown = v8.Sorts,
				onHeightChanged = v15
			})
		}),
		SortsSection = React.createElement(module2, {
			title = v13.sorts,
			Size = v16:map(function(p3)
				return UDim2.new(1, 0, 0, p3 + 24 + 24)
			end),
			contentSize = mapped2
		}, {
			Sorts = React.createElement(module4, {
				Size = mapped2,
				sortsController = v6,
				frameRef = v8.Sorts,
				NextSelectionUp = v8.Filters,
				onHeightChanged = v17
			})
		})
	})
end

return SortAndFiltersScreen
