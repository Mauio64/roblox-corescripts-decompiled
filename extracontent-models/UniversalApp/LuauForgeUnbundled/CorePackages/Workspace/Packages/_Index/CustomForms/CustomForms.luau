local module = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/getSduiCustomFormVerticalRegistry")

local registerCustomForms = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/registerCustomForms")

return {
	SduiCustomFormsRegister = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/SduiCustomFormsRegister"),
	registerCustomFormActions = registerCustomForms.registerCustomFormActions,
	registerCustomFormComponents = registerCustomForms.registerCustomFormComponents,
	getSduiCustomFormVerticalRegistry = module
}
