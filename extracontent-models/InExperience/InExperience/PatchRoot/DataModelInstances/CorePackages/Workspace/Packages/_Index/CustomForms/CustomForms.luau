local getSduiCustomFormVerticalRegistry = require(script.Sdui.getSduiCustomFormVerticalRegistry)

local registerCustomForms = require(script.Sdui.registerCustomForms)

return {
	["jest.config"] = script["jest.config"],
	SduiCustomFormsRegister = require(script.Sdui.SduiCustomFormsRegister),
	registerCustomFormActions = registerCustomForms.registerCustomFormActions,
	registerCustomFormComponents = registerCustomForms.registerCustomFormComponents,
	getSduiCustomFormVerticalRegistry = getSduiCustomFormVerticalRegistry
}
