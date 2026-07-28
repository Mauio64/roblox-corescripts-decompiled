local TextChatService = game:GetService("TextChatService")
local Parent = script:FindFirstAncestor("TextChannelWindow").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local LoggingProtocol = require(Parent.LoggingProtocol)
local t1 = {
	getChannelCategory = function(s1: string?) -- line: 12
		if not s1 or s1 == "" then
			return "none"
		end

		if s1:match("^RBXGeneral") then
			return "general"
		end

		if s1:match("^RBXTeam") then
			return "team"
		end

		if s1:match("^RBXWhisper") then
			return "whisper"
		end

		if s1:match("^RBXSystem") then
			return "system"
		end

		return "custom"
	end,
	getEnableProtectedChat = function() -- line: 34
		-- upvalues: TextChatService (copy)
		if game:GetEngineFeature("TextChatServiceProtectedChatEnabled") then
			return TextChatService:IsProtectedChatEnabled()
		end

		return false
	end
}
local v6 = SocialLuaAnalytics.Telemetry.createEmitter({
	shouldUseTelemetryService = true,
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = 10000,
		links = "https://roblox.atlassian.net/wiki/spaces/SOCIAL/pages/4918804707"
	},
	getSharedInfo = function() -- line: 49
		-- upvalues: t1 (copy)
		return {
			enableProtectedChat = t1.getEnableProtectedChat()
		}
	end
})
local t2 = {
	"addOSInfo",
	"addSessionInfo",
	"addPlaceId",
	"addUniverseId"
}

local function passthroughCounterBackend() -- line: 71
	-- upvalues: t2 (copy)
	return {
		type = "RobloxTelemetryCounter",
		standardizedFields = t2,
		format = function(t3: {[any]: any}, t4: {[any]: any}) -- line: 78
			local v41 = table.clone(t3)

			v41.enable_protected_chat = tostring(t4.enableProtectedChat)

			return v41
		end
	}
end

local v9 = SocialLuaAnalytics.Telemetry.new({
	name = "TextChannelWindowMount",
	description = "Mount outcome per occurrence. result = success | failed | deferred.",
	lastUpdated = {
		26,
		7,
		7
	},
	backendsList = {{
		type = "RobloxTelemetryCounter",
		standardizedFields = t2,
		format = function(t5: {[any]: any}, t6: {[any]: any}) -- line: 78
			local v21 = table.clone(t5)

			v21.enable_protected_chat = tostring(t6.enableProtectedChat)

			return v21
		end
	}},
	throttlingThousandths = game:DefineFastInt("TCWMountCountThrottlePerMyriad", 10000)
})
local v10 = SocialLuaAnalytics.Telemetry.new({
	name = "TextChannelWindowSend",
	description = "Send outcome per occurrence. result = success | failure.",
	lastUpdated = {
		26,
		7,
		7
	},
	backendsList = {{
		type = "RobloxTelemetryCounter",
		standardizedFields = t2,
		format = function(t7: {[any]: any}, t8: {[any]: any}) -- line: 78
			local v24 = table.clone(t7)

			v24.enable_protected_chat = tostring(t8.enableProtectedChat)

			return v24
		end
	}},
	throttlingThousandths = game:DefineFastInt("TCWSendCountThrottlePerMyriad", 10000)
})
local v11 = SocialLuaAnalytics.Telemetry.new({
	name = "TextChannelWindowMessageReceived",
	description = "Receive outcome by TextChatMessage.Status.",
	lastUpdated = {
		26,
		7,
		7
	},
	backendsList = {{
		type = "RobloxTelemetryCounter",
		standardizedFields = t2,
		format = function(t9: {[any]: any}, t10: {[any]: any}) -- line: 78
			local v27 = table.clone(t9)

			v27.enable_protected_chat = tostring(t10.enableProtectedChat)

			return v27
		end
	}},
	throttlingThousandths = game:DefineFastInt("TCWMessageReceivedCountThrottlePerMyriad", 1000)
})

t1.Counters = {
	Mount = v9,
	Send = v10,
	MessageReceived = v11
}
game:SetFlagVersion("TextChannelWindowCountersEnabled", 2)

local v12 = game:DefineFastFlag("TextChannelWindowCountersEnabled", false)
local u13 = nil

function t1._setCountersEnabledForTesting(b1: boolean?) -- line: 126
	-- upvalues: u13 (ref)
	u13 = b1
end
function t1.emit(p1, p2) -- line: 132
	-- upvalues: u13 (ref), v12 (copy), v6 (copy)
	if not if u13 == nil then v12 else u13 then
		return
	end

	v6.emit(p1, p2)
end

local v14 = game:DefineFastFlag("TextChannelWindowEventStreamEnabled", false)
local v15 = game:DefineFastFlag("TextChannelWindowMessageRenderedEnabled", false)
local v16 = game:DefineFastInt("TextChannelWindowMessageRenderedPermyriad", 0)

function t1.getFFlagExpChatTelemetryEnabled() -- line: 148
	-- upvalues: v14 (copy)
	return v14 and game:GetEngineFeature("ExpChatTelemetryEventTrigger")
end
function t1.getFFlagExpChatUseUpdatedMessageRendered() -- line: 152
	-- upvalues: v15 (copy)
	return v15 and game:GetEngineFeature("ExpChatAddMessageRenderedSurfaceFields")
end
function t1.shouldSendMessageRenderedTelemetry() -- line: 157
	-- upvalues: v16 (copy)
	local LocalPlayer = game:GetService("Players").LocalPlayer

	if not LocalPlayer then
		return false
	end

	return LocalPlayer.UserId % 10000 < v16
end

t1.FIntTextChannelWindowScrollThrottleMs = game:DefineFastInt("TextChannelWindowScrollThrottleMs", 400)

local function throttle(p3: ((...any) -> ...any), p4: ((...any) -> ...any)) -- line: 172
	local u34 = nil

	return function() -- line: 174
		-- upvalues: u34 (ref), p3 (copy), p4 (copy)
		if u34 then
			return
		end

		p3()
		u34 = task.delay(p4() / 1000, function() -- line: 179
			-- upvalues: u34 (ref)
			u34 = nil
		end)
	end
end

function t1.createOnScrollCallback(s2: string?) -- line: 187
	-- upvalues: t1 (copy), TextChatService (copy)
	if not t1.getFFlagExpChatTelemetryEnabled() then
		return nil
	end

	local function v36() -- line: 191
		-- upvalues: TextChatService (copy), s2 (copy)
		TextChatService:SendExpChatWindowScroll("text_channel_window", s2 or "")
	end
	local function v37() -- line: 193
		-- upvalues: t1 (copy)
		return t1.FIntTextChannelWindowScrollThrottleMs
	end

	local u38 = nil

	return function() -- line: 174
		-- upvalues: u38 (ref), v36 (copy), v37 (copy)
		if u38 then
			return
		end

		v36()
		u38 = task.delay(v37() / 1000, function() -- line: 179
			-- upvalues: u38 (ref)
			u38 = nil
		end)
	end
end

return t1
