local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local useKeybinds = require(ParentParent.Hooks.useKeybinds)
local TouchControlsEnum = require(ParentParent.Enums.TouchControlsEnum)
local TouchAction = require(ParentParent.Components.Touch.TouchAction)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local RobloxAppEnums = require(ParentParentParent.RobloxAppEnums)
local Display = require(ParentParentParent.Display)
local Constants = require(ParentParent.Constants)
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local v17 = game:DefineFastFlag("TouchHelpPageResponsiveUnits", false)

local function getTapOrRotate(p1, p2, t1: {[any]: any}) -- line: 26
	assert(not (t1[p1] and t1[p2]), "Cannot assign a position to both tap and rotate simultaneously.")

	if t1[p1] then
		return p1
	end

	if t1[p2] then
		return p2
	end

	return nil
end

local v19 = React.memo(function(t2: {[any]: any}) -- line: 62
	-- upvalues: useTokens (copy), DeviceOrientationMode (copy), React (copy), View (copy)
	local v25 = useTokens()
	local components = t2.components
	local v27 = t2.orientation == DeviceOrientationMode.Portrait

	local function createSideColumn(s1: string, n1: number, p3, p4) -- line: 68
		-- upvalues: React (copy), View (copy)
		return React.createElement(View, {
			tag = `align-x-{ s1 } auto-x col flex-y-between size-0-full`,
			LayoutOrder = n1
		}, {
			topComponent = p3,
			bottomComponent = p4
		})
	end

	local v29 = createSideColumn(not v27 and "left" or "center", 1, components.topLeftComponent, components.bottomLeftComponent)
	local v30 = createSideColumn(not v27 and "right" or "center", 3, components.topRightComponent, components.bottomRightComponent)

	if v27 then
		return React.createElement(View, {
			tag = "auto-y flex-x-between row size-full-0"
		}, {
			Inner = React.createElement(View, {
				tag = "col flex-y-fill padding-y-large padding-x-xxlarge size-full",
				LayoutOrder = 1
			}, {
				TopRow = React.createElement(View, {
					tag = "auto-y size-full-0",
					LayoutOrder = 1
				}, {
					Columns = React.createElement(View, {
						tag = "auto-y flex-x-between row size-full-0"
					}, {
						LeftColumn = v29,
						RightColumn = v30
					}),
					Center = React.createElement(View, {
						tag = "auto-xy",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					}, {
						TopMid = components.topMidComponent
					})
				}),
				BottomRow = React.createElement(View, {
					tag = "auto-y size-full-0",
					LayoutOrder = 2
				}, {
					BottomMid = React.createElement(View, {
						tag = "align-x-center align-y-bottom auto-y padding-top-xxlarge row size-full-0",
						LayoutOrder = 4
					}, {
						bottomMid = components.bottomMidComponent
					})
				})
			})
		})
	end

	return React.createElement(View, {
		tag = "auto-y flex-x-between row size-full-0",
		LayoutOrder = 1,
		padding = UDim2.fromOffset(v25.Margin.Large, v25.Margin.Small)
	}, {
		leftColumn = v29,
		middleColumn = React.createElement(View, {
			tag = "align-x-center auto-x col flex-y-fill size-0-full",
			LayoutOrder = 2
		}, {
			topMidContainer = React.createElement(View, {
				tag = "align-y-center auto-x col size-0-full",
				LayoutOrder = 1
			}, {
				topMid = components.topMidComponent
			}),
			bottomMidContainer = React.createElement(View, {
				tag = "align-y-bottom auto-xy col",
				LayoutOrder = 2
			}, {
				bottomMid = components.bottomMidComponent
			})
		}),
		rightColumn = v30
	})
end)

