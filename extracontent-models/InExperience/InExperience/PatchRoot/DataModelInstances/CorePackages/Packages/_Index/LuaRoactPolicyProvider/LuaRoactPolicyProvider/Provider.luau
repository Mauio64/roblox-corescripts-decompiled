local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local AppPolicyContext = require(script.Parent.AppPolicyContext)

return function()
	local extended = Roact.Component:extend("PolicyProvider")

	function extended:init(p)
		assert(type(p.policy) == "table", "Provider expects props.policy to be a table")

		self.policy = { presentationPolicy = p.policy, staticExternalPolicy = p.policyData }
	end

	function extended.render(p)
		return Roact.createElement(AppPolicyContext.Provider, { value = p.policy }, p.props[Roact.Children])
	end

	return extended
end
