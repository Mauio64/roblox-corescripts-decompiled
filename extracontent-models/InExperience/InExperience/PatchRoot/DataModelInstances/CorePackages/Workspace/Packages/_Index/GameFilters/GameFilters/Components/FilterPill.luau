local GameFilters = script:FindFirstAncestor("GameFilters")
local GameFiltersParent = GameFilters.Parent

require(GameFiltersParent.DiscoveryTypes)

local Foundation = require(GameFiltersParent.Foundation)
local IconPosition = Foundation.Enums.IconPosition
local ImpressionsTagUtility = require(GameFiltersParent.Impressions).ImpressionsTagUtility
local CentralOverlayType = require(GameFiltersParent.RobloxAppEnums).CentralOverlayType
local Chip = Foundation.Chip
local React = require(GameFiltersParent.React)
local SetCentralOverlay = require(GameFiltersParent.CentralOverlay).Actions.SetCentralOverlay
local useDispatch = require(GameFiltersParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local FilterClickButtonName = require(GameFilters.Analytics.FilterClickButtonName)

require(GameFilters.Components.Menu.FilterMenuDropdown)

local OpenFilterMenuPeekView = require(GameFilters.OpenFilterMenuPeekView)
local shouldUsePeekView = require(GameFilters.Components.Menu.shouldUsePeekView)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)
local FFlagLuaAppChartsFilterOptionTextTag = require(GameFiltersParent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local FFlagLuaAppChartsActiveFilterChips = require(GameFiltersParent.SharedFlags).FFlagLuaAppChartsActiveFilterChips

require(GameFilters.FilterCallbackTypes)

return React.memo(function(t1: {[any]: any}) -- line: 41
	-- upvalues: FFlagLuaAppChartsActiveFilterChips (copy), React (copy), useDispatch (copy), useTokens (copy), ImpressionsTagUtility (copy), shouldUsePeekView (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), OpenFilterMenuPeekView (copy), FilterClickButtonName (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Chip (copy), IconPosition (copy)
	local v19 = nil
	local u20 = nil

	if not FFlagLuaAppChartsActiveFilterChips then
		local v21

		v19, v21 = React.useState(false)
		u20 = v21
	end

	local v22 = nil
	local u23 = nil

	if FFlagLuaAppChartsActiveFilterChips then
		local v24

		v22, v24 = React.useState(false)
		u23 = v24
	end

	local v25 = React.useRef(nil)
	local v26 = useDispatch()
	local v27 = useTokens()
	local v28 = if not FFlagLuaAppChartsActiveFilterChips then nil else React.useMemo(function() -- line: 57
		-- upvalues: t1 (copy)
		if t1.filter.inactiveOptionIds == nil or t1.filter.selectedOptionId == nil then
			return false
		end

		return not t1.filter.inactiveOptionIds[t1.filter.selectedOptionId]
	end, {
		t1.filter.selectedOptionId,
		t1.filter.inactiveOptionIds
	})
	local v29 = if not FFlagLuaAppChartsActiveFilterChips then nil else v28 or v22

	React.useEffect(function() -- line: 68
		-- upvalues: v25 (copy), t1 (copy)
		local connection = nil

		if v25.current then
			connection = v25.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 72
				-- upvalues: t1 (copy), v25 (copy)
				t1.onAbsoluteSizeChanged(v25.current)
			end)
		end

		return function() -- line: 77
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { t1.onAbsoluteSizeChanged })
	React.useEffect(function() -- line: 84
		-- upvalues: ImpressionsTagUtility (copy), v25 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v25, t1.impressionsTag, t1.index)

		return function() -- line: 87
			-- upvalues: ImpressionsTagUtility (copy), v25 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v25, t1.impressionsTag, t1.index)
		end
	end, {
		t1.impressionsTag,
		t1.index
	})

	local v30 = React.useCallback(function(s1: string, s2: string, s3: string?, s4: string?, s5: string?, b1: boolean?) -- line: 100
		-- upvalues: t1 (copy)
		t1.sendFilterClick(s1, t1.filter.filterId, s2, s3, s4, s5, b1)
	end, {
		t1.sendFilterClick,
		t1.filter.filterId
	})
	local v31 = shouldUsePeekView()
	local v32 = React.useCallback(function() -- line: 122
		-- upvalues: FFlagLuaAppChartsActiveFilterChips (copy), u23 (ref), u20 (ref)
		if FFlagLuaAppChartsActiveFilterChips then
			u23(false)

			return
		end

		u20(false)
	end, {})
	local v33 = React.useCallback(function() -- line: 130
		-- upvalues: FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), t1 (copy), v31 (copy), v26 (copy), OpenFilterMenuPeekView (copy), v32 (copy), v30 (copy), FilterClickButtonName (copy), FFlagLuaAppChartsActiveFilterChips (copy), v29 (copy), v25 (copy), v27 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), u23 (ref), u20 (ref)
		local v41 = if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(t1.filter, t1.filter.selectedOptionId)

		if v31 then
			v26(OpenFilterMenuPeekView(t1.filter, t1.onFilterApplied, v32, v30))
			v30(FilterClickButtonName.OpenPeekView, t1.filter.selectedOptionId, nil, if not FFlagLuaAppChartsFilterOptionTextTag then nil else v41, nil, if not FFlagLuaAppChartsActiveFilterChips then nil else v29)
		else
			local t2 = {
				openPosition = if not v25.current then nil else Vector2.new(v25.current.AbsolutePosition.X, v25.current.AbsolutePosition.Y + v25.current.AbsoluteSize.Y + v27.Gap.Small),
				filter = t1.filter,
				onFilterApplied = t1.onFilterApplied,
				onFilterMenuClosed = v32,
				sendFilterClick = v30
			}

			v26(SetCentralOverlay(CentralOverlayType.GameFilterMenuDropdown, t2))
			v30(FilterClickButtonName.OpenDropdown, t1.filter.selectedOptionId, nil, if not FFlagLuaAppChartsFilterOptionTextTag then nil else v41, nil, if not FFlagLuaAppChartsActiveFilterChips then nil else v29)
		end

		if FFlagLuaAppChartsActiveFilterChips then
			u23(true)

			return
		end

		u20(true)
	end, {
		t1.filter,
		t1.onFilterApplied,
		v32,
		v30,
		v31,
		if not FFlagLuaAppChartsActiveFilterChips then nil else v29
	})

	return React.createElement(Chip, {
		icon = {
			name = "icons/actions/truncationExpand_small",
			position = IconPosition.Right
		},
		text = t1.filter.selectedOptionDisplayName,
		isChecked = if not FFlagLuaAppChartsActiveFilterChips then v19 else v29,
		onActivated = v33,
		ref = v25
	})
end)
