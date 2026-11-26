local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local TextChatService = game:GetService("TextChatService")

local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Logger"):new("ExpChat/Analytics")

local v6 = {}
local v7 = RbxAnalyticsService

local function withDefaultArgs(p2)
	return dictionary.join(p2, {
		gameId = tostring(game.GameId),
		placeId = tostring(game.PlaceId)
	})
end

local function setRbxEventStream(p2, p3, p4, options)
	if v7 then
		v5:debug("Event: {}", p4)
		v7:SetRBXEventStream(p2, p3, p4, withDefaultArgs(options or {}))
	end
end

local function sendEventDeferred(p2, p3, p4, options)
	if v7 then
		v5:debug("SendEventDeferred: {}", p4)
		v7:SendEventDeferred(p2, p3, p4, withDefaultArgs(options or {}))
	end
end

function v6.with(p2)
	v7 = p2 or RbxAnalyticsService
end

function v6.FireRccAnalyticsWithEventName(p2, p3)
	setRbxEventStream("rcc", "experienceChat", p2, p3)
end

function v6.FireClientAnalyticsWithEventName(p2, p3)
	setRbxEventStream("client", "experienceChat", p2, p3)
end

function v6.reportHistoryReplayed(p2, p3, p4)
	v6.FireClientAnalyticsWithEventName("HistoryReplayed", {
		receivedCount = p2,
		keptCount = p3,
		latencyMs = p4
	})
end

function v6.reportCounter(p2, value)
	if v7 then
		v5:debug("Counter: {}", p2)
		v7:ReportCounter(p2, value or 1)
	end
end

v6.ExpChatChatEnabledUserCountFetchConfig = {
	eventName = "ExpChatChatEnabledUserCountFetch",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 7, 22 },
	description = "Counts successful and failed attempts to fetch the local chat-enabled system message user count.",
	links = ""
}

function v6.reportChatEnabledUserCountFetchResult(p2)
	TelemetryService:LogCounter(v6.ExpChatChatEnabledUserCountFetchConfig, {
		customFields = {
			result = p2 and "success" or "failure"
		}
	}, 1)
end

function v6.FireRccAnalyticsDeferred(p2, p3)
	sendEventDeferred("RCC", "experienceChat", p2, p3)
end

function v6.TelemetryLogEvent(p2, p3, p4, p5)
	TelemetryService:LogEvent(p3, { customFields = p4, standardizedFields = p5 })
end

v6.DefaultStandardizedFields = {
	"addOSInfo",
	"addSessionInfo",
	"addUniverseId",
	"addPlaceId"
}

function v6.reportTextChatCommandClientSent(p2, p3)
	TextChatService:SendTextChatCommandClientSent(p3)
	p2.FireClientAnalyticsWithEventName("CommandSent", { commandName = p3 })
end

v6.RewriteDropdownToggledConfig = {
	eventName = "RewriteDropdownToggled",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatRewriteDropdownToggledThrottlePerMyriad", 10000),
	lastUpdated = { 26, 4, 21 },
	description = "When a user activates the AI rewrite dropdown toggle on a rewritten chat message.",
	links = ""
}

v6.ExpChatGlobalChatTabClickedConfig = {
	eventName = "ExpChatGlobalChatTabClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatGlobalChatTabClickedThrottlePerMyriad", 0),
	lastUpdated = { 26, 5, 13 },
	description = "When a user selects the Global channel tab in the experience chat channel bar.",
	links = ""
}

v6.ExpChatTabClickedConfig = {
	eventName = "ExpChatTabClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatTabClickedThrottlePerMyriad", 10000),
	lastUpdated = { 26, 8, 12 },
	description = "When a user clicks any tab in the experience chat channel bar.",
	links = "https://roblox.atlassian.net/wiki/spaces/SOCIAL/pages/4777640083/Friends+Chat+In+Exp+Tech+Spec#Experience-Chat-Tab-Events-Proposal"
}

v6.ExpChatTabImpressionConfig = {
	eventName = "ExpChatTabImpression",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatTabImpressionThrottlePerMyriad", 10000),
	lastUpdated = { 26, 7, 27 },
	description = "When an experience chat tab is rendered or a tracked field (index, overflow, visibility, badge count) changes.",
	links = "https://roblox.atlassian.net/wiki/spaces/SOCIAL/pages/4777640083/Friends+Chat+In+Exp+Tech+Spec#Experience-Chat-Tab-Events-Proposal"
}

v6.ExpChatPresetActionConfig = {
	eventName = "ExpChatPresetAction",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatPresetActionThrottlePerMyriad", 10000),
	lastUpdated = { 26, 6, 1 },
	description = "When a user interacts with the preset chat UI.",
	links = "https://roblox.atlassian.net/browse/EXPCHAT-1243"
}

return v6
