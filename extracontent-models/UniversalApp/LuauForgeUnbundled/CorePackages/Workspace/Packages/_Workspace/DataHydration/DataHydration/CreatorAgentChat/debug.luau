local HttpService = game:GetService("HttpService")

local defineFastFlag = game:DefineFastFlag("DebugMyStatsExperienceStats", false)

local now = nil
local v5 = nil
local v6 = nil

local function roundSec(p2)
	return math.floor(p2 * 1000 + 0.5) / 1000
end

local function timelineFields()
	local now2 = os.clock()
	local v7 = {
		tSec = math.floor((now2 - (now or now2)) * 1000 + 0.5) / 1000
	}

	if v5 ~= nil then
		v7.timeline = v5
	end

	if v6 ~= nil then
		v7.dtSec = math.floor((now2 - v6) * 1000 + 0.5) / 1000
	end

	v6 = now2
	return v7
end

local function mergeTimeline(p2)
	local v7 = timelineFields()

	if p2 == nil then
		return v7
	end

	if typeof(p2) ~= "table" then
		return { detail = p2, tSec = v7.tSec, dtSec = v7.dtSec, timeline = v7.timeline }
	end

	local clone = table.clone(p2)

	for k, v8 in v7 do
		clone[k] = v8
	end

	return clone
end

local function encode(p2)
	local success, result = pcall(HttpService.JSONEncode, HttpService, p2)

	if success and typeof(result) == "string" then
		return result
	end

	return (tostring(p2))
end

local function previewString(value, value2)
	if typeof(value) ~= "string" then
		return nil
	end

	local v7 = value2 or 120

	if #value <= v7 then
		return value
	end

	return string.sub(value, 1, v7) .. "..."
end

local function formatRequestState(data)
	if typeof(data) == "table" then
		return {
			status = data.status,
			error = data.error,
			errorCode = data.errorCode,
			result = data.result
		}
	end

	return { raw = tostring(data) }
end

return {
	isEnabled = function()
		return defineFastFlag
	end,
	log = function(p2, p3, p4)
		if not defineFastFlag then
			return
		end

		local v8 = mergeTimeline(p4)
		local success, result = pcall(HttpService.JSONEncode, HttpService, v8)

		if not success or typeof(result) ~= "string" then
			result = tostring(v8)
		end

		local formatted = ` | {result}`

		if p2 == "warn" then
			warn(`[MyStats] {p3}{formatted}`)
		else
			print(`[MyStats] {p3}{formatted}`)
		end
	end,
	resetTimeline = function(p2)
		now = os.clock()
		v5 = p2
		v6 = nil
	end,
	timelineFields = timelineFields,
	formatStudioAskUserQuestions = function(items)
		if typeof(items) ~= "table" then
			return { raw = tostring(items) }
		end

		local count = 0
		local v7 = nil
		local count2 = 0
		local v8 = nil

		for k, item in items do
			if typeof(item) ~= "table" then
				continue
			end

			count += 1

			if v7 == nil then
				v7 = item.question

				if (typeof)(v7) == "string" then
					if not (#v7 <= 120) then
						v7 = (string.sub)(v7, 1, 120) .. "..."
					end
				else
					v7 = nil
				end
			end

			local options = item.options

			if typeof(options) ~= "table" then
				continue
			end

			for k2, option in options do
				count2 += 1

				if not (v8 == nil and typeof(option) == "table") then
					continue
				end

				v8 = option.title

				if (typeof)(v8) == "string" then
					if not (#v8 <= 120) then
						v8 = (string.sub)(v8, 1, 120) .. "..."
					end
				else
					v8 = nil
				end
			end
		end

		return {
			questionCount = count,
			totalOptionCount = count2,
			firstQuestion = v7,
			firstOption = v8
		}
	end,
	formatToolResultPayload = function(data)
		if typeof(data) ~= "table" then
			return { raw = tostring(data) }
		end

		local content = data.content
		local v7 = if typeof(content) == "table" then content.text else nil
		local v8 = {
			sessionId = data.sessionId,
			turnId = data.turnId,
			referenceId = data.referenceId,
			isError = data.isError,
			textLength = typeof(v7) == "string" and #v7 or nil,
			textPreview = 0
		}

		if typeof(v7) == "string" then
			if not (#v7 <= 160) then
				v7 = string.sub(v7, 1, 160) .. "..."
			end
		else
			v7 = nil
		end

		v8.textPreview = v7
		return v8
	end,
	formatRequestState = formatRequestState,
	formatTurnState = function(data)
		if typeof(data) == "table" then
			return {
				status = data.status,
				isDone = data.isDone,
				error = data.error,
				errorCode = data.errorCode,
				stopReason = data.stopReason,
				assistantTextLength = typeof(data.assistantText) == "string" and #data.assistantText or nil,
				toolCallCount = data.toolCallCount,
				sessionId = data.sessionId
			}
		end

		return { raw = tostring(data) }
	end,
	rpcFailureMessage = function(p2, p3)
		local v7 = formatRequestState(p3)
		local status = v7.status

		if status == "failed" then
			local errorCode = v7.errorCode
			local err = v7.error or "unknown error"

			if errorCode == nil then
				return `{p2} failed: {err}`
			end

			return `{p2} failed ({errorCode}): {err}`
		elseif status == "pending" then
			return `{p2} timed out (still pending)`
		else
			return `{p2} ended with unexpected state (status={tostring(status)})`
		end
	end,
	LOG_PREFIX = "[MyStats]"
}
