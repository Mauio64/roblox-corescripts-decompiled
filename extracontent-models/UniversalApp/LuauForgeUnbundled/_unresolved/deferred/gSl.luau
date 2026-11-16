local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReactUtils = require(CorePackages.Packages.ReactUtils)

local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local gamepadUtils = require("@luauforge/bundled/fuE").Gamepad.GamepadUtils
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/fuD")
local useInitializedValue = ReactUtils.useInitializedValue
local useEventCallback = ReactUtils.useEventCallback

local module2 = require("@luauforge/bundled/eeo")
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

local module3 = require("@luauforge/bundled/gSi")
local defineFastFlag = game:DefineFastFlag("AXFixMissingThumbstickInputObject", false)

local component_assetsdropshadow_28 = images["component_assets/dropshadow_28"]
local component_assetscircle_29 = images["component_assets/circle_29"]

local white = colors.White
local pumice = colors.Pumice
local pumice2 = colors.Pumice
local v5 = module3 and 0.5 or 0.7
local v6 = module3 and 0.2 or 0.5
local v7 = { frequency = 5 }

local v8 = {}
local function getInputObjects()
	local lastInputType = UserInputService:GetLastInputType()

	if v8[lastInputType] ~= nil then
		return v8[lastInputType]
	end

	local gamepadState = UserInputService:GetGamepadState(lastInputType)
	local v9 = {}

	for i, v10 in ipairs(gamepadState) do
		v9[v10.KeyCode] = v10
	end

	v8[lastInputType] = v9

	return v8[lastInputType]
end

