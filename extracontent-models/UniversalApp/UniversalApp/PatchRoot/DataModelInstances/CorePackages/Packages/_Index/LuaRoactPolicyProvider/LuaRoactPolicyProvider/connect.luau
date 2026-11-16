local parent = script.Parent.Parent
local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)

local Logger = require(script.Parent.Logger)
local AppPolicyContext = require(script.Parent.AppPolicyContext)

local function mergePolicies(p, presentationPolicy)
	local joined = {}

	for _, item in ipairs(presentationPolicy) do
		joined = Cryo.Dictionary.join(joined, item(p))
	end

	return joined
end

return function(p)
	assert(p, "expected getPolicyImpl")

	return function(callback)
		assert(type(callback) == "function", "connect expects mapper to be a function")

		return function(p2)
			local formatted = ("AppPolicy(%s)"):format((tostring(p2)))
			local v = Logger:new(formatted)
			v:setContext({
				prefix = string.format("%s: ", formatted)
			})

			local v2 = string.format("%s: Not a descendent of PolicyProvider", formatted)
			local extended = Roact.PureComponent:extend(formatted)

			v:trace("Connected to component: {}", (tostring(p2)))

			function extended:init(p3)
				self.policyContext = p3.policy
				assert(self.policyContext, v2)

				function self.setWithEmptyPolicy()
					self.state = {
						policy = mergePolicies({}, self.policyContext.presentationPolicy)
					}
				end

				if self.policyContext.staticExternalPolicy then
					self.state = {
						policy = mergePolicies(
							self.policyContext.staticExternalPolicy,
							self.policyContext.presentationPolicy
						)
					}
					return
				end

				local v3 = p.read()

				if v3 then
					self.state = {
						policy = mergePolicies(v3, self.policyContext.presentationPolicy)
					}
				else
					self.setWithEmptyPolicy()
					v:trace("No app policy data available")
				end

				function self.onPolicyChanged(p4)
					self:setState({
						policy = mergePolicies(p4, self.policyContext.presentationPolicy)
					})
				end
			end

			function extended:didMount()
				if self.policyContext.staticExternalPolicy then
					return
				end

				self.connection = p.onPolicyChanged(function(p3)
					v:trace("Received policy update from MemStorageService")
					self.onPolicyChanged(p3)
				end)
			end

			function extended.render(p3)
				local v3 = callback(p3.state.policy, p3.props.innerProps)
				local joined = Cryo.Dictionary.join(p3.props.innerProps, v3)
				return Roact.createElement(p2, joined)
			end

			function extended:willUnmount()
				if self.connection then
					self.connection:Disconnect()
				end

				self.onPolicyChange = nil
			end

			return function(innerProps)
				return Roact.createElement(AppPolicyContext.Consumer, {
					render = function(policy)
						return Roact.createElement(extended, {
							innerProps = innerProps,
							policy = policy
						})
					end
				})
			end
		end
	end
end
