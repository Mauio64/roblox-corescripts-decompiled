local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReactUtils = require(CorePackages.Packages.ReactUtils)

local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local gamepadUtils = require("@luauforge/bundled/fCf").Gamepad.GamepadUtils
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/fCe")
local useInitializedValue = ReactUtils.useInitializedValue
local useEventCallback = ReactUtils.useEventCallback

local module2 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module2.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local colors = UIBlox.App.Style.Colors
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor

local defineFastFlag = game:DefineFastFlag("AXFixMissingThumbstickInputObject", false)

local component_assetsdropshadow_28 = images["component_assets/dropshadow_28"]
local component_assetscircle_29 = images["component_assets/circle_29"]

local white = colors.White
local pumice = colors.Pumice
local pumice2 = colors.Pumice

local v5 = { frequency = 5 }

local v6 = {}
local function getInputObjects()
	local lastInputType = UserInputService:GetLastInputType()

	if v6[lastInputType] ~= nil then
		return v6[lastInputType]
	end

	local gamepadState = UserInputService:GetGamepadState(lastInputType)
	local v7 = {}

	for i, v8 in ipairs(gamepadState) do
		v7[v8.KeyCode] = v8
	end

	v6[lastInputType] = v7

	return v6[lastInputType]
end

local function useFocusNavigationBindings(p2, p3, callback, p4)
	local v7 = ReactFocusNavigation.useEventMap(p3, p2)
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = callback and {
				handler = InputHandlers.onRelease(function(p5)
					p5.cancelled = true
					callback()
				end)
			} or nil,
			[focusNavigationEventNameEnum.ToggleGamepadInput] = {
				handler = InputHandlers.onRelease(p4)
			}
		}
	end, { callback, p4 })
	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

function LUAUFORGE_MODULE_GLOBALS_hew_getSliderDragInputSource(p2, p3)
	local parent = p2.Parent

	if p3 and parent and parent:IsA("GuiObject") then
		return parent
	end

	return UserInputService
end

