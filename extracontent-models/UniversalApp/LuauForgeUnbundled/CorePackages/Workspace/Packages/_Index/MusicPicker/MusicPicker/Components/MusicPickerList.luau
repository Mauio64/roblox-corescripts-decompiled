local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")

local button = Foundation.Button
local icon = Foundation.Icon
local radius = Foundation.Enums.Radius
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local scrollView = Foundation.ScrollView
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local MusicPickerRow = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Components/MusicPickerRow")
require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

local function MusicPickerList(props)
	local v5 = useTokens()
	local content = props.content
	local emptyState = content.emptyState
	local onLoadMore = content.onLoadMore
	local isLoadingMore = content.isLoadingMore == true

	local ref = React.useRef(nil)
	local v6 = React.useCallback(function(data)
		if onLoadMore == nil or isLoadingMore then
			return
		end

		local y = data.AbsoluteCanvasSize.Y
		local y2 = data.AbsoluteWindowSize.Y

		if y <= 0 or y2 <= 0 then
			return
		end

		local v7 = data.CanvasPosition.Y + y2

		if y - 128 <= v7 then
			onLoadMore()
		end
	end, { onLoadMore, isLoadingMore })

	React.useEffect(function()
		local current = ref.current

		if current ~= nil then
			v6(current)
		end
	end, { v6, #content.items })

	if content.status == "success" and #content.items == 0 and emptyState ~= nil then
		return React.createElement(view, {
			LayoutOrder = props.LayoutOrder,
			flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
			testId = "saved-empty-state",
			tag = "col align-x-center align-y-center gap-xxlarge size-full padding-bottom-xxlarge"
		}, {
			Graphic = React.createElement(view, { LayoutOrder = 1, tag = "size-3000" }, {
				Tile = React.createElement(view, {
					Rotation = -15,
					testId = "saved-empty-state-tile",
					tag = "position-center-center anchor-center-center size-2400 stroke-thick stroke-muted radius-medium"
				}),
				Icon = React.createElement(icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					name = emptyState.icon,
					size = v5.Size.Size_1200,
					style = v5.Color.Content.Emphasis,
					testId = "saved-empty-state-icon"
				})
			}),
			Copy = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "col align-x-center gap-small size-full-0 auto-y"
				},
				{
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = emptyState.title,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
					}),
					Subtitle = React.createElement(text, {
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
			children[`Skeleton{i}`] = React.createElement(skeleton, {
				LayoutOrder = i,
				radius = radius.Medium,
				Size = UDim2.new(1, 0, 0, 64)
			})
		end
	elseif content.status == "error" then
		children = {
			Error = React.createElement(text, {
				LayoutOrder = 1,
				Text = content.errorText or "",
				tag = "size-full-0 auto-y padding-top-large text-body-medium text-align-x-center content-default"
			}),
			Retry = 0
		}

		local v7 = if content.onRetry ~= nil then React.createElement(button, {
			LayoutOrder = 2,
			onActivated = content.onRetry,
			size = Foundation.Enums.InputSize.Small,
			text = content.retryText or "",
			variant = Foundation.Enums.ButtonVariant.Standard
		}) else nil
		children.Retry = v7
	elseif content.status == "success" and #content.items == 0 then
		children = {
			Empty = React.createElement(text, {
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
			children.LoadingMore = React.createElement(skeleton, {
				LayoutOrder = #content.items + 1,
				radius = radius.Medium,
				Size = UDim2.new(1, 0, 0, 64)
			})

			children.LoadingMoreSpacer = React.createElement(view, {
				LayoutOrder = #content.items + 2,
				Size = UDim2.new(1, 0, 0, v5.Padding.Large)
			})
		end
	end

	local createElement = React.createElement
	local v8 = {
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
	local v9 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = 0,
		SortOrder = 0
	}
	local newUDim = UDim.new
	local v11 = if content.status == "loading" then v5.Gap.Small else v5.Gap.XXSmall
	v9.Padding = newUDim(0, v11)
	v9.SortOrder = Enum.SortOrder.LayoutOrder
	v8.layout = v9

	local v12 = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = 0,
		ScrollingDirection = 0,
		scrollBarVisibility = 0
	}

	local v13 = if onLoadMore ~= nil then UDim2.new() else nil
	v12.CanvasSize = v13
	v12.ScrollingDirection = Enum.ScrollingDirection.Y
	v12.scrollBarVisibility = scrollBarVisibility.None
	v8.scroll = v12

	v8.scrollingFrameRef = ref
	local v14 = if onLoadMore ~= nil then v6 else nil
	v8.onCanvasPositionChanged = v14
	local v15 = if onLoadMore ~= nil then v6 else nil
	v8.onAbsoluteCanvasSizeChanged = v15
	local v16 = if onLoadMore ~= nil then v6 else nil
	v8.onAbsoluteWindowSizeChanged = v16
	return createElement(scrollView, v8, children)
end

return MusicPickerList
