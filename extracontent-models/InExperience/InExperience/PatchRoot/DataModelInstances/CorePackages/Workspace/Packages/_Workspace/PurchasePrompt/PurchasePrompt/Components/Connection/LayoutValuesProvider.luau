local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local LayoutValues = require(PurchasePrompt.Services.LayoutValues)

local LayoutValuesContext = require(script.Parent.LayoutValuesContext)

return function(props)
	local v = LayoutValues.new(props.isTenFootInterface)
	return Roact.createElement(
		LayoutValuesContext.Provider,
		{ value = v.layout },
		Roact.oneChild(props[Roact.Children])
	)
end
