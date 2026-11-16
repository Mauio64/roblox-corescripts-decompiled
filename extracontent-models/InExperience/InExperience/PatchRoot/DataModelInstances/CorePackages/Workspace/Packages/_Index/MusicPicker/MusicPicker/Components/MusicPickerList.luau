local MusicPicker = script:FindFirstAncestor("MusicPicker")
local parent = MusicPicker.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Radius = Foundation.Enums.Radius
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local MusicPickerRow = require(MusicPicker.Components.MusicPickerRow)
require(MusicPicker.Types.MusicPickerTypes)

local function MusicPickerList(props)
	local v = useTokens()
	local content = props.content
	local emptyState = content.emptyState
	local onLoadMore = content.onLoadMore
	local isLoadingMore = content.isLoadingMore == true

	local ref = React.useRef(nil)
	local v2 = React.useCallback(function(data)
		if onLoadMore == nil or isLoadingMore then
			return
		end

		local y = data.AbsoluteCanvasSize.Y
		local y2 = data.AbsoluteWindowSize.Y

		if y <= 0 or y2 <= 0 then
			return
		end

		local v2 = data.CanvasPosition.Y + y2

		if y - 128 <= v2 then
			onLoadMore()
		end
	end, { onLoadMore, isLoadingMore })

	React.useEffect(function()
		local current = ref.current

		if current ~= nil then
			v2(current)
		end
	end, { v2, #content.items })

	if content.status == "success" and #content.items == 0 and emptyState ~= nil then
		return React.createElement(View, {
			LayoutOrder = props.LayoutOrder,
			flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
			testId = "saved-empty-state",
			tag = "col align-x-center align-y-center gap-xxlarge size-full padding-bottom-xxlarge"
		}, {
			Graphic = React.createElement(View, { LayoutOrder = 1, tag = "size-3000" }, {
				Tile = React.createElement(View, {
					Rotation = -15,
					testId = "saved-empty-state-tile",
					tag = "position-center-center anchor-center-center size-2400 stroke-thick stroke-muted radius-medium"
				}),
				Icon = React.createElement(Icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					name = emptyState.icon,
					size = v.Size.Size_1200,
					style = v.Color.Content.Emphasis,
					testId = "saved-empty-state-icon"
				})
			}),
			Copy = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "col align-x-center gap-small size-full-0 auto-y" },
				{
					Title = React.createElement(Text, {
						LayoutOrder = 1,
						Text = emptyState.title,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
					}),
					Subtitle = React.createElement(Text, {
						LayoutOrder = 2,
						Text = emptyState.subtitle,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
					})
				}
			)
		})
	end

	local children

	if content.status == "loading" then
		children = {}

		for i = 1, 6 do
			children[`Skeleton{i}`] = React.createElement(Skeleton, {
				LayoutOrder = i,
				radius = Radius.Medium,
				Size = UDim2.new(1, 0, 0, 64)
			})
		end
	elseif content.status == "error" then
		children = {
			Error = React.createElement(Text, {
				LayoutOrder = 1,
				Text = content.errorText or "",
				tag = "size-full-0 auto-y padding-top-large text-body-medium text-align-x-center content-default"
			}),
			Retry = 0
		}
		local retry

		if content.onRetry ~= nil then
			retry = React.createElement(Button, {
				LayoutOrder = 2,
				onActivated = content.onRetry,
				size = Foundation.Enums.InputSize.Small,
				text = content.retryText or "",
				variant = Foundation.Enums.ButtonVariant.Standard
			})
		end

		children.Retry = retry
	elseif content.status == "success" and #content.items == 0 then
		children = {
			Empty = React.createElement(Text, {
				LayoutOrder = 1,
				Text = content.emptyText or "",
				tag = "size-full-0 auto-y padding-top-large text-body-medium text-align-x-center content-default"
			})
		}
	elseif #content.items > 0 then
		children = {}

		for k, item in content.items do
			children[tostring(item.id)] = React.createElement(MusicPickerRow, {
				item = item,
				layoutOrder = k,
				onSelect = props.onSelect
			})
		end

		if isLoadingMore then
			children.LoadingMore = React.createElement(Skeleton, {
				LayoutOrder = #content.items + 1,
				radius = Radius.Medium,
				Size = UDim2.new(1, 0, 0, 64)
			})

			children.LoadingMoreSpacer = React.createElement(View, {
				LayoutOrder = #content.items + 2,
				Size = UDim2.new(1, 0, 0, v.Padding.Large)
			})
		end
	end

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
		layout = 0,
		scroll = 0,
		tag = "col align-x-left align-y-top size-full",
		scrollingFrameRef = 0,
		onCanvasPositionChanged = 0,
		onAbsoluteCanvasSizeChanged = 0,
		onAbsoluteWindowSizeChanged = 0
	}
	local layout = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = 0,
		SortOrder = 0
	}
	local v4

	if content.status == "loading" then
		v4 = v.Gap.Small
	else
		v4 = v.Gap.XXSmall
	end

	layout.Padding = UDim.new(0, v4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	v3.layout = layout

	local scroll = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = 0,
		ScrollingDirection = 0,
		scrollBarVisibility = 0
	}
	local canvasSize

	if onLoadMore ~= nil then
		canvasSize = UDim2.new()
	end

	scroll.CanvasSize = canvasSize
	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	scroll.scrollBarVisibility = ScrollBarVisibility.None
	v3.scroll = scroll

	v3.scrollingFrameRef = ref
	local onCanvasPositionChanged

	if onLoadMore ~= nil then
		onCanvasPositionChanged = v2
	end

	v3.onCanvasPositionChanged = onCanvasPositionChanged
	local onAbsoluteCanvasSizeChanged

	if onLoadMore ~= nil then
		onAbsoluteCanvasSizeChanged = v2
	end

	v3.onAbsoluteCanvasSizeChanged = onAbsoluteCanvasSizeChanged
	local onAbsoluteWindowSizeChanged

	if onLoadMore ~= nil then
		onAbsoluteWindowSizeChanged = v2
	end

	v3.onAbsoluteWindowSizeChanged = onAbsoluteWindowSizeChanged
	return createElement(ScrollView, v3, children)
end

return MusicPickerList
