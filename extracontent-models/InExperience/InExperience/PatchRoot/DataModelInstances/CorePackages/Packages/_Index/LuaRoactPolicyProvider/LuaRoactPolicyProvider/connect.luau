local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Cryo = require(ParentParent.Cryo)
local Logger = require(script.Parent.Logger)
local AppPolicyContext = require(script.Parent.AppPolicyContext)

local function mergePolicies(p1, p2) -- line: 9
	-- upvalues: Cryo (copy)
	local t1 = {}

	for _, v in ipairs(p2) do
		t1 = Cryo.Dictionary.join(t1, v(p1))
	end

	return t1
end

return function(p3) -- line: 19
	-- upvalues: Logger (copy), Roact (copy), mergePolicies (copy), Cryo (copy), AppPolicyContext (copy)
	assert(p3, "expected getPolicyImpl")

	return function(p4) -- line: 22
		-- upvalues: Logger (copy), Roact (copy), mergePolicies (copy), p3 (copy), Cryo (copy), AppPolicyContext (copy)
		assert(type(p4) == "function", "connect expects mapper to be a function")

		return function(p5) -- line: 25
			-- upvalues: Logger (copy), Roact (copy), mergePolicies (copy), p3 (copy), p4 (copy), Cryo (copy), AppPolicyContext (copy)
			local v15 = ("AppPolicy(%s)"):format((tostring(p5)))
			local v16 = Logger:new(v15)

			v16:setContext({
				prefix = string.format("%s: ", v15)
			})

			local v17 = string.format("%s: Not a descendent of PolicyProvider", v15)
			local v18 = Roact.PureComponent:extend(v15)

			v16:trace("Connected to component: {}", (tostring(p5)))

			function v18.init(p6, p7) -- line: 37
				-- upvalues: v17 (copy), mergePolicies (copy), p3 (copy), v16 (copy)
				p6.policyContext = p7.policy
				assert(p6.policyContext, v17)

				function p6.setWithEmptyPolicy() -- line: 41
					-- upvalues: p6 (copy), mergePolicies (copy)
					p6.state = {
						policy = mergePolicies({}, p6.policyContext.presentationPolicy)
					}
				end

				if p6.policyContext.staticExternalPolicy then
					p6.state = {
						policy = mergePolicies(p6.policyContext.staticExternalPolicy, p6.policyContext.presentationPolicy)
					}

					return
				end

				local v21 = p3.read()

				if v21 then
					p6.state = {
						policy = mergePolicies(v21, p6.policyContext.presentationPolicy)
					}
				else
					p6.setWithEmptyPolicy()
					v16:trace("No app policy data available")
				end

				function p6.onPolicyChanged(p8) -- line: 67
					-- upvalues: p6 (copy), mergePolicies (copy)
					p6:setState({
						policy = mergePolicies(p8, p6.policyContext.presentationPolicy)
					})
				end
			end
			function v18.didMount(p9) -- line: 75
				-- upvalues: p3 (copy), v16 (copy)
				if p9.policyContext.staticExternalPolicy then
					return
				end

				p9.connection = p3.onPolicyChanged(function(p10) -- line: 79
					-- upvalues: v16 (copy), p9 (copy)
					v16:trace("Received policy update from MemStorageService")
					p9.onPolicyChanged(p10)
				end)
			end
			function v18.render(p11) -- line: 85
				-- upvalues: p4 (copy), Cryo (copy), Roact (copy), p5 (copy)
				local v24 = p4(p11.state.policy, p11.props.innerProps)
				local v25 = Cryo.Dictionary.join(p11.props.innerProps, v24)

				return Roact.createElement(p5, v25)
			end
			function v18.willUnmount(p12) -- line: 91
				if p12.connection then
					p12.connection:Disconnect()
				end

				p12.onPolicyChange = nil
			end

			return function(p13) -- line: 99
				-- upvalues: Roact (copy), AppPolicyContext (copy), v18 (copy)
				return Roact.createElement(AppPolicyContext.Consumer, {
					render = function(p14) -- line: 101
						-- upvalues: Roact (copy), v18 (copy), p13 (copy)
						return Roact.createElement(v18, {
							innerProps = p13,
							policy = p14
						})
					end
				})
			end
		end
	end
end
