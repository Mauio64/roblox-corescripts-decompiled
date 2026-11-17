local TextChatService = game:GetService("TextChatService")

local parent = script:FindFirstAncestor("TextChannelWindow").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local LoggingProtocol = require(parent.LoggingProtocol)

local TextChannelWindowAnalytics = {}

function TextChannelWindowAnalytics.getChannelCategory(value: string?): string
	if not value or value == "" then
		return "none"
	end

	if value:match("^RBXGeneral") then
		return "general"
	end

	if value:match("^RBXTeam") then
		return "team"
	end

	if value:match("^RBXWhisper") then
		return "whisper"
	end

	return if value:match("^RBXSystem") then "system" else "custom"
end

function TextChannelWindowAnalytics.getEnableProtectedChat()
	if game:GetEngineFeature("TextChatServiceProtectedChatEnabled") then
		return TextChatService:IsProtectedChatEnabled()
	end

	return false
end

local emitter = SocialLuaAnalytics.Telemetry.createEmitter({
	shouldUseTelemetryService = true,
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = 10000,
		links = "https://roblox.atlassian.net/wiki/spaces/SOCIAL/pages/4918804707"
	},
	getSharedInfo = function()
		return {
			enableProtectedChat = TextChannelWindowAnalytics.getEnableProtectedChat()
		}
	end
})

local function passthroughCounterBackend()
	return {
		type = "RobloxTelemetryCounter",
		format = function(p, p2)
			local clone = table.clone(p)
			clone.enable_protected_chat = tostring(p2.enableProtectedChat)
			return clone
		end
	}
end
local function format(p, p2)
	local clone = table.clone(p)
	clone.enable_protected_chat = tostring(p2.enableProtectedChat)
	return clone
end

TextChannelWindowAnalytics.Counters = {
	Mount = SocialLuaAnalytics.Telemetry.new({
		name = "TextChannelWindowMount",
		description = "Mount outcome per occurrence. result = success | failed | deferred.",
		lastUpdated = { 26, 7, 7 },
		backendsList = {
			{ type = "RobloxTelemetryCounter", format = format }
		},
		throttlingThousandths = game:DefineFastInt("TCWMountCountThrottlePerMyriad", 10000)
	}),
	Send = SocialLuaAnalytics.Telemetry.new({
		name = "TextChannelWindowSend",
		description = "Send outcome per occurrence. result = success | failure.",
		lastUpdated = { 26, 7, 7 },
		backendsList = {
			{ type = "RobloxTelemetryCounter", format = format }
		},
		throttlingThousandths = game:DefineFastInt("TCWSendCountThrottlePerMyriad", 10000)
	}),
	MessageReceived = SocialLuaAnalytics.Telemetry.new({
		name = "TextChannelWindowMessageReceived",
		description = "Receive outcome by TextChatMessage.Status.",
		lastUpdated = { 26, 7, 7 },
		backendsList = {
			{ type = "RobloxTelemetryCounter", format = format }
		},
		throttlingThousandths = game:DefineFastInt("TCWMessageReceivedCountThrottlePerMyriad", 1000)
	})
}

function TextChannelWindowAnalytics.emit(p, p2)
	emitter.emit(p, p2)
end

local defineFastFlag = game:DefineFastFlag("TextChannelWindowEventStreamEnabled", false)

local defineFastFlag2 = game:DefineFastFlag("TextChannelWindowMessageRenderedEnabled", false)
local defineFastInt = game:DefineFastInt("TextChannelWindowMessageRenderedPermyriad", 0)

function TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled()
	return defineFastFlag and game:GetEngineFeature("ExpChatTelemetryEventTrigger")
end

function TextChannelWindowAnalytics.getFFlagExpChatUseUpdatedMessageRendered()
	return defineFastFlag2 and game:GetEngineFeature("ExpChatAddMessageRenderedSurfaceFields")
end

function TextChannelWindowAnalytics.shouldSendMessageRenderedTelemetry(): boolean
	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return localPlayer.UserId % 10000 < defineFastInt
	end

	return false
end

TextChannelWindowAnalytics.FIntTextChannelWindowScrollThrottleMs = game:DefineFastInt("TextChannelWindowScrollThrottleMs", 400)

local function throttle(fn, fn2) -- 1 equivalent call inferred from this helper
	local thread = nil
	return function()
		if thread then
			return
		end

		fn()
		thread = task.delay(fn2() / 1000, function()
			thread = nil
		end)
	end
end

function TextChannelWindowAnalytics.createOnScrollCallback(value: string?)
	if not TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
		return nil
	end

	local function fn()
		TextChatService:SendExpChatWindowScroll("text_channel_window", value or "")
	end
	local function fn2()
		return TextChannelWindowAnalytics.FIntTextChannelWindowScrollThrottleMs
	end

	return throttle(fn, fn2) -- inferred equivalent call
end

return TextChannelWindowAnalytics
