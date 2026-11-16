local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/React")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Otter")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags")

local defineFastFlag = game:DefineFastFlag("AppIaScrollAwayIgnoreHorizontal", false)
local defineFastInt = game:DefineFastInt("AppIaScrollAwayThreshold", 10)
local fFlagAppIaScrollAwayPinHeader = SharedFlags.FFlagAppIaScrollAwayPinHeader
local fFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local fFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix

local v5 = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local v6 = { binding = nil, motor = nil }

v6.__index = v6

function v6.create(p2)
	local binding, v7 = React.createBinding(p2)
	local singleMotor = Otter.createSingleMotor(p2)
	singleMotor:onStep(v7)

	local v8 = { binding = binding, motor = singleMotor }

	setmetatable(v8, v6)

	return v8
end

function v6.destroy(p2)
	p2.motor:destroy()
end

function v6:getBinding()
	return self.binding
end

function v6.show(p2)
	p2.motor:setGoal(Otter.spring(1, v5))
end

function v6.hide(p2)
	p2.motor:setGoal(Otter.spring(0, v5))
end

function v6.update(p2, p3)
	local v7 = math.clamp(p2.binding:getValue() + p3, 0, 1)
	p2.motor:setGoal(Otter.instant(v7))
end

function v6:finishUp()
	if self.binding:getValue() < 0.5 then
		self:hide()
	else
		self:show()
	end
end

local v7 = {
	enabled = false,
	header = nil,
	footer = nil,
	footerVisible = false,
	headerScrollAwayDisabled = if fFlagAppIaScrollAwayPinHeader then false else nil,
	globalTouchDisabled = if fFlagAppIaScopedScrollAway then false else nil,
	connections = nil,
	touching = false,
	moving = false,
	touchPositionX = 0,
	touchPositionY = 0,
	horizontalLocked = false,
	scrollDistance = 50,
	contentScrollable = true
}

v7.__index = v7

local instance = nil

function v7.onTouchMoved(data, p2)
	if fFlagEnableScrollAwayContentScrollableFix and not data.contentScrollable then
		return
	end

	local v10 = p2 / data.scrollDistance

	if data.footerVisible then
		data.footer:update(v10)
	end

	if fFlagAppIaScrollAwayPinHeader then
		if not data.headerScrollAwayDisabled then
			data.header:update(v10)
		end
	else
		data.header:update(v10)
	end
end

function v7.onTouchEnded(data)
	if data.footerVisible then
		data.footer:finishUp()
	end

	if fFlagAppIaScrollAwayPinHeader then
		if not data.headerScrollAwayDisabled then
			data.header:finishUp()
		end
	else
		data.header:finishUp()
	end
end

function v7:connectTouch()
	if self.connections ~= nil then
		return
	end

	self.connections = {}
	self.connections.started = UserInputService.TouchStarted:Connect(function(p2)
		self.touching = true

		if defineFastFlag then
			self.moving = false
			self.horizontalLocked = false
			self.touchPositionX = p2.Position.X
		end

		self.touchPositionY = p2.Position.Y
	end)
	self.connections.moved = UserInputService.TouchMoved:Connect(function(p2)
		if not self.touching or defineFastFlag and self.horizontalLocked then
			return
		end

		local y = p2.Position.Y

		if self.moving then
			local v10 = y - self.touchPositionY
			self.touchPositionY = y
			self:onTouchMoved(v10)
		elseif defineFastFlag then
			local v10 = math.abs(p2.Position.X - self.touchPositionX)
			local v11 = math.abs(y - self.touchPositionY)

			if defineFastInt < v10 and v11 < v10 then
				self.horizontalLocked = true
			elseif defineFastInt < v11 then
				self.moving = true
				self.touchPositionY = y
			end
		elseif defineFastInt < math.abs(y - self.touchPositionY) then
			self.moving = true
			self.touchPositionY = y
		end
	end)
	self.connections.ended = UserInputService.TouchEnded:Connect(function(otherPart)
		if not self.touching then
			return
		end

		self.touching = false
		self.moving = false

		if defineFastFlag then
			self.horizontalLocked = false
		end

		self:onTouchEnded()
	end)
end

function v7:disconnectTouch()
	if self.connections == nil then
		return
	end

	for k, connection in pairs(self.connections) do
		connection:Disconnect()
	end

	self.connections = nil
