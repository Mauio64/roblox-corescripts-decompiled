local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local LocalizationContextConsumer = require(script.Parent.LocalizationContextConsumer)

local function TextLocalizer(props)
	local locKey = props.locKey
	local params = props.params
	local render = props.render

	assert(typeof(locKey) == "string", "String prop 'locKey' must be provided")
	assert(typeof(render) == "function", "Render prop must be a function")

	return Roact.createElement(LocalizationContextConsumer, {
		render = function(object)
			return render(object:Format(locKey, params))
		end
	})
end

return TextLocalizer
