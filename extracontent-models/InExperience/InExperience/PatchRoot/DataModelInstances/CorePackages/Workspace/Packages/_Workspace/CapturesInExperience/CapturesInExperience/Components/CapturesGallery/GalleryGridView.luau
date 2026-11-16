local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Dash = require(parent2.Dash)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)

local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useScreenSize = RobloxAppHooks.useScreenSize

local GridView = UIBlox.App.Grid.GridView

local GalleryActionContainer = require(parent.Components.CapturesGallery.GalleryActionContainer)
local GalleryItem = require(parent.Components.CapturesGallery.GalleryItem)
local ShowMoreButton = require(parent.Components.Common.ShowMoreButton)
require(parent.Types)

local function getItemsPerRow(p: number) -- 2 equivalent calls inferred from this helper
	return (math.clamp(math.floor(p / 120), 1, 4))
end

local function getGalleryItemSize(p: number, p2: number) -- 2 equivalent calls inferred from this helper
	local itemsPerRow = getItemsPerRow(p2) -- inferred equivalent call
	local v = p2 - 4 * (itemsPerRow - 1)

	local v2 = math.min(v / itemsPerRow, v)
	local v3 = v2 * p

	return Vector2.new(math.floor(v2), (math.floor(v3)))
end

local function getItemsPerPage(p: number, p2: number, vector2: Vector2) -- 2 equivalent calls inferred from this helper
	if p <= 0 then
		return 0
	end

	local v = math.floor(p / vector2.Y)

	if p < vector2.Y * v + (v - 1) * 4 then
		v -= 1
	end

	return (math.max(v * getItemsPerRow(p2), 8)) -- inferred equivalent call
end

local function renderGalleryItem(capture, captureIndex: number)
	return React.createElement(GalleryItem, { capture = capture, captureIndex = captureIndex })
end

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(0)
	local v = useScreenSize()

	local v2 = state2 < #props.captures
	local v3

	if state.X > 0 then
		v3 = state.Y > 0
	else
		v3 = false
	end

	local v4 = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})

	local v5 = math.clamp(v.Y / v.X, 3 / 7, 1)

	local v6 = state.Y - 12 - 40 - 36
	local x = state.X
	local itemSize = getGalleryItemSize(v5, x) -- inferred equivalent call
	local itemsPerPage = getItemsPerPage(v6, x, itemSize) -- inferred equivalent call

	if itemsPerPage < state2 then
		local v7 = x - 9
		itemSize = getGalleryItemSize(v5, v7) -- inferred equivalent call
		itemsPerPage = getItemsPerPage(v6, v7, itemSize) -- inferred equivalent call
	end

	useEffectOnce(function()
		setState2(itemsPerPage)
	end, itemsPerPage ~= 0)

	React.useEffect(function()
		if state2 < itemsPerPage then
			setState2(itemsPerPage)
		end
	end, { state })

	local onActivated = React.useCallback(function()
		setState2(state2 + itemsPerPage)
	end, { state2, itemsPerPage })

	local items = React.useMemo(function()
		local v7 = math.min(#props.captures, state2)
		return Dash.slice(props.captures, 1, v7)
	end, { props.captures, state2 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Size = props.Size or UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = v4
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		GalleryActionContainer = React.createElement(GalleryActionContainer, {
			isDisabled = false,
			itemCount = #props.captures,
			LayoutOrder = 1
		}),
		ScrollingFrame = React.createElement("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(1, 0),
			LayoutOrder = 2,
			ScrollBarThickness = 1,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Size = UDim2.new(1, 0, 1, -36)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, 12)
			}),
			GridView = v3 and React.createElement(GridView, {
				itemPadding = Vector2.new(4, 4),
				items = items,
				itemSize = itemSize,
				LayoutOrder = 1,
				renderItem = renderGalleryItem
			}),
			ShowMoreButton = v2 and React.createElement(ShowMoreButton, {
				LayoutOrder = 2,
				buttonHeight = 40,
				onActivated = onActivated
			})
		})
	})
end
