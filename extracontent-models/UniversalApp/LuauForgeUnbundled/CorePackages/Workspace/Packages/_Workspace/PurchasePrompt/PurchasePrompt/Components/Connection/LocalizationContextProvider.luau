local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local LocalizationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/LocalizationContext")

return function(props)
	return roact.createElement(
		LocalizationContext.Provider,
		{ value = props.localizationContext },
		roact.oneChild(props[roact.Children])
	)
end
