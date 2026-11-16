local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)

local registerSharedActions = require(script.Parent.Actions.registerSharedActions)
local registerSharedUiComponents = require(script.Parent.Components.registerSharedUiComponents)

local function SduiSharedRegister(): nil
	React.useEffect(function()
		registerSharedActions()
		registerSharedUiComponents()
	end, {})
	return nil
end

return React.memo(SduiSharedRegister)
