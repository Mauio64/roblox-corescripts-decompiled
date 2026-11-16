local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local UserInputService = game:GetService("UserInputService")
local parent = FocusNavigationUtils.Parent
local React = require(parent.React)
local useLastInputMethod = require(script.Parent.useLastInputMethod)
local useFocusedTextBox = require(script.Parent.useFocusedTextBox)
local MockableProxyServices = require(parent.MockableProxyServices)
local VRService = MockableProxyServices.VRService
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local SharedFlags = require(parent.SharedFlags)
local FFlagFixSelectionWithWebViews = SharedFlags.FFlagFixSelectionWithWebViews
local FFlagEnableFocusNavTelemetry = SharedFlags.FFlagEnableFocusNavTelemetry

local v = {
	Keyboard = "Focus",
	Gamepad = "Focus",
	Mouse = "Cursor",
	Touch = "Cursor",
	None = "None"
}

local set = {
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Down] = true,
	[Enum.KeyCode.Left] = true,
	[Enum.KeyCode.Right] = true,
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Escape] = true
}

return function()
	local v2 = useLastInputMethod()

	local v3 = v[v2]
	local v4 = useFocusedTextBox()
	local state, setState = React.useState(GamepadService.GamepadCursorEnabled)

	local state2, setState2 = React.useState(false)
	local ref = React.useRef(v2 == "Keyboard" and "Cursor" or v3)
	local ref2

	if FFlagEnableFocusNavTelemetry then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	React.useEffect(function()
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			local v5 = not FFlagFixSelectionWithWebViews or GuiService.CoreGuiNavigationEnabled

			if not set[input.KeyCode] or v4 ~= nil or not v5 then
				setState2(false)

				return
			end

			if FFlagEnableFocusNavTelemetry and ref2 then
				ref2.current = input.KeyCode
			end

			setState2(true)
		end)

		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v4 })
	React.useEffect(function()
		local gamepadCursorEnabledChangedConnection = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function()
			setState(GamepadService.GamepadCursorEnabled)
		end)

		return function()
			gamepadCursorEnabledChangedConnection:Disconnect()
		end
	end, {})
	local current

	if VRService.VREnabled then
		current = "Cursor"
	elseif v2 == "Keyboard" then
		current = (state2 or ref.current == "Focus") and "Focus" or "Cursor"
	else
		current = v2 == "Gamepad" and (state and "Cursor" or "Focus") or v3
	end

	ref.current = current

	if FFlagEnableFocusNavTelemetry and ref2 and current == "Focus" and v2 == "Keyboard" then
		return "Focus", ref2.current
	end

	return current
end
