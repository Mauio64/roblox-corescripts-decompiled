local Analytics = script:FindFirstAncestor("Analytics")
local AnalyticsParent = Analytics.Parent
local UserInputService = game:GetService("UserInputService")
local getPlatformTarget

if require(AnalyticsParent.SharedFlags).GetFFlagShareGetPlatformTargetImpl() then
	getPlatformTarget = require(Analytics.getPlatformTarget)
else
	function getPlatformTarget() -- line: 19
		-- upvalues: UserInputService (copy)
		local None = Enum.Platform.None

		pcall(function() -- line: 25
			-- upvalues: None (ref), UserInputService (copy)
			None = UserInputService:GetPlatform()
		end)

		local v7 = None == Enum.Platform.Windows or None == Enum.Platform.OSX
		local v8 = None == Enum.Platform.IOS or None == Enum.Platform.Android or None == Enum.Platform.UWP
		local v9 = None == Enum.Platform.XBox360 or None == Enum.Platform.XBoxOne or (None == Enum.Platform.PS3 or (None == Enum.Platform.PS4 or game:GetEngineFeature("PlatformEnumPS5") and None == Enum.Platform.PS5)) or None == Enum.Platform.WiiU

		return if not v7 then if not v8 then if not v9 then "unknownLua" .. tostring(None) else "console" else "mobile" else "client"
	end
end

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 61
	-- upvalues: t1 (copy)
	local v11 = type(p1)

	assert(v11 == "table" or v11 == "userdata", "Unexpected value for eventIngestService")

	local t2 = {
		_eventIngest = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.setRBXEvent(p2, p3, p4, p5) -- line: 76
	-- upvalues: getPlatformTarget (ref)
	local v17 = getPlatformTarget()
	local v18 = p5 or {}

	assert(type(p3) == "string", "Expected eventContext to be a string")
	assert(type(p4) == "string", "Expected eventName to be a string")
	assert(type(v18) == "table", "Expected additionalArgs to be a table")
	p2._eventIngest:SetRBXEvent(v17, p3, p4, v18)
end
function t1.setRBXEventStream(p6, p7, p8, p9) -- line: 90
	-- upvalues: getPlatformTarget (ref)
	local v23 = getPlatformTarget()
	local v24 = p9 or {}

	assert(type(p7) == "string", "Expected eventContext to be a string")
	assert(type(p8) == "string", "Expected eventName to be a string")
	assert(type(v24) == "table", "Expected additionalArgs to be a table")
	p6._eventIngest:SetRBXEventStream(v23, p7, p8, v24)
end
function t1.sendEventDeferred(p10, p11, p12, p13) -- line: 104
	-- upvalues: getPlatformTarget (ref)
	local v29 = getPlatformTarget()
	local v30 = p13 or {}

	assert(type(p11) == "string", "Expected eventContext to be a string")
	assert(type(p12) == "string", "Expected eventName to be a string")
	assert(type(v30) == "table", "Expected additionalArgs to be a table")
	p10._eventIngest:SendEventDeferred(v29, p11, p12, v30)
end
function t1.sendEventImmediately(p14, p15, p16, p17) -- line: 119
	-- upvalues: getPlatformTarget (ref)
	local v35 = getPlatformTarget()
	local v36 = p17 or {}

	assert(type(p15) == "string", "Expected eventContext to be a string")
	assert(type(p16) == "string", "Expected eventName to be a string")
	assert(type(v36) == "table", "Expected additionalArgs to be a table")
	p14._eventIngest:SendEventImmediately(v35, p15, p16, v36)
end

return t1
