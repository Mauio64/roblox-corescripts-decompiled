local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local Modules = CoreGui.RobloxGui.Modules
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local useInitializedValue = ReactUtils.useInitializedValue
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Colors = UIBlox.App.Style.Colors
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local FFlagAXFixBodyScaleReduxUpdates = require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates)
local v27 = game:DefineFastFlag("AXFixMissingThumbstickInputObject", false)
local v28 = Images["component_assets/dropshadow_28"]
local v29 = Images["component_assets/circle_29"]
local White = Colors.White
local Pumice = Colors.Pumice
local Pumice2 = Colors.Pumice
local v33 = not FFlagAXFixBodyScaleReduxUpdates and 0.7 or 0.5
local v34 = not FFlagAXFixBodyScaleReduxUpdates and 0.5 or 0.2
local t1 = {
	frequency = 5
}
local t2 = {}

local function getInputObjects() -- line: 63
	-- upvalues: UserInputService (copy), t2 (ref)
	local LastInputType = UserInputService:GetLastInputType()

	if t2[LastInputType] == nil then
		local GamepadState = UserInputService:GetGamepadState(LastInputType)
		local t3 = {}

		for _, v in ipairs(GamepadState) do
			t3[v.KeyCode] = v
		end

		t2[LastInputType] = t3
	end

	return t2[LastInputType]
end
local function useFocusNavigationBindings(p1, p2, p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)) -- line: 80
	-- upvalues: ReactFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v48 = ReactFocusNavigation.useEventMap(p2, p1)
	local v49 = React.useMemo(function() -- line: 87
		-- upvalues: FocusNavigationEventNameEnum (copy), p3 (copy), InputHandlers (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = if not p3 then nil else {
				handler = InputHandlers.onRelease(function(p5) -- line: 91
					-- upvalues: p3 (copy)
					p5.cancelled = true
					p3()
				end)
			},
			[FocusNavigationEventNameEnum.ToggleGamepadInput] = {
				handler = InputHandlers.onRelease(p4)
			}
		}
	end, {
		p3,
		p4
	})

	return ReactFocusNavigation.useEventHandlerMap(v49, v48)
end

