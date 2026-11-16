local Analytics = script:FindFirstAncestor("Analytics")
local parent = Analytics.Parent

local UserInputService = game:GetService("UserInputService")

local SharedFlags = require(parent.SharedFlags)
local getPlatformTarget

if SharedFlags.GetFFlagShareGetPlatformTargetImpl() then
	getPlatformTarget = require(Analytics.getPlatformTarget)
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

local EventIngest = {}
EventIngest.__index = EventIngest

function EventIngest.new(eventIngest)
	local typeName = type(eventIngest)
	assert(typeName == "table" or typeName == "userdata", "Unexpected value for eventIngestService")

	local v = { _eventIngest = eventIngest }

	setmetatable(v, EventIngest)

	return v
end

function EventIngest:setRBXEvent(value, value2, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")

	self._eventIngest:SetRBXEvent(platformTarget, value, value2, v)
end

function EventIngest:setRBXEventStream(value, value2, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")

	self._eventIngest:SetRBXEventStream(platformTarget, value, value2, v)
end

function EventIngest:sendEventDeferred(value, value2, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")

	self._eventIngest:SendEventDeferred(platformTarget, value, value2, v)
end

function EventIngest:sendEventImmediately(value, value2, options)
	local platformTarget = getPlatformTarget()
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")

	self._eventIngest:SendEventImmediately(platformTarget, value, value2, v)
end

return EventIngest
