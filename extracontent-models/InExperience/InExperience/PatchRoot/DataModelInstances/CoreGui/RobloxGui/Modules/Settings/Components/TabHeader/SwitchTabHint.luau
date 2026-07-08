local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local Foundation = require(CorePackages.Packages.Foundation)
local HelpPage = require(CorePackages.Workspace.Packages.HelpPage)
local useEventConnection = ReactUtils.useEventConnection
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local HELP_PAGE = HelpPage.Constants.HELP_PAGE
local FFlagGamepadIconSupportCheck = require(CorePackages.Workspace.Packages.SharedFlags).FFlagGamepadIconSupportCheck

local function getSupportsButton(p1) -- line: 22
	-- upvalues: FFlagGamepadIconSupportCheck (copy), UserInputService (copy)
	if not FFlagGamepadIconSupportCheck then
		return true
	end

	return UserInputService:GamepadSupports(UserInputService:GetLastInputType(), p1)
end
local function isPreferredInputTypeGamepad() -- line: 29
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end
local function isPlayStationGamepad() -- line: 33
	-- upvalues: UserInputService (copy)
	return UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross"
end
local function SwitchTabHint(t1: {[any]: any}, p2) -- line: 38
	-- upvalues: useTokens (copy), React (copy), getSupportsButton (copy), UserInputService (copy), useEventConnection (copy), FFlagGamepadIconSupportCheck (copy), HELP_PAGE (copy), Icon (copy)
	local v19 = useTokens()
	local v20, v21 = React.useState(getSupportsButton(t1.keycode))
	local v22, v23 = React.useState(UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross")
	local v24, v25 = React.useBinding(UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)

	useEventConnection(UserInputService:GetPropertyChangedSignal("PreferredInput"), function() -- line: 43
		-- upvalues: v25 (copy), UserInputService (copy), v23 (copy)
		v25(UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)
		v23(UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross")
	end, {})

	if FFlagGamepadIconSupportCheck then
		useEventConnection(UserInputService.LastInputTypeChanged, function() -- line: 48
			-- upvalues: v21 (copy), getSupportsButton (copy), t1 (copy)
			v21(getSupportsButton(t1.keycode))
		end, {})
	end

	local v26 = React.useMemo(function() -- line: 53
		-- upvalues: v22 (copy), HELP_PAGE (copy), t1 (copy)
		if v22 then
			return HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION[t1.keycode]
		end

		return HELP_PAGE.GAMEPAD_ICON_MAP_XBOX[t1.keycode]
	end, {
		t1.keycode,
		v22
	})

	if v20 then
		return (React.createElement(Icon, {
			name = v26,
			size = v19.Size.Size_800,
			Visible = v24,
			ref = p2
		}))
	end

	return nil
end

return React.memo(React.forwardRef(SwitchTabHint))
