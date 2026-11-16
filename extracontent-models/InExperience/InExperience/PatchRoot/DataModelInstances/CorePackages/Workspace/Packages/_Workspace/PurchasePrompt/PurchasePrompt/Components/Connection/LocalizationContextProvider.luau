local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local LocalizationContext = require(script.Parent.LocalizationContext)

return function(props)
	return Roact.createElement(
		LocalizationContext.Provider,
		{ value = props.localizationContext },
		Roact.oneChild(props[Roact.Children])
	)
end
