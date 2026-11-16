local UserInputService = game:GetService("UserInputService")
local getPlatformTarget

if require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/SharedFlags").GetFFlagShareGetPlatformTargetImpl() then
	getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/getPlatformTarget")
else
	getPlatformTarget = function()
		local v5 = Enum.Platform.None

		pcall(function()
			v5 = UserInputService:GetPlatform()
		end)

		local v6 = v5 == Enum.Platform.Windows or v5 == Enum.Platform.OSX

		local v7 = v5 == Enum.Platform.IOS or v5 == Enum.Platform.Android or v5 == Enum.Platform.UWP

		local v8 = v5 == Enum.Platform.XBox360
			or v5 == Enum.Platform.XBoxOne
			or v5 == Enum.Platform.PS3
			or v5 == Enum.Platform.PS4
			or game:GetEngineFeature("PlatformEnumPS5") and v5 == Enum.Platform.PS5
			or v5 == Enum.Platform.WiiU

		return v6 and "client" or v7 and "mobile" or v8 and "console" or "unknownLua" .. tostring(v5)
	end
end

local class = {}
class.__index = class

function class.new(p2)
	local typeName = type(p2)
	assert(typeName == "table" or typeName == "userdata", "Unexpected value for reportingService")

	local v5 = { _reporter = p2, _isEnabled = true }

	setmetatable(v5, class)

	return v5
end

function class:setEnabled(isEnabled)
	assert(type(isEnabled) == "boolean", "Expected isEnabled to be a boolean")
	self._isEnabled = isEnabled
end

function class:setRBXEvent(value, value2, options)
	local v5 = getPlatformTarget()
	local v6 = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v6) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SetRBXEvent(v5, value, value2, v6)
end

function class:setRBXEventStream(value, value2, options)
	local v5 = getPlatformTarget()
	local v6 = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v6) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SetRBXEventStream(v5, value, value2, v6)
end

function class:releaseRBXEventStream()
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:ReleaseRBXEventStream(getPlatformTarget())
end

function class:sendEventDeferred(value, value2, options)
	local v5 = getPlatformTarget()
	local v6 = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v6) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SendEventDeferred(v5, value, value2, v6)
end

function class:sendEventImmediately(value, value2, options)
	local v5 = getPlatformTarget()
	local v6 = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v6) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SendEventImmediately(v5, value, value2, v6)
end

function class:updateHeartbeatObject(options)
	local v5 = options or {}

	assert(type(v5) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:UpdateHeartbeatObject(v5)
end

return class
