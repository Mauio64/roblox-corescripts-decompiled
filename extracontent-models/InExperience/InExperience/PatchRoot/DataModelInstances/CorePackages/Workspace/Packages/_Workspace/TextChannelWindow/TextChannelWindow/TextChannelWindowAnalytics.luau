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

local v = { "addOSInfo", "addSessionInfo", "addPlaceId", "addUniverseId" }

local defineFastFlag = game:DefineFastFlag("TextChannelWindowExcludeStandardizedFieldsFromCounters", false)

local function passthroughCounterBackend()
	local standardizedFields

	if not defineFastFlag then
		standardizedFields = v
	end

	return {
		type = "RobloxTelemetryCounter",
		standardizedFields = standardizedFields,
		format = function(p, p2)
			local clone = table.clone(p)
			clone.enable_protected_chat = tostring(p2.enableProtectedChat)
			return clone
		end
	}
end

local new = SocialLuaAnalytics.Telemetry.new
local standardizedFields

if not defineFastFlag then
	standardizedFields = v
end

local function format(p, p2)
	local clone = table.clone(p)
	clone.enable_protected_chat = tostring(p2.enableProtectedChat)
	return clone
end

local mount = new({
	name = "TextChannelWindowMount",
	description = "Mount outcome per occurrence. result = success | failed | deferred.",
	lastUpdated = { 26, 7, 7 },
	backendsList = {
		{
			type = "RobloxTelemetryCounter",
			standardizedFields = standardizedFields,
			format = format
		}
	},
	throttlingThousandths = game:DefineFastInt("TCWMountCountThrottlePerMyriad", 10000)
})

local new2 = SocialLuaAnalytics.Telemetry.new
local standardizedFields2

if not defineFastFlag then
	standardizedFields2 = v
end

local send = new2({
	name = "TextChannelWindowSend",
	description = "Send outcome per occurrence. result = success | failure.",
	lastUpdated = { 26, 7, 7 },
	backendsList = {
		{
			type = "RobloxTelemetryCounter",
			standardizedFields = standardizedFields2,
			format = format
		}
	},
	throttlingThousandths = game:DefineFastInt("TCWSendCountThrottlePerMyriad", 10000)
})

local new3 = SocialLuaAnalytics.Telemetry.new
local standardizedFields3

if not defineFastFlag then
	standardizedFields3 = v
end

TextChannelWindowAnalytics.Counters = {
	Mount = mount,
	Send = send,
	MessageReceived = new3({
		name = "TextChannelWindowMessageReceived",
		description = "Receive outcome by TextChatMessage.Status.",
		lastUpdated = { 26, 7, 7 },
		backendsList = {
			{
				type = "RobloxTelemetryCounter",
				standardizedFields = standardizedFields3,
				format = format
			}
		},
		throttlingThousandths = game:DefineFastInt("TCWMessageReceivedCountThrottlePerMyriad", 1000)
	})
}

game:SetFlagVersion("TextChannelWindowCountersEnabled", 2)
local defineFastFlag2 = game:DefineFastFlag("TextChannelWindowCountersEnabled", false)

local v2 = nil

function TextChannelWindowAnalytics._setCountersEnabledForTesting(flag: boolean?)
	v2 = flag
end

function TextChannelWindowAnalytics.emit(p, p2)
	local v3 = if v2 == nil then defineFastFlag2 else v2

	if not v3 then
		return
	end

	emitter.emit(p, p2)
end

local defineFastFlag3 = game:DefineFastFlag("TextChannelWindowEventStreamEnabled", false)

local defineFastFlag4 = game:DefineFastFlag("TextChannelWindowMessageRenderedEnabled", false)
local defineFastInt = game:DefineFastInt("TextChannelWindowMessageRenderedPermyriad", 0)

function TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled()
	return defineFastFlag3 and game:GetEngineFeature("ExpChatTelemetryEventTrigger")
end

function TextChannelWindowAnalytics.getFFlagExpChatUseUpdatedMessageRendered()
	return defineFastFlag4 and game:GetEngineFeature("ExpChatAddMessageRenderedSurfaceFields")
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
