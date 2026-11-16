local ReactUtils = script:FindFirstAncestor("ReactUtils")

local React = require(ReactUtils.Parent.React)

local Bindings = {}

function Bindings:map(callback)
	return self:map(callback)
end

function Bindings.binding(p)
	return p
end

function Bindings.useBinding(p)
	local v, v2 = React.useBinding(p)
	return Bindings.binding(v), v2
end

function Bindings.createBinding(p)
	local binding, v = React.createBinding(p)
	return Bindings.binding(binding), v
end

function Bindings.joinBindings2(first, second)
	return Bindings.binding(React.joinBindings({ first = first, second = second }))
end

function Bindings.mapBindings2(first, second, callback)
	return Bindings.map(Bindings.binding(React.joinBindings({ first = first, second = second })), function(p)
		return callback(p.first, p.second)
	end)
end

function Bindings.joinBindings3(first, second, third)
	return Bindings.binding(React.joinBindings({ first = first, second = second, third = third }))
end

function Bindings.mapBindings3(first, second, third, callback)
	return Bindings.map(
		Bindings.binding(React.joinBindings({ first = first, second = second, third = third })),
		function(data)
			return callback(data.first, data.second, data.third)
		end
	)
end

function Bindings.mapBindings4(first, second, third, fourth, callback)
	return Bindings.map(
		Bindings.binding(React.joinBindings({
			first = first,
			second = second,
			third = third,
			fourth = fourth
		})),
		function(data)
			return callback(data.first, data.second, data.third, data.fourth)
		end
	)
end

return Bindings
