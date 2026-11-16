local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local InputTypesEnum = require(parent.Enums.InputTypesEnum)
local Responsive = require(parent2.Responsive)
local KeyboardHelpPage = require(parent.Components.Keyboard.KeyboardHelpPage)
local GamepadHelpPage = require(parent.Components.Gamepad.GamepadHelpPage)
local TouchHelpPage = require(parent.Components.Touch.TouchHelpPage)
local CCLTouchHelpPageContainer = require(parent.Components.Touch.CCLTouchHelpPage.CCLTouchHelpPageContainer)
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)
local HelpPageTelemetry = require(parent.Telemetry.HelpPageTelemetry)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
require(parent2.RobloxAppEnums)

local View = Foundation.View
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation

local function HelpPageContainer()
	local v = Responsive.useLastInput()
	local v2 = Responsive.useIsSpatial()
	local v3 = Responsive.usePreferredInput()
	local last_input_type

	if v2 then
		last_input_type = InputTypesEnum.InputType.SPATIAL_GAMEPAD
	else
		if v ~= nil then
			v3 = v
		end

		if v3 == Responsive.Input.Pointer then
			last_input_type = InputTypesEnum.InputType.KEYBOARD
		elseif v3 == Responsive.Input.Directional then
			last_input_type = InputTypesEnum.InputType.GAMEPAD
		elseif v3 == Responsive.Input.Touch then
			last_input_type = InputTypesEnum.InputType.TOUCH
		else
			last_input_type = InputTypesEnum.InputType.KEYBOARD
		end
	end

	local orientation = useDeviceOrientation()

	React.useEffect(function()
		HelpPageTelemetry.default:logHelpPageInteraction("Help_Interaction", {
			orientation = orientation,
			last_input_type = last_input_type
		})
	end, { orientation, last_input_type })

	if last_input_type == InputTypesEnum.InputType.KEYBOARD then
		return React.createElement(KeyboardHelpPage)
	end

	if
		last_input_type == InputTypesEnum.InputType.GAMEPAD
		or last_input_type == InputTypesEnum.InputType.SPATIAL_GAMEPAD
	then
		return React.createElement(GamepadHelpPage, {
			isSpatial = last_input_type == InputTypesEnum.InputType.SPATIAL_GAMEPAD
		})
	end

	if last_input_type ~= InputTypesEnum.InputType.TOUCH then
		return React.createElement(View, nil, {})
	end

	local createElement = React.createElement
	local v4

	if FFlagHelpPageCCL then
		v4 = CCLTouchHelpPageContainer
	else
		v4 = TouchHelpPage
	end

	return createElement(v4)
end

return React.memo(HelpPageContainer)
