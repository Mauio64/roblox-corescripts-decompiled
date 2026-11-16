local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactServices/Roact")
local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactServices/AppCommonLib").Immutable
local symbol = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactServices/AppCommonLib").Symbol

local RoactServicesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactServices/RoactServices/RoactServicesContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/RoactServices/RoactServices/RoactServicesTypes")

local extended = Roact.PureComponent:extend("ServiceProvider")
local v5 = { ServiceProvider = extended }

function extended.init(object, p2)
	local v6 = {}

	if p2 and p2.services then
		assert(p2.services, "Expected some services to connect, found none")
		assert(type(p2.services) == "table", "Expected the provided services to be a map")

		for k, service in pairs(p2.services) do
			if type(k) == "table" then
				k.set(v6, service)
			end
		end
	end

	object:setState({ services = v6 })
end

function extended.render(p2)
	return Roact.createElement(
		RoactServicesContext.Provider,
		{ value = p2.state.services },
		Roact.oneChild(p2.props[Roact.Children])
	)
end

function v5.createService(value)
	assert(type(value) == "string", "Expected serviceName to be a string")
	local named = symbol.named(value)

	return {
		get = function(p2)
			if p2 then
				return p2[named]
			end

			return nil
		end,
		set = function(p2, p3)
			p2[named] = p3
		end
	}
end

function v5.connect(items)
	assert(items ~= nil, "Expected some services to connect, found none.")
	return function(p2)
		assert(p2 ~= nil, "Expected a component to connect, found none.")

		local v6 = {}
		local formatted = ("Services(%s)"):format((tostring(p2)))

		local extended2 = Roact.PureComponent:extend(formatted)

		function extended2.init(p3, p4)
			for k, item in pairs(items) do
				assert(
					type(k) == "string",
					string.format("serviceMap must be indexed by strings, not %s", (type(k)))
				)

				assert(type(item) == "table", "serviceMap must have a service created by createService()")
				assert(
					type(item.get) == "function",
					"serviceMap must have a service created by createService()"
				)
				assert(p4.innerProps[k] == nil, "Naming conflict with prop : " .. k)
				v6[k] = item.get(p4.services)
			end
		end

		function extended2.render(p3)
			local joinDictionaries = immutable.JoinDictionaries(p3.props.innerProps, v6)
			return Roact.createElement(p2, joinDictionaries)
		end

		local extended3 = Roact.PureComponent:extend("ConnectionWrapper")

		function extended3.render(p3)
			return Roact.createElement(RoactServicesContext.Consumer, {
				render = function(p4)
					return Roact.createElement(extended2, {
						innerProps = p3.props,
						services = p4
					})
				end
			})
		end

		return extended3
	end
end

return v5
