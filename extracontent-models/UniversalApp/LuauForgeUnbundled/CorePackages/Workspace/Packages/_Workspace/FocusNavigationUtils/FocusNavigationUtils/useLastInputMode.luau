local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local useLastInputMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useLastInputMethod")
local useFocusedTextBox = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useFocusedTextBox")
local vrService = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/MockableProxyServices").VRService
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/SharedFlags")
local fFlagFixSelectionWithWebViews = SharedFlags.FFlagFixSelectionWithWebViews
local fFlagEnableFocusNavTelemetry = SharedFlags.FFlagEnableFocusNavTelemetry

local v5 = {
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
	local v6 = useLastInputMethod()

	local v7 = v5[v6]
	local v8 = useFocusedTextBox()
	local state, setState = React.useState(GamepadService.GamepadCursorEnabled)

	local state2, setState2 = React.useState(false)
	local ref = React.useRef(v6 == "Keyboard" and "Cursor" or v7)

	local ref2 = if fFlagEnableFocusNavTelemetry then React.useRef(nil) else nil

	React.useEffect(function()
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			local v9 = not fFlagFixSelectionWithWebViews or GuiService.CoreGuiNavigationEnabled

			if not set[input.KeyCode] or v8 ~= nil or not v9 then
				setState2(false)

				return
			end

			if fFlagEnableFocusNavTelemetry and ref2 then
				ref2.current = input.KeyCode
			end

			setState2(true)
		end)

		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v8 })
	React.useEffect(function()
		local gamepadCursorEnabledChangedConnection = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function()
			setState(GamepadService.GamepadCursorEnabled)
		end)

		return function()
			gamepadCursorEnabledChangedConnection:Disconnect()
		end
	end, {})
	local v9

	if vrService.VREnabled then
		v9 = "Cursor"
	elseif v6 == "Keyboard" then
		v9 = (state2 or ref.current == "Focus") and "Focus" or "Cursor"
	else
		v9 = v6 == "Gamepad" and (state and "Cursor" or "Focus") or v7
	end

	ref.current = v9

	if fFlagEnableFocusNavTelemetry and ref2 and v9 == "Focus" and v6 == "Keyboard" then
		return "Focus", ref2.current
	end

	return v9
end
