local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local TextChatService = game:GetService("TextChatService")

local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Logger = require(ExpChatShared.Logger)
local v = Logger:new("ExpChat/" .. script.Name)

local Analytics = {}
local v2 = RbxAnalyticsService

local function withDefaultArgs(p)
	return dictionary.join(p, { gameId = tostring(game.GameId), placeId = tostring(game.PlaceId) })
end

local function setRbxEventStream(p: string, p2: string, p3: string, options)
	if v2 then
		v:debug("Event: {}", p3)
		v2:SetRBXEventStream(p, p2, p3, withDefaultArgs(options or {}))
	end
end

local function sendEventDeferred(p: string, p2: string, p3: string, options)
	if v2 then
		v:debug("SendEventDeferred: {}", p3)
		v2:SendEventDeferred(p, p2, p3, withDefaultArgs(options or {}))
	end
end

function Analytics.with(p)
	v2 = p or RbxAnalyticsService
end

function Analytics.FireRccAnalyticsWithEventName(p: string, p2)
	setRbxEventStream("rcc", "experienceChat", p, p2)
end

function Analytics.FireClientAnalyticsWithEventName(p: string, p2)
	setRbxEventStream("client", "experienceChat", p, p2)
end

function Analytics.reportHistoryReplayed(receivedCount: number, keptCount: number, latencyMs: number)
	Analytics.FireClientAnalyticsWithEventName("HistoryReplayed", {
		receivedCount = receivedCount,
		keptCount = keptCount,
		latencyMs = latencyMs
	})
end

function Analytics.reportCounter(p: string, value: number?)
	if v2 then
		v:debug("Counter: {}", p)
		v2:ReportCounter(p, value or 1)
	end
end

Analytics.ExpChatChatEnabledUserCountFetchConfig = {
	eventName = "ExpChatChatEnabledUserCountFetch",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 7, 22 },
	description = "Counts successful and failed attempts to fetch the local chat-enabled system message user count.",
	links = ""
}

function Analytics.reportChatEnabledUserCountFetchResult(flag: boolean)
	TelemetryService:LogCounter(Analytics.ExpChatChatEnabledUserCountFetchConfig, {
		customFields = {
			result = flag and "success" or "failure"
		}
	}, 1)
end

function Analytics.FireRccAnalyticsDeferred(p: string, p2)
	sendEventDeferred("RCC", "experienceChat", p, p2)
end

function Analytics.TelemetryLogEvent(_, p, customFields, standardizedFields)
	TelemetryService:LogEvent(p, {
		customFields = customFields,
		standardizedFields = standardizedFields
	})
end

Analytics.DefaultStandardizedFields = {
	"addOSInfo",
	"addSessionInfo",
	"addUniverseId",
	"addPlaceId"
}

function Analytics.reportTextChatCommandClientSent(p, commandName: string)
	TextChatService:SendTextChatCommandClientSent(commandName)
	p.FireClientAnalyticsWithEventName("CommandSent", { commandName = commandName })
end

Analytics.RewriteDropdownToggledConfig = {
	eventName = "RewriteDropdownToggled",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatRewriteDropdownToggledThrottlePerMyriad", 10000),
	lastUpdated = { 26, 4, 21 },
	description = "When a user activates the AI rewrite dropdown toggle on a rewritten chat message.",
	links = ""
}

Analytics.ExpChatGlobalChatTabClickedConfig = {
	eventName = "ExpChatGlobalChatTabClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatGlobalChatTabClickedThrottlePerMyriad", 0),
	lastUpdated = { 26, 5, 13 },
	description = "When a user selects the Global channel tab in the experience chat channel bar.",
	links = ""
}

Analytics.ExpChatTabClickedConfig = {
	eventName = "ExpChatTabClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatTabClickedThrottlePerMyriad", 10000),
	lastUpdated = { 26, 8, 12 },
	description = "When a user clicks any tab in the experience chat channel bar.",
	links = "https://roblox.atlassian.net/wiki/spaces/SOCIAL/pages/4777640083/Friends+Chat+In+Exp+Tech+Spec#Experience-Chat-Tab-Events-Proposal"
}

Analytics.ExpChatTabImpressionConfig = {
	eventName = "ExpChatTabImpression",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatTabImpressionThrottlePerMyriad", 10000),
	lastUpdated = { 26, 7, 27 },
	description = "When an experience chat tab is rendered or a tracked field (index, overflow, visibility, badge count) changes.",
	links = "https://roblox.atlassian.net/wiki/spaces/SOCIAL/pages/4777640083/Friends+Chat+In+Exp+Tech+Spec#Experience-Chat-Tab-Events-Proposal"
}

Analytics.ExpChatPresetActionConfig = {
	eventName = "ExpChatPresetAction",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ExpChatPresetActionThrottlePerMyriad", 10000),
	lastUpdated = { 26, 6, 1 },
	description = "When a user interacts with the preset chat UI.",
	links = "https://roblox.atlassian.net/browse/EXPCHAT-1243"
}

return Analytics
