local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
local FFlagAbuseReportConfigStoreResolver = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportConfigStoreResolver

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local downgradeV2ToV1 = require(GenericAbuseReporting.BeduiV2.Utils.downgradeV2ToV1)
local fetchConfigWithAttributes = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfigWithAttributes)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.inExperienceConfig)

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

return {
	CONFIG_CACHE_TTL_MS = 1800000,
	useDynamicInExpConfig = function(b1: boolean, p2) -- line: 73
		-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), getCacheKey (copy), InExperience (copy), t3 (ref), sendAnalyticsEvent (copy), TelemetryEventType (copy), fetchConfigWithAttributes (copy), FFlagAbuseReportConfigStoreResolver (copy), downgradeV2ToV1 (copy), Dash (copy), getNewRunId (copy)
		local v27 = useRoactService(RoactNetworking)
		local v28, v29 = React.useState(nil)
		local v30, v31 = React.useState(false)
		local v32 = React.useRef(0)

		React.useEffect(function() -- line: 79
			-- upvalues: b1 (copy), v29 (copy), getCacheKey (copy), InExperience (copy), p2 (copy), t3 (ref), v31 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v32 (copy), fetchConfigWithAttributes (copy), v27 (copy), FFlagAbuseReportConfigStoreResolver (copy), downgradeV2ToV1 (copy), Dash (copy), getNewRunId (copy)
			if not b1 then
				v29(nil)

				return
			end

			local v33 = getCacheKey(InExperience, p2)
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			if t3 and v33 == t3.key and UnixTimestampMillis - t3.fetchedAtMs <= 1800000 then
				v29(t3.data)
				v31(false)
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

			local v35 = v32.current + 1

			v32.current = v35
			v29(nil)
			v31(false)

			local UnixTimestampMillis2 = DateTime.now().UnixTimestampMillis

			fetchConfigWithAttributes(v27, InExperience, p2):andThen(function(p3) -- line: 123
				-- upvalues: v32 (copy), v35 (copy), FFlagAbuseReportConfigStoreResolver (copy), downgradeV2ToV1 (copy), t3 (ref), v33 (copy), v29 (copy), sendAnalyticsEvent (copy), InExperience (copy), p2 (copy), TelemetryEventType (copy), UnixTimestampMillis2 (copy)
				if v32.current ~= v35 then
					return
				end

				local v38 = if not FFlagAbuseReportConfigStoreResolver then downgradeV2ToV1(p3.responseBody) else p3.responseBody

				t3 = {
					key = v33,
					data = v38,
					fetchedAtMs = DateTime.now().UnixTimestampMillis
				}
				v29(v38)
				sendAnalyticsEvent({
					run_id = "unknown",
					total_duration = 0,
					abuse_vector = InExperience,
					target_id = p2.experienceTargetId,
					path = {},
					config_name = v38.name
				}, {
					sub_event_type = TelemetryEventType.ConfigLoaded,
					config_load_detail = {
						cache_hit = false,
						retry_count = 0,
						load_duration_ms = DateTime.now().UnixTimestampMillis - UnixTimestampMillis2
					}
				})
			end):catch(function(p4) -- line: 148
				-- upvalues: v32 (copy), v35 (copy), v31 (copy), Dash (copy), sendAnalyticsEvent (copy), InExperience (copy), p2 (copy), getNewRunId (copy), TelemetryEventType (copy)
				if v32.current ~= v35 then
					return
				end

				warn("Failed to fetch Dynamic Report V2 config:", p4)
				v31(true)

				local v40 = string.sub(Dash.pretty(p4, {
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
						error_message = `Failed to fetch config: { v40 }`
					}
				})
			end)
		end, {
			v27,
			b1,
			p2
		})

		return {
			config = v28,
			hasError = v30,
			setHasError = v31,
			abuseVector = InExperience
		}
	end,
	clearCacheForTesting = function() -- line: 53
		-- upvalues: t3 (ref)
		t3 = nil
	end
}
