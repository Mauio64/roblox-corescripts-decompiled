local parent = script:FindFirstAncestor("ShareSheet").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local ScrollView = Foundation.ScrollView
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local Visibility = Foundation.Enums.Visibility
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ShareSheetRowWithScrollArrows(p)
	local v = useTokens()
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local v2 = React.useCallback(function(data)
		local v2 = math.max(0, data.AbsoluteCanvasSize.X - data.AbsoluteWindowSize.X)
		local x = data.CanvasPosition.X
		setState2(x > 1)
		setState3(x < v2 - 1)
	end, {})

	local v3 = React.useCallback(function(p2: number)
		local current = ref.current

		if current == nil then
			return
		end

		local v3 = math.max(0, current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X)
		local v4 = math.clamp(current.CanvasPosition.X + p2 * current.AbsoluteWindowSize.X, 0, v3)

		current.CanvasPosition = Vector2.new(v4, current.CanvasPosition.Y)
		v2(current)
	end, { v2 })

	return React.createElement(
		View,
		{ tag = "size-full-0 auto-y", LayoutOrder = p.LayoutOrder, testId = "share-sheet-row" },
		{
			ScrollView = React.createElement(ScrollView, {
				tag = "size-full-0 auto-y",
				testId = "share-sheet-row-scroll-view",
				padding = {
					left = UDim.new(0, v.Padding.XLarge),
					right = UDim.new(0, v.Padding.XLarge)
				},
				scrollingFrameRef = ref,
				onCanvasPositionChanged = v2,
				onAbsoluteCanvasSizeChanged = v2,
				onAbsoluteWindowSizeChanged = v2,
				scroll = {
					AutomaticSize = Enum.AutomaticSize.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					CanvasSize = UDim2.fromScale(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.X,
					scrollBarVisibility = Visibility.None
				},
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, v.Padding.Medium)
				}
			}, p.children),
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
				Left = React.createElement(View, {
					Position = UDim2.new(0, v.Padding.Medium, 0.5, 0),
					Visible = state and state2,
					ZIndex = 11,
					backgroundStyle = v.DarkMode.OverMedia.OverMedia_100,
					onActivated = function()
						v3(-1)
					end,
					stateLayer = { affordance = StateLayerAffordance.Background },
					tag = "anchor-center-left size-1000 radius-circle",
					testId = "share-sheet-row-scroll-left"
				}, {
					Icon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = IconName.ChevronLargeLeft,
						size = IconSize.Large,
						style = v.Color.Extended.White.White_100,
						testId = "share-sheet-row-scroll-left--icon",
						variant = IconVariant.Regular
					})
				}),
				Right = React.createElement(View, {
					Position = UDim2.new(1, -v.Padding.Medium, 0.5, 0),
					Visible = state and state3,
					ZIndex = 11,
					backgroundStyle = v.DarkMode.OverMedia.OverMedia_100,
					onActivated = function()
						v3(1)
					end,
					stateLayer = { affordance = StateLayerAffordance.Background },
					tag = "anchor-center-right size-1000 radius-circle",
					testId = "share-sheet-row-scroll-right"
				}, {
					Icon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = IconName.ChevronLargeRight,
						size = IconSize.Large,
						style = v.Color.Extended.White.White_100,
						testId = "share-sheet-row-scroll-right--icon",
						variant = IconVariant.Regular
					})
				})
			})
		}
	)
end

return ShareSheetRowWithScrollArrows
