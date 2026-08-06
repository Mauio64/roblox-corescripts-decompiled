local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local fetchConfigWithAttributes = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfigWithAttributes)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.inExperienceConfig)

local FFlagFixAbuseReportInExpPhantomAnalytics = require(GenericAbuseReporting.Flags.FFlagFixAbuseReportInExpPhantomAnalytics)
local getNewRunId = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer).getNewRunId
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local TelemetryEventType = analyticsService.TelemetryEventType
local InExperience = AbuseVector.InExperience

local function getCacheKey(s1: string, p1) -- line: 37
	local t1 = {}

	for k in pairs(p1) do
		table.insert(t1, k)
	end

	table.sort(t1)

	local t2 = { s1 }

	for _, v in ipairs(t1) do
		table.insert(t2, v .. "=" .. tostring(p1[v]))
	end

	return table.concat(t2, ":")
end

local t3 = nil

local function useDynamicInExpConfigWithKeyGuard(b1: boolean, p2) -- line: 76
	-- upvalues: useRoactService (copy), RoactNetworking (copy), getCacheKey (copy), InExperience (copy), React (copy), t3 (ref), sendAnalyticsEvent (copy), TelemetryEventType (copy), fetchConfigWithAttributes (copy), Dash (copy), getNewRunId (copy)
	local v28 = useRoactService(RoactNetworking)
	local v29 = getCacheKey(InExperience, p2)
	local v30, v31 = React.useState(nil)
	local v32, v33 = React.useState(false)
	local v34 = React.useRef(0)
	local v35 = if not v30 then nil else v30.data

	if v30 and v29 ~= v30.key then
		v35 = nil
	end

	React.useEffect(function() -- line: 94
		-- upvalues: b1 (copy), v31 (copy), p2 (copy), t3 (ref), v29 (copy), v33 (copy), sendAnalyticsEvent (copy), InExperience (copy), TelemetryEventType (copy), v34 (copy), fetchConfigWithAttributes (copy), v28 (copy), Dash (copy), getNewRunId (copy)
		if not b1 then
			v31(nil)

			return
		end

		local experienceTargetId = p2.experienceTargetId
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		if t3 and t3.key == v29 and UnixTimestampMillis - t3.fetchedAtMs <= 1800000 then
			v31({
				key = v29,
				data = t3.data
			})
			v33(false)
			sendAnalyticsEvent({
				run_id = "unknown",
				total_duration = 0,
				abuse_vector = InExperience,
				target_id = experienceTargetId,
				path = {},
				config_name = t3.data.name
			}, {
				sub_event_type = TelemetryEventType.ConfigLoaded,
				config_load_detail = {
					load_duration_ms = 0,
					cache_hit = true,
					retry_count = 0
				}
			})

			return
		end

		local v48 = v34.current + 1

		v34.current = v48
		v31(nil)
		v33(false)

		local UnixTimestampMillis2 = DateTime.now().UnixTimestampMillis

		fetchConfigWithAttributes(v28, InExperience, p2):andThen(function(p3) -- line: 144
			-- upvalues: v34 (copy), v48 (copy), t3 (ref), v29 (copy), v31 (copy), sendAnalyticsEvent (copy), InExperience (copy), experienceTargetId (copy), TelemetryEventType (copy), UnixTimestampMillis2 (copy)
			if v34.current ~= v48 then
				return
			end

			local responseBody = p3.responseBody

			t3 = {
				key = v29,
				data = responseBody,
				fetchedAtMs = DateTime.now().UnixTimestampMillis
			}
			v31({
				key = v29,
				data = responseBody
			})
			sendAnalyticsEvent({
				run_id = "unknown",
				total_duration = 0,
				abuse_vector = InExperience,
				target_id = experienceTargetId,
				path = {},
				config_name = responseBody.name
			}, {
				sub_event_type = TelemetryEventType.ConfigLoaded,
				config_load_detail = {
					cache_hit = false,
					retry_count = 0,
					load_duration_ms = DateTime.now().UnixTimestampMillis - UnixTimestampMillis2
				}
			})
		end):catch(function(p4) -- line: 170
			-- upvalues: v34 (copy), v48 (copy), v33 (copy), Dash (copy), sendAnalyticsEvent (copy), InExperience (copy), experienceTargetId (copy), getNewRunId (copy), TelemetryEventType (copy)
			if v34.current ~= v48 then
				return
			end

			warn("Failed to fetch Dynamic Report V2 config:", p4)
			v33(true)

			local v57 = string.sub(Dash.pretty(p4, {
				depth = 2
			}), 1, 256)

			sendAnalyticsEvent({
				total_duration = 0,
				abuse_vector = InExperience,
				target_id = experienceTargetId,
				run_id = getNewRunId(),
				path = {}
			}, {
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `Failed to fetch config: { v57 }`
				}
			})
		end)
	end, {
		v28,
		b1,
		p2,
		v29
	})

	return {
		config = v35,
		hasError = v32,
		setHasError = v33,
		abuseVector = InExperience
	}
