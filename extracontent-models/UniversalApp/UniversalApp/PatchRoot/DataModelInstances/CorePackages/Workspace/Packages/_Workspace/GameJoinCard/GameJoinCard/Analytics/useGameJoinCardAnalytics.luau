local Players = game:GetService("Players")
local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local AgeCheckUpsellOutcome = require(script.Parent.AnalyticsConstants).AgeCheckUpsellOutcome
local v6 = game:DefineFastInt("GameJoinCardAnalyticsThrottleHundredthsPercent", 10000)
local t1 = {
	eventName = "buttonClick",
	description = "Game join card button taps (GameJoinCardButtonEvents → buttonClick, ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_button_events.proto",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = v6,
	lastUpdated = {
		2026,
		4,
		14
	}
}
local t2 = {
	eventName = "luaPageLoad",
	description = "Game join card surface shown (GameJoinCardPageLoadedEvent → luaPageLoad, ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_page_loaded.proto",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = v6,
	lastUpdated = {
		2026,
		4,
		14
	}
}
local t3 = {
	eventName = "joinCardAgeCheckUpsellImpression",
	description = "Game join card age-check upsell shown to user (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_age_check_upsell_impression.proto",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = v6,
	lastUpdated = {
		2026,
		5,
		19
	}
}
local t4 = {
	eventName = "joinCardAgeCheckVerificationOutcome",
	description = "Outcome (success/cancelled/error) of the age-check verification flow opened from the game join card (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_age_check_verification_outcome.proto",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = v6,
	lastUpdated = {
		2026,
		5,
		19
	}
}
local t5 = {
	eventName = "joinCardCtaLoadTime",
	description = "Game join card carousel tap → CTA settled duration in ms, plus the ctaType rendered and whether playability was served from cache (ctx gameJoinCard)",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/game_join_card/game_join_card_cta_load_time.proto",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = v6,
	lastUpdated = {
		2026,
		5,
		19
	}
}

local function optionalInt64FromString(s1: string?) -- line: 76
	if s1 == nil or s1 == "" then
		return nil
	end

	return (tonumber(s1))
end
local function buildGameJoinCardCommonFields(t6: {[any]: any}) -- line: 84
	-- upvalues: Players (copy)
	local t7 = {}
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		t7.uid = LocalPlayer.UserId
	end

	if t6.friendId and t6.friendId ~= "" then
		local num = tonumber(t6.friendId)

		if num then
			t7.cardUserId = num
		end
	end

	local universeId = t6.universeId
	local v20 = if universeId ~= nil and universeId ~= "" then tonumber(universeId) else nil

	if v20 then
		t7.universeId = v20
	end

	if t6.absolutePosition ~= nil then
		t7.carouselAbsolutePosition = math.floor(t6.absolutePosition)
	end

	return t7
end

return {
	logGameJoinCardButtonEvent = function(n1: number, t8: {[any]: any}?) -- line: 111
		-- upvalues: buildGameJoinCardCommonFields (copy), TelemetryService (copy), t1 (copy)
		local v23 = buildGameJoinCardCommonFields(t8 or {})

		v23.buttonAction = n1
		TelemetryService:LogEvent(t1, {
			eventContext = "gameJoinCard",
			customFields = v23,
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logGameJoinCardPageLoaded = function(t9: {[any]: any}?) -- line: 122
		-- upvalues: buildGameJoinCardCommonFields (copy), TelemetryService (copy), t2 (copy)
		local v25 = buildGameJoinCardCommonFields(t9 or {})

		TelemetryService:LogEvent(t2, {
			eventContext = "gameJoinCard",
			customFields = v25,
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logJoinCardAgeCheckUpsellImpression = function(t10: {[any]: any}) -- line: 136
		-- upvalues: TelemetryService (copy), t3 (copy)
		local t11 = {}
		local universeId = t10.universeId
		local v29 = if universeId ~= nil and universeId ~= "" then tonumber(universeId) else nil

		if v29 then
			t11.universeId = v29
		end

		TelemetryService:LogEvent(t3, {
			eventContext = "gameJoinCard",
			customFields = t11,
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logJoinCardAgeCheckVerificationOutcome = function(t12: {[any]: any}) -- line: 164
		-- upvalues: AgeCheckUpsellOutcome (copy), TelemetryService (copy), t4 (copy)
		local t13 = {
			outcome = AgeCheckUpsellOutcome[t12.outcome]
		}
		local universeId = t12.universeId
		local v33 = if universeId ~= nil and universeId ~= "" then tonumber(universeId) else nil

		if v33 then
			t13.universeId = v33
		end

		TelemetryService:LogEvent(t4, {
			eventContext = "gameJoinCard",
			customFields = t13,
			standardizedFields = { "addSessionInfo" }
		})
	end,
	logJoinCardCtaLoadTime = function(t14: {[any]: any}) -- line: 187
		-- upvalues: TelemetryService (copy), t5 (copy)
		TelemetryService:LogEvent(t5, {
			eventContext = "gameJoinCard",
			customFields = {
				durationMs = math.max(0, (math.floor(t14.durationMs))),
				ctaType = t14.ctaType,
				wasCached = t14.wasCached
			},
			standardizedFields = { "addSessionInfo" }
		})
	end
}
