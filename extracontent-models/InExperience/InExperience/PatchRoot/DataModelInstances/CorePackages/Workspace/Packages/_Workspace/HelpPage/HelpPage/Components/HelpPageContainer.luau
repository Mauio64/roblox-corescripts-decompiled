local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local InputTypesEnum = require(ParentParent.Enums.InputTypesEnum)
local Responsive = require(ParentParentParent.Responsive)
local KeyboardHelpPage = require(ParentParent.Components.Keyboard.KeyboardHelpPage)
local GamepadHelpPage = require(ParentParent.Components.Gamepad.GamepadHelpPage)
local TouchHelpPage = require(ParentParent.Components.Touch.TouchHelpPage)
local HelpPageTelemetry = require(ParentParent.Telemetry.HelpPageTelemetry)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)

require(ParentParentParent.RobloxAppEnums)

local View = Foundation.View
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation

local function HelpPageContainer() -- line: 43
	-- upvalues: Responsive (copy), InputTypesEnum (copy), useDeviceOrientation (copy), React (copy), HelpPageTelemetry (copy), KeyboardHelpPage (copy), GamepadHelpPage (copy), TouchHelpPage (copy), View (copy)
	local v18 = Responsive.useLastInput()
	local v19 = Responsive.useIsSpatial()
	local v20 = Responsive.usePreferredInput()
	local SPATIAL_GAMEPAD

	if v19 then
		SPATIAL_GAMEPAD = InputTypesEnum.InputType.SPATIAL_GAMEPAD
	else
		if v18 == nil then
			v18 = v20
		end

		SPATIAL_GAMEPAD = if v18 ~= Responsive.Input.Pointer then if v18 ~= Responsive.Input.Directional then if v18 ~= Responsive.Input.Touch then InputTypesEnum.InputType.KEYBOARD else InputTypesEnum.InputType.TOUCH else InputTypesEnum.InputType.GAMEPAD else InputTypesEnum.InputType.KEYBOARD
	end

	local v22 = SPATIAL_GAMEPAD
	local v23 = useDeviceOrientation()

	React.useEffect(function() -- line: 50
		-- upvalues: HelpPageTelemetry (copy), v23 (copy), v22 (copy)
		HelpPageTelemetry.default:logHelpPageInteraction("Help_Interaction", {
			orientation = v23,
			last_input_type = v22
		})
	end, {
		v23,
		v22
	})

	if v22 == InputTypesEnum.InputType.KEYBOARD then
		return React.createElement(KeyboardHelpPage)
	end

	if v22 == InputTypesEnum.InputType.GAMEPAD or v22 == InputTypesEnum.InputType.SPATIAL_GAMEPAD then
		return React.createElement(GamepadHelpPage, {
			isSpatial = v22 == InputTypesEnum.InputType.SPATIAL_GAMEPAD
		})
	end

	if v22 == InputTypesEnum.InputType.TOUCH then
		return React.createElement(TouchHelpPage)
	end

	return React.createElement(View, nil, {})
end

return React.memo(HelpPageContainer)
