local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local TextChatService = game:GetService("TextChatService")
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local v7 = require(ExpChatShared.Logger):new("ExpChat/" .. script.Name)
local t1 = {}
local u9 = RbxAnalyticsService

local function withDefaultArgs(p1) -- line: 17
	-- upvalues: Dictionary (copy)
	return Dictionary.join(p1, {
		gameId = tostring(game.GameId),
		placeId = tostring(game.PlaceId)
	})
end
local function setRbxEventStream(s1: string, s2: string, s3: string, p2) -- line: 24
	-- upvalues: u9 (ref), v7 (copy), withDefaultArgs (copy)
	if u9 then
		v7:debug("Event: {}", s3)
		u9:SetRBXEventStream(s1, s2, s3, withDefaultArgs(p2 or {}))
	end
end
local function sendEventDeferred(s4: string, s5: string, s6: string, p3) -- line: 31
	-- upvalues: u9 (ref), v7 (copy), withDefaultArgs (copy)
	if u9 then
		v7:debug("SendEventDeferred: {}", s6)
		u9:SendEventDeferred(s4, s5, s6, withDefaultArgs(p3 or {}))
	end
end

function t1.with(p4) -- line: 38
	-- upvalues: u9 (ref), RbxAnalyticsService (copy)
	u9 = p4 or RbxAnalyticsService
end
function t1.FireRccAnalyticsWithEventName(s7: string, p5) -- line: 42
	-- upvalues: setRbxEventStream (copy)
	setRbxEventStream("rcc", "experienceChat", s7, p5)
end
function t1.FireClientAnalyticsWithEventName(s8: string, p6) -- line: 46
	-- upvalues: setRbxEventStream (copy)
	setRbxEventStream("client", "experienceChat", s8, p6)
end
function t1.reportCounter(s9: string, n1: number?) -- line: 50
	-- upvalues: u9 (ref), v7 (copy)
	if u9 then
		v7:debug("Counter: {}", s9)
		u9:ReportCounter(s9, n1 or 1)
	end
end

t1.ExpChatChatEnabledUserCountFetchConfig = {
	eventName = "ExpChatChatEnabledUserCountFetch",
	description = "Counts successful and failed attempts to fetch the local chat-enabled system message user count.",
	links = "",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2026,
		7,
		22
	}
}

function t1.reportChatEnabledUserCountFetchResult(b1: boolean) -- line: 65
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogCounter(t1.ExpChatChatEnabledUserCountFetchConfig, {
		customFields = {
			result = not b1 and "failure" or "success"
		}
	}, 1)
end
function t1.FireRccAnalyticsDeferred(s10: string, p7) -- line: 73
	-- upvalues: sendEventDeferred (copy)
	sendEventDeferred("RCC", "experienceChat", s10, p7)
end
function t1.TelemetryLogEvent(_: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?, t5: {[any]: any}?) -- line: 77
	-- upvalues: TelemetryService (copy)
	TelemetryService:LogEvent(t3, {
		customFields = t4,
		standardizedFields = t5
	})
end

t1.DefaultStandardizedFields = {
	"addOSInfo",
	"addSessionInfo",
	"addUniverseId",
	"addPlaceId"
}

function t1.reportTextChatCommandClientSent(t6: {[any]: any}, s11: string) -- line: 83
	-- upvalues: TextChatService (copy)
	TextChatService:SendTextChatCommandClientSent(s11)
	t6.FireClientAnalyticsWithEventName("CommandSent", {
		commandName = s11
	})
end

t1.RewriteDropdownToggledConfig = {
	eventName = "RewriteDropdownToggled",
	description = "When a user activates the AI rewrite dropdown toggle on a rewritten chat message.",
	links = "",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatRewriteDropdownToggledThrottlePerMyriad", 10000),
	lastUpdated = {
		26,
		4,
		21
	}
}
t1.ExpChatGlobalChatTabClickedConfig = {
	eventName = "ExpChatGlobalChatTabClicked",
	description = "When a user selects the Global channel tab in the experience chat channel bar.",
	links = "",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatGlobalChatTabClickedThrottlePerMyriad", 0),
	lastUpdated = {
		26,
		5,
		13
	}
}
t1.ExpChatPresetActionConfig = {
	eventName = "ExpChatPresetAction",
	description = "When a user interacts with the preset chat UI.",
	links = "https://roblox.atlassian.net/browse/EXPCHAT-1243",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatPresetActionThrottlePerMyriad", 10000),
	lastUpdated = {
		26,
		6,
		1
	}
}

return t1
