local CustomForms = script:FindFirstAncestor("CustomForms")
local parent = CustomForms.Parent
local React = require(parent.React)

local registerCustomForms = require(CustomForms.Sdui.registerCustomForms)
local registerCustomForms2 = registerCustomForms.registerCustomForms

local function SduiCustomFormsRegister(): nil
	React.useEffect(function()
		registerCustomForms2()
	end, {})
	return nil
end

return React.memo(SduiCustomFormsRegister)
