local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")

local Dash = require(parent.Dash)

local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local v = { "errorMessage", "message", "error" }

local function getBoundedUtf8String(p, p2: number) -- 2 equivalent calls inferred from this helper
	local v2 = tostring(p)

	if utf8.len(v2) == nil then
		return nil
	end

	if #v2 <= p2 then
		return v2
	end

	return (string.sub(v2, 1, utf8.offset(v2, 0, p2 + 1) - 1))
end

local function setBoundedMetadata(boundedUtf8Strings, p: string, p2) -- 10 equivalent calls inferred from this helper
	if p2 ~= nil then
		local boundedUtf8String = getBoundedUtf8String(p2, 1000) -- inferred equivalent call

		if boundedUtf8String ~= nil then
			boundedUtf8Strings[p] = boundedUtf8String
		end
	end
end

local function getFallbackErrorMessage(p)
	if type(p) ~= "table" then
		return nil
	end

	for _, v2 in v do
		local v3 = p[v2]

		if type(v3) == "string" then
			return v3
		end
	end

	return nil
end

local function getHeader(items, value: string)
	if type(items) ~= "table" then
		return nil
	end

	local v2 = string.lower(value)

	for k, item in items do
		if type(k) == "string" and string.lower(k) == v2 then
			return item
		end
	end

	return nil
end

local function setBoundedNumericHeaderMetadata(boundedUtf8Strings, p: string, headers, p2: string) -- 2 equivalent calls inferred from this helper
	local v2 = tonumber(getHeader(headers, p2))

	if v2 then
		setBoundedMetadata(boundedUtf8Strings, p, v2) -- inferred equivalent call
	end
end

local function isArray(item): boolean -- 1 equivalent call inferred from this helper
	local count = 0

	for _ in item do
		count += 1
	end

	return count == #item and count > 0
end

local function flattenForTelemetry(joined)
	local result = {}

	for k, item in joined do
		if type(item) == "table" then
			if isArray(item) then -- inferred equivalent call
				local v2 = {}

				for _, v3 in item do
					table.insert(v2, (tostring(v3)))
				end

				result[k] = "[" .. table.concat(v2, ", ") .. "]"
			else
				for k2, v2 in item do
					result[tostring(k2)] = tostring(v2)
				end
			end
		else
			result[k] = tostring(item)
		end
	end

	return result
end

