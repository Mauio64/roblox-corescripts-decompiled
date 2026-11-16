local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")

local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local scrollView = Foundation.ScrollView
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local visibility = Foundation.Enums.Visibility
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ShareSheetRowWithScrollArrows(p2)
	local v5 = useTokens()
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local v6 = React.useCallback(function(data)
		local v7 = math.max(0, data.AbsoluteCanvasSize.X - data.AbsoluteWindowSize.X)
		local x = data.CanvasPosition.X
		setState2(x > 1)
		setState3(x < v7 - 1)
	end, {})

	local v7 = React.useCallback(function(p3)
		local current = ref.current

		if current == nil then
			return
		end

		local v8 = math.max(0, current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X)
		local v9 = math.clamp(current.CanvasPosition.X + p3 * current.AbsoluteWindowSize.X, 0, v8)

		current.CanvasPosition = Vector2.new(v9, current.CanvasPosition.Y)
		v6(current)
	end, { v6 })

	return React.createElement(
		view,
		{
			tag = "size-full-0 auto-y",
			LayoutOrder = p2.LayoutOrder,
			testId = "share-sheet-row"
		},
		{
			ScrollView = React.createElement(scrollView, {
				tag = "size-full-0 auto-y",
				testId = "share-sheet-row-scroll-view",
				padding = {
					left = UDim.new(0, v5.Padding.XLarge),
					right = UDim.new(0, v5.Padding.XLarge)
				},
				scrollingFrameRef = ref,
				onCanvasPositionChanged = v6,
				onAbsoluteCanvasSizeChanged = v6,
				onAbsoluteWindowSizeChanged = v6,
				scroll = {
					AutomaticSize = Enum.AutomaticSize.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					CanvasSize = UDim2.fromScale(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.X,
					scrollBarVisibility = visibility.None
				},
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, v5.Padding.Medium)
				}
			}, p2.children),
			ScrollControls = React.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 10,
				[React.Event.MouseEnter] = function()
					setState(true)
				end,
				[React.Event.MouseLeave] = function()
					setState(false)
				end,
				[React.Tag] = "data-testid=share-sheet-row-scroll-controls"
			}, {
				Left = React.createElement(view, {
					Position = UDim2.new(0, v5.Padding.Medium, 0.5, 0),
					Visible = state and state2,
					ZIndex = 11,
					backgroundStyle = v5.DarkMode.OverMedia.OverMedia_100,
					onActivated = function()
						v7(-1)
					end,
					stateLayer = { affordance = stateLayerAffordance.Background },
					tag = "anchor-center-left size-1000 radius-circle",
					testId = "share-sheet-row-scroll-left"
				}, {
					Icon = React.createElement(icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = iconName.ChevronLargeLeft,
						size = iconSize.Large,
						style = v5.Color.Extended.White.White_100,
						testId = "share-sheet-row-scroll-left--icon",
						variant = iconVariant.Regular
					})
				}),
				Right = React.createElement(view, {
					Position = UDim2.new(1, -v5.Padding.Medium, 0.5, 0),
					Visible = state and state3,
					ZIndex = 11,
					backgroundStyle = v5.DarkMode.OverMedia.OverMedia_100,
					onActivated = function()
						v7(1)
					end,
					stateLayer = { affordance = stateLayerAffordance.Background },
					tag = "anchor-center-right size-1000 radius-circle",
					testId = "share-sheet-row-scroll-right"
				}, {
					Icon = React.createElement(icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = iconName.ChevronLargeRight,
						size = iconSize.Large,
						style = v5.Color.Extended.White.White_100,
						testId = "share-sheet-row-scroll-right--icon",
						variant = iconVariant.Regular
					})
				})
			})
		}
	)
end

return ShareSheetRowWithScrollArrows
