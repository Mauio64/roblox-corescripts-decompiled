local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/ego")

local module2 = require("@luauforge/bundled/egS")
local module3 = require("@luauforge/bundled/egT")
local module4 = require("@luauforge/bundled/egP")
local module5 = require("@luauforge/bundled/egQ")
local module6 = require("@luauforge/bundled/egO")

local extended = module.Component:extend("SimpleMotion")

local v5 = {}

RunService.RenderStepped:Connect(function(dt)
	for k in pairs(v5) do
		k(dt)
	end
end)

function extended:init()
	local v6 = {}
	local v7 = {}

	for k, v8 in pairs(self.props.style) do
		v6[k] = 0
		v7[k] = module6.extractValue(v8)
	end

	if self.props.defaultStyle then
		for k, v8 in pairs(self.props.defaultStyle) do
			v7[k] = v8
		end
	end

	self.resting = false

	self.wasResting = true

	self.accumulator = 0
	self.state = { values = v7, velocities = v6 }
end

function extended.render(p2)
	return p2.props.render(p2.state.values)
end

function extended:update(p2)
	if self.resting then
		return
	end

	local v6 = module3(self.state.values)
	local v7 = module3(self.state.velocities)

	self.accumulator += p2 % module4.MAX_ACCUMULATION
	local v8 = false

	while self.accumulator >= module4.UPDATE_RATE do
		self.accumulator -= module4.UPDATE_RATE
		local flag = true

		for k, v9 in pairs(self.props.style) do
			local kind = module6.getType(v9)

			local v10 = nil
			local v11 = nil

			if kind == module5.Instant then
				self.wasResting = false
				v10 = v9
				v11 = 0
			elseif kind == module5.Spring then
				v10, v11 = module2(
					module4.UPDATE_RATE * module4.TIME_FACTOR,
					v6[k],
					v7[k],
					v9.value,
					v9.stiffness,
					v9.damping,
					v9.precision
				)
			else
				error(("Unsupported MotionType %q"):format(kind))
			end

			v6[k] = v10
			v7[k] = v11

			v8 = v10 ~= self.state.values[k] or v11 ~= self.state.velocities[k] or v8

			if v10 ~= module6.extractValue(v9) or v11 ~= 0 then
				flag = false
			end
		end

		if flag then
			self.resting = true
			self.accumulator = 0
			break
		end
	end

	if v8 then
		self:setState({ values = v6, velocities = v7 })
	end

	if not self.wasResting and self.resting and self.props.onRested then
		self.props.onRested()
	end

	self.wasResting = self.resting
end

function extended:didMount()
	function self.renderCallback(p2)
		self:update(p2)
	end
	v5[self.renderCallback] = true
end

function extended.willUnmount(p2)
	v5[p2.renderCallback] = nil
end

function extended:didUpdate(p3)
	if p3 == self.props then
		return
	end

	self.resting = false
end

return extended
