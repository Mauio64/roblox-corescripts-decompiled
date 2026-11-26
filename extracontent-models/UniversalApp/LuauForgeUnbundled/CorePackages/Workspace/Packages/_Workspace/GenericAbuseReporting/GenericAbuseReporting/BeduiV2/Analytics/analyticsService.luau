local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")

local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local v8 = { "errorMessage", "message", "error" }

local function getBoundedUtf8String(p2, p3)
	local v9 = tostring(p2)

	if utf8.len(v9) == nil then
		return nil
	end

	if #v9 <= p3 then
		return v9
	end

	return (string.sub(v9, 1, utf8.offset(v9, 0, p3 + 1) - 1))
end

local function setBoundedMetadata(p2, p3, p4)
	if p4 ~= nil then
		local v9 = tostring(p4)

		if utf8.len(v9) == nil then
			v9 = nil
		elseif not (#v9 <= 1000) then
			v9 = string.sub(v9, 1, utf8.offset(v9, 0, 1001) - 1)
		end

		if v9 ~= nil then
			p2[p3] = v9
		end
	end
end

local function getFallbackErrorMessage(p2)
	if type(p2) ~= "table" then
		return nil
	end

	for k, v9 in v8 do
		local v10 = p2[v9]

		if type(v10) == "string" then
			return v10
		end
	end

	return nil
end

local function getHeader(items, value)
	if type(items) ~= "table" then
		return nil
	end

	local v9 = string.lower(value)

	for k, item in items do
		if type(k) == "string" and string.lower(k) == v9 then
			return item
		end
	end

	return nil
end

local function setBoundedNumericHeaderMetadata(p2, p3, p4, p5)
	local v9 = tonumber(getHeader(p4, p5))

	if v9 and v9 ~= nil then
		local v10 = tostring(v9)

		if utf8.len(v10) == nil then
			v10 = nil
		elseif not (#v10 <= 1000) then
			v10 = string.sub(v10, 1, utf8.offset(v10, 0, 1001) - 1)
		end

		if v10 ~= nil then
			p2[p3] = v10
		end
	end
end

local function isArray(list): boolean
	local count = 0

	for k in list do
		count += 1
	end

	return count == #list and count > 0
end

local function flattenForTelemetry(joined)
	local result = {}

	for k, item in joined do
		if type(item) == "table" then
			local count = 0

			for k2 in item do
				count += 1
			end

			local v9 = count == #item and count > 0

			if v9 then
				local v10 = {}

				for k2, v11 in item do
					table.insert(v10, (tostring(v11)))
				end

				result[k] = "[" .. table.concat(v10, ", ") .. "]"
			else
				for k2, v10 in item do
					result[tostring(k2)] = tostring(v10)
				end
			end
		else
			result[k] = tostring(item)
		end
	end

	return result
end

local v9 = {
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

	if success then
		return result
	end

	return nil
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

return {
	sendAnalyticsEvent = function(p2, p3)
		local v10 = {
			user_id = localPlayer and localPlayer.UserId or nil,
			client_version = result
		}

		local v11 = flattenForTelemetry(Dash.join(p2, p3, v10))

		if FFlagAbuseReportImproveErrorEvents and p3.sub_event_type == "Error" and p3.error_detail.error_metadata ~= nil then
			local success, result2 = pcall(
				HttpService.JSONEncode,
				HttpService,
				p3.error_detail.error_metadata
			)

			if success and type(result2) == "string" then
				v11.error_metadata = result2
			else
				v11 = Dash.omit(v11, { "error_metadata" })
			end
		end

		TelemetryService:LogEvent(v9, {
			customFields = v11,
			eventContext = p2.abuse_vector
		})
	end,
	TelemetryEventType = {
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
	},
	LinkOpenedSource = { Footer = "footer", NextAction = "next_action" },
	SubmitSource = { Flow = "flow", SceneSelection = "sceneSelection" },
	formatErrorDetailForAnalytics = function(p2, value, p3)
		local v9 = if type(value) == "string" then value else nil
		local v10 = {}

		if type(value) == "table" then
			local statusCode = value.StatusCode

			if statusCode ~= nil then
				local v11 = tostring(statusCode)

				if utf8.len(v11) == nil then
					v11 = nil
				elseif not (#v11 <= 1000) then
					v11 = string.sub(v11, 1, utf8.offset(v11, 0, 1001) - 1)
				end

				if v11 ~= nil then
					v10.status_code = v11
				end
			end

			local httpError = value.HttpError

			if httpError ~= nil then
				local v11 = tostring(httpError)

				if utf8.len(v11) == nil then
					v11 = nil
				elseif not (#v11 <= 1000) then
					v11 = string.sub(v11, 1, utf8.offset(v11, 0, 1001) - 1)
				end

				if v11 ~= nil then
					v10.http_error = v11
				end
			end

			local isCached = value.IsCached

			if isCached ~= nil then
				local v11 = tostring(isCached)

				if utf8.len(v11) == nil then
					v11 = nil
				elseif not (#v11 <= 1000) then
					v11 = string.sub(v11, 1, utf8.offset(v11, 0, 1001) - 1)
				end

				if v11 ~= nil then
					v10.is_cached = v11
				end
			end

			local isPrefetch = value.IsPrefetch

			if isPrefetch ~= nil then
				local v11 = tostring(isPrefetch)

				if utf8.len(v11) == nil then
					v11 = nil
				elseif not (#v11 <= 1000) then
					v11 = string.sub(v11, 1, utf8.offset(v11, 0, 1001) - 1)
				end

				if v11 ~= nil then
					v10.is_prefetch = v11
				end
			end

			if value.isJSONValid == false then
				v10.reason = "invalid_json"
			end

			local stats = value.Stats

			if type(stats) == "table" then
				local roundTripTime = tonumber(stats.RoundTripTime)

				if roundTripTime then
					local v11 = roundTripTime * 1000

					if v11 ~= nil then
						local v12 = tostring(v11)

						if utf8.len(v12) == nil then
							v12 = nil
						elseif not (#v12 <= 1000) then
							v12 = string.sub(v12, 1, utf8.offset(v12, 0, 1001) - 1)
						end

						if v12 ~= nil then
							v10.round_trip_milliseconds = v12
						end
					end
				end

				local wasRequestRetried = stats.WasRequestRetried

				if wasRequestRetried ~= nil then
					local v11 = tostring(wasRequestRetried)

					if utf8.len(v11) == nil then
						v11 = nil
					elseif not (#v11 <= 1000) then
						v11 = string.sub(v11, 1, utf8.offset(v11, 0, 1001) - 1)
					end

					if v11 ~= nil then
						v10.was_request_retried = v11
					end
				end
			end

			local headers = value.Headers
			local v11 = tonumber(getHeader(headers, "Retry-After"))

			if v11 and v11 ~= nil then
				local v12 = tostring(v11)

				if utf8.len(v12) == nil then
					v12 = nil
				elseif not (#v12 <= 1000) then
					v12 = string.sub(v12, 1, utf8.offset(v12, 0, 1001) - 1)
				end

				if v12 ~= nil then
					v10.retry_after_seconds = v12
				end
			end

			local headers2 = value.Headers
			local v12 = tonumber(getHeader(headers2, "x-envoy-upstream-service-time"))

			if v12 and v12 ~= nil then
				local v13 = tostring(v12)

				if utf8.len(v13) == nil then
					v13 = nil
				elseif not (#v13 <= 1000) then
					v13 = string.sub(v13, 1, utf8.offset(v13, 0, 1001) - 1)
				end

				if v13 ~= nil then
					v10.upstream_service_time_milliseconds = v13
				end
			end

			if next(v10) == nil then
				if type(value) == "table" then
					local flag = true

					for k, v13 in v8 do
						v9 = value[v13]

						if type(v9) == "string" then
							flag = false
							break
						end
					end

					if flag then
						v9 = nil
					end
				else
					v9 = nil
				end

				v10.reason = "unknown"
			end

			if type(value.Body) == "string" then
				local count = #value.Body

				if count ~= nil then
					local v13 = tostring(count)

					if utf8.len(v13) == nil then
						v13 = nil
					elseif not (#v13 <= 1000) then
						v13 = string.sub(v13, 1, utf8.offset(v13, 0, 1001) - 1)
					end

					if v13 ~= nil then
						v10.body_size_bytes = v13
					end
				end
			end

			if p3 and p3.includeResponseBody and value.Body ~= nil then
				local v13

				if type(value.Body) == "string" then
					v13 = value.Body
				else
					v13 = Dash.pretty(value.Body, { depth = 10 })
				end

				if v13 ~= nil then
					local v14 = tostring(v13)

					if utf8.len(v14) == nil then
						v14 = nil
					elseif not (#v14 <= 1000) then
						v14 = string.sub(v14, 1, utf8.offset(v14, 0, 1001) - 1)
					end

					if v14 ~= nil then
						v10.response_body = v14
					end
				end
			end
		end

		if next(v10) == nil then
			v10.reason = "unknown"
		end

		if v9 ~= nil then
			local v11 = tostring(v9)

			if utf8.len(v11) == nil then
				v11 = nil
			elseif not (#v11 <= 1000) then
				v11 = string.sub(v11, 1, utf8.offset(v11, 0, 1001) - 1)
			end

			if v11 ~= nil then
				v10.runtime_message = v11
			end
		end

		local v12 = tostring(p2)

		if utf8.len(v12) == nil then
			v12 = nil
		elseif not (#v12 <= 1000) then
			v12 = string.sub(v12, 1, utf8.offset(v12, 0, 1001) - 1)
		end

		return {
			error_message = v12 or "Unknown error",
			error_metadata = v10
		}
	end
}
