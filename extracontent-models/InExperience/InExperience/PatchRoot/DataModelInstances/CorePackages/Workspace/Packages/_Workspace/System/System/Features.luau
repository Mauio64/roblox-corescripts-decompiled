local StarterGui = game:GetService("StarterGui")

local Lifecycle = require(script.Parent.Lifecycle)

local FeatureName = require(script.Parent.FeatureName)

local class = {}
class.__index = class

function class.new(data)
	local object = setmetatable({}, class)
	local coreGuiType, v

	if data then
		coreGuiType = data.coreGuiType

		local defaultEnabled = data.defaultEnabled or false

		if coreGuiType then
			defaultEnabled = StarterGui:GetCoreGuiEnabled(coreGuiType)
		end

		v = {
			defaultVisible = data.defaultVisible or false,
			defaultEnabled = defaultEnabled
		}
	else
		coreGuiType = nil
	end

	local lifecycle = Lifecycle.new(v)
	object.lifecycle = lifecycle

	if coreGuiType then
		object._coreGuiConnection = StarterGui.CoreGuiChangedSignal:Connect(function(p, p2)
			if p == coreGuiType or p == Enum.CoreGuiType.All then
				lifecycle.setEnabled(p2)
			end
		end)
	end

	return object
end

function class:dispose()
	if self._coreGuiConnection then
		self._coreGuiConnection:Disconnect()
		self._coreGuiConnection = nil
	end

	self.lifecycle:dispose()
end

local lifecycles = {}
local Features = {}
Features.FeatureName = FeatureName

function Features.registerLifecycle(p, p2)
	assert(not lifecycles[p], `Feature "{p}" already has a registered lifecycle`)

	local lifecycle = class.new(p2)
	lifecycles[p] = lifecycle
	return lifecycle
end

function Features.getFeature(p)
	return lifecycles[p]
end

function Features.getVisibility(p)
	local v = lifecycles[p]

	if v then
		return v.lifecycle.getVisible(false)
	end

	return false
end

function Features.setVisibility(p, flag: boolean)
	local v = lifecycles[p]

	if v then
		v.lifecycle.setVisible(flag)
	end
end

function Features.toggleVisibility(p)
	local v = lifecycles[p]

	if v then
		v.lifecycle.setVisible(not v.lifecycle.getVisible(false))
	end
end

function Features.setEnabled(p, flag: boolean)
	local v = lifecycles[p]

	if v then
		v.lifecycle.setEnabled(flag)
	end
end

function Features:onVisibilityChanged(callback)
	local v = lifecycles[self]

	if v then
		return v.lifecycle:onVisibilityChanged(callback)
	end

	return function() end
end

function Features:onEnabledChanged(callback)
	local v = lifecycles[self]

	if v then
		return v.lifecycle:onEnabledChanged(callback)
	end

	return function() end
end

return Features