end
local function useDynamicInExpConfigLegacy(b2: boolean, p5) -- line: 204
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), getCacheKey (copy), InExperience (copy), t3 (ref), sendAnalyticsEvent (copy), TelemetryEventType (copy), fetchConfigWithAttributes (copy), Dash (copy), getNewRunId (copy)
	local v38 = useRoactService(RoactNetworking)
	local v39, v40 = React.useState(nil)
	local v41, v42 = React.useState(false)
	local v43 = React.useRef(0)

	React.useEffect(function() -- line: 210
		-- upvalues: b2 (copy), v40 (copy), getCacheKey (copy), InExperience (copy), p5 (copy), t3 (ref), v42 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v43 (copy), fetchConfigWithAttributes (copy), v38 (copy), Dash (copy), getNewRunId (copy)
		if not b2 then
			v40(nil)

			return
		end

		local v50 = getCacheKey(InExperience, p5)
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		if t3 and v50 == t3.key and UnixTimestampMillis - t3.fetchedAtMs <= 1800000 then
			v40(t3.data)
			v42(false)
			sendAnalyticsEvent({
				run_id = "unknown",
				total_duration = 0,
				abuse_vector = InExperience,
				target_id = p5.experienceTargetId,
				path = {},
				config_name = t3.data.name
			}, {
				sub_event_type = TelemetryEventType.ConfigLoaded,
				config_load_detail = {
					load_duration_ms = 0,
					cache_hit = true,
					retry_count = 0
				}
			})

			return
		end

		local v52 = v43.current + 1

		v43.current = v52
		v40(nil)
		v42(false)

		local UnixTimestampMillis3 = DateTime.now().UnixTimestampMillis

		fetchConfigWithAttributes(v38, InExperience, p5):andThen(function(p6) -- line: 254
			-- upvalues: v43 (copy), v52 (copy), t3 (ref), v50 (copy), v40 (copy), sendAnalyticsEvent (copy), InExperience (copy), p5 (copy), TelemetryEventType (copy), UnixTimestampMillis3 (copy)
			if v43.current ~= v52 then
				return
			end

			local responseBody = p6.responseBody

			t3 = {
				key = v50,
				data = responseBody,
				fetchedAtMs = DateTime.now().UnixTimestampMillis
			}
			v40(responseBody)
			sendAnalyticsEvent({
				run_id = "unknown",
				total_duration = 0,
				abuse_vector = InExperience,
				target_id = p5.experienceTargetId,
				path = {},
				config_name = responseBody.name
			}, {
				sub_event_type = TelemetryEventType.ConfigLoaded,
				config_load_detail = {
					cache_hit = false,
					retry_count = 0,
					load_duration_ms = DateTime.now().UnixTimestampMillis - UnixTimestampMillis3
				}
			})
		end):catch(function(p7) -- line: 277
			-- upvalues: v43 (copy), v52 (copy), v42 (copy), Dash (copy), sendAnalyticsEvent (copy), InExperience (copy), p5 (copy), getNewRunId (copy), TelemetryEventType (copy)
			if v43.current ~= v52 then
				return
			end

			warn("Failed to fetch Dynamic Report V2 config:", p7)
			v42(true)

			local v61 = string.sub(Dash.pretty(p7, {
				depth = 2
			}), 1, 256)

			sendAnalyticsEvent({
				total_duration = 0,
				abuse_vector = InExperience,
				target_id = p5.experienceTargetId,
				run_id = getNewRunId(),
				path = {}
			}, {
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `Failed to fetch config: { v61 }`
				}
			})
		end)
	end, {
		v38,
		b2,
		p5
	})

	return {
		config = v39,
		hasError = v41,
		setHasError = v42,
		abuseVector = InExperience
	}
end

return {
	CONFIG_CACHE_TTL_MS = 1800000,
	useDynamicInExpConfig = function(b3: boolean, p8) -- line: 309
		-- upvalues: FFlagFixAbuseReportInExpPhantomAnalytics (copy), useDynamicInExpConfigWithKeyGuard (copy), useDynamicInExpConfigLegacy (copy)
		if FFlagFixAbuseReportInExpPhantomAnalytics then
			return (useDynamicInExpConfigWithKeyGuard(b3, p8))
		end

		return (useDynamicInExpConfigLegacy(b3, p8))
	end,
	clearCacheForTesting = function() -- line: 53
		-- upvalues: t3 (ref)
		t3 = nil
	end
}
