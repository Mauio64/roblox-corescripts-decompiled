local parent = script.Parent.Parent
local PolicyProvider = require(parent.PolicyProvider)
local Logger = PolicyProvider.Logger
local React = require(parent.React)
local Cryo = require(parent.Cryo)
require(script.Parent.PolicyTypes)

local defineFastFlag = game:DefineFastFlag("UniversalAppPolicySkipUnchangedPolicy2", false)

local function sameValues(current, p): boolean -- 1 equivalent call inferred from this helper
	if current.n ~= p.n then
		return false
	end

	for i = 1, current.n do
		if current[i] ~= p[i] then
			return false
		end
	end

	return true
end

local function mergePolicies(p, presentationPolicy)
	local joined = {}

	for _, item in ipairs(presentationPolicy) do
		joined = Cryo.Dictionary.join(joined, item(p))
	end

	return joined
end

return function(p)
	assert(p, "expected getPolicyImpl")

	local function useAppPolicy(current)
		local v = React.useContext(PolicyProvider.AppPolicyContext)
		assert(v, "Not a descendent of PolicyProvider")

		local function getInitialPolicy()
			if v.staticExternalPolicy then
				return mergePolicies(v.staticExternalPolicy, v.presentationPolicy)
			end

			local v2 = p.read()

			if v2 then
				return mergePolicies(v2, v.presentationPolicy)
			end

			Logger:trace("No app policy data available")
			return mergePolicies({}, v.presentationPolicy)
		end

		local state, setState = React.useState(getInitialPolicy)
		local ref, ref2, ref3

		if defineFastFlag then
			ref = React.useRef(current)
			assert(ref, "latestMapPolicies")
			ref.current = current
			ref2 = React.useRef(state)
			ref3 = React.useRef(nil)
		else
			ref = nil
			ref2 = nil
			ref3 = nil
		end

		React.useEffect(function()
			local connection

			if v.staticExternalPolicy then
				connection = nil
			else
				connection = p.onPolicyChanged(function(p2)
					Logger:trace("Received policy update")

					if not (defineFastFlag and ref and ref2 and ref3) then
						setState(mergePolicies(p2, v.presentationPolicy))

						return
					end

					local current3 = mergePolicies(p2, v.presentationPolicy)
					ref2.current = current3
					local current2 = ref3.current

					if current2 ~= nil and sameValues(current2, table.pack(ref.current(current3))) then -- inferred equivalent call
						return
					end

					setState(current3)
				end)
			end

			return function()
				if connection then
					connection:Disconnect()
				end
			end
		end, { v })

		if defineFastFlag and ref2 and ref3 then
			local current2 = table.pack(current(ref2.current))
			ref3.current = current2

			return (table.unpack)(current2, 1, current2.n)
		end

		return current(state)
	end

	return useAppPolicy
end
