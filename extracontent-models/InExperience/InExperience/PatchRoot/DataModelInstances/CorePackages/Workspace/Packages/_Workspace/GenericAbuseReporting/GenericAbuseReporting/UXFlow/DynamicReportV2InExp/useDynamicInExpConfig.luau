local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)

local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local fetchConfigWithAttributes = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfigWithAttributes)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.inExperienceConfig)
local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local reducer = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer)
local getNewRunId = reducer.getNewRunId
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType

local InExperience = AbuseVector.InExperience

local function getCacheKey(inExperience: string, items)
	local v = {}

	for k in pairs(items) do
		table.insert(v, k)
	end

	table.sort(v)

	local v2 = { inExperience }

	for _, v3 in ipairs(v) do
		table.insert(v2, v3 .. "=" .. tostring(items[v3]))
	end

	return table.concat(v2, ":")
end

local v = nil
local UseDynamicInExpConfig = {}

function UseDynamicInExpConfig.useDynamicInExpConfig(flag: boolean, p)
	local v2 = useRoactService(RoactNetworking)
	local cacheKey = getCacheKey(InExperience, p)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(0)
	local data

	if state then
		data = state.data
	end

	if state and state.key ~= cacheKey then
		data = nil
	end

	React.useEffect(function()
		if not flag then
			setState(nil)
			return
		end

		local experienceTargetId = p.experienceTargetId
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis

		if v and v.key == cacheKey and unixTimestampMillis - v.fetchedAtMs <= 1800000 then
			setState({ key = cacheKey, data = v.data })

			setState2(false)
			sendAnalyticsEvent({
				abuse_vector = InExperience,
				target_id = experienceTargetId,
				run_id = "unknown",
				total_duration = 0,
				path = {},
				config_name = v.data.name
			}, {
				sub_event_type = telemetryEventType.ConfigLoaded,
				config_load_detail = { load_duration_ms = 0, cache_hit = true, retry_count = 0 }
			})
		else
			local current = ref.current + 1
			ref.current = current
			setState(nil)
			setState2(false)

			local unixTimestampMillis2 = DateTime.now().UnixTimestampMillis
			fetchConfigWithAttributes(v2, InExperience, p):andThen(function(p2)
				if ref.current ~= current then
					return
				end

				local responseBody = p2.responseBody
				v = {
					key = cacheKey,
					data = responseBody,
					fetchedAtMs = DateTime.now().UnixTimestampMillis
				}
				setState({ key = cacheKey, data = responseBody })

				sendAnalyticsEvent({
					abuse_vector = InExperience,
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
			end):catch(function(p2)
				if ref.current ~= current then
					return
				end

				warn("Failed to fetch Dynamic Report V2 config:", p2)
				setState2(true)
				local v3 = {
					abuse_vector = InExperience,
					target_id = experienceTargetId,
					run_id = getNewRunId(),
					total_duration = 0,
					path = {}
				}
				local v4 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
				local error_detail

				if FFlagAbuseReportImproveErrorEvents then
					error_detail = formatErrorDetailForAnalytics("Failed to fetch config", p2)
				else
					error_detail = {
						error_message = "Failed to fetch config: " .. string.sub(Dash.pretty(p2, {
							depth = 2
						}), 1, 256)
					}
				end

				v4.error_detail = error_detail
				sendAnalyticsEvent(v3, v4)
			end)
		end
	end, { v2, flag, p, cacheKey })

	return { config = data, hasError = state2, setHasError = setState2, abuseVector = InExperience }
end

function UseDynamicInExpConfig.clearCacheForTesting()
	v = nil
end

UseDynamicInExpConfig.CONFIG_CACHE_TTL_MS = 1800000
return UseDynamicInExpConfig
