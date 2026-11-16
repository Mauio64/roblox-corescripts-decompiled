local PolicyProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/PolicyProvider")
local logger = PolicyProvider.Logger
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/PolicyTypes")

local defineFastFlag = game:DefineFastFlag("UniversalAppPolicySkipUnchangedPolicy2", false)

local function sameValues(p2, p3): boolean
	if p2.n ~= p3.n then
		return false
	end

	for i = 1, p2.n do
		if p2[i] ~= p3[i] then
			return false
		end
	end

	return true
end

local function mergePolicies(p2, presentationPolicy)
	local joined = {}

	for i, item in ipairs(presentationPolicy) do
		joined = Cryo.Dictionary.join(joined, item(p2))
	end

	return joined
end

return function(p2)
	assert(p2, "expected getPolicyImpl")

	local function useAppPolicy(current)
		local v5 = React.useContext(PolicyProvider.AppPolicyContext)
		assert(v5, "Not a descendent of PolicyProvider")

		local function getInitialPolicy()
			if v5.staticExternalPolicy then
				return mergePolicies(v5.staticExternalPolicy, v5.presentationPolicy)
			end

			local v6 = p2.read()

			if v6 then
				return mergePolicies(v6, v5.presentationPolicy)
			end

			logger:trace("No app policy data available")
			return mergePolicies({}, v5.presentationPolicy)
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

			if v5.staticExternalPolicy then
				connection = nil
			else
				connection = p2.onPolicyChanged(function(p3)
					logger:trace("Received policy update")

					if not (defineFastFlag and ref and ref2 and ref3) then
						setState(mergePolicies(p3, v5.presentationPolicy))

						return
					end

					local v6 = mergePolicies(p3, v5.presentationPolicy)
					ref2.current = v6
					local current2 = ref3.current

					if current2 ~= nil then
						local v7 = table.pack(ref.current(v6))
						local flag

						if current2.n == v7.n then
							local flag2 = true

							for i = 1, current2.n do
								if current2[i] ~= v7[i] then
									flag = false
									flag2 = false
									break
								end
							end

							if flag2 then
								flag = true
							end
						else
							flag = false
						end

						if flag then
							return
						end
					end

					setState(v6)
				end)
			end

			return function()
				if connection then
					connection:Disconnect()
				end
			end
		end, { v5 })

		if defineFastFlag and ref2 and ref3 then
			local v6 = table.pack(current(ref2.current))
			ref3.current = v6

			return (table.unpack)(v6, 1, v6.n)
		end

		return current(state)
	end

	return useAppPolicy
end
