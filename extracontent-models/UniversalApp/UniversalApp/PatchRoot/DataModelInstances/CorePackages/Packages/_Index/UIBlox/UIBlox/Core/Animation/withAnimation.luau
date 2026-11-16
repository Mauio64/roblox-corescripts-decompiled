local parent = script.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)
local Otter = require(parent.Otter)
local t = require(parent.t)

local extended = Roact.PureComponent:extend("AnimatedComponent")

extended.validateProps = t.strictInterface({
	values = t.table,
	render = t.callback,
	options = t.optional(t.table)
})

function extended:update(items)
	local v = {}

	for k, item in pairs(items) do
		if type(k) == "function" then
			k(item)
		else
			v[k] = item
		end
	end

	for k, _ in pairs(self.state) do
		if not items[k] then
			v[k] = Roact.None
		end
	end

	if next(v) ~= nil then
		self:setState(v)
	end
end

function extended:init()
	self:update(self.props.values)
	self.motor = Otter.createGroupMotor(self.props.values)
	self.motor:onStep(function(p)
		self:update(p)
	end)
end

function extended.didUpdate(p, p2)
	local values = p.props.values
	local options = p.props.options

	local v = values ~= p2.values
	local v2 = options ~= p2.options

	if v or v2 then
		local values2 = {}

		for k, value in pairs(values) do
			values2[k] = Otter.spring(value, options)
		end

		p.motor:setGoal(values2)
	end
end

function extended.render(p)
	local state = p.state
	return p.props.render(state)
end

function extended:willUnmount()
	if self.motor then
		self.motor:destroy()
		self.motor = nil
	end
end

return function(values, render, options)
	return Roact.createElement(extended, { values = values, options = options, render = render })
end