local function useFocusNavigationBindings(p2, p3, callback, p4)
	local v9 = ReactFocusNavigation.useEventMap(p3, p2)
	local v10 = React.useMemo(function()
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
	return ReactFocusNavigation.useEventHandlerMap(v10, v9)
end

function LUAUFORGE_MODULE_GLOBALS_gSl_getSliderDragInputSource(p2, p3)
	local parent = p2.Parent

	if p3 and parent and parent:IsA("GuiObject") then
		return parent
	end

	return UserInputService
end

return function(props)
	local state, setState = React.useState(false)
	local v9 = useIsSpatial()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(true)
	local ref7 = React.useRef(Otter.createSingleMotor(0))
	local ref8 = React.useRef(Otter.createSingleMotor(0))

	local v10, v11 = React.useBinding(0)
	local v12, v13 = React.useBinding(0)
	local v14 = useInitializedValue(function()
		return React.joinBindings({ pressed = v10, hovered = v12 })
	end)

	local v15 = React.useCallback(function()
		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end

		if ref3.current then
			ref3.current:Disconnect()
			ref3.current = nil
		end
	end, {})

	local v16 = React.useCallback(function()
		ref8.current:setGoal(Otter.spring(1, v7))
	end, {})

	local v17 = React.useCallback(function()
		ref8.current:setGoal(Otter.spring(0, v7))
	end, {})

	local v18 = React.useCallback(function(p2)
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

	local v19 = useEventCallback(function(p2)
		if
			p2.UserInputType ~= Enum.UserInputType.MouseButton1
			and p2.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		if props.onDragEnd then
			props.onDragEnd()
		end

		v15()
		ref7.current:setGoal(Otter.spring(0, v7))
	end)

	local v20 = React.useCallback(function(p2, p3)
		local v21

		if p3.UserInputState == Enum.UserInputState.Begin then
			v21 = p3.UserInputType == Enum.UserInputType.MouseButton1
				or p3.UserInputType == Enum.UserInputType.Touch
		else
			v21 = false
		end

		if props.isDisabled or ref2.current or not v21 then
			return
		end

		if props.onDragStart then
			props.onDragStart()
		end

		ref2.current = LUAUFORGE_MODULE_GLOBALS_gSl_getSliderDragInputSource(p2, v9).InputChanged:Connect(v18)
		ref3.current = UserInputService.InputEnded:connect(v19)
		ref7.current:setGoal(Otter.spring(1, v7))
	end, { props.isDisabled, props.onDragStart, v18, v19, v9 })

	local v21 = React.useCallback(function()
		setState(false)
	end, {})

	local v22 = React.useCallback(function(p2)
		if state then
			setState(false)
		elseif not props.isDisabled then
			setState(true)
		end
	end, { state, props.isDisabled })

	local v23 = React.useCallback(function(p2, p3)
		local v24 = p2[Enum.KeyCode.Thumbstick1]
		local v25

		if defineFastFlag then
			v25 = if v24 then gamepadUtils.normalizeStickByDeadzone(v24.Position) else Vector2.new(0, 0)
		else
			v25 = gamepadUtils.normalizeStickByDeadzone(p2[Enum.KeyCode.Thumbstick1].Position)
		end

		local v26 = v25 ~= Vector2.new(0, 0)
		local v27, v28, v29, v30

		if defineFastFlag then
			local v31 = p2[Enum.KeyCode.DPadLeft]
			local v32 = p2[Enum.KeyCode.DPadRight]
			local v33 = p2[Enum.KeyCode.DPadUp]
			local v34 = p2[Enum.KeyCode.DPadDown]
			v27 = v31 and v31.Position.z == 1 and -1 or 0
			v28 = v32 and v32.Position.z == 1 and 1 or 0
			v29 = v33 and v33.Position.z == 1 and 1 or 0
			v30 = if v34 and v34.Position.z == 1 then -1 else 0
		else
			v27 = p2[Enum.KeyCode.DPadLeft].Position.z == 1 and -1 or 0
			v28 = p2[Enum.KeyCode.DPadRight].Position.z == 1 and 1 or 0
			v29 = p2[Enum.KeyCode.DPadUp].Position.z == 1 and 1 or 0
			v30 = p2[Enum.KeyCode.DPadDown].Position.z == 1 and -1 or 0
		end

		local vector2 = Vector2.new(v27 + v28, v29 + v30)

		local xScale = props.xScale
		local yScale = props.yScale
		local v31, v32

		if v26 then
			ref4.current += p3

			local mapScalesToPosition = props.mapScalesToPosition(xScale, yScale)
			local vector2_2 = Vector2.new(v25.x, -v25.y)

			v31, v32 = props.mapPositionToScales(mapScalesToPosition + vector2_2 * 1 * p3)

			ref5.current = 0
			ref6.current = false
		elseif vector2 == Vector2.new(0, 0) then
			ref4.current = 0
			ref5.current = 0
			ref6.current = true
			v32 = yScale
			v31 = xScale
		else
			ref4.current += p3
			local v33

			if ref6.current then
				ref5.current = 0
				ref6.current = false
				v33 = 1
			elseif ref4.current > 0.2 then
				local v34 = p3 - math.max(0.2 - (ref4.current - p3), 0) + ref5.current
				v33 = math.floor(8 * v34)

				ref5.current = v34 - v33 / 8
			else
				ref5.current = 0
				v33 = 0
			end

			local vector2_2 = Vector2.new(props.invertDPadX and -1 or 1, props.invertDPadY and -1 or 1)
			local v34 = v33 - 1 + 0.51

			if vector2.x == 0 then
				v31 = xScale
			else
				local xScaleRules = props.xScaleRules
				local v35 = xScale + vector2.x * vector2_2.x * xScaleRules.increment * v34
				v31 = math.clamp(
					xScaleRules.min + module.Round(v35 - xScaleRules.min, xScaleRules.increment),
					xScaleRules.min,
					xScaleRules.max
				)
			end

			if vector2.y == 0 then
				v32 = yScale
			else
				local yScaleRules = props.yScaleRules
				local v35 = yScale + vector2.y * vector2_2.y * yScaleRules.increment * v34
				v32 = math.clamp(
					yScaleRules.min + module.Round(v35 - yScaleRules.min, yScaleRules.increment),
					yScaleRules.min,
					yScaleRules.max
				)
			end
		end

		if v31 ~= xScale or v32 ~= yScale then
			props.setScales(v31, v32)
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

	local v24 = React.useMemo(function()
		local buttonB = Enum.KeyCode.ButtonB
		local v26 = if state then focusNavigationEventNameEnum.NavigateBack else nil
		local v25 = { [buttonB] = v26 }

		local escape = Enum.KeyCode.Escape
		local v27 = if state then focusNavigationEventNameEnum.NavigateBack else nil
		v25[escape] = v27
		v25[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.ToggleGamepadInput
		return v25
	end, { state })
	local v26 = if state then v21 else nil
	local v27 = useTableWrappedCallbackRef((useFocusNavigationBindings(ref, v24, v26, v22)))

	React.useEffect(function()
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if state then
				v23(getInputObjects(), dt)
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
			v8 = {}
		end
	end, { state, v23 })

	React.useEffect(function()
		ref7.current:onStep(v11)
		ref8.current:onStep(v13)

		return function()
			v15()
			ref7.current:destroy()
			ref8.current:destroy()
		end
	end, { v15 })

	local isDisabled = props.isDisabled
	local xScale = props.xScale
	local yScale = props.yScale
	local mapScalesToPosition = props.mapScalesToPosition(xScale, yScale)

	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		Knob = React.createElement(focusable[imageSetLabel], {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(mapScalesToPosition.X, 0, mapScalesToPosition.Y, 0),
			Size = UDim2.fromOffset(30, 30),
			Image = component_assetscircle_29,
			ImageColor3 = isDisabled and pumice2 or v10:map(function(p2)
				return white:lerp(pumice, p2)
			end),
			ImageTransparency = isDisabled and 0.5 or 0,
			Active = true,
			BackgroundTransparency = 1,
			ZIndex = 2,
			[Roact.Event.InputBegan] = v20,
			[Roact.Event.MouseEnter] = v16,
			[Roact.Event.MouseLeave] = v17,
			[Roact.Ref] = v27,
			onFocusLost = v21,
			NextSelectionLeft = state and ref or nil,
			NextSelectionRight = state and ref or nil,
			NextSelectionUp = state and ref or nil,
			NextSelectionDown = state and ref or nil,
			Selectable = true,
			SelectionImageObject = useSelectionCursor(state and cursorKind.SelectedKnob or cursorKind.UnselectedKnob)
		}),
		KnobShadow = 0
	}

	local createElement3 = Roact.createElement
	local v32 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(mapScalesToPosition.X, 0, mapScalesToPosition.Y, 0),
		Size = 0,
		Image = 0,
		ImageTransparency = 0,
		Active = true,
		BackgroundTransparency = 1,
		ZIndex = 1
	}
	local v33 = if module3 then UDim2.new(0, 52, 0, 52) else UDim2.new(0, 48, 0, 48)
	v32.Size = v33
	v32.Image = component_assetsdropshadow_28
	v32.ImageTransparency = isDisabled and 1 or v14:map(function(p2)
		local lerped = module.lerp(v5, v6, p2.hovered)
		return module.lerp(lerped, 1, p2.pressed)
	end)
	children.KnobShadow = createElement3(imageSetLabel, v32)
	return createElement(fragment, nil, children)
end
