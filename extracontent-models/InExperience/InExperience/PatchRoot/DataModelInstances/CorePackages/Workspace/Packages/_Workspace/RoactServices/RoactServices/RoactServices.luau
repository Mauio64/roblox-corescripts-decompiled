local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Immutable = require(ParentParent.AppCommonLib).Immutable
local Symbol = require(ParentParent.AppCommonLib).Symbol
local RoactServicesContext = require(script.Parent.RoactServicesContext)

require(script.Parent.RoactServicesTypes)

local v6 = Roact.PureComponent:extend("ServiceProvider")
local t1 = {
	ServiceProvider = v6
}

function v6.init(t2: {[any]: any}, t3: {[any]: any}) -- line: 36
	local t4 = {}

	if t3 and t3.services then
		assert(t3.services, "Expected some services to connect, found none")
		assert(type(t3.services) == "table", "Expected the provided services to be a map")

		for k, v in pairs(t3.services) do
			if type(k) == "table" then
				k.set(t4, v)
			end
		end
	end

	t2:setState({
		services = t4
	})
end
function v6.render(p1) -- line: 54
	-- upvalues: Roact (copy), RoactServicesContext (copy)
	return Roact.createElement(RoactServicesContext.Provider, {
		value = p1.state.services
	}, Roact.oneChild(p1.props[Roact.Children]))
end
function t1.createService(s1: string) -- line: 62
	-- upvalues: Symbol (copy)
	assert(type(s1) == "string", "Expected serviceName to be a string")

	local v15 = Symbol.named(s1)

	return {
		get = function(p2) -- line: 68
			-- upvalues: v15 (copy)
			if p2 then
				return p2[v15]
			end

			return nil
		end,
		set = function(p3, p4) -- line: 72
			-- upvalues: v15 (copy)
			p3[v15] = p4
		end
	}
end
function t1.connect(p5) -- line: 81
	-- upvalues: Roact (copy), Immutable (copy), RoactServicesContext (copy)
	assert(p5 ~= nil, "Expected some services to connect, found none.")

	return function(p6) -- line: 83
		-- upvalues: Roact (copy), p5 (copy), Immutable (copy), RoactServicesContext (copy)
		assert(p6 ~= nil, "Expected a component to connect, found none.")

		local t5 = {}
		local v22 = ("Services(%s)"):format((tostring(p6)))
		local v23 = Roact.PureComponent:extend(v22)

		function v23.init(_, p8) -- line: 91
			-- upvalues: p5 (copy), t5 (copy)
			for k, v in pairs(p5) do
				assert(type(k) == "string", string.format("serviceMap must be indexed by strings, not %s", (type(k))))
				assert(type(v) == "table", "serviceMap must have a service created by createService()")
				assert(type(v.get) == "function", "serviceMap must have a service created by createService()")
				assert(p8.innerProps[k] == nil, "Naming conflict with prop : " .. k)
				t5[k] = v.get(p8.services)
			end
		end
		function v23.render(p9) -- line: 105
			-- upvalues: Immutable (copy), t5 (copy), Roact (copy), p6 (copy)
			local v30 = Immutable.JoinDictionaries(p9.props.innerProps, t5)

			return Roact.createElement(p6, v30)
		end

		local v24 = Roact.PureComponent:extend("ConnectionWrapper")

		function v24.render(p10) -- line: 112
			-- upvalues: Roact (copy), RoactServicesContext (copy), v23 (copy)
			return Roact.createElement(RoactServicesContext.Consumer, {
				render = function(p11) -- line: 114
					-- upvalues: Roact (copy), v23 (copy), p10 (copy)
					return Roact.createElement(v23, {
						innerProps = p10.props,
						services = p11
					})
				end
			})
		end

		return v24
	end
end

return t1
