local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local UserInputService = game:GetService("UserInputService")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local React = require(FocusNavigationUtilsParent.React)
local useLastInputMethod = require(script.Parent.useLastInputMethod)
local useFocusedTextBox = require(script.Parent.useFocusedTextBox)
local VRService = require(FocusNavigationUtilsParent.MockableProxyServices).VRService
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local FFlagFixSelectionWithWebViews = require(FocusNavigationUtilsParent.SharedFlags).FFlagFixSelectionWithWebViews
local t1 = {
	Keyboard = "Focus",
	Gamepad = "Focus",
	Mouse = "Cursor",
	Touch = "Cursor",
	None = "None"
}
local t2 = {
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

return function() -- line: 39
	-- upvalues: useLastInputMethod (copy), t1 (copy), useFocusedTextBox (copy), React (copy), GamepadService (copy), UserInputService (copy), FFlagFixSelectionWithWebViews (copy), GuiService (copy), t2 (copy), VRService (copy)
	local v13 = useLastInputMethod()
	local v14 = t1[v13]
	local v15 = useFocusedTextBox()
	local v16, v17 = React.useState(GamepadService.GamepadCursorEnabled)
	local v18, v19 = React.useState(false)
	local v20 = React.useRef(if v13 ~= "Keyboard" then v14 else "Cursor")

	React.useEffect(function() -- line: 49
		-- upvalues: UserInputService (copy), FFlagFixSelectionWithWebViews (copy), GuiService (copy), t2 (copy), v15 (copy), v19 (copy)
		local connection = UserInputService.InputBegan:Connect(function(input) -- line: 50
			-- upvalues: FFlagFixSelectionWithWebViews (copy), GuiService (copy), t2 (copy), v15 (copy), v19 (copy)
			local v24 = not FFlagFixSelectionWithWebViews or GuiService.CoreGuiNavigationEnabled

			if t2[input.KeyCode] and (v15 == nil and v24) then
				v19(true)

				return
			end

			v19(false)
		end)

		return function() -- line: 61
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v15 })
	React.useEffect(function() -- line: 65
		-- upvalues: GamepadService (copy), v17 (copy)
		local connection = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function() -- line: 66
			-- upvalues: v17 (copy), GamepadService (copy)
			v17(GamepadService.GamepadCursorEnabled)
		end)

		return function() -- line: 70
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	if VRService.VREnabled then
		v14 = "Cursor"
	elseif v13 == "Keyboard" then
		v14 = not v18 and v20.current ~= "Focus" and "Cursor" or "Focus"
	elseif v13 == "Gamepad" then
		v14 = not v16 and "Focus" or "Cursor"
	end

	v20.current = v14

	return v14
end
