local GameFilters = script:FindFirstAncestor("GameFilters")
local GameFiltersParent = GameFilters.Parent
local AppCommonLib = require(GameFiltersParent.AppCommonLib)

require(GameFiltersParent.DiscoveryTypes)

local PeekView = require(GameFiltersParent.PeekView)
local PeekView2 = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState
local React = require(GameFiltersParent.React)
local Signal = AppCommonLib.Signal
local useNavigation = require(GameFiltersParent.Navigation).useNavigation
local useNavigationProps = require(GameFiltersParent.RobloxAppNavigation).useNavigationProps
local FilterClickButtonName = require(GameFilters.Analytics.FilterClickButtonName)
local FilterMenuActionBar = require(GameFilters.Components.Menu.FilterMenuActionBar)
local FilterMenuHeader = require(GameFilters.Components.Menu.FilterMenuHeader)
local FilterMenuOptions = require(GameFilters.Components.Menu.FilterMenuOptions)
local useTopBarHeightSelector = require(GameFilters.Components.Menu.useTopBarHeightSelector)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)
local FFlagLuaAppChartsFilterOptionTextTag = require(GameFiltersParent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local FFlagLuaAppChartsActiveFilterChips = require(GameFiltersParent.SharedFlags).FFlagLuaAppChartsActiveFilterChips

local function FilterMenuPeekView() -- line: 35
	-- upvalues: useNavigationProps (copy), React (copy), useNavigation (copy), PeekViewState (copy), FilterClickButtonName (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy), useTopBarHeightSelector (copy), Signal (copy), PeekView2 (copy), FilterMenuActionBar (copy), FilterMenuHeader (copy), FilterMenuOptions (copy)
	local v20 = useNavigationProps(function(_, p2) -- line: 36
		return {
			filter = p2.filter,
			onFilterApplied = p2.onFilterApplied,
			onFilterMenuClosed = p2.onFilterMenuClosed,
			sendFilterClick = p2.sendFilterClick
		}
	end)
	local filter = v20.filter
	local v22, v23 = React.useState(filter.selectedOptionId)
	local v24 = React.useRef(false)
	local v25 = useNavigation()
	local v26 = React.useCallback(function(p3, _) -- line: 54
		-- upvalues: PeekViewState (copy), v25 (copy), v20 (copy), v24 (copy), FilterClickButtonName (copy), filter (copy), v22 (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy)
		if p3 == PeekViewState.Closed or p3 == PeekViewState.Hidden then
			v25.goBack()
			v20.onFilterMenuClosed()

			if not v24.current then
				v20.sendFilterClick(FilterClickButtonName.ClosePeekView, filter.selectedOptionId, v22, if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(filter, filter.selectedOptionId), if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(filter, v22), not not FFlagLuaAppChartsActiveFilterChips or nil)
			end
		end
	end, {
		if not FFlagLuaAppChartsFilterOptionTextTag then filter.selectedOptionId else nil,
		v22,
		v25,
		v20.onFilterMenuClosed,
		v20.sendFilterClick,
		if not FFlagLuaAppChartsFilterOptionTextTag then nil else filter
	})
	local v27 = useTopBarHeightSelector()
	local v28, v29 = React.useBinding(Vector2.new(0, 0))
	local v30, v31 = React.useBinding(0)
	local v32 = nil
	local v33 = nil
	local v34 = nil
	local u35 = nil
	local v36 = nil

	if FFlagLuaAppChartsFilterOptionTextTag then
		local v37

		v34, v37 = React.useBinding(0)
		u35 = v37
		v36 = React.useCallback(function(p5) -- line: 92
			-- upvalues: u35 (ref)
			u35(p5.AbsoluteCanvasSize.Y)
		end, {})
	else
		v32, v33 = React.useBinding(Vector2.new(0, 0))
	end

	local v38 = if not FFlagLuaAppChartsFilterOptionTextTag then v28:map(function(vector2: Vector2) -- line: 101
		return vector2.X
	end) else nil
	local v39 = React.joinBindings({
		v28,
		v30,
		if not FFlagLuaAppChartsFilterOptionTextTag then v32 else v34
	}):map(function(t1: {[any]: any}) -- line: 109
		-- upvalues: FFlagLuaAppChartsFilterOptionTextTag (copy), v27 (copy)
		local Y = t1[1].Y
		local v56 = t1[2]
		local v57 = if not FFlagLuaAppChartsFilterOptionTextTag then t1[3].Y else t1[3]
		local v58 = Y - 84 - 25 - v27
		local v59 = math.min(v56 + v57, v58)

		return UDim2.new(1, 0, 0, v59)
	end)
	local v40 = v30:map(function(n1: number) -- line: 121
		return UDim2.new(1, 0, 1, -n1)
	end)
	local v41 = React.useRef(nil)
	local v42 = React.useCallback(function(p6) -- line: 127
		-- upvalues: v41 (copy)
		local current = v41.current

		if current then
			local AbsoluteSizeY = p6.AbsoluteSize.Y

			current.AutomaticSize = Enum.AutomaticSize.None
			current.Size = UDim2.new(1, 0, 0, AbsoluteSizeY)
		end
	end, {})
	local v43 = React.useRef(Signal.new())
	local v44 = React.useCallback(function() -- line: 140
		-- upvalues: v43 (copy)
		v43.current:fire()
	end, {})
	local v45 = React.useCallback(function(s1: string) -- line: 145
		-- upvalues: v23 (copy)
		v23(s1)
	end, {})
	local v46 = v22 ~= filter.selectedOptionId
	local v47 = React.useCallback(function() -- line: 152
		-- upvalues: v20 (copy), filter (copy), v22 (copy), v24 (copy), v44 (copy), FilterClickButtonName (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy)
		v20.onFilterApplied(filter.filterType, v22)
		v24.current = true
		v44()
		v20.sendFilterClick(FilterClickButtonName.Apply, v22, filter.selectedOptionId, if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(filter, v22), if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(filter, filter.selectedOptionId), not not FFlagLuaAppChartsActiveFilterChips or nil)
	end, {
		if not FFlagLuaAppChartsFilterOptionTextTag then filter.filterType else nil,
		if not FFlagLuaAppChartsFilterOptionTextTag then filter.selectedOptionId else nil,
		v22,
		v20.onFilterApplied,
		v44,
		v20.sendFilterClick,
		if not FFlagLuaAppChartsFilterOptionTextTag then nil else filter
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = function(p7) -- line: 179
			-- upvalues: v29 (copy)
			v29(p7.AbsoluteSize)
		end
	}, {
		PeekView = React.createElement(PeekView2, {
			hasScrim = true,
			mountAsFullView = true,
			returnToFullView = true,
			showDraggerInClosedState = false,
			thumbstickScrollEnabled = true,
			bottomDockedContainerHeight = 84,
			briefViewContentHeight = UDim.new(0, 0),
			contentFrameRef = v41,
			closeSignal = v43.current,
			viewStateChanged = v26,
			bottomDockedContainerContent = React.createElement(FilterMenuActionBar, {
				Size = UDim2.new(1, 0, 0, 84),
				applyEnabled = v46,
				onApply = v47
			})
		}, {
			Content = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = v39,
				[React.Change.AbsoluteSize] = v42
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Header = React.createElement(FilterMenuHeader, {
					LayoutOrder = 1,
					title = filter.filterDisplayName,
					onCloseButtonActivated = v44,
					onHeightChanged = v31
				}),
				Options = React.createElement(FilterMenuOptions, {
					LayoutOrder = 2,
					Size = v40,
					containerMaxWidthBinding = if not FFlagLuaAppChartsFilterOptionTextTag then v38 else nil,
					options = filter.filterOptions,
					selectedOptionId = v22,
					onSelectedOptionChanged = v45,
					onCanvasSizeChanged = if not FFlagLuaAppChartsFilterOptionTextTag then v33 else v36
				})
			})
		})
	})
end

return FilterMenuPeekView
