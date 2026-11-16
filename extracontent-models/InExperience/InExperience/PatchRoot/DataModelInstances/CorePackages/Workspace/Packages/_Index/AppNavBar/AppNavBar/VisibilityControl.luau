local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent

local React = require(parent.React)
local Otter = require(parent.Otter)
local SharedFlags = require(parent.SharedFlags)

local defineFastFlag = game:DefineFastFlag("AppIaScrollAwayIgnoreHorizontal", false)
local defineFastInt = game:DefineFastInt("AppIaScrollAwayThreshold", 10)
local FFlagAppIaScrollAwayPinHeader = SharedFlags.FFlagAppIaScrollAwayPinHeader
local FFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local FFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix

local v = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local v2 = { binding = nil, motor = nil }

v2.__index = v2

function v2.create(p: number)
	local binding, v3 = React.createBinding(p)
	local singleMotor = Otter.createSingleMotor(p)
	singleMotor:onStep(v3)

	local v4 = { binding = binding, motor = singleMotor }

	setmetatable(v4, v2)

	return v4
end

function v2:destroy()
	self.motor:destroy()
end

function v2:getBinding()
	return self.binding
end

function v2:show()
	self.motor:setGoal(Otter.spring(1, v))
end

function v2:hide()
	self.motor:setGoal(Otter.spring(0, v))
end

function v2:update(p: number)
	local v3 = math.clamp(self.binding:getValue() + p, 0, 1)
	self.motor:setGoal(Otter.instant(v3))
end

function v2:finishUp()
	if self.binding:getValue() < 0.5 then
		self:hide()
	else
		self:show()
	end
end

local v3 = {
	enabled = false,
	header = nil,
	footer = nil,
	footerVisible = false,
	headerScrollAwayDisabled = not FFlagAppIaScrollAwayPinHeader and nil,
	globalTouchDisabled = not FFlagAppIaScopedScrollAway and nil,
	connections = nil,
	touching = false,
	moving = false,
	touchPositionX = 0,
	touchPositionY = 0,
	horizontalLocked = false,
	scrollDistance = 50,
	contentScrollable = true
}

v3.__index = v3

local instance = nil

function v3:onTouchMoved(p: number)
	if FFlagEnableScrollAwayContentScrollableFix and not self.contentScrollable then
		return
	end

	local v4 = p / self.scrollDistance

	if self.footerVisible then
		self.footer:update(v4)
	end

	if FFlagAppIaScrollAwayPinHeader then
		if not self.headerScrollAwayDisabled then
			self.header:update(v4)
		end
	else
		self.header:update(v4)
	end
end

function v3:onTouchEnded()
	if self.footerVisible then
		self.footer:finishUp()
	end

	if FFlagAppIaScrollAwayPinHeader then
		if not self.headerScrollAwayDisabled then
			self.header:finishUp()
		end
	else
		self.header:finishUp()
	end
end

