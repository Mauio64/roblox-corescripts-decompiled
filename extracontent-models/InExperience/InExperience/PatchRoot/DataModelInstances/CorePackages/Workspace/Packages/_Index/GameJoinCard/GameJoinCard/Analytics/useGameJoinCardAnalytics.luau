local Players = game:GetService("Players")
local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("GameJoinCard").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local SharedFlags = require(parent.SharedFlags)
local FFlagGameJoinCardAnalyticsCardId = SharedFlags.FFlagGameJoinCardAnalyticsCardId
local FFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local AnalyticsConstants = require(script.Parent.AnalyticsConstants)
local AgeCheckUpsellOutcome = AnalyticsConstants.AgeCheckUpsellOutcome

local defineFastInt = game:DefineFastInt("GameJoinCardAnalyticsThrottleHundredthsPercent", 10000)

local v = {
	eventName = "buttonClick",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 14 },
	description = "Game join card button taps (GameJoinCardButtonEvents → buttonClick, ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_button_events.proto"
}

local v2 = {
	eventName = "luaPageLoad",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 14 },
	description = "Game join card surface shown (GameJoinCardPageLoadedEvent → luaPageLoad, ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_page_loaded.proto"
}

local v3 = {
	eventName = "joinCardAgeCheckUpsellImpression",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 19 },
	description = "Game join card age-check upsell shown to user (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_age_check_upsell_impression.proto"
}

local v4 = {
	eventName = "joinCardAgeCheckVerificationOutcome",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 19 },
	description = "Outcome (success/cancelled/error) of the age-check verification flow opened from the game join card (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_age_check_verification_outcome.proto"
}

local v5 = {
	eventName = "joinCardCtaLoadTime",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 19 },
	description = "Game join card carousel tap → CTA settled duration in ms, plus the ctaType rendered and whether playability was served from cache (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_cta_load_time.proto"
}

local function optionalInt64FromString(universeId: string?) -- 3 equivalent calls inferred from this helper
	if universeId == nil or universeId == "" then
		return nil
	end

	return (tonumber(universeId))
end

local function buildGameJoinCardCommonFields(data)
	local gameJoinCardCommonFields = {}

	local localPlayer = Players.LocalPlayer

	if localPlayer then
		gameJoinCardCommonFields.uid = localPlayer.UserId
	end

	local friendId = data.friendId and data.friendId ~= "" and tonumber(data.friendId)

	if friendId then
		gameJoinCardCommonFields.cardUserId = friendId
	end

	local universeId = optionalInt64FromString(data.universeId) -- inferred equivalent call

	if universeId then
		gameJoinCardCommonFields.universeId = universeId
	end

	if data.absolutePosition ~= nil then
		gameJoinCardCommonFields.carouselAbsolutePosition = math.floor(data.absolutePosition)
	end

	if FFlagGameJoinCardAnalyticsCardId and data.joinGameCardId and data.joinGameCardId ~= "" then
		gameJoinCardCommonFields.joinGameCardId = data.joinGameCardId
	end

	if FFlagSocialCarouselBuildPresence and data.cardType ~= nil then
		gameJoinCardCommonFields.cardType = data.cardType
	end

	return gameJoinCardCommonFields
end

local UseGameJoinCardAnalytics = {}

function UseGameJoinCardAnalytics.logGameJoinCardButtonEvent(buttonAction: number, options)
	local gameJoinCardCommonFields = buildGameJoinCardCommonFields(options or {})
	gameJoinCardCommonFields.buttonAction = buttonAction

	TelemetryService:LogEvent(v, {
		eventContext = "gameJoinCard",
		customFields = gameJoinCardCommonFields,
		standardizedFields = { "addSessionInfo" }
	})
end

function UseGameJoinCardAnalytics.logGameJoinCardPageLoaded(options)
	TelemetryService:LogEvent(v2, {
		eventContext = "gameJoinCard",
		customFields = buildGameJoinCardCommonFields(options or {}),
		standardizedFields = { "addSessionInfo" }
	})
end

function UseGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression(p)
	local customFields = {}

	local universeId = optionalInt64FromString(p.universeId) -- inferred equivalent call

	if universeId then
		customFields.universeId = universeId
	end

	TelemetryService:LogEvent(v3, {
		eventContext = "gameJoinCard",
		customFields = customFields,
		standardizedFields = { "addSessionInfo" }
	})
end

function UseGameJoinCardAnalytics.logJoinCardAgeCheckVerificationOutcome(p)
	local customFields = { outcome = AgeCheckUpsellOutcome[p.outcome] }

	local universeId = optionalInt64FromString(p.universeId) -- inferred equivalent call

	if universeId then
		customFields.universeId = universeId
	end

	TelemetryService:LogEvent(v4, {
		eventContext = "gameJoinCard",
		customFields = customFields,
		standardizedFields = { "addSessionInfo" }
	})
end

function UseGameJoinCardAnalytics.logJoinCardCtaLoadTime(data)
	TelemetryService:LogEvent(v5, {
		eventContext = "gameJoinCard",
		customFields = {
			durationMs = math.max(0, (math.floor(data.durationMs))),
			ctaType = data.ctaType,
			wasCached = data.wasCached
		},
		standardizedFields = { "addSessionInfo" }
	})
end

return UseGameJoinCardAnalytics
