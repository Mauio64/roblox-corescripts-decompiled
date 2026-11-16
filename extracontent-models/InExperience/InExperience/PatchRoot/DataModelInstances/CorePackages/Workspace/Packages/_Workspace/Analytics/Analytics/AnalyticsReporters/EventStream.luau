local parent = script:FindFirstAncestor("Analytics").Parent
local UserInputService = game:GetService("UserInputService")

local SharedFlags = require(parent.SharedFlags)
local getPlatformTarget

if SharedFlags.GetFFlagShareGetPlatformTargetImpl() then
	getPlatformTarget = require(script.Parent.Parent.getPlatformTarget)
else
	getPlatformTarget = function()
		local v = Enum.Platform.None

		pcall(function()
			v = UserInputService:GetPlatform()
		end)

		local v2 = v == Enum.Platform.Windows or v == Enum.Platform.OSX

		local v3 = v == Enum.Platform.IOS or v == Enum.Platform.Android or v == Enum.Platform.UWP

		local v4 = v == Enum.Platform.XBox360
			or v == Enum.Platform.XBoxOne
			or v == Enum.Platform.PS3
			or v == Enum.Platform.PS4
			or game:GetEngineFeature("PlatformEnumPS5") and v == Enum.Platform.PS5
			or v == Enum.Platform.WiiU

		return v2 and "client" or v3 and "mobile" or v4 and "console" or "unknownLua" .. tostring(v)
	end
end

local EventStream = {}
EventStream.__index = EventStream

function EventStream.new(reporter)
	local typeName = type(reporter)
	assert(typeName == "table" or typeName == "userdata", "Unexpected value for reportingService")

	local v = { _reporter = reporter, _isEnabled = true }

	setmetatable(v, EventStream)

	return v
end

function EventStream:setEnabled(isEnabled: boolean)
	assert(type(isEnabled) == "boolean", "Expected isEnabled to be a boolean")
	self._isEnabled = isEnabled
end

function EventStream:setRBXEvent(value: string, value2: string, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SetRBXEvent(platformTarget, value, value2, v)
end

function EventStream:setRBXEventStream(value: string, value2: string, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SetRBXEventStream(platformTarget, value, value2, v)
end

function EventStream:releaseRBXEventStream()
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:ReleaseRBXEventStream(getPlatformTarget())
end

function EventStream:sendEventDeferred(value: string, value2: string, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SendEventDeferred(platformTarget, value, value2, v)
end

function EventStream:sendEventImmediately(value: string, value2: string, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:SendEventImmediately(platformTarget, value, value2, v)
end

function EventStream:updateHeartbeatObject(options)
	local v = options or {}

	assert(type(v) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:UpdateHeartbeatObject(v)
end

return EventStream
