local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local LayoutValues = require(PurchasePrompt.Services.LayoutValues)
local LayoutValuesContext = require(script.Parent.LayoutValuesContext)

return function(p1) -- line: 15
	-- upvalues: LayoutValues (copy), Roact (copy), LayoutValuesContext (copy)
	local v7 = LayoutValues.new(p1.isTenFootInterface)

	return Roact.createElement(LayoutValuesContext.Provider, {
		value = v7.layout
	}, Roact.oneChild(p1[Roact.Children]))
end
