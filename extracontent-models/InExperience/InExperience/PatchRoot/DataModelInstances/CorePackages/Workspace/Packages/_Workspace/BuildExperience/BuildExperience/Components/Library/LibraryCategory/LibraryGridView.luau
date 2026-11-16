local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local LibraryTile = require(script.Parent.Parent.LibraryTile)
require(script.Parent.Parent.LibraryTypes)
local useHardwareInsets = require(BuildExperience.Components.ChatSheet.useHardwareInsets)

local ScrollView = Foundation.ScrollView
local Skeleton = Foundation.Skeleton
local View = Foundation.View

local Radius = Foundation.Enums.Radius
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local function LibraryGridView(props)
	local v = Foundation.Hooks.useTokens()
	local bottom = useHardwareInsets().bottom
	local medium = v.Gap.Medium
	local v2 = Foundation.Hooks.useScaledValue(180)
	local size_1200 = v.Size.Size_1200
	local state, setState = React.useState(Vector2.zero)

	local v3 = math.max(3, (math.ceil((state.X + medium) / (v2 + medium))))
	local v4 = math.floor(math.max(0, state.X - medium * (v3 - 1)) / v3)
	local v5 = v4 + size_1200
	local v6 = math.ceil((not props.isLoading and #props.items or v3) / v3)
	local v7 = math.max(0, v6 * v5 + math.max(0, v6 - 1) * medium)

	local v8 = React.useCallback(function()
		if props.hasMore then
			props.onLoadMore()
		end
	end, { props.hasMore, props.onLoadMore })

	React.useEffect(function()
		if props.hasMore and state.Y > 0 and v7 <= state.Y then
			v8()
		end
	end, { state.Y, v7, props.hasMore, v8 })

	local onCanvasPositionChanged = React.useCallback(function(data)
		if not props.hasMore or v5 <= 0 then
			return
		end

		if data.CanvasPosition.Y + data.AbsoluteWindowSize.Y >= data.AbsoluteCanvasSize.Y - v5 then
			v8()
		end
	end, { v5, props.hasMore, v8 })

	local children = {}

	if props.isLoading then
		for i = 1, v3 do
			children[tostring(i)] = React.createElement(
				View,
				{
					LayoutOrder = i,
					Size = UDim2.fromOffset(v4, v5),
					tag = "col gap-small",
					testId = `Library.Category.Skeleton.{i}`
				},
				{
					Thumbnail = React.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 1, -size_1200),
						radius = Radius.Medium
					}),
					Title = React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0.75, 0, 0, v.Size.Size_500),
						radius = Radius.Small
					})
				}
			)
		end
	else
		for k, item in props.items do
			children[item.tileKey or item.itemId or item.displayName] = React.createElement(
				View,
				{ LayoutOrder = k, Size = UDim2.fromOffset(v4, v5) },
				{
					Tile = React.createElement(LibraryTile, {
						tileKey = item.tileKey,
						itemId = item.itemId,
						itemKind = item.itemKind,
						isFolder = item.isFolder,
						folderPreview = item.folderPreview,
						displayName = item.displayName,
						unavailableText = item.unavailableText,
						thumbnail = item.thumbnail,
						model = item.model,
						onActivated = item.onActivated,
						Size = UDim2.fromScale(1, 1),
						mediaSize = UDim2.new(1, 0, 1, -size_1200)
					})
				}
			)
		end
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = function(p)
			setState(p.AbsoluteSize)
		end,
		tag = "size-full",
		testId = "Library.Category.Grid"
	}, {
		Scroll = React.createElement(ScrollView, {
			BorderSizePixel = 0,
			onCanvasPositionChanged = onCanvasPositionChanged,
			scrollingFrameRef = props.scrollingFrameRef,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, v7),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = ScrollBarVisibility.None
			},
			tag = "size-full",
			testId = "Library.Category.Grid.Scroll"
		}, {
			Content = React.createElement(View, {
				padding = { bottom = UDim.new(0, bottom) },
				tag = "size-full-0 auto-y",
				testId = "Library.Category.Grid.Content"
			}, {
				Layout = React.createElement("UIGridLayout", {
					CellPadding = UDim2.fromOffset(medium, medium),
					CellSize = UDim2.fromOffset(v4, v5),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Items = React.createElement(React.Fragment, nil, children)
			})
		})
	})
end

return LibraryGridView
