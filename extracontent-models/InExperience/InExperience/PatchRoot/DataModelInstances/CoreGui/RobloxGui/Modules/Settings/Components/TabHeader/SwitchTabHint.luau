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

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagGamepadIconSupportCheck = SharedFlags.FFlagGamepadIconSupportCheck
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local function getSupportsButton(keycode)
	if FFlagGamepadIconSupportCheck then
		return UserInputService:GamepadSupports(UserInputService:GetLastInputType(), keycode)
	end

	return true
end

local function isPreferredInputTypeGamepad() -- 2 equivalent calls inferred from this helper
	return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
		or FFlagLuaSupportMicroGamepadPreferredInput
		and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
end

local function isPlayStationGamepad(): boolean -- 2 equivalent calls inferred from this helper
	return UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross"
end

local function SwitchTabHint(p, ref)
	local v = useTokens()
	local state, setState = React.useState(getSupportsButton(p.keycode))
	local state2, setState2 = React.useState(isPlayStationGamepad()) -- inferred equivalent call
	local visible, v2 = React.useBinding(isPreferredInputTypeGamepad()) -- inferred equivalent call
	useEventConnection(UserInputService:GetPropertyChangedSignal("PreferredInput"), function()
		v2(isPreferredInputTypeGamepad()) -- inferred equivalent call
		setState2(isPlayStationGamepad()) -- inferred equivalent call
	end, {})

	if FFlagGamepadIconSupportCheck then
		useEventConnection(UserInputService.LastInputTypeChanged, function()
			setState(getSupportsButton(p.keycode))
		end, {})
	end

	local name = React.useMemo(function()
		if state2 then
			return HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION[p.keycode]
		end

		return HELP_PAGE.GAMEPAD_ICON_MAP_XBOX[p.keycode]
	end, { p.keycode, state2 })

	if state then
		return (React.createElement(Icon, {
			name = name,
			size = v.Size.Size_800,
			Visible = visible,
			ref = ref
		}))
	end

	return nil
end

return React.memo(React.forwardRef(SwitchTabHint))
