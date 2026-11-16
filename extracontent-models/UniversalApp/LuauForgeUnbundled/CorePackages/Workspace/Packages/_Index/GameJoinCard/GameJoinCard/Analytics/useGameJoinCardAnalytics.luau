local Players = game:GetService("Players")
local TelemetryService = game:GetService("TelemetryService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/LoggingProtocol")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")
local fFlagGameJoinCardAnalyticsCardId = SharedFlags.FFlagGameJoinCardAnalyticsCardId
local fFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local ageCheckUpsellOutcome = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants").AgeCheckUpsellOutcome

local defineFastInt = game:DefineFastInt("GameJoinCardAnalyticsThrottleHundredthsPercent", 10000)

local v5 = {
	eventName = "buttonClick",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 14 },
	description = "Game join card button taps (GameJoinCardButtonEvents → buttonClick, ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_button_events.proto"
}

local v6 = {
	eventName = "luaPageLoad",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 14 },
	description = "Game join card surface shown (GameJoinCardPageLoadedEvent → luaPageLoad, ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_page_loaded.proto"
}

local v7 = {
	eventName = "joinCardAgeCheckUpsellImpression",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 19 },
	description = "Game join card age-check upsell shown to user (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_age_check_upsell_impression.proto"
}

local v8 = {
	eventName = "joinCardAgeCheckVerificationOutcome",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 19 },
	description = "Outcome (success/cancelled/error) of the age-check verification flow opened from the game join card (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_age_check_verification_outcome.proto"
}

local v9 = {
	eventName = "joinCardCtaLoadTime",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 19 },
	description = "Game join card carousel tap → CTA settled duration in ms, plus the ctaType rendered and whether playability was served from cache (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_cta_load_time.proto"
}

local function optionalInt64FromString(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return (tonumber(p2))
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

	local universeId = data.universeId
	local v10 = if not (universeId == nil or universeId == "") then tonumber(universeId) else nil

	if v10 then
		gameJoinCardCommonFields.universeId = v10
	end

	if data.absolutePosition ~= nil then
		gameJoinCardCommonFields.carouselAbsolutePosition = math.floor(data.absolutePosition)
	end

	if fFlagGameJoinCardAnalyticsCardId and data.joinGameCardId and data.joinGameCardId ~= "" then
		gameJoinCardCommonFields.joinGameCardId = data.joinGameCardId
	end

	if fFlagSocialCarouselBuildPresence and data.cardType ~= nil then
		gameJoinCardCommonFields.cardType = data.cardType
	end

	return gameJoinCardCommonFields
end

return {
	logGameJoinCardButtonEvent = function(buttonAction, options)
		local gameJoinCardCommonFields = buildGameJoinCardCommonFields(options or {})
		gameJoinCardCommonFields.buttonAction = buttonAction

		TelemetryService:LogEvent(v5, {
			eventContext = "gameJoinCard",
			customFields = gameJoinCardCommonFields,
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logGameJoinCardPageLoaded = function(options)
		TelemetryService:LogEvent(v6, {
			eventContext = "gameJoinCard",
			customFields = buildGameJoinCardCommonFields(options or {}),
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logJoinCardAgeCheckUpsellImpression = function(p2)
		local v10 = {}

		local universeId = p2.universeId
		local v11 = if not (universeId == nil or universeId == "") then tonumber(universeId) else nil

		if v11 then
			v10.universeId = v11
		end

		TelemetryService:LogEvent(v7, {
			eventContext = "gameJoinCard",
			customFields = v10,
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logJoinCardAgeCheckVerificationOutcome = function(p2)
		local v10 = { outcome = ageCheckUpsellOutcome[p2.outcome] }

		local universeId = p2.universeId
		local v11 = if not (universeId == nil or universeId == "") then tonumber(universeId) else nil

		if v11 then
			v10.universeId = v11
		end

		TelemetryService:LogEvent(v8, {
			eventContext = "gameJoinCard",
			customFields = v10,
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logJoinCardCtaLoadTime = function(data)
		TelemetryService:LogEvent(v9, {
			eventContext = "gameJoinCard",
			customFields = {
				durationMs = math.max(0, (math.floor(data.durationMs))),
				ctaType = data.ctaType,
				wasCached = data.wasCached
			},
			standardizedFields = { "addSessionInfo" }
		})
	end
}