return function(t4: {[any]: any}) -- line: 134
	-- upvalues: React (copy), Otter (copy), useInitializedValue (copy), t1 (copy), UserInputService (copy), v27 (copy), GamepadUtils (copy), Utils (copy), FocusNavigationEventNameEnum (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), RunService (copy), getInputObjects (copy), t2 (ref), Focusable (copy), ImageSetLabel (copy), v29 (copy), Pumice2 (copy), White (copy), Pumice (copy), Roact (copy), useSelectionCursor (copy), CursorKind (copy), FFlagAXFixBodyScaleReduxUpdates (copy), v28 (copy), v33 (copy), v34 (copy)
	local v51, v52 = React.useState(false)
	local v53 = React.useRef(nil)
	local v54 = React.useRef(nil)
	local v55 = React.useRef(nil)
	local v56 = React.useRef(0)
	local v57 = React.useRef(0)
	local v58 = React.useRef(true)
	local v59 = React.useRef(Otter.createSingleMotor(0))
	local v60 = React.useRef(Otter.createSingleMotor(0))
	local v61, v62 = React.useBinding(0)
	local v63, v64 = React.useBinding(0)
	local v65 = useInitializedValue(function() -- line: 148
		-- upvalues: React (copy), v61 (copy), v63 (copy)
		return React.joinBindings({
			pressed = v61,
			hovered = v63
		})
	end)
	local v66 = React.useCallback(function() -- line: 155
		-- upvalues: v54 (copy), v55 (copy)
		if v54.current then
			v54.current:Disconnect()
			v54.current = nil
		end

		if v55.current then
			v55.current:Disconnect()
			v55.current = nil
		end
	end, {})
	local v67 = React.useCallback(function() -- line: 166
		-- upvalues: v60 (copy), Otter (copy), t1 (copy)
		v60.current:setGoal(Otter.spring(1, t1))
	end, {})
	local v68 = React.useCallback(function() -- line: 170
		-- upvalues: v60 (copy), Otter (copy), t1 (copy)
		v60.current:setGoal(Otter.spring(0, t1))
	end, {})
	local v69 = React.useCallback(function(p6) -- line: 174
		-- upvalues: t4 (copy)
		if p6.UserInputType ~= Enum.UserInputType.MouseMovement and p6.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local v83 = t4.getBackgroundAbsolutePosition()
		local v84 = t4.getBackgroundAbsoluteSize()

		if v83 and v84 then
			local p6Position = p6.Position
			local vector2 = Vector2.new((p6Position.X - v83.X) / v84.X, (p6Position.Y - v83.Y) / v84.Y)

			t4.setScales(t4.mapPositionToScales(vector2))
		end
	end, {
		t4.getBackgroundAbsolutePosition,
		t4.getBackgroundAbsoluteSize,
		t4.setScales,
		t4.mapPositionToScales
	})
	local v70 = React.useCallback(function(p7) -- line: 202
		-- upvalues: t4 (copy), v66 (copy), v59 (copy), Otter (copy), t1 (copy)
		if p7.UserInputType ~= Enum.UserInputType.MouseButton1 and p7.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if t4.onDragEnd then
			t4.onDragEnd()
		end

		v66()
		v59.current:setGoal(Otter.spring(0, t1))
	end, {
		t4.onDragEnd,
		v66
	})
	local v71 = React.useCallback(function(_, p9) -- line: 220
		-- upvalues: t4 (copy), v54 (copy), UserInputService (copy), v69 (copy), v55 (copy), v70 (copy), v59 (copy), Otter (copy), t1 (copy)
		local v90 = p9.UserInputState == Enum.UserInputState.Begin and (p9.UserInputType == Enum.UserInputType.MouseButton1 or p9.UserInputType == Enum.UserInputType.Touch)

		if t4.isDisabled or (v54.current or not v90) then
			return
		end

		if t4.onDragStart then
			t4.onDragStart()
		end

		v54.current = UserInputService.InputChanged:connect(v69)
		v55.current = UserInputService.InputEnded:connect(v70)
		v59.current:setGoal(Otter.spring(1, t1))
	end, {
		t4.isDisabled,
		t4.onDragStart,
		v69,
		v70
	})
	local v72 = React.useCallback(function() -- line: 239
		-- upvalues: v52 (copy)
		v52(false)
	end, {})
	local v73 = React.useCallback(function(_) -- line: 243
		-- upvalues: v51 (copy), v52 (copy), t4 (copy)
		if v51 then
			v52(false)

			return
		end

		if not t4.isDisabled then
			v52(true)
		end
	end, {
		v51,
		t4.isDisabled
	})
	local v74 = React.useCallback(function(p11, p12) -- line: 251
		-- upvalues: v27 (copy), GamepadUtils (copy), t4 (copy), v56 (copy), v57 (copy), v58 (copy), Utils (copy)
		local v94 = p11[Enum.KeyCode.Thumbstick1]
		local v95 = if not v27 then GamepadUtils.normalizeStickByDeadzone(p11[Enum.KeyCode.Thumbstick1].Position) else if not v94 then Vector2.new(0, 0) else GamepadUtils.normalizeStickByDeadzone(v94.Position)
		local v96 = v95 ~= Vector2.new(0, 0)
		local v101, v102, v103, v104

		if v27 then
			local v97 = p11[Enum.KeyCode.DPadLeft]
			local v98 = p11[Enum.KeyCode.DPadRight]
			local v99 = p11[Enum.KeyCode.DPadUp]
			local v100 = p11[Enum.KeyCode.DPadDown]

			v101 = (not v97 or v97.Position.z ~= 1) and 0 or -1
			v102 = (not v98 or v98.Position.z ~= 1) and 0 or 1
			v103 = (not v99 or v99.Position.z ~= 1) and 0 or 1
			v104 = (not v100 or v100.Position.z ~= 1) and 0 or -1
		else
			v101 = p11[Enum.KeyCode.DPadLeft].Position.z ~= 1 and 0 or -1
			v102 = p11[Enum.KeyCode.DPadRight].Position.z ~= 1 and 0 or 1
			v103 = p11[Enum.KeyCode.DPadUp].Position.z ~= 1 and 0 or 1
			v104 = p11[Enum.KeyCode.DPadDown].Position.z ~= 1 and 0 or -1
		end

		local vector2 = Vector2.new(v101 + v102, v103 + v104)
		local xScale = t4.xScale
		local yScale = t4.yScale
		local v108 = xScale
		local v109 = yScale

		if v96 then
			v56.current = v56.current + p12

			local v110 = t4.mapScalesToPosition(xScale, yScale)
			local vector2_2 = Vector2.new(v95.x, -v95.y)

			v108, v109 = t4.mapPositionToScales(v110 + vector2_2 * 1 * p12)
			v57.current = 0
			v58.current = false
		elseif vector2 ~= Vector2.new(0, 0) then
			v56.current = v56.current + p12

			local n1

			if v58.current then
				n1 = 1
				v57.current = 0
				v58.current = false
			elseif v56.current > 0.2 then
				local v113 = p12 - math.max(0.2 - (v56.current - p12), 0) + v57.current

				n1 = math.floor(8 * v113)
				v57.current = v113 - n1 / 8
			else
				n1 = 0
				v57.current = 0
			end

			local vector2_3 = Vector2.new(not t4.invertDPadX and 1 or -1, not t4.invertDPadY and 1 or -1)
			local v115 = n1 - 1 + 0.51

			if vector2.x == 0 then
				v108 = xScale
			else
				local xScaleRules = t4.xScaleRules
				local v117 = xScale + vector2.x * vector2_3.x * xScaleRules.increment * v115

				v108 = math.clamp(xScaleRules.min + Utils.Round(v117 - xScaleRules.min, xScaleRules.increment), xScaleRules.min, xScaleRules.max)
			end

			if vector2.y == 0 then
				v109 = yScale
			else
				local yScaleRules = t4.yScaleRules
				local v119 = yScale + vector2.y * vector2_3.y * yScaleRules.increment * v115

				v109 = math.clamp(yScaleRules.min + Utils.Round(v119 - yScaleRules.min, yScaleRules.increment), yScaleRules.min, yScaleRules.max)
			end
		else
			v56.current = 0
			v57.current = 0
			v58.current = true
		end

		if v108 ~= xScale or v109 ~= yScale then
			t4.setScales(v108, v109)
		end
	end, {
		t4.xScale,
		t4.yScale,
		t4.mapScalesToPosition,
		t4.mapPositionToScales,
		t4.invertDPadX,
		t4.invertDPadY,
		t4.xScaleRules,
		t4.yScaleRules,
		t4.setScales
	})
	local v75 = React.useMemo(function() -- line: 362
		-- upvalues: v51 (copy), FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonB] = if not v51 then nil else FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.Escape] = if not v51 then nil else FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.ToggleGamepadInput
		}
	end, { v51 })
	local v76 = useFocusNavigationBindings(v53, v75, if not v51 then nil else v72, v73)
	local v77 = useTableWrappedCallbackRef(v76)

	React.useEffect(function() -- line: 374
		-- upvalues: RunService (copy), v51 (copy), v74 (copy), getInputObjects (copy), t2 (ref)
		local connection = RunService.Heartbeat:Connect(function(dt) -- line: 375
			-- upvalues: v51 (copy), v74 (copy), getInputObjects (copy)
			if v51 then
				v74(getInputObjects(), dt)
			end
		end)

		return function() -- line: 381
			-- upvalues: connection (copy), t2 (ref)
			connection:Disconnect()
			t2 = {}
		end
	end, {
		v51,
		v74
	})
	React.useEffect(function() -- line: 387
		-- upvalues: v59 (copy), v62 (copy), v60 (copy), v64 (copy), v66 (copy)
		v59.current:onStep(v62)
		v60.current:onStep(v64)

		return function() -- line: 391
			-- upvalues: v66 (copy), v59 (copy), v60 (copy)
			v66()
			v59.current:destroy()
			v60.current:destroy()
		end
	end, { v66 })

	local isDisabled = t4.isDisabled
	local xScale = t4.xScale
	local yScale = t4.yScale
	local v81 = t4.mapScalesToPosition(xScale, yScale)

	return React.createElement(React.Fragment, nil, {
		Knob = React.createElement(Focusable[ImageSetLabel], {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(v81.X, 0, v81.Y, 0),
			Size = UDim2.fromOffset(30, 30),
			Image = v29,
			ImageColor3 = isDisabled and Pumice2 or v61:map(function(p13) -- line: 409
				-- upvalues: White (copy), Pumice (copy)
				return White:lerp(Pumice, p13)
			end),
			ImageTransparency = not isDisabled and 0 or 0.5,
			Active = true,
			BackgroundTransparency = 1,
			ZIndex = 2,
			[Roact.Event.InputBegan] = v71,
			[Roact.Event.MouseEnter] = v67,
			[Roact.Event.MouseLeave] = v68,
			[Roact.Ref] = v77,
			onFocusLost = v72,
			NextSelectionLeft = v51 and v53 or nil,
			NextSelectionRight = v51 and v53 or nil,
			NextSelectionUp = v51 and v53 or nil,
			NextSelectionDown = v51 and v53 or nil,
			Selectable = true,
			SelectionImageObject = useSelectionCursor(v51 and CursorKind.SelectedKnob or CursorKind.UnselectedKnob)
		}),
		KnobShadow = Roact.createElement(ImageSetLabel, {
			Active = true,
			BackgroundTransparency = 1,
			ZIndex = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(v81.X, 0, v81.Y, 0),
			Size = if not FFlagAXFixBodyScaleReduxUpdates then UDim2.new(0, 48, 0, 48) else UDim2.new(0, 52, 0, 52),
			Image = v28,
			ImageTransparency = if not isDisabled then v65:map(function(p14) -- line: 441
				-- upvalues: Utils (copy), v33 (copy), v34 (copy)
				local v123 = Utils.lerp(v33, v34, p14.hovered)

				return Utils.lerp(v123, 1, p14.pressed)
			end) else 1
		})
	})
end
