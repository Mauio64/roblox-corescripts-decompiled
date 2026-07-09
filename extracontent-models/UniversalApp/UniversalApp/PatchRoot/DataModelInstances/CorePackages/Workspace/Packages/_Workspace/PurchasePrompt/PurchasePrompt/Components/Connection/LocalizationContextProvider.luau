local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Roact = require(Parent.PurchasePromptDeps).Roact
local LocalizationContext = require(script.Parent.LocalizationContext)

return function(p1) -- line: 13
	-- upvalues: Roact (copy), LocalizationContext (copy)
	return Roact.createElement(LocalizationContext.Provider, {
		value = p1.localizationContext
	}, Roact.oneChild(p1[Roact.Children]))
end
