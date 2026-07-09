local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Roact = require(Parent.PurchasePromptDeps).Roact
local LayoutValuesContext = require(script.Parent.LayoutValuesContext)

return function(p1) -- line: 12
	-- upvalues: Roact (copy), LayoutValuesContext (copy)
	assert(type(p1) == "function", "Expect withLayoutValues callback to be a function.")

	return Roact.createElement(LayoutValuesContext.Consumer, {
		render = p1
	})
end
