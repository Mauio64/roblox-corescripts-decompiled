local module = require("@luauforge/deferred/gQM")
local module2 = require("@luauforge/deferred/gRk")
local sendAXCounterV2 = module2.sendAXCounterV2
local sendAXStat = module2.sendAXStat

local module3 = require("@luauforge/deferred/gRM")
local module4 = require("@luauforge/deferred/gRP")
local module5 = require("@luauforge/deferred/gRQ")
local module6 = require("@luauforge/deferred/gRv")
local module7 = require("@luauforge/deferred/gQK")
local fFlagAXBackgroundUploadQuotaError = module7.FFlagAXBackgroundUploadQuotaError
local module8 = require("@luauforge/deferred/gRx")

local function trim(value)
	return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

local function isWithinLimit(p2, p3): boolean
	local v5 = utf8.len(p2)
	return v5 ~= nil and v5 <= p3
end

local function mapUploadError(p2): string
	local statusCode = if type(p2) == "table" then p2.StatusCode else nil

	if statusCode == 403 then
		return "PermissionDenied"
	elseif statusCode == 404 then
		return "NotFound"
	elseif statusCode == 409 then
		return "NotCompleted"
	elseif statusCode == 410 then
		return "ImageExpired"
	end

	if type(p2) == "table" then
		return "Network"
	end

	return "Unknown"
end

local function isTerminalUploadStatus(p2): boolean
	return p2 == nil or p2.status == "Completed" or p2.status == "Failed"
end

