local parent = script.Parent.Parent
local parent2 = parent.Parent

local Dash = require(parent2.Dash)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)

local GridView = UIBlox.App.Grid.GridView

local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local View = Foundation.View

local MenuButton = require(parent.Components.MenuButton)
require(parent.Types)
local useScreenSize = require(parent.Hooks.useScreenSize)

local function getItemsPerRow(p: number) -- 2 equivalent calls inferred from this helper
	return (math.clamp(math.floor(p / 120), 1, 4))
end

local function getGalleryItemSize(p: number, p2: number)
	local itemsPerRow = getItemsPerRow(p2) -- inferred equivalent call
	local v = p2 - 4 * (itemsPerRow - 1)

	local v2 = math.min(v / itemsPerRow, v)
	local v3 = v2 * p

	return Vector2.new(math.floor(v2), (math.floor(v3)))
end

local function getItemsPerPage(p: number, p2: number, vector2: Vector2) -- 1 equivalent call inferred from this helper
	if p <= 0 then
		return 0
	end

	local v = math.floor(p / vector2.Y)

	if p < vector2.Y * v + (v - 1) * 4 then
		v -= 1
	end

	return (math.max(v * getItemsPerRow(p2), 8)) -- inferred equivalent call
end

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(0)
	local v = useScreenSize()

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})
	local v2

	if state.X > 0 then
		v2 = state.Y > 0
	else
		v2 = false
	end

	local v3 = props.shouldShowShowMoreButton and state2 < #props.captures
	local v4 = math.clamp(v.Y / v.X, 3 / 7, 1)

	local v5 = state.Y - 12 - 40 - 36
	local v6 = state.X - 12 - 8

	local itemSize = React.useMemo(function()
		return getGalleryItemSize(v4, v6)
	end, { v4, v6 })

	local v7 = React.useMemo(function()
		return getItemsPerPage(v5, v6, itemSize) -- inferred equivalent call
	end, { v5, v6, itemSize })

	React.useEffect(function()
		if state2 < v7 then
			setState2(v7)
		end
	end, { state, v7, state2 })

	local onActivated = React.useCallback(function()
		setState2(state2 + v7)
	end, { state2, v7 })

	local items = React.useMemo(function()
		if not v3 then
			return props.captures
		end

		local v8 = math.min(#props.captures, state2)
		return Dash.slice(props.captures, 1, v8)
	end, { props.captures, v3, state2 })

	local createElement = React.createElement
	local position

	if props.position then
		position = props.position
	else
		position = UDim2.fromOffset(0, 0)
	end

	local size

	if props.size then
		size = props.size
	else
		size = UDim2.fromScale(1, 1)
	end

	local createElement2 = React.createElement

	local v8 = { Header = props.header, ScrollView = 0 }
	local createElement3 = React.createElement
	local v9 = {
		BorderSizePixel = 0,
		LayoutOrder = not props.layoutOrder and 1 or props.layoutOrder,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = ScrollBarVisibility.Auto
		},
		tag = "auto-y size-full-0 gap-xsmall col align-x-center align-y-top shrink padding-x-xsmall"
	}
	local gridView

	if v2 then
		gridView = React.createElement(GridView, {
			itemPadding = Vector2.new(4, 4),
			items = items,
			itemSize = itemSize,
			LayoutOrder = 1,
			renderItem = props.renderItem
		})
	end

	local showMore

	if v3 then
		showMore = React.createElement(MenuButton, {
			buttonHeight = 40,
			LayoutOrder = 2,
			onActivated = onActivated,
			text = "Show More"
		})
	end

	v8.ScrollView = createElement3(ScrollView, v9, { GridView = gridView, ShowMore = showMore })
	return createElement(View, {
		BorderSizePixel = 0,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		Position = position,
		Size = size,
		tag = "bg-surface-0"
	}, {
		CaptureGridViewContainer = createElement2(
			View,
			{ tag = "bg-action-subtle size-full gap-xsmall col align-x-center align-y-top shrink" },
			v8
		)
	})
end
