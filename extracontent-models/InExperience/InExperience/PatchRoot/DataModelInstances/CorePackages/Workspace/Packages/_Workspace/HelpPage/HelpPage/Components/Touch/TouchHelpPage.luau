local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local useKeybinds = require(parent.Hooks.useKeybinds)
local TouchControlsEnum = require(parent.Enums.TouchControlsEnum)
local TouchAction = require(parent.Components.Touch.TouchAction)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local RobloxAppEnums = require(parent2.RobloxAppEnums)
local Display = require(parent2.Display)
local Constants = require(parent.Constants)
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local defineFastFlag = game:DefineFastFlag("TouchHelpPageResponsiveUnits", false)

local function getTapOrRotate(p, p2, p3) -- 3 equivalent calls inferred from this helper
	assert(not (p3[p] and p3[p2]), "Cannot assign a position to both tap and rotate simultaneously.")

	if p3[p] then
		return p
	end

	return if p3[p2] then p2 else nil
end

local memo = React.memo(function(p)
	local v = useTokens()
	local components = p.components
	local v2 = p.orientation == DeviceOrientationMode.Portrait

	local function createSideColumn(p2: string, layoutOrder: number, topComponent, bottomComponent)
		return React.createElement(
			View,
			{
				tag = `align-x-{p2} auto-x col flex-y-between size-0-full`,
				LayoutOrder = layoutOrder
			},
			{ topComponent = topComponent, bottomComponent = bottomComponent }
		)
	end

	local sideColumn = createSideColumn(
		v2 and "center" or "left",
		1,
		components.topLeftComponent,
		components.bottomLeftComponent
	)

	local sideColumn2 = createSideColumn(
		v2 and "center" or "right",
		3,
		components.topRightComponent,
		components.bottomRightComponent
	)

	if v2 then
		return React.createElement(View, { tag = "auto-y flex-x-between row size-full-0" }, {
			Inner = React.createElement(
				View,
				{
					tag = "col flex-y-fill padding-y-large padding-x-xxlarge size-full",
					LayoutOrder = 1
				},
				{
					TopRow = React.createElement(View, {
						tag = "auto-y size-full-0",
						LayoutOrder = 1
					}, {
						Columns = React.createElement(View, {
							tag = "auto-y flex-x-between row size-full-0"
						}, {
							LeftColumn = sideColumn,
							RightColumn = sideColumn2
						}),
						Center = React.createElement(
							View,
							{
								tag = "auto-xy",
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5)
							},
							{ TopMid = components.topMidComponent }
						)
					}),
					BottomRow = React.createElement(View, {
						tag = "auto-y size-full-0",
						LayoutOrder = 2
					}, {
						BottomMid = React.createElement(
							View,
							{
								tag = "align-x-center align-y-bottom auto-y padding-top-xxlarge row size-full-0",
								LayoutOrder = 4
							},
							{ bottomMid = components.bottomMidComponent }
						)
					})
				}
			)
		})
	end

	return React.createElement(
		View,
		{
			tag = "auto-y flex-x-between row size-full-0",
			LayoutOrder = 1,
			padding = UDim2.fromOffset(v.Margin.Large, v.Margin.Small)
		},
		{
			leftColumn = sideColumn,
			middleColumn = React.createElement(
				View,
				{ tag = "align-x-center auto-x col flex-y-fill size-0-full", LayoutOrder = 2 },
				{
					topMidContainer = React.createElement(
						View,
						{ tag = "align-y-center auto-x col size-0-full", LayoutOrder = 1 },
						{ topMid = components.topMidComponent }
					),
					bottomMidContainer = React.createElement(
						View,
						{ tag = "align-y-bottom auto-xy col", LayoutOrder = 2 },
						{ bottomMid = components.bottomMidComponent }
					)
				}
			),
			rightColumn = sideColumn2
		}
	)
end)

local function TouchHelpPage()
	local orientation = useDeviceOrientation()
	local controls = useKeybinds().controls
	local state, setState = React.useState(UserGameSettings.TouchMovementMode)
	local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)

	React.useEffect(function()
		local touchMovementModeChangedConnection = UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
			setState(UserGameSettings.TouchMovementMode)
		end)

		return function()
			touchMovementModeChangedConnection:Disconnect()
		end
	end, {})

	local v = state == Enum.TouchMovementMode.ClickToMove

	local v2 = React.useMemo(function()
		local labels = {}

		if controls == nil then
			return labels
		end

		for _, control in controls do
			if control.touchInput == nil then
				continue
			end

			local v2

			if v then
				v2 = control.touchInput.tapToMoveInput
			else
				v2 = control.touchInput.thumbstickInput
			end

			for _, v3 in ipairs(v2) do
				assert(labels[v3] == nil, "A touch input position cannot have multiple actions.")

				labels[v3] = control.label
			end
		end

		return labels
	end, { controls, state })

	if controls == nil then
		return nil
	end

	local tapOrRotate = getTapOrRotate(TouchControlsEnum.TopMidTap, TouchControlsEnum.TopMidRotate, v2) -- inferred equivalent call

	local tapOrRotate2 = getTapOrRotate(TouchControlsEnum.TopRightTap, TouchControlsEnum.TopRightRotate, v2) -- inferred equivalent call

	local tapOrRotate3 = getTapOrRotate(TouchControlsEnum.BottomLeftTap, TouchControlsEnum.BottomLeftRotate, v2) -- inferred equivalent call

	local components = {
		["topLeftComponent"] = v2[TouchControlsEnum.TopLeft] and React.createElement(TouchAction, {
			action = v2[TouchControlsEnum.TopLeft],
			touchInput = TouchControlsEnum.TopLeft,
			layoutOrder = 0
		}) or React.createElement(View),
		bottomLeftComponent = tapOrRotate3 and React.createElement(TouchAction, {
			action = tapOrRotate3 and v2[tapOrRotate3],
			touchInput = tapOrRotate3,
			layoutOrder = 1
		}) or React.createElement(View),
		topMidComponent = tapOrRotate and React.createElement(TouchAction, {
			action = tapOrRotate and v2[tapOrRotate],
			touchInput = tapOrRotate,
			layoutOrder = 1
		}) or React.createElement(View),
		bottomMidComponent = v2[TouchControlsEnum.BottomMid] and React.createElement(TouchAction, {
			action = v2[TouchControlsEnum.BottomMid],
			touchInput = TouchControlsEnum.BottomMid,
			layoutOrder = 1
		}) or React.createElement(View),
		topRightComponent = tapOrRotate2 and React.createElement(TouchAction, {
			action = tapOrRotate2 and v2[tapOrRotate2],
			touchInput = tapOrRotate2,
			layoutOrder = 1
		}) or React.createElement(View),
		bottomRightComponent = v2[TouchControlsEnum.BottomRight] and React.createElement(TouchAction, {
			action = v2[TouchControlsEnum.BottomRight],
			touchInput = TouchControlsEnum.BottomRight,
			layoutOrder = 2
		}) or React.createElement(View)
	}

	local element = React.createElement(memo, { components = components, orientation = orientation })

	local v3 = Constants.HELP_PAGE.TOUCH_OFFSETS.BIG_SCREEN_OFFSET

	if
		viewportSize.X < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_X
		or viewportSize.Y < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_Y
	then
		v3 = Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_OFFSET
	end

	local createElement = React.createElement
	local size

	if defineFastFlag then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.new(1, 0, 0, viewportSize.Y - v3)
	end

	return createElement(View, { Size = size, ClipsDescendants = true }, { pageComponent = element })
end

return React.memo(TouchHelpPage)
