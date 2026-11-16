local GameFilters = script:FindFirstAncestor("GameFilters")

local parent = GameFilters.Parent
require(parent.DiscoveryTypes)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens

local FilterClickButtonName = require(GameFilters.Analytics.FilterClickButtonName)
local FilterMenuActionBar = require(GameFilters.Components.Menu.FilterMenuActionBar)
local FilterMenuHeader = require(GameFilters.Components.Menu.FilterMenuHeader)
local FilterMenuOptions = require(GameFilters.Components.Menu.FilterMenuOptions)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag
local v = not FFlagLuaAppChartsFilterOptionTextTag and 10000 or nil

local function applyTokenScaling(p: number, p2) -- 2 equivalent calls inferred from this helper
	return p * p2.Config.UI.Scale
end

local function FilterMenuDropdown(props)
	local v2 = useTokens()
	local v3 = useDispatch()
	local v4 = applyTokenScaling(260, v2) -- inferred equivalent call
	local v5 = applyTokenScaling(84, v2) -- inferred equivalent call
	local state, setState = React.useState(props.filter.selectedOptionId)

	local scrim = v2.Color.Common.Scrim
	local surface_100 = v2.Color.Surface.Surface_100
	local border = v2.Color.ActionStandard.Border
	local udim, vector2

	if props.openPosition then
		udim = UDim2.fromOffset(props.openPosition.X, props.openPosition.Y)
		vector2 = Vector2.new(0, 0)
	else
		udim = UDim2.fromScale(0.5, 0.5)
		vector2 = Vector2.new(0.5, 0.5)
	end

	local v6, v7 = React.useBinding(Vector2.new(0, 0))
	local v8, onHeightChanged = React.useBinding(0)
	local v9 = nil
	local onCanvasSizeChanged = nil
	local v10 = nil
	local v11 = nil
	local v12 = nil

	if FFlagLuaAppChartsFilterOptionTextTag then
		local v13
		v10, v13 = React.useBinding(0)
		v11 = v13
		v12 = React.useCallback(function(p)
			v11(p.AbsoluteCanvasSize.Y)
		end, {})
	else
		v9, onCanvasSizeChanged = React.useBinding(Vector2.new(v, 0))
	end

	local mapped = v6:map(function(vector2_2: Vector2)
		local v13, v14

		if props.openPosition then
			v13 = math.max(vector2_2.X - props.openPosition.X - 24, v4)
			v14 = math.max(vector2_2.Y - props.openPosition.Y - 24, 0)
		else
			v13 = vector2_2.X - 48
			v14 = vector2_2.Y - 48
		end

		return Vector2.new(v13, v14)
	end)
	local containerMaxWidthBinding

	if not FFlagLuaAppChartsFilterOptionTextTag then
		containerMaxWidthBinding = mapped:map(function(vector2_2: Vector2)
			return vector2_2.X
		end)
	end

	local joinBindings = React.joinBindings

	if FFlagLuaAppChartsFilterOptionTextTag then
		v9 = v10
	end

	local mapped2 = joinBindings({ v8, v9 }):map(function(list)
		local item = list[1]

		if FFlagLuaAppChartsFilterOptionTextTag then
			local item2 = list[2]

			return UDim2.fromOffset(0, item + item2 + v5)
		end

		local item2 = list[2]

		return UDim2.fromOffset(item2.X, item + item2.Y + v5)
	end)

	local mapped3 = v8:map(function(p: number)
		return UDim2.new(FFlagLuaAppChartsFilterOptionTextTag and 0 or 1, 0, 1, -p - v5)
	end)

	local onCloseButtonActivated = React.useCallback(function()
		v3(props.closeCentralOverlayThunk())
		props.onFilterMenuClosed()
		local sendFilterClick = props.sendFilterClick
		local closeDropdown = FilterClickButtonName.CloseDropdown
		local selectedOptionId = props.filter.selectedOptionId
		local v13

		if FFlagLuaAppChartsFilterOptionTextTag then
			v13 = getOptionContextTag(props.filter, props.filter.selectedOptionId)
		end

		local v14

		if FFlagLuaAppChartsFilterOptionTextTag then
			v14 = getOptionContextTag(props.filter, state)
		end

		sendFilterClick(closeDropdown, selectedOptionId, state, v13, v14, true)
	end, {
		props.filter,
		state,
		props.closeCentralOverlayThunk,
		props.onFilterMenuClosed,
		props.sendFilterClick
	})

	local applyEnabled = state ~= props.filter.selectedOptionId

	local onApply = React.useCallback(function()
		props.onFilterApplied(props.filter.filterType, state)
		v3(props.closeCentralOverlayThunk())
		props.onFilterMenuClosed()
		local sendFilterClick = props.sendFilterClick
		local apply = FilterClickButtonName.Apply

		local selectedOptionId = props.filter.selectedOptionId
		local v13

		if FFlagLuaAppChartsFilterOptionTextTag then
			v13 = getOptionContextTag(props.filter, state)
		end

		local v14

		if FFlagLuaAppChartsFilterOptionTextTag then
			v14 = getOptionContextTag(props.filter, props.filter.selectedOptionId)
		end

		sendFilterClick(apply, state, selectedOptionId, v13, v14, true)
	end, {
		props.filter,
		state,
		props.onFilterApplied,
		props.closeCentralOverlayThunk,
		props.onFilterMenuClosed,
		props.sendFilterClick
	})

	local createElement = React.createElement
	local v13 = {
		BackgroundColor3 = scrim.Color3,
		BackgroundTransparency = scrim.Transparency,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = onCloseButtonActivated,
		[React.Change.AbsoluteSize] = function(p)
			v7(p.AbsoluteSize)
		end,
		Selectable = false
	}

	local createElement2 = React.createElement
	local v14 = {
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
	local automaticSize

	if FFlagLuaAppChartsFilterOptionTextTag then
		automaticSize = Enum.AutomaticSize.X
	end

	v14.AutomaticSize = automaticSize

	local children = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v2.Radius.Medium) }),
		SizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(v4, 0),
			MaxSize = mapped
		}),
		Layout = 0,
		Header = 0,
		Options = 0,
		ActionBar = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalFlex = 0
	}
	local horizontalFlex

	if FFlagLuaAppChartsFilterOptionTextTag then
		horizontalFlex = Enum.UIFlexAlignment.Fill
	end

	v15.HorizontalFlex = horizontalFlex
	children.Layout = createElement3("UIListLayout", v15)

	children.Header = React.createElement(FilterMenuHeader, {
		LayoutOrder = 1,
		title = props.filter.filterDisplayName,
		onCloseButtonActivated = onCloseButtonActivated,
		onHeightChanged = onHeightChanged
	})

	local createElement4 = React.createElement

	if FFlagLuaAppChartsFilterOptionTextTag then
		containerMaxWidthBinding = nil
	end

	local v16 = {
		LayoutOrder = 2,
		Size = mapped3,
		containerMaxWidthBinding = containerMaxWidthBinding,
		options = props.filter.filterOptions,
		selectedOptionId = state,
		onSelectedOptionChanged = setState,
		onCanvasSizeChanged = 0
	}

	if FFlagLuaAppChartsFilterOptionTextTag then
		onCanvasSizeChanged = v12
	end

	v16.onCanvasSizeChanged = onCanvasSizeChanged
	children.Options = createElement4(FilterMenuOptions, v16)

	children.ActionBar = React.createElement(FilterMenuActionBar, {
		LayoutOrder = 3,
		Size = UDim2.new(FFlagLuaAppChartsFilterOptionTextTag and 0 or 1, 0, 0, v5),
		applyEnabled = applyEnabled,
		onApply = onApply
	})
	return createElement("TextButton", v13, {
		Dropdown = createElement2("TextButton", v14, children)
	})
end

return FilterMenuDropdown
