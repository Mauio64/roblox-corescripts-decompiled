local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local v6 = require(ExpChatShared.Logger):new("ExpChat/" .. script.Name)
local t1 = {}
local u8 = RbxAnalyticsService

local function withDefaultArgs(p1) -- line: 16
	-- upvalues: Dictionary (copy)
	return Dictionary.join(p1, {
		gameId = tostring(game.GameId),
		placeId = tostring(game.PlaceId)
	})
end
local function setRbxEventStream(s1: string, s2: string, s3: string, p2) -- line: 23
	-- upvalues: u8 (ref), v6 (copy), withDefaultArgs (copy)
	if u8 then
		v6:debug("Event: {}", s3)
		u8:SetRBXEventStream(s1, s2, s3, withDefaultArgs(p2 or {}))
	end
end
local function sendEventDeferred(s4: string, s5: string, s6: string, p3) -- line: 30
	-- upvalues: u8 (ref), v6 (copy), withDefaultArgs (copy)
	if u8 then
		v6:debug("SendEventDeferred: {}", s6)
		u8:SendEventDeferred(s4, s5, s6, withDefaultArgs(p3 or {}))
	end
end

function t1.with(p4) -- line: 37
	-- upvalues: u8 (ref), RbxAnalyticsService (copy)
	u8 = p4 or RbxAnalyticsService
end
function t1.FireRccAnalyticsWithEventName(s7: string, p5) -- line: 41
	-- upvalues: setRbxEventStream (copy)
	setRbxEventStream("rcc", "experienceChat", s7, p5)
end
function t1.FireClientAnalyticsWithEventName(s8: string, p6) -- line: 45
	-- upvalues: setRbxEventStream (copy)
	setRbxEventStream("client", "experienceChat", s8, p6)
end
function t1.reportCounter(s9: string, n1: number?) -- line: 49
	-- upvalues: u8 (ref), v6 (copy)
	if u8 then
		v6:debug("Counter: {}", s9)
		u8:ReportCounter(s9, n1 or 1)
	end
end
function t1.FireRccAnalyticsDeferred(s10: string, p7) -- line: 56
	-- upvalues: sendEventDeferred (copy)
	sendEventDeferred("RCC", "experienceChat", s10, p7)
end
function t1.TelemetryLogEvent(_: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?, t5: {[any]: any}?) -- line: 60
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
