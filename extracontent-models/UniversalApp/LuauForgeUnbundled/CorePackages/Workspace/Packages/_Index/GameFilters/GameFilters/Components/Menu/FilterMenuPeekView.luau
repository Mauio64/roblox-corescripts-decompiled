local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/AppCommonLib")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/PeekView")
local peekView = module2.PeekView
local peekViewState = module2.PeekViewState
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")
local signal = AppCommonLib.Signal

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Navigation").useNavigation
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RobloxAppNavigation").useNavigationProps

local FilterClickButtonName = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/FilterClickButtonName")
local FilterMenuActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/FilterMenuActionBar")
local FilterMenuHeader = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/FilterMenuHeader")
local FilterMenuOptions = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/FilterMenuOptions")
local useTopBarHeightSelector = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/useTopBarHeightSelector")
local getOptionContextTag = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/getOptionContextTag")

local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag

local function FilterMenuPeekView()
	local v5 = useNavigationProps(function(p2, data)
		return {
			filter = data.filter,
			onFilterApplied = data.onFilterApplied,
			onFilterMenuClosed = data.onFilterMenuClosed,
			sendFilterClick = data.sendFilterClick
		}
	end)

	local filter = v5.filter

	local state, setState = React.useState(filter.selectedOptionId)

	local ref = React.useRef(false)

	local v6 = useNavigation()

	local useCallback = React.useCallback
	local function fn(p2, p3)
		if p2 == peekViewState.Closed or p2 == peekViewState.Hidden then
			v6.goBack()
			v5.onFilterMenuClosed()

			if not ref.current then
				local sendFilterClick = v5.sendFilterClick
				local closePeekView = FilterClickButtonName.ClosePeekView
				local selectedOptionId = filter.selectedOptionId
				local v8

				if fFlagLuaAppChartsFilterOptionTextTag then
					v8 = getOptionContextTag(filter, filter.selectedOptionId)
				end

				local v9 = if fFlagLuaAppChartsFilterOptionTextTag then getOptionContextTag(filter, state) else nil
				sendFilterClick(closePeekView, selectedOptionId, state, v8, v9, true)
			end
		end
	end
	local selectedOptionId = if not fFlagLuaAppChartsFilterOptionTextTag then filter.selectedOptionId else nil
	local v9 = useCallback(fn, {
		selectedOptionId,
		state,
		v6,
		v5.onFilterMenuClosed,
		v5.sendFilterClick,
		if fFlagLuaAppChartsFilterOptionTextTag then filter else nil
	})

	local v10 = useTopBarHeightSelector()

	local v11, v12 = React.useBinding(Vector2.new(0, 0))
	local v13, v14 = React.useBinding(0)
	local v15 = nil
	local v16 = nil
	local v17 = nil
	local v18 = nil
	local v19 = nil

	if fFlagLuaAppChartsFilterOptionTextTag then
		local v20
		v17, v20 = React.useBinding(0)
		v18 = v20
		v19 = React.useCallback(function(p2)
			v18(p2.AbsoluteCanvasSize.Y)
		end, {})
	else
		v15, v16 = React.useBinding(Vector2.new(0, 0))
	end

	local v20

	if not fFlagLuaAppChartsFilterOptionTextTag then
		v20 = v11:map(function(p2)
			return p2.X
		end)
	end

	local joinBindings = React.joinBindings

	if fFlagLuaAppChartsFilterOptionTextTag then
		v15 = v17
	end

	local mapped = joinBindings({ v11, v13, v15 }):map(function(list)
		local y = list[1].Y
		local item = list[2]
		local v22 = if fFlagLuaAppChartsFilterOptionTextTag then list[3] else list[3].Y

		local v23 = y - 84 - 25 - v10

		local v24 = math.min(item + v22, v23)

		return UDim2.new(1, 0, 0, v24)
	end)

	local mapped2 = v13:map(function(p2)
		return UDim2.new(1, 0, 1, -p2)
	end)

	local ref2 = React.useRef(nil)

	local v22 = React.useCallback(function(p2)
		local current = ref2.current

		if current then
			local y = p2.AbsoluteSize.Y
			current.AutomaticSize = Enum.AutomaticSize.None
			current.Size = UDim2.new(1, 0, 0, y)
		end
	end, {})

	local ref3 = React.useRef(signal.new())

	local v23 = React.useCallback(function()
		ref3.current:fire()
	end, {})

	local v24 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local v25 = state ~= filter.selectedOptionId

	local useCallback2 = React.useCallback
	local function fn2()
		v5.onFilterApplied(filter.filterType, state)
		ref.current = true
		v23()
		local sendFilterClick2 = v5.sendFilterClick
		local apply = FilterClickButtonName.Apply

		local selectedOptionId2 = filter.selectedOptionId
		local v27 = if fFlagLuaAppChartsFilterOptionTextTag then getOptionContextTag(filter, state) else nil
		local v28 = if fFlagLuaAppChartsFilterOptionTextTag then getOptionContextTag(filter, filter.selectedOptionId) else nil
		sendFilterClick2(apply, state, selectedOptionId2, v27, v28, true)
	end
	local filterType = if not fFlagLuaAppChartsFilterOptionTextTag then filter.filterType else nil
	local selectedOptionId2 = if not fFlagLuaAppChartsFilterOptionTextTag then filter.selectedOptionId else nil
	local v28 = useCallback2(fn2, {
		filterType,
		selectedOptionId2,
		state,
		v5.onFilterApplied,
		v23,
		v5.sendFilterClick,
		if fFlagLuaAppChartsFilterOptionTextTag then filter else nil
	})

	local createElement = React.createElement
	local v30 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = function(p2)
			v12(p2.AbsoluteSize)
		end
	}

	local createElement2 = React.createElement
	local v33 = {
		briefViewContentHeight = UDim.new(0, 0),
		contentFrameRef = ref2,
		closeSignal = ref3.current,
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		viewStateChanged = v9,
		bottomDockedContainerHeight = 84,
		bottomDockedContainerContent = React.createElement(FilterMenuActionBar, {
			Size = UDim2.new(1, 0, 0, 84),
			applyEnabled = v25,
			onApply = v28
		})
	}

	local createElement3 = React.createElement
	local v36 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = mapped,
		[React.Change.AbsoluteSize] = v22
	}
	local v37 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = React.createElement(FilterMenuHeader, {
			LayoutOrder = 1,
			title = filter.filterDisplayName,
			onCloseButtonActivated = v23,
			onHeightChanged = v14
		}),
		Options = 0
	}

	local createElement4 = React.createElement

	if fFlagLuaAppChartsFilterOptionTextTag then
		v20 = nil
	end

	local v39 = {
		LayoutOrder = 2,
		Size = mapped2,
		containerMaxWidthBinding = v20,
		options = filter.filterOptions,
		selectedOptionId = state,
		onSelectedOptionChanged = v24,
		onCanvasSizeChanged = 0
	}

	if fFlagLuaAppChartsFilterOptionTextTag then
		v16 = v19
	end

	v39.onCanvasSizeChanged = v16
	v37.Options = createElement4(FilterMenuOptions, v39)
	return createElement("Frame", v30, {
		PeekView = createElement2(peekView, v33, {
			Content = createElement3("Frame", v36, v37)
		})
	})
end

return FilterMenuPeekView