function v3:connectTouch()
	if self.connections ~= nil then
		return
	end

	self.connections = {}
	self.connections.started = UserInputService.TouchStarted:Connect(function(p)
		self.touching = true

		if defineFastFlag then
			self.moving = false
			self.horizontalLocked = false
			self.touchPositionX = p.Position.X
		end

		self.touchPositionY = p.Position.Y
	end)
	self.connections.moved = UserInputService.TouchMoved:Connect(function(p)
		if not self.touching or defineFastFlag and self.horizontalLocked then
			return
		end

		local y = p.Position.Y

		if self.moving then
			local v4 = y - self.touchPositionY
			self.touchPositionY = y
			self:onTouchMoved(v4)
		elseif defineFastFlag then
			local v4 = math.abs(p.Position.X - self.touchPositionX)
			local v5 = math.abs(y - self.touchPositionY)

			if defineFastInt < v4 and v5 < v4 then
				self.horizontalLocked = true
			elseif defineFastInt < v5 then
				self.moving = true
				self.touchPositionY = y
			end
		elseif defineFastInt < math.abs(y - self.touchPositionY) then
			self.moving = true
			self.touchPositionY = y
		end
	end)
	self.connections.ended = UserInputService.TouchEnded:Connect(function(_)
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

function v3:disconnectTouch()
	if self.connections == nil then
		return
	end

	for _, connection in pairs(self.connections) do
		connection:Disconnect()
	end

	self.connections = nil
end

function v3:isEnabled()
	return self.enabled
end

function v3:setEnabled(enabled: boolean)
	if self.enabled == enabled then
		return
	end

	self.enabled = enabled

	if enabled then
		if not FFlagAppIaScopedScrollAway then
			self:connectTouch()
		elseif not self.globalTouchDisabled then
			self:connectTouch()
		end
	else
		self:disconnectTouch()

		if FFlagEnableScrollAwayContentScrollableFix then
			self.contentScrollable = true
		end
	end
end

function v3:setGlobalTouchEnabled(flag: boolean)
	self.globalTouchDisabled = not flag

	if flag then
		if self.enabled then
			self:connectTouch()
		end
	else
		self:disconnectTouch()
	end
end

function v3:setContentScrollable(contentScrollable: boolean)
	if self.contentScrollable == contentScrollable then
		return
	end

	if not contentScrollable then
		self:show()
	end

	self.contentScrollable = contentScrollable
end

function v3:setFooterVisible(footerVisible: boolean)
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

function v3:getHeaderBinding()
	return self.header:getBinding()
end

function v3:getFooterBinding()
	return self.footer:getBinding()
end

function v3:setHeaderScrollAwayDisabled(headerScrollAwayDisabled: boolean)
	if not FFlagAppIaScrollAwayPinHeader then
		return
	end

	self.headerScrollAwayDisabled = headerScrollAwayDisabled

	if headerScrollAwayDisabled then
		self.header:show()
	end
end

function v3:show()
	if FFlagEnableScrollAwayContentScrollableFix then
		self.contentScrollable = true
	end

	self.header:show()

	if self.footerVisible then
		self.footer:show()
	end
end

function v3:hide()
	if FFlagAppIaScrollAwayPinHeader then
		if not self.headerScrollAwayDisabled then
			self.header:hide()
		end
	else
		self.header:hide()
	end

	if self.footerVisible then
		self.footer:hide()
	end
end

function v3.getInstance()
	if not instance then
		instance = {}
		setmetatable(instance, v3)
		instance:initialize()
	end

	return instance
end

function v3:initialize()
	self.header = v2.create(1)

	self.footer = v2.create(0)
end

function v3:destroy()
	self.header:destroy()
	self.footer:destroy()
	self:disconnectTouch()
	instance = nil
end

function v3:setScrollDistance(scrollDistance: number)
	if scrollDistance == 0 then
		return
	end

	self.scrollDistance = scrollDistance
end

local VisibilityControl = {}

function VisibilityControl.isEnabled()
	return v3.getInstance():isEnabled()
end

function VisibilityControl:setEnabled()
	v3.getInstance():setEnabled(self)
end
function VisibilityControl.getHeaderBinding()
	return v3.getInstance():getHeaderBinding()
end

function VisibilityControl.getFooterBinding()
	return v3.getInstance():getFooterBinding()
end

function VisibilityControl:setFooterVisible()
	v3.getInstance():setFooterVisible(self)
end

VisibilityControl.setHeaderScrollAwayDisabled = FFlagAppIaScrollAwayPinHeader and function(flag: boolean)
	v3.getInstance():setHeaderScrollAwayDisabled(flag)
end or nil

function VisibilityControl.show()
	v3.getInstance():show()
end
function VisibilityControl.hide()
	v3.getInstance():hide()
end
function VisibilityControl.destroy()
	v3.getInstance():destroy()
end
function VisibilityControl:setScrollDistance()
	v3.getInstance():setScrollDistance(self)
end

VisibilityControl.setGlobalTouchEnabled = FFlagAppIaScopedScrollAway and function(flag: boolean)
	v3.getInstance():setGlobalTouchEnabled(flag)
end or nil

VisibilityControl.onTouchMoved = FFlagAppIaScopedScrollAway and function(p: number)
	local instance2 = v3.getInstance()

	if instance2.enabled then
		instance2:onTouchMoved(p)
	end
end or nil

VisibilityControl.onTouchEnded = FFlagAppIaScopedScrollAway and function()
	local instance2 = v3.getInstance()

	if instance2.enabled then
		instance2:onTouchEnded()
	end
end or nil

function VisibilityControl:setContentScrollable()
	v3.getInstance():setContentScrollable(self)
end

return VisibilityControl
