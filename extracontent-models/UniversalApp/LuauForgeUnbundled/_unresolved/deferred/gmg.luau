local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local gamepadUtils = require("@luauforge/bundled/fuE").Gamepad.GamepadUtils
local useDescendantHasFocus = require("@luauforge/bundled/eeo").useDescendantHasFocus
local animatedScrollingFrame = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AnimatedScrollingFrame.AnimatedScrollingFrame
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/dUd")

local module2 = require("@luauforge/deferred/glj")

local fFlagAXItemDetailsSdui = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemDetailsSdui

local udim = UDim.new(1, 0)

local function fn(): nil
	return nil
end

return function(props)
	local renderContent = props.renderContent
	local renderTopBar = props.renderTopBar or fn
	local renderBottomBar = props.renderBottomBar or fn
	local topBarHeight = props.topBarHeight or 0
	local bottomBarHeight = props.bottomBarHeight or 0
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v5 = useDescendantHasFocus(ref2.current)

	local useCallback = React.useCallback
	local function fn2(p2, p3)
		if not v5 then
			return
		end

		local vector2 = Vector2.new(p2.Position.X, p2.Position.Y)

		local current = if fFlagAXItemDetailsSdui then (props.scrollingFrameRef or ref).current else ref.current

		if current then
			local v6 = current.CanvasPosition.Y + p3 * -gamepadUtils.normalizeStickByDeadzone(vector2).Y * 1000

			if v6 <= current.AbsoluteSize.Y * udim.Scale + udim.Offset then
				current.CanvasPosition = Vector2.new(0, v6)
			end
		end
	end
	local v7 = if fFlagAXItemDetailsSdui then props.scrollingFrameRef else nil
	local v8 = useCallback(fn2, { v5, v7 })

	React.useEffect(function()
		local v9 = nil
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if v9 and v9.KeyCode == Enum.KeyCode.Thumbstick2 then
				v8(v9, dt)
			end
		end)
		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if input.UserInputState == Enum.UserInputState.Change then
					v9 = input
				elseif input.UserInputState == Enum.UserInputState.End then
					v9 = nil
				end
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
			inputChangedConnection:Disconnect()
		end
	end, { v8 })

	local v9 = useSignalState(module.GetDisplayStore().getDeviceSafePadding)

	local createElement = Roact.createElement
	local refsByRef = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = props.viewSize,
		Position = props.viewPosition,
		[Roact.Ref] = ref2
	}
	local v11 = { TopBar = renderTopBar(), ScrollingContent = 0, BottomBar = 0 }
	local createElement2 = Roact.createElement
	local v14 = if module2() then props.scrollingEnabled else nil
	local v13 = {
		ScrollingEnabled = v14,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, v9.right, 1, -(topBarHeight + bottomBarHeight)),
		Position = UDim2.new(0, 0, 0, topBarHeight),
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		ref = 0,
		Selectable = false
	}

	local v15 = if fFlagAXItemDetailsSdui then props.scrollingFrameRef or ref else ref
	v13.ref = v15
	v11.ScrollingContent = createElement2(animatedScrollingFrame, v13, {
		Content = renderContent()
	})

	v11.BottomBar = renderBottomBar()
	return createElement("Frame", refsByRef, v11)
end
