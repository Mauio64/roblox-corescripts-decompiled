local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")
local gridView = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/UIBlox").App.Grid.GridView

local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local scrollView = Foundation.ScrollView
local view = Foundation.View

local MenuButton = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Components/MenuButton")
require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Types")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Hooks/useScreenSize")

local function getItemsPerRow(p2)
	return (math.clamp(math.floor(p2 / 120), 1, 4))
end

local function getGalleryItemSize(p2, p3)
	local v5 = math.clamp(math.floor(p3 / 120), 1, 4)

	local v6 = p3 - 4 * (v5 - 1)

	local v7 = math.min(v6 / v5, v6)
	local v8 = v7 * p2

	return Vector2.new(math.floor(v7), (math.floor(v8)))
end

local function getItemsPerPage(p2, p3, p4)
	if p2 <= 0 then
		return 0
	end

	local v5 = math.floor(p2 / p4.Y)

	if p2 < p4.Y * v5 + (v5 - 1) * 4 then
		v5 -= 1
	end

	return (math.max(v5 * math.clamp(math.floor(p3 / 120), 1, 4), 8))
end

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(0)
	local v5 = useScreenSize()

	local v6 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	local v7 = state.X > 0 and state.Y > 0
	local v8 = props.shouldShowShowMoreButton and state2 < #props.captures
	local v9 = math.clamp(v5.Y / v5.X, 3 / 7, 1)

	local v10 = state.Y - 12 - 40 - 36
	local v11 = state.X - 12 - 8

	local v12 = React.useMemo(function()
		return getGalleryItemSize(v9, v11)
	end, { v9, v11 })

	local v13 = React.useMemo(function()
		local v14 = v10
		local v16 = v12

		if v14 <= 0 then
			return 0
		end

		local v17 = math.floor(v14 / v16.Y)

		if v14 < v16.Y * v17 + (v17 - 1) * 4 then
			v17 -= 1
		end

		return (math.max(v17 * math.clamp(math.floor(v11 / 120), 1, 4), 8))
	end, { v10, v11, v12 })

	React.useEffect(function()
		if state2 < v13 then
			setState2(v13)
		end
	end, { state, v13, state2 })

	local v14 = React.useCallback(function()
		setState2(state2 + v13)
	end, { state2, v13 })

	local v15 = React.useMemo(function()
		if not v8 then
			return props.captures
		end

		local v16 = math.min(#props.captures, state2)
		return Dash.slice(props.captures, 1, v16)
	end, { props.captures, v8, state2 })

	local createElement = React.createElement

	local v18 = if props.position then props.position else UDim2.fromOffset(0, 0)
	local v19 = if props.size then props.size else UDim2.fromScale(1, 1)

	local createElement2 = React.createElement

	local v23 = { Header = props.header, ScrollView = 0 }
	local createElement3 = React.createElement
	local v25 = {
		BorderSizePixel = 0,
		LayoutOrder = not props.layoutOrder and 1 or props.layoutOrder,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = scrollBarVisibility.Auto
		},
		tag = "auto-y size-full-0 gap-xsmall col align-x-center align-y-top shrink padding-x-xsmall"
	}

	local v27 = if v7 then React.createElement(gridView, {
		itemPadding = Vector2.new(4, 4),
		items = v15,
		itemSize = v12,
		LayoutOrder = 1,
		renderItem = props.renderItem
	}) else nil

	local v28 = if v8 then React.createElement(MenuButton, {
		buttonHeight = 40,
		LayoutOrder = 2,
		onActivated = v14,
		text = "Show More"
	}) else nil
	v23.ScrollView = createElement3(scrollView, v25, { GridView = v27, ShowMore = v28 })
	return createElement(view, {
		BorderSizePixel = 0,
		onAbsoluteSizeChanged = v6,
		Position = v18,
		Size = v19,
		tag = "bg-surface-0"
	}, {
		CaptureGridViewContainer = createElement2(
			view,
			{
				tag = "bg-action-subtle size-full gap-xsmall col align-x-center align-y-top shrink"
			},
			v23
		)
	})
end
