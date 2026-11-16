local GameFilters = script:FindFirstAncestor("GameFilters")

local parent = GameFilters.Parent
local AppCommonLib = require(parent.AppCommonLib)
require(parent.DiscoveryTypes)
local PeekView = require(parent.PeekView)
local peekView = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState
local React = require(parent.React)
local Signal = AppCommonLib.Signal

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps

local FilterClickButtonName = require(GameFilters.Analytics.FilterClickButtonName)
local FilterMenuActionBar = require(GameFilters.Components.Menu.FilterMenuActionBar)
local FilterMenuHeader = require(GameFilters.Components.Menu.FilterMenuHeader)
local FilterMenuOptions = require(GameFilters.Components.Menu.FilterMenuOptions)
local useTopBarHeightSelector = require(GameFilters.Components.Menu.useTopBarHeightSelector)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag

local function FilterMenuPeekView()
	local v = useNavigationProps(function(_, data)
		return {
			filter = data.filter,
			onFilterApplied = data.onFilterApplied,
			onFilterMenuClosed = data.onFilterMenuClosed,
			sendFilterClick = data.sendFilterClick
		}
	end)

	local filter = v.filter

	local state, setState = React.useState(filter.selectedOptionId)

	local ref = React.useRef(false)

	local v2 = useNavigation()

	local useCallback = React.useCallback
	local function fn(p, _)
		if p == PeekViewState.Closed or p == PeekViewState.Hidden then
			v2.goBack()
			v.onFilterMenuClosed()

			if not ref.current then
				local sendFilterClick = v.sendFilterClick
				local closePeekView = FilterClickButtonName.ClosePeekView
				local selectedOptionId = filter.selectedOptionId
				local v3

				if FFlagLuaAppChartsFilterOptionTextTag then
					v3 = getOptionContextTag(filter, filter.selectedOptionId)
				end

				local v4

				if FFlagLuaAppChartsFilterOptionTextTag then
					v4 = getOptionContextTag(filter, state)
				end

				sendFilterClick(closePeekView, selectedOptionId, state, v3, v4, true)
			end
		end
	end

	local selectedOptionId

	if not FFlagLuaAppChartsFilterOptionTextTag then
		selectedOptionId = filter.selectedOptionId
	end

	local onFilterMenuClosed = v.onFilterMenuClosed
	local sendFilterClick = v.sendFilterClick
	local v3

	if FFlagLuaAppChartsFilterOptionTextTag then
		v3 = filter
	end

	local viewStateChanged = useCallback(fn, {
		selectedOptionId,
		state,
		v2,
		onFilterMenuClosed,
		sendFilterClick,
		v3
	})

	local v4 = useTopBarHeightSelector()

	local v5, v6 = React.useBinding(Vector2.new(0, 0))
	local v7, onHeightChanged = React.useBinding(0)
	local v8 = nil
	local onCanvasSizeChanged = nil
	local v9 = nil
	local v10 = nil
	local v11 = nil

	if FFlagLuaAppChartsFilterOptionTextTag then
		local v12
		v9, v12 = React.useBinding(0)
		v10 = v12
		v11 = React.useCallback(function(p)
			v10(p.AbsoluteCanvasSize.Y)
		end, {})
	else
		v8, onCanvasSizeChanged = React.useBinding(Vector2.new(0, 0))
	end

	local containerMaxWidthBinding

	if not FFlagLuaAppChartsFilterOptionTextTag then
		containerMaxWidthBinding = v5:map(function(vector2: Vector2)
			return vector2.X
		end)
	end

	local joinBindings = React.joinBindings

	if FFlagLuaAppChartsFilterOptionTextTag then
		v8 = v9
	end

	local mapped = joinBindings({ v5, v7, v8 }):map(function(list)
		local y = list[1].Y
		local item = list[2]
		local v12

		if FFlagLuaAppChartsFilterOptionTextTag then
			v12 = list[3]
		else
			v12 = list[3].Y
		end

		local v13 = y - 84 - 25 - v4

		local v14 = math.min(item + v12, v13)

		return UDim2.new(1, 0, 0, v14)
	end)

	local mapped2 = v7:map(function(p: number)
		return UDim2.new(1, 0, 1, -p)
	end)

	local ref2 = React.useRef(nil)

	local v12 = React.useCallback(function(p)
		local current = ref2.current

		if current then
			local y = p.AbsoluteSize.Y
			current.AutomaticSize = Enum.AutomaticSize.None
			current.Size = UDim2.new(1, 0, 0, y)
		end
	end, {})

	local ref3 = React.useRef(Signal.new())

	local onCloseButtonActivated = React.useCallback(function()
		ref3.current:fire()
	end, {})

	local onSelectedOptionChanged = React.useCallback(function(p: string)
		setState(p)
	end, {})

	local applyEnabled = state ~= filter.selectedOptionId

	local useCallback2 = React.useCallback
	local function fn2()
		v.onFilterApplied(filter.filterType, state)
		ref.current = true
		onCloseButtonActivated()
		local sendFilterClick2 = v.sendFilterClick
		local apply = FilterClickButtonName.Apply

		local selectedOptionId2 = filter.selectedOptionId
		local v13

		if FFlagLuaAppChartsFilterOptionTextTag then
			v13 = getOptionContextTag(filter, state)
		end

		local v14

		if FFlagLuaAppChartsFilterOptionTextTag then
			v14 = getOptionContextTag(filter, filter.selectedOptionId)
		end

		sendFilterClick2(apply, state, selectedOptionId2, v13, v14, true)
	end

	local filterType

	if not FFlagLuaAppChartsFilterOptionTextTag then
		filterType = filter.filterType
	end

	local selectedOptionId2

	if not FFlagLuaAppChartsFilterOptionTextTag then
		selectedOptionId2 = filter.selectedOptionId
	end

	local onFilterApplied = v.onFilterApplied

	local sendFilterClick2 = v.sendFilterClick
	local v13

	if FFlagLuaAppChartsFilterOptionTextTag then
		v13 = filter
	end

	local onApply = useCallback2(fn2, {
		filterType,
		selectedOptionId2,
		state,
		onFilterApplied,
		onCloseButtonActivated,
		sendFilterClick2,
		v13
	})

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = function(p)
			v6(p.AbsoluteSize)
		end
	}

	local createElement2 = React.createElement
	local v15 = {
		briefViewContentHeight = UDim.new(0, 0),
		contentFrameRef = ref2,
		closeSignal = ref3.current,
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		viewStateChanged = viewStateChanged,
		bottomDockedContainerHeight = 84,
		bottomDockedContainerContent = React.createElement(FilterMenuActionBar, {
			Size = UDim2.new(1, 0, 0, 84),
			applyEnabled = applyEnabled,
			onApply = onApply
		})
	}

	local createElement3 = React.createElement
	local v16 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = mapped,
		[React.Change.AbsoluteSize] = v12
	}
	local v17 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = React.createElement(FilterMenuHeader, {
			LayoutOrder = 1,
			title = filter.filterDisplayName,
			onCloseButtonActivated = onCloseButtonActivated,
			onHeightChanged = onHeightChanged
		}),
		Options = 0
	}

	local createElement4 = React.createElement

	if FFlagLuaAppChartsFilterOptionTextTag then
		containerMaxWidthBinding = nil
	end

	local v18 = {
		LayoutOrder = 2,
		Size = mapped2,
		containerMaxWidthBinding = containerMaxWidthBinding,
		options = filter.filterOptions,
		selectedOptionId = state,
		onSelectedOptionChanged = onSelectedOptionChanged,
		onCanvasSizeChanged = 0
	}

	if FFlagLuaAppChartsFilterOptionTextTag then
		onCanvasSizeChanged = v11
	end

	v18.onCanvasSizeChanged = onCanvasSizeChanged
	v17.Options = createElement4(FilterMenuOptions, v18)
	return createElement("Frame", v14, {
		PeekView = createElement2(peekView, v15, {
			Content = createElement3("Frame", v16, v17)
		})
	})
end

return FilterMenuPeekView
