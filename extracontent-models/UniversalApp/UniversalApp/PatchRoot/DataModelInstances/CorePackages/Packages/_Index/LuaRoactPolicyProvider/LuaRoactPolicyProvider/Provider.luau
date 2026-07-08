local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local AppPolicyContext = require(script.Parent.AppPolicyContext)

return function() -- line: 6
	-- upvalues: Roact (copy), AppPolicyContext (copy)
	local v4 = Roact.Component:extend("PolicyProvider")

	function v4.init(p1, p2) -- line: 9
		assert(type(p2.policy) == "table", "Provider expects props.policy to be a table")
		p1.policy = {
			presentationPolicy = p2.policy,
			staticExternalPolicy = p2.policyData
		}
	end
	function v4.render(p3) -- line: 18
		-- upvalues: Roact (copy), AppPolicyContext (copy)
		return Roact.createElement(AppPolicyContext.Provider, {
			value = p3.policy
		}, p3.props[Roact.Children])
	end

	return v4
end
