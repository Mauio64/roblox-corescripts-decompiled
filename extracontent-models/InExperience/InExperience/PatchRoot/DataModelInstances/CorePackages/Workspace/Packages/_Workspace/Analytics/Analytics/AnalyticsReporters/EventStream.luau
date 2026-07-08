local Parent = script:FindFirstAncestor("Analytics").Parent
local UserInputService = game:GetService("UserInputService")
local getPlatformTarget

if require(Parent.SharedFlags).GetFFlagShareGetPlatformTargetImpl() then
	getPlatformTarget = require(script.Parent.Parent.getPlatformTarget)
else
	function getPlatformTarget() -- line: 36
		-- upvalues: UserInputService (copy)
		local None = Enum.Platform.None

		pcall(function() -- line: 42
			-- upvalues: None (ref), UserInputService (copy)
			None = UserInputService:GetPlatform()
		end)

		local v6 = None == Enum.Platform.Windows or None == Enum.Platform.OSX
		local v7 = None == Enum.Platform.IOS or None == Enum.Platform.Android or None == Enum.Platform.UWP
		local v8 = None == Enum.Platform.XBox360 or None == Enum.Platform.XBoxOne or (None == Enum.Platform.PS3 or (None == Enum.Platform.PS4 or game:GetEngineFeature("PlatformEnumPS5") and None == Enum.Platform.PS5)) or None == Enum.Platform.WiiU

		return if not v6 then if not v7 then if not v8 then "unknownLua" .. tostring(None) else "console" else "mobile" else "client"
	end
end

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 79
	-- upvalues: t1 (copy)
	local v10 = type(p1)

	assert(v10 == "table" or v10 == "userdata", "Unexpected value for reportingService")

	local t2 = {
		_isEnabled = true,
		_reporter = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.setEnabled(t3: {[any]: any}, b1: boolean) -- line: 92
	assert(type(b1) == "boolean", "Expected isEnabled to be a boolean")
	t3._isEnabled = b1
end
function t1.setRBXEvent(t4: {[any]: any}, s1: string, s2: string, t5: {[any]: any}?) -- line: 100
	-- upvalues: getPlatformTarget (ref)
	local v18 = getPlatformTarget()
	local v19 = t5 or {}

	assert(type(s1) == "string", "Expected eventContext to be a string")
	assert(type(s2) == "string", "Expected eventName to be a string")
	assert(type(v19) == "table", "Expected additionalArgs to be a table")
	assert(t4._isEnabled, "This reporting service is disabled")
	t4._reporter:SetRBXEvent(v18, s1, s2, v19)
end
function t1.setRBXEventStream(t6: {[any]: any}, s3: string, s4: string, t7: {[any]: any}?) -- line: 116
	-- upvalues: getPlatformTarget (ref)
	local v24 = getPlatformTarget()
	local v25 = t7 or {}

	assert(type(s3) == "string", "Expected eventContext to be a string")
	assert(type(s4) == "string", "Expected eventName to be a string")
	assert(type(v25) == "table", "Expected additionalArgs to be a table")
	assert(t6._isEnabled, "This reporting service is disabled")
	t6._reporter:SetRBXEventStream(v24, s3, s4, v25)
end
function t1.releaseRBXEventStream(p2) -- line: 129
	-- upvalues: getPlatformTarget (ref)
	assert(p2._isEnabled, "This reporting service is disabled")
	p2._reporter:ReleaseRBXEventStream(getPlatformTarget())
end
function t1.sendEventDeferred(t8: {[any]: any}, s5: string, s6: string, t9: {[any]: any}?) -- line: 138
	-- upvalues: getPlatformTarget (ref)
	local v31 = getPlatformTarget()
	local v32 = t9 or {}

	assert(type(s5) == "string", "Expected eventContext to be a string")
	assert(type(s6) == "string", "Expected eventName to be a string")
	assert(type(v32) == "table", "Expected additionalArgs to be a table")
	assert(t8._isEnabled, "This reporting service is disabled")
	t8._reporter:SendEventDeferred(v31, s5, s6, v32)
end
function t1.sendEventImmediately(t10: {[any]: any}, s7: string, s8: string, t11: {[any]: any}?) -- line: 154
	-- upvalues: getPlatformTarget (ref)
	local v37 = getPlatformTarget()
	local v38 = t11 or {}

	assert(type(s7) == "string", "Expected eventContext to be a string")
	assert(type(s8) == "string", "Expected eventName to be a string")
	assert(type(v38) == "table", "Expected additionalArgs to be a table")
	assert(t10._isEnabled, "This reporting service is disabled")
	t10._reporter:SendEventImmediately(v37, s7, s8, v38)
end
function t1.updateHeartbeatObject(t12: {[any]: any}, t13: {[any]: any}?) -- line: 168
	local v41 = t13 or {}

	assert(type(v41) == "table", "Expected additionalArgs to be a table")
	assert(t12._isEnabled, "This reporting service is disabled")
	t12._reporter:UpdateHeartbeatObject(v41)
end

return t1
