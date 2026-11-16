local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local LayoutValuesContext = require(script.Parent.LayoutValuesContext)

return function(render)
	assert(type(render) == "function", "Expect withLayoutValues callback to be a function.")
	return Roact.createElement(LayoutValuesContext.Consumer, { render = render })
end
