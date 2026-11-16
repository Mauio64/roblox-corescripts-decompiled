local CorePackages = game:GetService("CorePackages")
local Components = script.Parent.Parent.Components

local Roact = require(CorePackages.Packages.Roact)
local Immutable = require(script.Parent.Parent.Immutable)
local DataContext = require(Components.DataContext)

return function(p, ...)
	if not p then
		error("Expected component to be passed to connection, got nil.")
	end

	local v = {}

	for i = 1, select("#", ...) do
		v[i] = select(i, ...)
	end

	local v2 = string.format("Consumer(%s)_DependsOn_%s", tostring(p), v[1])
	local extended = Roact.Component:extend(v2)

	function extended.init(object)
		local v3 = {}

		for _, v4 in pairs(v) do
			local v5 = object.props.DevConsoleData[v4]

			if v5 then
				v3[v4] = v5
			else
				local v6 = string.format(
					"%s %s",
					tostring(v4),
					"could not be found. Make sure DataProvider is above this consumer"
				)

				error(v6)
				return
			end
		end

		object:setState(v3)
	end

	function extended.render(p2)
		local joinDictionaries = Immutable.JoinDictionaries(p2.props.componentProps, p2.state)
		return Roact.createElement(p, joinDictionaries)
	end

	local function DataConsumerWrapper(componentProps)
		return Roact.createElement(DataContext.Consumer, {
			render = function(devConsoleData)
				return Roact.createElement(extended, {
					componentProps = componentProps,
					DevConsoleData = devConsoleData
				})
			end
		})
	end

	return DataConsumerWrapper
end