end

function v7.isEnabled(p2)
	return p2.enabled
end

function v7:setEnabled(enabled)
	if self.enabled == enabled then
		return
	end

	self.enabled = enabled

	if enabled then
		if not fFlagAppIaScopedScrollAway then
			self:connectTouch()
		elseif not self.globalTouchDisabled then
			self:connectTouch()
		end
	else
		self:disconnectTouch()

		if fFlagEnableScrollAwayContentScrollableFix then
			self.contentScrollable = true
		end
	end
end

function v7:setGlobalTouchEnabled(p2)
	self.globalTouchDisabled = not p2

	if p2 then
		if self.enabled then
			self:connectTouch()
		end
	else
		self:disconnectTouch()
	end
end

function v7:setContentScrollable(contentScrollable)
	if self.contentScrollable == contentScrollable then
		return
	end

	if not contentScrollable then
		self:show()
	end

	self.contentScrollable = contentScrollable
end

function v7:setFooterVisible(footerVisible)
	if self.footerVisible == footerVisible then
		return
	end

	self.footerVisible = footerVisible

	if footerVisible then
		self.footer:show()
	else
		self.footer:hide()
	end
end

function v7.getHeaderBinding(p2)
	return p2.header:getBinding()
end

function v7.getFooterBinding(p2)
	return p2.footer:getBinding()
end

function v7:setHeaderScrollAwayDisabled(headerScrollAwayDisabled)
	if not fFlagAppIaScrollAwayPinHeader then
		return
	end

	self.headerScrollAwayDisabled = headerScrollAwayDisabled

	if headerScrollAwayDisabled then
		self.header:show()
	end
end

function v7:show()
	if fFlagEnableScrollAwayContentScrollableFix then
		self.contentScrollable = true
	end

	self.header:show()

	if self.footerVisible then
		self.footer:show()
	end
end

function v7.hide(data)
	if fFlagAppIaScrollAwayPinHeader then
		if not data.headerScrollAwayDisabled then
			data.header:hide()
		end
	else
		data.header:hide()
	end

	if data.footerVisible then
		data.footer:hide()
	end
end

function v7.getInstance()
	if not instance then
		instance = {}
		setmetatable(instance, v7)
		instance:initialize()
	end

	return instance
end

function v7:initialize()
	self.header = v6.create(1)

	self.footer = v6.create(0)
end

function v7:destroy()
	self.header:destroy()
	self.footer:destroy()
	self:disconnectTouch()
	instance = nil
end

function v7:setScrollDistance(scrollDistance)
	if scrollDistance == 0 then
		return
	end

	self.scrollDistance = scrollDistance
end

return {
	isEnabled = function()
		return v7.getInstance():isEnabled()
	end,
	setEnabled = function(p2)
		v7.getInstance():setEnabled(p2)
	end,
	getHeaderBinding = function()
		return v7.getInstance():getHeaderBinding()
	end,
	getFooterBinding = function()
		return v7.getInstance():getFooterBinding()
	end,
	setFooterVisible = function(p2)
		v7.getInstance():setFooterVisible(p2)
	end,
	setHeaderScrollAwayDisabled = fFlagAppIaScrollAwayPinHeader and function(p2)
		v7.getInstance():setHeaderScrollAwayDisabled(p2)
	end or nil,
	show = function()
		v7.getInstance():show()
	end,
	hide = function()
		v7.getInstance():hide()
	end,
	destroy = function()
		v7.getInstance():destroy()
	end,
	setScrollDistance = function(p2)
		v7.getInstance():setScrollDistance(p2)
	end,
	setGlobalTouchEnabled = fFlagAppIaScopedScrollAway and function(p2)
		v7.getInstance():setGlobalTouchEnabled(p2)
	end or nil,
	onTouchMoved = fFlagAppIaScopedScrollAway and function(p2)
		local instance2 = v7.getInstance()

		if instance2.enabled then
			instance2:onTouchMoved(p2)
		end
	end or nil,
	onTouchEnded = fFlagAppIaScopedScrollAway and function()
		local instance2 = v7.getInstance()

		if instance2.enabled then
			instance2:onTouchEnded()
		end
	end or nil,
	setContentScrollable = function(p2)
		v7.getInstance():setContentScrollable(p2)
	end
}
