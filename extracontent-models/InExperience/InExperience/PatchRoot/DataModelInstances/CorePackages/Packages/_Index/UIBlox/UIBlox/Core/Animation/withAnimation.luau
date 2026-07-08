local ParentParent = script.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local Otter = require(ParentParent.Otter)
local t = require(ParentParent.t)
local v5 = Roact.PureComponent:extend("AnimatedComponent")

v5.validateProps = t.strictInterface({
	values = t.table,
	render = t.callback,
	options = t.optional(t.table)
})

function v5.update(p1, p2) -- line: 37
	-- upvalues: Roact (copy)
	local t1 = {}

	for k, v in pairs(p2) do
		if type(k) == "function" then
			k(v)
		else
			t1[k] = v
		end
	end

	for k, _ in pairs(p1.state) do
		if not p2[k] then
			t1[k] = Roact.None
		end
	end

	if next(t1) ~= nil then
		p1:setState(t1)
	end
end
function v5.init(p3) -- line: 56
	-- upvalues: Otter (copy)
	p3:update(p3.props.values)
	p3.motor = Otter.createGroupMotor(p3.props.values)
	p3.motor:onStep(function(p4) -- line: 59
		-- upvalues: p3 (copy)
		p3:update(p4)
	end)
end
function v5.didUpdate(p5, p6) -- line: 64
	-- upvalues: Otter (copy)
	local values = p5.props.values
	local options = p5.props.options
	local v18 = values ~= p6.values
	local v19 = options ~= p6.options

	if v18 or v19 then
		local t2 = {}

		for k, v in pairs(values) do
			t2[k] = Otter.spring(v, options)
		end

		p5.motor:setGoal(t2)
	end
end
function v5.render(p7) -- line: 80
	local state = p7.state

	return p7.props.render(state)
end
function v5.willUnmount(p8) -- line: 85
	if p8.motor then
		p8.motor:destroy()
		p8.motor = nil
	end
end

return function(p9, p10, p11) -- line: 92
	-- upvalues: Roact (copy), v5 (copy)
	return Roact.createElement(v5, {
		values = p9,
		options = p11,
		render = p10
	})
end
