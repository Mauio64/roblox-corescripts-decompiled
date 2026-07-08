local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Roact = require(Parent.PurchasePromptDeps).Roact
local LocalizationContextConsumer = require(script.Parent.LocalizationContextConsumer)

local function TextLocalizer(p1) -- line: 8
	-- upvalues: Roact (copy), LocalizationContextConsumer (copy)
	local locKey = p1.locKey
	local params = p1.params
	local render = p1.render

	assert(typeof(locKey) == "string", "String prop 'locKey' must be provided")
	assert(typeof(render) == "function", "Render prop must be a function")

	return Roact.createElement(LocalizationContextConsumer, {
		render = function(p2) -- line: 17
			-- upvalues: render (copy), locKey (copy), params (copy)
			return render(p2:Format(locKey, params))
		end
	})
end

return TextLocalizer