local v2 = {
	eventName = "DynamicAbuseReportEventV2",
	description = "Event to track dynamic abuse report v2",
	lastUpdated = { 2026, 9, 10 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("DynamicAbuseReportV2ThrottleHundredthsPercent", 0),
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/13201"
}

local function getCoreScriptVersion()
	if not game:GetEngineFeature("CoreScriptVersionEnabled") then
		return nil
	end

	local success, result = pcall(function()
		return RunService:GetCoreScriptVersion()
	end)
	return if success then result else nil
end

local result

if game:GetEngineFeature("CoreScriptVersionEnabled") then
	local success
	success, result = pcall(function()
		return RunService:GetCoreScriptVersion()
	end)

	if not success then
		result = nil
	end
else
	result = nil
end

local AnalyticsService = {}

function AnalyticsService.sendAnalyticsEvent(p, p2)
	local v3 = {
		user_id = LocalPlayer and LocalPlayer.UserId or nil,
		client_version = result
	}

	local customFields = flattenForTelemetry(Dash.join(p, p2, v3))

	if
		FFlagAbuseReportImproveErrorEvents
		and p2.sub_event_type == "Error"
		and p2.error_detail.error_metadata ~= nil
	then
		local success, result2 = pcall(HttpService.JSONEncode, HttpService, p2.error_detail.error_metadata)

		if success and type(result2) == "string" then
			customFields.error_metadata = result2
		else
			customFields = Dash.omit(customFields, { "error_metadata" })
		end
	end

	TelemetryService:LogEvent(v2, { customFields = customFields, eventContext = p.abuse_vector })
end

AnalyticsService.TelemetryEventType = {
	ReportStarted = "OpenDialog",
	ReportAbandoned = "EarlyClose",
	ReportCompleted = "Close",
	Submit = "Submit",
	SubmitSuccess = "SubmitSuccess",
	SubmitFail = "SubmitFail",
	BackAction = "BackAction",
	NodeDone = "NodeDone",
	SelectItem = "SelectItem",
	IsUserBlockAvailable = "IsUserBlockAvailable",
	IsUserMuteAvailable = "IsUserMuteAvailable",
	DidBlockUser = "DidBlockUser",
	DidUnblockUser = "DidUnblockUser",
	DidMuteUser = "DidMuteUser",
	HelplineShown = "HelplineShown",
	HelplineOpened = "HelplineOpened",
	LinkOpened = "LinkOpened",
	Error = "Error",
	CommentInput = "CommentInput",
	TextChannelSwitch = "TextChannelSwitch",
	EmptyState = "EmptyState",
	SceneCaptureResult = "SceneCaptureResult",
	ConfigLoaded = "ConfigLoaded"
}

AnalyticsService.LinkOpenedSource = { Footer = "footer", NextAction = "next_action" }

AnalyticsService.SubmitSource = { Flow = "flow", SceneSelection = "sceneSelection" }

function AnalyticsService.formatErrorDetailForAnalytics(p: string, value, p2)
	local v3

	if type(value) == "string" then
		v3 = value
	end

	local error_metadata = {}

	if type(value) == "table" then
		setBoundedMetadata(error_metadata, "status_code", value.StatusCode) -- inferred equivalent call
		setBoundedMetadata(error_metadata, "http_error", value.HttpError) -- inferred equivalent call
		setBoundedMetadata(error_metadata, "is_cached", value.IsCached) -- inferred equivalent call
		setBoundedMetadata(error_metadata, "is_prefetch", value.IsPrefetch) -- inferred equivalent call

		if value.isJSONValid == false then
			error_metadata.reason = "invalid_json"
		end

		local stats = value.Stats

		if type(stats) == "table" then
			local roundTripTime = tonumber(stats.RoundTripTime)

			if roundTripTime then
				setBoundedMetadata(error_metadata, "round_trip_milliseconds", roundTripTime * 1000) -- inferred equivalent call
			end

			setBoundedMetadata(error_metadata, "was_request_retried", stats.WasRequestRetried) -- inferred equivalent call
		end

		setBoundedNumericHeaderMetadata(error_metadata, "retry_after_seconds", value.Headers, "Retry-After") -- inferred equivalent call

		setBoundedNumericHeaderMetadata( -- inferred equivalent call
			error_metadata,
			"upstream_service_time_milliseconds",
			value.Headers,
			"x-envoy-upstream-service-time"
		)

		if next(error_metadata) == nil then
			if type(value) == "table" then
				local flag = true

				for _, v4 in v do
					v3 = value[v4]

					if type(v3) == "string" then
						flag = false
						break
					end
				end

				if flag then
					v3 = nil
				end
			else
				v3 = nil
			end

			error_metadata.reason = "unknown"
		end

		if type(value.Body) == "string" then
			setBoundedMetadata(error_metadata, "body_size_bytes", #value.Body) -- inferred equivalent call
		end

		if p2 and p2.includeResponseBody and value.Body ~= nil then
			local v4

			if type(value.Body) == "string" then
				v4 = value.Body
			else
				v4 = Dash.pretty(value.Body, { depth = 10 })
			end

			setBoundedMetadata(error_metadata, "response_body", v4) -- inferred equivalent call
		end
	end

	if next(error_metadata) == nil then
		error_metadata.reason = "unknown"
	end

	setBoundedMetadata(error_metadata, "runtime_message", v3) -- inferred equivalent call
	return {
		error_message = getBoundedUtf8String(p, 1000) or "Unknown error", -- inferred equivalent call
		error_metadata = error_metadata
	}
end

return AnalyticsService
