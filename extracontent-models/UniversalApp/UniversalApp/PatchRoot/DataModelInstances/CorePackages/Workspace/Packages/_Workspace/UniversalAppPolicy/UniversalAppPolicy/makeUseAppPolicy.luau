local ParentParent = script.Parent.Parent
local PolicyProvider = require(ParentParent.PolicyProvider)
local Logger = PolicyProvider.Logger
local React = require(ParentParent.React)
local Cryo = require(ParentParent.Cryo)

require(script.Parent.PolicyTypes)

local function mergePolicies(p1, t1: {[any]: any}) -- line: 15
	-- upvalues: Cryo (copy)
	local t2 = {}

	for _, v in ipairs(t1) do
		t2 = Cryo.Dictionary.join(t2, v(p1))
	end

	return t2
end

return function(p2) -- line: 25
	-- upvalues: React (copy), PolicyProvider (copy), mergePolicies (copy), Logger (copy)
	assert(p2, "expected getPolicyImpl")

	local function useAppPolicy(p3: ((...any) -> ...any)) -- line: 28
		-- upvalues: React (copy), PolicyProvider (copy), mergePolicies (copy), p2 (copy), Logger (copy)
		local v15 = React.useContext(PolicyProvider.AppPolicyContext)

		assert(v15, "Not a descendent of PolicyProvider")

		local function getInitialPolicy() -- line: 32
			-- upvalues: v15 (copy), mergePolicies (copy), p2 (copy), Logger (copy)
			if v15.staticExternalPolicy then
				return (mergePolicies(v15.staticExternalPolicy, v15.presentationPolicy))
			end

			local v19 = p2.read()

			if v19 then
				return (mergePolicies(v19, v15.presentationPolicy))
			end

			Logger:trace("No app policy data available")

			return (mergePolicies({}, v15.presentationPolicy))
		end

		local v17, v18 = React.useState(getInitialPolicy)

		React.useEffect(function() -- line: 50
			-- upvalues: v15 (copy), p2 (copy), Logger (copy), v18 (copy), mergePolicies (copy)
			local u20 = nil

			if not v15.staticExternalPolicy then
				u20 = p2.onPolicyChanged(function(p4) -- line: 53
					-- upvalues: Logger (copy), v18 (copy), mergePolicies (copy), v15 (copy)
					Logger:trace("Received policy update")
					v18((mergePolicies(p4, v15.presentationPolicy)))
				end)
			end

			return function() -- line: 59
				-- upvalues: u20 (ref)
				if u20 then
					u20:Disconnect()
				end
			end
		end, { v15 })

		return p3(v17)
	end

	return useAppPolicy
end
