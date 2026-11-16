require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RoactUtils").Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens

local FilterClickButtonName = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/FilterClickButtonName")
local FilterMenuActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/FilterMenuActionBar")
local FilterMenuHeader = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/FilterMenuHeader")
local FilterMenuOptions = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/FilterMenuOptions")
local getOptionContextTag = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/getOptionContextTag")

local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag
local v5 = not fFlagLuaAppChartsFilterOptionTextTag and 10000 or nil

local function applyTokenScaling(p2, p3)
	return p2 * p3.Config.UI.Scale
end

local function FilterMenuDropdown(props)
	local v6 = useTokens()
	local v7 = useDispatch()
	local v8 = 260 * v6.Config.UI.Scale
	local v9 = 84 * v6.Config.UI.Scale

	local state, setState = React.useState(props.filter.selectedOptionId)

	local scrim = v6.Color.Common.Scrim
	local surface_100 = v6.Color.Surface.Surface_100
	local border = v6.Color.ActionStandard.Border
	local udim, vector2

	if props.openPosition then
		udim = UDim2.fromOffset(props.openPosition.X, props.openPosition.Y)
		vector2 = Vector2.new(0, 0)
	else
		udim = UDim2.fromScale(0.5, 0.5)
		vector2 = Vector2.new(0.5, 0.5)
	end

	local v10, v11 = React.useBinding(Vector2.new(0, 0))
	local v12, v13 = React.useBinding(0)
	local v14 = nil
	local v15 = nil
	local v16 = nil
	local v17 = nil
	local v18 = nil

	if fFlagLuaAppChartsFilterOptionTextTag then
		local v19
		v16, v19 = React.useBinding(0)
		v17 = v19
		v18 = React.useCallback(function(p2)
			v17(p2.AbsoluteCanvasSize.Y)
		end, {})
	else
		v14, v15 = React.useBinding(Vector2.new(v5, 0))
	end

	local mapped = v10:map(function(p2)
		local v19, v20

		if props.openPosition then
			v19 = math.max(p2.X - props.openPosition.X - 24, v8)
			v20 = math.max(p2.Y - props.openPosition.Y - 24, 0)
		else
			v19 = p2.X - 48
			v20 = p2.Y - 48
		end

		return Vector2.new(v19, v20)
	end)
	local v19

	if not fFlagLuaAppChartsFilterOptionTextTag then
		v19 = mapped:map(function(p2)
			return p2.X
		end)
	end

	local joinBindings = React.joinBindings

	if fFlagLuaAppChartsFilterOptionTextTag then
		v14 = v16
	end

	local mapped2 = joinBindings({ v12, v14 }):map(function(list)
		local item = list[1]

		if fFlagLuaAppChartsFilterOptionTextTag then
			local item2 = list[2]

			return UDim2.fromOffset(0, item + item2 + v9)
		end

		local item2 = list[2]

		return UDim2.fromOffset(item2.X, item + item2.Y + v9)
	end)

	local mapped3 = v12:map(function(p2)
		return UDim2.new(fFlagLuaAppChartsFilterOptionTextTag and 0 or 1, 0, 1, -p2 - v9)
	end)

	local v21 = React.useCallback(function()
		v7(props.closeCentralOverlayThunk())
		props.onFilterMenuClosed()
		local sendFilterClick = props.sendFilterClick
		local closeDropdown = FilterClickButtonName.CloseDropdown
		local selectedOptionId = props.filter.selectedOptionId
		local v23

		if fFlagLuaAppChartsFilterOptionTextTag then
			v23 = getOptionContextTag(props.filter, props.filter.selectedOptionId)
		end

		local v24 = if fFlagLuaAppChartsFilterOptionTextTag then getOptionContextTag(props.filter, state) else nil
		sendFilterClick(closeDropdown, selectedOptionId, state, v23, v24, true)
	end, {
		props.filter,
		state,
		props.closeCentralOverlayThunk,
		props.onFilterMenuClosed,
		props.sendFilterClick
	})

	local v22 = state ~= props.filter.selectedOptionId

	local v23 = React.useCallback(function()
		props.onFilterApplied(props.filter.filterType, state)
		v7(props.closeCentralOverlayThunk())
		props.onFilterMenuClosed()
		local sendFilterClick = props.sendFilterClick
		local apply = FilterClickButtonName.Apply

		local selectedOptionId = props.filter.selectedOptionId
		local v25 = if fFlagLuaAppChartsFilterOptionTextTag then getOptionContextTag(props.filter, state) else nil

		local v26 = if fFlagLuaAppChartsFilterOptionTextTag then getOptionContextTag(props.filter, props.filter.selectedOptionId) else nil
		sendFilterClick(apply, state, selectedOptionId, v25, v26, true)
	end, {
		props.filter,
		state,
		props.onFilterApplied,
		props.closeCentralOverlayThunk,
		props.onFilterMenuClosed,
		props.sendFilterClick
	})

	local createElement = React.createElement
	local v25 = {
		BackgroundColor3 = scrim.Color3,
		BackgroundTransparency = scrim.Transparency,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = v21,
		[React.Change.AbsoluteSize] = function(p2)
			v11(p2.AbsoluteSize)
		end,
		Selectable = false
	}

	local createElement2 = React.createElement
	local v28 = {
		BackgroundColor3 = surface_100.Color3,
		BackgroundTransparency = surface_100.Transparency,
		BorderColor3 = border.Color3,
		ClipsDescendants = true,
		Text = "",
		AutoButtonColor = false,
		Position = udim,
		AnchorPoint = vector2,
		Size = mapped2,
		AutomaticSize = 0,
		Selectable = false
	}

	local v29 = if fFlagLuaAppChartsFilterOptionTextTag then Enum.AutomaticSize.X else nil
	v28.AutomaticSize = v29

	local children = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v6.Radius.Medium)
		}),
		SizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(v8, 0),
			MaxSize = mapped
		}),
		Layout = 0,
		Header = 0,
		Options = 0,
		ActionBar = 0
	}

	local createElement3 = React.createElement
	local v31 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalFlex = 0
	}
	local v32 = if fFlagLuaAppChartsFilterOptionTextTag then Enum.UIFlexAlignment.Fill else nil
	v31.HorizontalFlex = v32
	children.Layout = createElement3("UIListLayout", v31)

	children.Header = React.createElement(FilterMenuHeader, {
		LayoutOrder = 1,
		title = props.filter.filterDisplayName,
		onCloseButtonActivated = v21,
		onHeightChanged = v13
	})

	local createElement4 = React.createElement

	if fFlagLuaAppChartsFilterOptionTextTag then
		v19 = nil
	end

	local v34 = {
		LayoutOrder = 2,
		Size = mapped3,
		containerMaxWidthBinding = v19,
		options = props.filter.filterOptions,
		selectedOptionId = state,
		onSelectedOptionChanged = setState,
		onCanvasSizeChanged = 0
	}

	if fFlagLuaAppChartsFilterOptionTextTag then
		v15 = v18
	end

	v34.onCanvasSizeChanged = v15
	children.Options = createElement4(FilterMenuOptions, v34)

	children.ActionBar = React.createElement(FilterMenuActionBar, {
		LayoutOrder = 3,
		Size = UDim2.new(fFlagLuaAppChartsFilterOptionTextTag and 0 or 1, 0, 0, v9),
		applyEnabled = v22,
		onApply = v23
	})
	return createElement("TextButton", v25, {
		Dropdown = createElement2("TextButton", v28, children)
	})
end

return FilterMenuDropdown
