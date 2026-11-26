local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local LayoutValues = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/LayoutValues")

local LayoutValuesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/LayoutValuesContext")

return function(props)
	local v5 = LayoutValues.new(props.isTenFootInterface)
	return roact.createElement(
		LayoutValuesContext.Provider,
		{ value = v5.layout },
		roact.oneChild(props[roact.Children])
	)
end