local function TouchHelpPage() -- line: 165
	-- upvalues: useDeviceOrientation (copy), useKeybinds (copy), React (copy), UserGameSettings (copy), Display (copy), TouchControlsEnum (copy), TouchAction (copy), View (copy), v19 (copy), Constants (copy), v17 (copy)
	local v31 = useDeviceOrientation()
	local controls = useKeybinds().controls
	local v33, v34 = React.useState(UserGameSettings.TouchMovementMode)
	local v35 = Display.GetDisplayStore(false).getViewportSize(false)

	React.useEffect(function() -- line: 172
		-- upvalues: UserGameSettings (copy), v34 (copy)
		local connection = UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- line: 173
			-- upvalues: v34 (copy), UserGameSettings (copy)
			v34(UserGameSettings.TouchMovementMode)
		end)

		return function() -- line: 177
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v36 = v33 == Enum.TouchMovementMode.ClickToMove
	local v37 = React.useMemo(function() -- line: 185
		-- upvalues: controls (copy), v36 (copy)
		local t3 = {}

		if controls == nil then
			return t3
		end

		for _, v57 in controls do
			if v57.touchInput ~= nil then
				local v58 = if not v36 then v57.touchInput.thumbstickInput else v57.touchInput.tapToMoveInput

				for _, v in ipairs(v58) do
					assert(t3[v] == nil, "A touch input position cannot have multiple actions.")
					t3[v] = v57.label
				end
			end
		end

		return t3
	end, {
		controls,
		v33
	})

	if controls == nil then
		return nil
	end

	local TopMidTap = TouchControlsEnum.TopMidTap
	local TopMidRotate = TouchControlsEnum.TopMidRotate

	assert(not (v37[TopMidTap] and v37[TopMidRotate]), "Cannot assign a position to both tap and rotate simultaneously.")

	local v40 = if not v37[TopMidTap] then if not v37[TopMidRotate] then nil else TopMidRotate else TopMidTap
	local TopRightTap = TouchControlsEnum.TopRightTap
	local TopRightRotate = TouchControlsEnum.TopRightRotate

	assert(not (v37[TopRightTap] and v37[TopRightRotate]), "Cannot assign a position to both tap and rotate simultaneously.")

	local v43 = if not v37[TopRightTap] then if not v37[TopRightRotate] then nil else TopRightRotate else TopRightTap
	local BottomLeftTap = TouchControlsEnum.BottomLeftTap
	local BottomLeftRotate = TouchControlsEnum.BottomLeftRotate

	assert(not (v37[BottomLeftTap] and v37[BottomLeftRotate]), "Cannot assign a position to both tap and rotate simultaneously.")

	local v46 = if not v37[BottomLeftTap] then if not v37[BottomLeftRotate] then nil else BottomLeftRotate else BottomLeftTap
	local t4 = {
		topLeftComponent = v37[TouchControlsEnum.TopLeft] and React.createElement(TouchAction, {
			layoutOrder = 0,
			action = v37[TouchControlsEnum.TopLeft],
			touchInput = TouchControlsEnum.TopLeft
		}) or React.createElement(View),
		bottomLeftComponent = v46 and React.createElement(TouchAction, {
			layoutOrder = 1,
			action = v46 and v37[v46],
			touchInput = v46
		}) or React.createElement(View),
		topMidComponent = v40 and React.createElement(TouchAction, {
			layoutOrder = 1,
			action = v40 and v37[v40],
			touchInput = v40
		}) or React.createElement(View),
		bottomMidComponent = v37[TouchControlsEnum.BottomMid] and React.createElement(TouchAction, {
			layoutOrder = 1,
			action = v37[TouchControlsEnum.BottomMid],
			touchInput = TouchControlsEnum.BottomMid
		}) or React.createElement(View),
		topRightComponent = v43 and React.createElement(TouchAction, {
			layoutOrder = 1,
			action = v43 and v37[v43],
			touchInput = v43
		}) or React.createElement(View),
		bottomRightComponent = v37[TouchControlsEnum.BottomRight] and React.createElement(TouchAction, {
			layoutOrder = 2,
			action = v37[TouchControlsEnum.BottomRight],
			touchInput = TouchControlsEnum.BottomRight
		}) or React.createElement(View)
	}
	local v48 = React.createElement(v19, {
		components = t4,
		orientation = v31
	})
	local BIG_SCREEN_OFFSET = Constants.HELP_PAGE.TOUCH_OFFSETS.BIG_SCREEN_OFFSET

	if v35.X < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_X or v35.Y < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_Y then
		BIG_SCREEN_OFFSET = Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_OFFSET
	end

	return React.createElement(View, {
		ClipsDescendants = true,
		Size = if not v17 then UDim2.new(1, 0, 0, v35.Y - BIG_SCREEN_OFFSET) else UDim2.fromScale(1, 1)
	}, {
		pageComponent = v48
	})
end

return React.memo(TouchHelpPage)
