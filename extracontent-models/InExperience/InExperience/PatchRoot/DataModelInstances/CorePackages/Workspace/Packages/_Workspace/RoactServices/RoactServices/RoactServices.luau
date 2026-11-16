local parent = script.Parent.Parent
local Roact = require(parent.Roact)
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local AppCommonLib2 = require(parent.AppCommonLib)
local Symbol = AppCommonLib2.Symbol

local RoactServicesContext = require(script.Parent.RoactServicesContext)
require(script.Parent.RoactServicesTypes)

local extended = Roact.PureComponent:extend("ServiceProvider")
local RoactServices = { ServiceProvider = extended }

function extended.init(object, p)
	local services = {}

	if p and p.services then
		assert(p.services, "Expected some services to connect, found none")
		assert(type(p.services) == "table", "Expected the provided services to be a map")

		for k, service in pairs(p.services) do
			if type(k) == "table" then
				k.set(services, service)
			end
		end
	end

	object:setState({ services = services })
end

function extended.render(p)
	return Roact.createElement(
		RoactServicesContext.Provider,
		{ value = p.state.services },
		Roact.oneChild(p.props[Roact.Children])
	)
end

function RoactServices.createService(value: string)
	assert(type(value) == "string", "Expected serviceName to be a string")
	local named = Symbol.named(value)

	return {
		get = function(p)
			if p then
				return p[named]
			end

			return nil
		end,
		set = function(p, p2)
			p[named] = p2
		end
	}
end

function RoactServices.connect(items)
	assert(items ~= nil, "Expected some services to connect, found none.")
	return function(p)
		assert(p ~= nil, "Expected a component to connect, found none.")

		local v = {}
		local formatted = ("Services(%s)"):format((tostring(p)))

		local extended2 = Roact.PureComponent:extend(formatted)

		function extended2.init(_, p2)
			for k, item in pairs(items) do
				assert(type(k) == "string", string.format("serviceMap must be indexed by strings, not %s", (type(k))))

				assert(type(item) == "table", "serviceMap must have a service created by createService()")
				assert(type(item.get) == "function", "serviceMap must have a service created by createService()")
				assert(p2.innerProps[k] == nil, "Naming conflict with prop : " .. k)
				v[k] = item.get(p2.services)
			end
		end

		function extended2.render(p2)
			local joinDictionaries = Immutable.JoinDictionaries(p2.props.innerProps, v)
			return Roact.createElement(p, joinDictionaries)
		end

		local extended3 = Roact.PureComponent:extend("ConnectionWrapper")

		function extended3.render(p2)
			return Roact.createElement(RoactServicesContext.Consumer, {
				render = function(services)
					return Roact.createElement(extended2, {
						innerProps = p2.props,
						services = services
					})
				end
			})
		end

		return extended3
	end
end

return RoactServices
