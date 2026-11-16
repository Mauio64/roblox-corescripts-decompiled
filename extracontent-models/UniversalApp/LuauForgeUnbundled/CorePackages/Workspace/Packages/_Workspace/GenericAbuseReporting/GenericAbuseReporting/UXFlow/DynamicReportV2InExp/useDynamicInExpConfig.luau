local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local fetchConfigWithAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/fetchConfigWithAttributes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/inExperienceConfig")
local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local getNewRunId = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/reducer").getNewRunId
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType

local inExperience = AbuseVector.InExperience

local function getCacheKey(inExperience2, items)
	local v5 = {}

	for k in pairs(items) do
		table.insert(v5, k)
	end

	table.sort(v5)

	local v6 = { inExperience2 }

	for i, v7 in ipairs(v5) do
		table.insert(v6, v7 .. "=" .. tostring(items[v7]))
	end

	return table.concat(v6, ":")
end

local v5 = nil

return {
	useDynamicInExpConfig = function(p2, p3)
		local v6 = useRoactService(roactNetworking)
		local cacheKey = getCacheKey(inExperience, p3)
		local state, setState = React.useState(nil)
		local state2, setState2 = React.useState(false)
		local ref = React.useRef(0)

		local data = if state then state.data else nil

		if state and state.key ~= cacheKey then
			data = nil
		end

		React.useEffect(function()
			if not p2 then
				setState(nil)
				return
			end

			local experienceTargetId = p3.experienceTargetId
			local unixTimestampMillis = DateTime.now().UnixTimestampMillis

			if v5 and v5.key == cacheKey and unixTimestampMillis - v5.fetchedAtMs <= 1800000 then
				setState({ key = cacheKey, data = v5.data })

				setState2(false)
				sendAnalyticsEvent({
					abuse_vector = inExperience,
					target_id = experienceTargetId,
					run_id = "unknown",
					total_duration = 0,
					path = {},
					config_name = v5.data.name
				}, {
					sub_event_type = telemetryEventType.ConfigLoaded,
					config_load_detail = {
						load_duration_ms = 0,
						cache_hit = true,
						retry_count = 0
					}
				})
			else
				local v7 = ref.current + 1
				ref.current = v7
				setState(nil)
				setState2(false)

				local unixTimestampMillis2 = DateTime.now().UnixTimestampMillis
				fetchConfigWithAttributes(v6, inExperience, p3):andThen(function(p4)
					if ref.current ~= v7 then
						return
					end

					local responseBody = p4.responseBody
					v5 = {
						key = cacheKey,
						data = responseBody,
						fetchedAtMs = DateTime.now().UnixTimestampMillis
					}
					setState({ key = cacheKey, data = responseBody })

					sendAnalyticsEvent({
						abuse_vector = inExperience,
						target_id = experienceTargetId,
						run_id = "unknown",
						total_duration = 0,
						path = {},
						config_name = responseBody.name
					}, {
						sub_event_type = telemetryEventType.ConfigLoaded,
						config_load_detail = {
							load_duration_ms = DateTime.now().UnixTimestampMillis - unixTimestampMillis2,
							cache_hit = false,
							retry_count = 0
						}
					})
				end):catch(function(p4)
					if ref.current ~= v7 then
						return
					end

					warn("Failed to fetch Dynamic Report V2 config:", p4)
					setState2(true)
					local v9 = {
						abuse_vector = inExperience,
						target_id = experienceTargetId,
						run_id = getNewRunId(),
						total_duration = 0,
						path = {}
					}
					local v10 = {
						sub_event_type = telemetryEventType.Error,
						error_detail = 0
					}

					local v11 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("Failed to fetch config", p4) else {
						error_message = "Failed to fetch config: " .. string.sub(Dash.pretty(p4, {
							depth = 2
						}), 1, 256)
					}
					v10.error_detail = v11
					sendAnalyticsEvent(v9, v10)
				end)
			end
		end, { v6, p2, p3, cacheKey })

		return {
			config = data,
			hasError = state2,
			setHasError = setState2,
			abuseVector = inExperience
		}
	end,
	clearCacheForTesting = function()
		v5 = nil
	end,
	CONFIG_CACHE_TTL_MS = 1800000
}
