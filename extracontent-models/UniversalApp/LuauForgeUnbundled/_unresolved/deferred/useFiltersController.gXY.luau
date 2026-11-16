local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/gXW")
local module2 = require("@luauforge/deferred/gXX")
local module3 = require("@luauforge/bundled/dMp")
local module4 = require("@luauforge/bundled/dMo")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module5 = require("@luauforge/bundled/dME")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module6 = require("@luauforge/bundled/dSC")
local module7 = require("@luauforge/bundled/dSE")
local module8 = require("@luauforge/bundled/dSA")
local module9 = require("@luauforge/bundled/dSG")
local module10 = require("@luauforge/bundled/dSL")
local module11 = require("@luauforge/bundled/fuL")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local wearTimeFilter = AvatarExperienceCommon.Enums.WearTimeFilter
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagMinMaxPriceValidation = AvatarExperienceFlags.FFlagMinMaxPriceValidation
local fFlagAXCatalogSpecialFeaturesFilter = AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter
local setSpecialFeaturesFilter

if fFlagAXCatalogSpecialFeaturesFilter then
	setSpecialFeaturesFilter = require("@luauforge/bundled/dHL").Actions.SetSpecialFeaturesFilter
else
	setSpecialFeaturesFilter = nil
end

local function getPriceSelection(p2, p3)
	if module5.MinPriceFilter < p2 or p3 < module5.MaxPriceFilter then
		return module2.PriceRange
	end

	return module2.AnyPrice
end

local function getCreatorSelection(p2)
	if p2 == nil or p2 == "" then
		return module.AllCreators
	end

	return module.Username
end

local function wearTimeFilterChanged(p2, p3): boolean
	return p2 ~= p3
end

local function useFiltersController()
	local v5 = useSelector(module11.selectSalesTypeFilter, getUseSelectorDeepEquals())
	local state, setState = React.useState(v5)

	local v6 = useSelector(module11.selectCreatorFilter, getUseSelectorDeepEquals())
	local v7 = if v6 == nil or v6 == "" then module.AllCreators else module.Username

	local state2, setState2 = React.useState(v7)
	local state3, setState3 = React.useState(v6)

	local v8 = useSelector(module11.selectMinPrice, getUseSelectorDeepEquals())
	local v9 = useSelector(module11.selectMaxPrice, getUseSelectorDeepEquals())
	local v10

	if module5.MinPriceFilter < v8 or v9 < module5.MaxPriceFilter then
		v10 = module2.PriceRange
	else
		v10 = module2.AnyPrice
	end

	local state4, setState4 = React.useState(v10)
	local state5, setState5 = React.useState(v8)
	local state6, setState6 = React.useState(v9)

	local v11 = useSelector(module11.selectUnavailableItemFilter, getUseSelectorDeepEquals())

	local state7, setState7 = React.useState(v11)

	local v12 = useSelector(module11.selectWearTimeFilter, getUseSelectorDeepEquals())
	local state8, setState8 = React.useState(v12)
	local v13, state9, v14, v15

	if fFlagAXCatalogSpecialFeaturesFilter then
		v13 = useSelector(module11.selectSpecialFeaturesFilter, getUseSelectorDeepEquals()) or {}
		local setState9
		state9, setState9 = React.useState(v13)
		v14 = setState9
		v15 = React.useCallback(function(p2)
			v14(function(p3)
				local clone = table.clone(p3)
				local index = table.find(clone, p2)

				if index then
					table.remove(clone, index)
				else
					table.insert(clone, p2)
				end

				table.sort(clone)
				return clone
			end)
		end, {})
	else
		state9 = nil
		v14 = nil
	end

	local v16 = useDispatch()

	local v17 = state ~= module3.All
		or state2 ~= module.AllCreators
		or state4 ~= module2.AnyPrice
		or state7 ~= module4.Hide
		or state8 ~= wearTimeFilter.All

	local v18 = state2 == module.AllCreators and "" or state3
	local v19 = if state4 == module2.AnyPrice then module5.MinPriceFilter else state5
	local v20 = if state4 == module2.AnyPrice then module5.MaxPriceFilter else state6
	local v21 = state ~= v5
		or v18 ~= v6
		or v19 ~= v8
		or v20 ~= v9
		or state7 ~= v11
		or wearTimeFilterChanged and state8 ~= v12

	if fFlagAXCatalogSpecialFeaturesFilter then
		local v22 = state9 or {}
		v17 = #v22 > 0 or v17

		if table.concat(v22, ",") ~= table.concat(v13 or {}, ",") then
			v21 = true
		end
	end

	if fFlagMinMaxPriceValidation and v20 < v19 then
		v21 = false
	end

	local function fn()
		v16(module6(state))
		v16(module7(v18))
		v16(module8(v19, v20))
		v16(module9(state7))
		v16(module10(state8))

		if fFlagAXCatalogSpecialFeaturesFilter and setSpecialFeaturesFilter and state9 then
			v16(setSpecialFeaturesFilter(state9))
		end
	end

	return {
		salesTypeFilter = state,
		setSalesTypeFilter = setState,
		creatorFilter = state2,
		setCreatorFilter = setState2,
		creatorUsername = state3,
		setCreatorUsername = setState3,
		priceFilter = state4,
		setPriceFilter = setState4,
		minPrice = state5,
		setMinPrice = setState5,
		maxPrice = state6,
		setMaxPrice = setState6,
		wearTimeFilter = state8,
		setWearTimeFilter = setState8,
		specialFeaturesFilter = state9,
		toggleSpecialFeature = v15,
		unavailableItemFilter = state7,
		setUnavailableItemFilter = setState7,
		canReset = v17,
		canApply = v21,
		reset = React.useCallback(function()
			setState(module3.All)
			setState2(module.AllCreators)
			setState4(module2.AnyPrice)
			setState7(module4.Hide)
			setState8(wearTimeFilter.All)

			if fFlagAXCatalogSpecialFeaturesFilter and v14 then
				v14({})
			end
		end, {}),
		apply = React.useCallback(fn, {
			state,
			v18,
			v19,
			v20,
			state7,
			state8,
			if fFlagAXCatalogSpecialFeaturesFilter then state9 else nil
		})
	}
end

return useFiltersController
