local HttpService = game:GetService("HttpService")

local defineFastFlag = game:DefineFastFlag("DebugMyStatsExperienceStats", false)

local now = nil
local timeline = nil
local v = nil

local function roundSec(p: number) -- 2 equivalent calls inferred from this helper
	return math.floor(p * 1000 + 0.5) / 1000
end

local function timelineFields()
	local now2 = os.clock()

	local v2 = {
		tSec = roundSec(now2 - (now or now2)) -- inferred equivalent call
	}

	if timeline ~= nil then
		v2.timeline = timeline
	end

	if v ~= nil then
		v2.dtSec = roundSec(now2 - v) -- inferred equivalent call
	end

	v = now2
	return v2
end

local function mergeTimeline(detail)
	local v2 = timelineFields()

	if detail == nil then
		return v2
	end

	if typeof(detail) ~= "table" then
		return { detail = detail, tSec = v2.tSec, dtSec = v2.dtSec, timeline = v2.timeline }
	end

	local clone = table.clone(detail)

	for k, v3 in v2 do
		clone[k] = v3
	end

	return clone
end

local function encode(p) -- 1 equivalent call inferred from this helper
	local success, result = pcall(HttpService.JSONEncode, HttpService, p)

	if success and typeof(result) == "string" then
		return result
	end

	return (tostring(p))
end

local function previewString(value, value2: number?)
	if typeof(value) ~= "string" then
		return nil
	end

	local v2 = value2 or 120

	if #value <= v2 then
		return value
	end

	return string.sub(value, 1, v2) .. "..."
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

local Debug = {}

function Debug.isEnabled()
	return defineFastFlag
end

function Debug.log(p: string, p2: string, detail)
	if not defineFastFlag then
		return
	end

	local formatted = ` | {encode(mergeTimeline(detail))}` -- inferred equivalent call

	if p == "warn" then
		warn(`[MyStats] {p2}{formatted}`)
	else
		print(`[MyStats] {p2}{formatted}`)
	end
end

function Debug.resetTimeline(p: string?)
	now = os.clock()
	timeline = p
	v = nil
end

Debug.timelineFields = timelineFields

function Debug.formatStudioAskUserQuestions(items)
	if typeof(items) ~= "table" then
		return { raw = tostring(items) }
	end

	local count = 0
	local firstQuestion = nil
	local count2 = 0
	local firstOption = nil

	for _, item in items do
		if typeof(item) ~= "table" then
			continue
		end

		count += 1

		if firstQuestion == nil then
			firstQuestion = item.question

			if typeof(firstQuestion) == "string" then
				if not (#firstQuestion <= 120) then
					firstQuestion = string.sub(firstQuestion, 1, 120) .. "..."
				end
			else
				firstQuestion = nil
			end
		end

		local options = item.options

		if typeof(options) ~= "table" then
			continue
		end

		for _, option in options do
			count2 += 1

			if not (firstOption == nil and typeof(option) == "table") then
				continue
			end

			firstOption = option.title

			if typeof(firstOption) == "string" then
				if not (#firstOption <= 120) then
					firstOption = string.sub(firstOption, 1, 120) .. "..."
				end
			else
				firstOption = nil
			end
		end
	end

	return {
		questionCount = count,
		totalOptionCount = count2,
		firstQuestion = firstQuestion,
		firstOption = firstOption
	}
end

function Debug.formatToolResultPayload(data)
	if typeof(data) ~= "table" then
		return { raw = tostring(data) }
	end

	local content = data.content
	local textPreview

	if typeof(content) == "table" then
		textPreview = content.text
	end

	local v2 = {
		sessionId = data.sessionId,
		turnId = data.turnId,
		referenceId = data.referenceId,
		isError = data.isError,
		textLength = typeof(textPreview) == "string" and #textPreview or nil,
		textPreview = 0
	}

	if typeof(textPreview) == "string" then
		if not (#textPreview <= 160) then
			textPreview = string.sub(textPreview, 1, 160) .. "..."
		end
	else
		textPreview = nil
	end

	v2.textPreview = textPreview
	return v2
end

Debug.formatRequestState = formatRequestState

function Debug.formatTurnState(data)
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
end

function Debug.rpcFailureMessage(p: string, p2)
	local v2 = formatRequestState(p2)
	local status = v2.status

	if status == "failed" then
		local errorCode = v2.errorCode
		local err = v2.error or "unknown error"

		if errorCode == nil then
			return `{p} failed: {err}`
		end

		return `{p} failed ({errorCode}): {err}`
	elseif status == "pending" then
		return `{p} timed out (still pending)`
	else
		return `{p} ended with unexpected state (status={tostring(status)})`
	end
end

Debug.LOG_PREFIX = "[MyStats]"
return Debug
