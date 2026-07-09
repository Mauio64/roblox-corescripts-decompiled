local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local useDescendantHasFocus = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useDescendantHasFocus
local AnimatedScrollingFrame = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AnimatedScrollingFrame.AnimatedScrollingFrame
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Display = require(CorePackages.Workspace.Packages.Display)
local GetFFlagAXItemDetailsScrollingEnabledCallback = require(CoreGui.RobloxGui.Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsScrollingEnabledCallback)
local FFlagAXScrollingFramesShouldAnimateOnFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXScrollingFramesShouldAnimateOnFocus
local v14 = game:DefineFastFlag("AXMigrateItemDetailsFullToAutoFocus", false)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local uDim = UDim.new(1, 0)

local function v17() -- line: 44
	return nil
end

return function(t1: {[any]: any}) -- line: 48
	-- upvalues: v17 (copy), React (copy), useDescendantHasFocus (copy), GamepadUtils (copy), uDim (copy), RunService (copy), UserInputService (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), Roact (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy), AnimatedScrollingFrame (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), v14 (copy)
	local renderContent = t1.renderContent
	local v20 = t1.renderTopBar or v17
	local v21 = t1.renderBottomBar or v17
	local v22 = t1.topBarHeight or 0
	local v23 = t1.bottomBarHeight or 0
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26 = useDescendantHasFocus(v25.current)
	local v27 = React.useCallback(function(p1, n1: number) -- line: 58
		-- upvalues: v26 (copy), v24 (copy), GamepadUtils (copy), uDim (copy)
		if not v26 then
			return
		end

		local vector2 = Vector2.new(p1.Position.X, p1.Position.Y)
		local current = v24.current

		if current then
			local v33 = current.CanvasPosition.Y + n1 * -GamepadUtils.normalizeStickByDeadzone(vector2).Y * 1000

			if v33 <= current.AbsoluteSize.Y * uDim.Scale + uDim.Offset then
				current.CanvasPosition = Vector2.new(0, v33)
			end
		end
	end, { v26 })

	React.useEffect(function() -- line: 78
		-- upvalues: RunService (copy), v27 (copy), UserInputService (copy)
		local u34 = nil
		local connection = RunService.Heartbeat:Connect(function(dt) -- line: 80
			-- upvalues: u34 (ref), v27 (copy)
			if u34 and u34.KeyCode == Enum.KeyCode.Thumbstick2 then
				v27(u34, dt)
			end
		end)
		local connection2 = UserInputService.InputChanged:Connect(function(input, _) -- line: 85
			-- upvalues: u34 (ref)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if input.UserInputState == Enum.UserInputState.Change then
					u34 = input

					return
				end

				if input.UserInputState == Enum.UserInputState.End then
					u34 = nil
				end
			end
		end)

		return function() -- line: 95
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { v27 })

	local v28 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t1.viewSize,
		Position = t1.viewPosition,
		[Roact.Ref] = v25
	}, {
		TopBar = v20(),
		ScrollingContent = Roact.createElement(not FFlagAXScrollingFramesShouldAnimateOnFocus and "ScrollingFrame" or AnimatedScrollingFrame, {
			ScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else t1.scrollingEnabled,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, not FFlagEnableLeftNavOnConsole and 0 or v28.right, 1, -(v22 + v23)),
			Position = UDim2.new(0, 0, 0, v22),
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			[Roact.Ref] = v24,
			Selectable = not v14 and nil
		}, {
			Content = renderContent()
		}),
		BottomBar = v21()
	})
end
