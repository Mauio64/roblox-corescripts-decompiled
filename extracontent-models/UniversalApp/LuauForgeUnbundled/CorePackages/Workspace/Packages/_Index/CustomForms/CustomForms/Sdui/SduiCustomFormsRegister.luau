local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/React")

local registerCustomForms = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/registerCustomForms").registerCustomForms

local function SduiCustomFormsRegister(): nil
	React.useEffect(function()
		registerCustomForms()
	end, {})
	return nil
end

return React.memo(SduiCustomFormsRegister)