return function(props)
	local state, setState = React.useState(false)
	local v7 = useIsSpatial()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(true)
	local ref7 = React.useRef(Otter.createSingleMotor(0))
	local ref8 = React.useRef(Otter.createSingleMotor(0))

	local v8, v9 = React.useBinding(0)
	local v10, v11 = React.useBinding(0)
	local v12 = useInitializedValue(function()
		return React.joinBindings({ pressed = v8, hovered = v10 })
	end)

	local v13 = React.useCallback(function()
		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end

		if ref3.current then
			ref3.current:Disconnect()
			ref3.current = nil
		end
	end, {})

	local v14 = React.useCallback(function()
		ref8.current:setGoal(Otter.spring(1, v5))
	end, {})

	local v15 = React.useCallback(function()
		ref8.current:setGoal(Otter.spring(0, v5))
	end, {})

	local v16 = React.useCallback(function(p2)
		if
			p2.UserInputType ~= Enum.UserInputType.MouseMovement
			and p2.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		local backgroundAbsolutePosition = props.getBackgroundAbsolutePosition()
		local backgroundAbsoluteSize = props.getBackgroundAbsoluteSize()

		if backgroundAbsolutePosition and backgroundAbsoluteSize then
			local position = p2.Position
			local vector2 = Vector2.new(
				(position.X - backgroundAbsolutePosition.X) / backgroundAbsoluteSize.X,
				(position.Y - backgroundAbsolutePosition.Y) / backgroundAbsoluteSize.Y
			)

			props.setScales(props.mapPositionToScales(vector2))
		end
	end, {
		props.getBackgroundAbsolutePosition,
		props.getBackgroundAbsoluteSize,
		props.setScales,
		props.mapPositionToScales
	})

	local v17 = useEventCallback(function(p2)
		if
			p2.UserInputType ~= Enum.UserInputType.MouseButton1
			and p2.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		if props.onDragEnd then
			props.onDragEnd()
		end

		v13()
		ref7.current:setGoal(Otter.spring(0, v5))
	end)

	local v18 = React.useCallback(function(p2, p3)
		local v19

		if p3.UserInputState == Enum.UserInputState.Begin then
			v19 = p3.UserInputType == Enum.UserInputType.MouseButton1
				or p3.UserInputType == Enum.UserInputType.Touch
		else
			v19 = false
		end

		if props.isDisabled or ref2.current or not v19 then
			return
		end

		if props.onDragStart then
			props.onDragStart()
		end

		ref2.current = LUAUFORGE_MODULE_GLOBALS_hew_getSliderDragInputSource(p2, v7).InputChanged:Connect(v16)
		ref3.current = UserInputService.InputEnded:connect(v17)
		ref7.current:setGoal(Otter.spring(1, v5))
	end, { props.isDisabled, props.onDragStart, v16, v17, v7 })

	local v19 = React.useCallback(function()
		setState(false)
	end, {})

	local v20 = React.useCallback(function(p2)
		if state then
			setState(false)
		elseif not props.isDisabled then
			setState(true)
		end
	end, { state, props.isDisabled })

	local v21 = React.useCallback(function(p2, p3)
		local v22 = p2[Enum.KeyCode.Thumbstick1]
		local v23

		if defineFastFlag then
			v23 = if v22 then gamepadUtils.normalizeStickByDeadzone(v22.Position) else Vector2.new(0, 0)
		else
			v23 = gamepadUtils.normalizeStickByDeadzone(p2[Enum.KeyCode.Thumbstick1].Position)
		end

		local v24 = v23 ~= Vector2.new(0, 0)
		local v25, v26, v27, v28

		if defineFastFlag then
			local v29 = p2[Enum.KeyCode.DPadLeft]
			local v30 = p2[Enum.KeyCode.DPadRight]
			local v31 = p2[Enum.KeyCode.DPadUp]
			local v32 = p2[Enum.KeyCode.DPadDown]
			v25 = v29 and v29.Position.z == 1 and -1 or 0
			v26 = v30 and v30.Position.z == 1 and 1 or 0
			v27 = v31 and v31.Position.z == 1 and 1 or 0
			v28 = if v32 and v32.Position.z == 1 then -1 else 0
		else
			v25 = p2[Enum.KeyCode.DPadLeft].Position.z == 1 and -1 or 0
			v26 = p2[Enum.KeyCode.DPadRight].Position.z == 1 and 1 or 0
			v27 = p2[Enum.KeyCode.DPadUp].Position.z == 1 and 1 or 0
			v28 = p2[Enum.KeyCode.DPadDown].Position.z == 1 and -1 or 0
		end

		local vector2 = Vector2.new(v25 + v26, v27 + v28)

		local xScale = props.xScale
		local yScale = props.yScale
		local v29, v30

		if v24 then
			ref4.current += p3

			local mapScalesToPosition = props.mapScalesToPosition(xScale, yScale)
			local vector2_2 = Vector2.new(v23.x, -v23.y)

			v29, v30 = props.mapPositionToScales(mapScalesToPosition + vector2_2 * 1 * p3)

			ref5.current = 0
			ref6.current = false
		elseif vector2 == Vector2.new(0, 0) then
			ref4.current = 0
			ref5.current = 0
			ref6.current = true
			v30 = yScale
			v29 = xScale
		else
			ref4.current += p3
			local v31

			if ref6.current then
				ref5.current = 0
				ref6.current = false
				v31 = 1
			elseif ref4.current > 0.2 then
				local v32 = p3 - math.max(0.2 - (ref4.current - p3), 0) + ref5.current
				v31 = math.floor(8 * v32)

				ref5.current = v32 - v31 / 8
			else
				ref5.current = 0
				v31 = 0
			end

			local vector2_2 = Vector2.new(props.invertDPadX and -1 or 1, props.invertDPadY and -1 or 1)
			local v32 = v31 - 1 + 0.51

			if vector2.x == 0 then
				v29 = xScale
			else
				local xScaleRules = props.xScaleRules
				local v33 = xScale + vector2.x * vector2_2.x * xScaleRules.increment * v32
				v29 = math.clamp(
					xScaleRules.min + module.Round(v33 - xScaleRules.min, xScaleRules.increment),
					xScaleRules.min,
					xScaleRules.max
				)
			end

			if vector2.y == 0 then
				v30 = yScale
			else
				local yScaleRules = props.yScaleRules
				local v33 = yScale + vector2.y * vector2_2.y * yScaleRules.increment * v32
				v30 = math.clamp(
					yScaleRules.min + module.Round(v33 - yScaleRules.min, yScaleRules.increment),
					yScaleRules.min,
					yScaleRules.max
				)
			end
		end

		if v29 ~= xScale or v30 ~= yScale then
			props.setScales(v29, v30)
		end
	end, {
		props.xScale,
		props.yScale,
		props.mapScalesToPosition,
		props.mapPositionToScales,
		props.invertDPadX,
		props.invertDPadY,
		props.xScaleRules,
		props.yScaleRules,
		props.setScales
	})

	local v22 = React.useMemo(function()
		local buttonB = Enum.KeyCode.ButtonB
		local v24 = if state then focusNavigationEventNameEnum.NavigateBack else nil
		local v23 = { [buttonB] = v24 }

		local escape = Enum.KeyCode.Escape
		local v25 = if state then focusNavigationEventNameEnum.NavigateBack else nil
		v23[escape] = v25
		v23[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.ToggleGamepadInput
		return v23
	end, { state })
	local v24 = if state then v19 else nil
	local v26 = useTableWrappedCallbackRef((useFocusNavigationBindings(ref, v22, v24, v20)))

	React.useEffect(function()
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if state then
				v21(getInputObjects(), dt)
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
			v6 = {}
		end
	end, { state, v21 })

	React.useEffect(function()
		ref7.current:onStep(v9)
		ref8.current:onStep(v11)

		return function()
			v13()
			ref7.current:destroy()
			ref8.current:destroy()
		end
	end, { v13 })

	local isDisabled = props.isDisabled
	local xScale = props.xScale
	local yScale = props.yScale
	local mapScalesToPosition = props.mapScalesToPosition(xScale, yScale)

	return React.createElement(React.Fragment, nil, {
		Knob = React.createElement(focusable[imageSetLabel], {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(mapScalesToPosition.X, 0, mapScalesToPosition.Y, 0),
			Size = UDim2.fromOffset(30, 30),
			Image = component_assetscircle_29,
			ImageColor3 = isDisabled and pumice2 or v8:map(function(p2)
				return white:lerp(pumice, p2)
			end),
			ImageTransparency = isDisabled and 0.5 or 0,
			Active = true,
			BackgroundTransparency = 1,
			ZIndex = 2,
			[Roact.Event.InputBegan] = v18,
			[Roact.Event.MouseEnter] = v14,
			[Roact.Event.MouseLeave] = v15,
			[Roact.Ref] = v26,
			onFocusLost = v19,
			NextSelectionLeft = state and ref or nil,
			NextSelectionRight = state and ref or nil,
			NextSelectionUp = state and ref or nil,
			NextSelectionDown = state and ref or nil,
			Selectable = true,
			SelectionImageObject = useSelectionCursor(state and cursorKind.SelectedKnob or cursorKind.UnselectedKnob)
		}),
		KnobShadow = Roact.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(mapScalesToPosition.X, 0, mapScalesToPosition.Y, 0),
			Size = UDim2.new(0, 52, 0, 52),
			Image = component_assetsdropshadow_28,
			ImageTransparency = isDisabled and 1 or v12:map(function(p2)
				local lerped = module.lerp(0.5, 0.2, p2.hovered)
				return module.lerp(lerped, 1, p2.pressed)
			end),
			Active = true,
			BackgroundTransparency = 1,
			ZIndex = 1
		})
	})
end