local function usePublishController(p2, p3)
	local state, setState = module.useState("idle")
	local state2, setState2 = module.useState("")
	local state3, setState3 = module.useState("")
	local state4, setState4 = module.useState(nil)
	local state5, setState5 = module.useState(nil)
	local state6, setState6

	if fFlagAXBackgroundUploadQuotaError then
		state6, setState6 = module.useState(nil)
	else
		setState6 = nil
	end

	local v5 = module6()
	local ref = module.useRef(0)

	local ref2 = module.useRef(false)
	module.useEffect(function()
		return function()
			ref2.current = true
		end
	end, {})

	local v6 = module.useCallback(function(p4)
		local fIntAXBackgroundPublishNameMaxLength = module7.FIntAXBackgroundPublishNameMaxLength
		local v7 = utf8.len(p4)
		local v8 = not (v7 == nil) and v7 <= fIntAXBackgroundPublishNameMaxLength

		if v8 then
			setState2(p4)
		end
	end, {})

	local v7 = module.useCallback(function(p4)
		local fIntAXBackgroundPublishDescriptionMaxLength = module7.FIntAXBackgroundPublishDescriptionMaxLength
		local v8 = utf8.len(p4)
		local v9 = not (v8 == nil) and v8 <= fIntAXBackgroundPublishDescriptionMaxLength

		if v9 then
			setState3(p4)
		end
	end, {})

	local function emitDuration(p4)
		sendAXStat({
			statName = module8.PUBLISH_DURATION_STAT_NAME,
			deltaMs = (os.clock() - ref.current) * 1000,
			metaData = { status = p4 }
		})
	end

	local function fail(p4, p5)
		sendAXCounterV2(module8.PUBLISH_OUTCOME_COUNTER_NAME, {
			status = "error",
			errorKind = p4,
			reason = p5
		})
		emitDuration("error")
		setState("error")
		setState5(p4)
	end

	local function failQuota(p4)
		fail("QuotaReached", "upload_quota_reached")

		setState6(p4)
	end

	local function succeed(assetId)
		sendAXCounterV2(module8.PUBLISH_OUTCOME_COUNTER_NAME, { status = "success" })
		emitDuration("success")
		setState4(assetId)
		setState5(nil)

		if fFlagAXBackgroundUploadQuotaError and setState6 then
			setState6(nil)
		end

		setState("completed")
	end

	local function pollUpload(operationId)
		local function fetchStatus()
			return module5(p2, p3, operationId)
		end

		local function onResult(p4)
			if ref2.current then
				return
			end

			if p4 then
				if p4.status ~= "Completed" then
					fail("Failed", "upload_failed")

					return
				end

				if p4.assetId then
					succeed(p4.assetId)
					return
				end

				warn(`[BackgroundPublish] Completed status missing assetId for generationId={p3}, operationId={operationId}`)

				fail("Unknown", "missing_asset_id")
			else
				warn(`[BackgroundPublish] Malformed status response for generationId={p3}, operationId={operationId}`)

				fail("Unknown", "malformed_status")
			end
		end

		local function onFailure(p4)
			if ref2.current then
				return
			end

			if p4.kind == "timeout" then
				warn(`[BackgroundPublish] Client poll timeout for generationId={p3}, operationId={operationId}`)

				fail("Timeout", "client_poll_timeout")
			elseif p4.kind == "internal" then
				warn(`[BackgroundPublish] Internal poll failure for generationId={p3}, operationId={operationId}: {tostring(p4.error)}`)

				fail("Unknown", "poll_internal_error")
			else
				warn(`[BackgroundPublish] Poll failed for generationId={p3}, operationId={operationId}: {tostring(p4.error)}`)

				local err = p4.error
				local statusCode = if type(err) == "table" then err.StatusCode else nil
				fail(
					statusCode == 403 and "PermissionDenied" or statusCode == 404 and "NotFound" or statusCode == 409 and "NotCompleted" or statusCode == 410 and "ImageExpired" or type(err) == "table" and "Network" or "Unknown",
					"poll_failed"
				)
			end
		end

		return v5(fetchStatus, isTerminalUploadStatus, {
			intervalSeconds = module7.FIntAXBackgroundPublishPollIntervalSeconds,
			timeoutSeconds = module7.FIntAXBackgroundPublishPollTimeoutSeconds,
			maxConsecutiveFailures = module7.FIntAXBackgroundPublishMaxConsecutivePollFailures
		}):andThen(onResult):catch(onFailure)
	end

	local v8

	if
		p3 == nil
		or state ~= "idle" and state ~= "error"
		or string.gsub(state2, "^%s*(.-)%s*$", "%1") == ""
	then
		v8 = false
	else
		local fIntAXBackgroundPublishNameMaxLength = module7.FIntAXBackgroundPublishNameMaxLength
		local v9 = utf8.len(state2)
		v8 = not (v9 == nil) and v9 <= fIntAXBackgroundPublishNameMaxLength

		if v8 then
			local fIntAXBackgroundPublishDescriptionMaxLength = module7.FIntAXBackgroundPublishDescriptionMaxLength
			local v10 = utf8.len(state3)
			v8 = not (v10 == nil) and v10 <= fIntAXBackgroundPublishDescriptionMaxLength
		end
	end

	local v9 = module.useCallback(function()
		if not v8 then
			return
		end

		ref.current = os.clock()
		sendAXCounterV2(module8.PUBLISH_OUTCOME_COUNTER_NAME, { status = "attempt" })
		setState("uploading")
		setState4(nil)
		setState5(nil)

		if fFlagAXBackgroundUploadQuotaError and setState6 then
			setState6(nil)
		end

		module3(p2, p3, {
			displayName = string.gsub(state2, "^%s*(.-)%s*$", "%1"),
			description = state3
		}):andThen(function(p4)
			if ref2.current then
				return
			end

			local operationId = p4 and p4.operationId

			if operationId then
				setState("polling")
				return pollUpload(operationId)
			end

			warn(`[BackgroundPublish] Upload response missing operationId for generationId={p3}`)
			fail("Unknown", "missing_operation_id")
		end):catch(function(p4)
			if ref2.current then
				return
			end

			if fFlagAXBackgroundUploadQuotaError then
				local v15, v16 = module4(p4)

				if v15 then
					fail("QuotaReached", "upload_quota_reached")

					setState6(v16)

					return
				end
			end

			warn(`[BackgroundPublish] Upload request failed for generationId={p3}: {tostring(p4)}`)
			local statusCode = if type(p4) == "table" then p4.StatusCode else nil
			fail(
				statusCode == 403 and "PermissionDenied" or statusCode == 404 and "NotFound" or statusCode == 409 and "NotCompleted" or statusCode == 410 and "ImageExpired" or type(p4) == "table" and "Network" or "Unknown",
				"start_upload_failed"
			)
		end)
	end, { v8, state3, state2, p3, p2, v5 })

	local v10 = module.useCallback(function()
		setState("idle")
		setState4(nil)
		setState5(nil)

		if fFlagAXBackgroundUploadQuotaError and setState6 then
			setState6(nil)
		end
	end, {})
	return {
		state = state,
		displayName = state2,
		description = state3,
		assetId = state4,
		errorKind = state5,
		quotaPeriod = state6,
		canSubmit = v8,
		setDisplayName = v6,
		setDescription = v7,
		submit = v9,
		reset = v10,
		clear = module.useCallback(function()
			v10()
			setState2("")
			setState3("")
		end, { v10 })
	}
end

return usePublishController
