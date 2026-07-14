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

local getNewRunId = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer).getNewRunId
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local TelemetryEventType = analyticsService.TelemetryEventType
local InExperience = AbuseVector.InExperience

local function getCacheKey(s1: string, p1) -- line: 32
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

return {
	CONFIG_CACHE_TTL_MS = 1800000,
	useDynamicInExpConfig = function(b1: boolean, p2) -- line: 68
		-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), getCacheKey (copy), InExperience (copy), t3 (ref), sendAnalyticsEvent (copy), TelemetryEventType (copy), fetchConfigWithAttributes (copy), Dash (copy), getNewRunId (copy)
		local v25 = useRoactService(RoactNetworking)
		local v26, v27 = React.useState(nil)
		local v28, v29 = React.useState(false)
		local v30 = React.useRef(0)

		React.useEffect(function() -- line: 74
			-- upvalues: b1 (copy), v27 (copy), getCacheKey (copy), InExperience (copy), p2 (copy), t3 (ref), v29 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v30 (copy), fetchConfigWithAttributes (copy), v25 (copy), Dash (copy), getNewRunId (copy)
			if not b1 then
				v27(nil)

				return
			end

			local v31 = getCacheKey(InExperience, p2)
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			if t3 and v31 == t3.key and UnixTimestampMillis - t3.fetchedAtMs <= 1800000 then
				v27(t3.data)
				v29(false)
				sendAnalyticsEvent({
					run_id = "unknown",
					total_duration = 0,
					abuse_vector = InExperience,
					target_id = p2.experienceTargetId,
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

			local v33 = v30.current + 1

			v30.current = v33
			v27(nil)
			v29(false)

			local UnixTimestampMillis2 = DateTime.now().UnixTimestampMillis

			fetchConfigWithAttributes(v25, InExperience, p2):andThen(function(p3) -- line: 118
				-- upvalues: v30 (copy), v33 (copy), t3 (ref), v31 (copy), v27 (copy), sendAnalyticsEvent (copy), InExperience (copy), p2 (copy), TelemetryEventType (copy), UnixTimestampMillis2 (copy)
				if v30.current ~= v33 then
					return
				end

				local responseBody = p3.responseBody

				t3 = {
					key = v31,
					data = responseBody,
					fetchedAtMs = DateTime.now().UnixTimestampMillis
				}
				v27(responseBody)
				sendAnalyticsEvent({
					run_id = "unknown",
					total_duration = 0,
					abuse_vector = InExperience,
					target_id = p2.experienceTargetId,
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
			end):catch(function(p4) -- line: 141
				-- upvalues: v30 (copy), v33 (copy), v29 (copy), Dash (copy), sendAnalyticsEvent (copy), InExperience (copy), p2 (copy), getNewRunId (copy), TelemetryEventType (copy)
				if v30.current ~= v33 then
					return
				end

				warn("Failed to fetch Dynamic Report V2 config:", p4)
				v29(true)

				local v38 = string.sub(Dash.pretty(p4, {
					depth = 2
				}), 1, 256)

				sendAnalyticsEvent({
					total_duration = 0,
					abuse_vector = InExperience,
					target_id = p2.experienceTargetId,
					run_id = getNewRunId(),
					path = {}
				}, {
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = `Failed to fetch config: { v38 }`
					}
				})
			end)
		end, {
			v25,
			b1,
			p2
		})

		return {
			config = v26,
			hasError = v28,
			setHasError = v29,
			abuseVector = InExperience
		}
	end,
	clearCacheForTesting = function() -- line: 48
		-- upvalues: t3 (ref)
		t3 = nil
	end
}
