local HttpService = game:GetService("HttpService")
local v2 = game:DefineFastFlag("DebugMyStatsExperienceStats", false)
local elapsed = nil
local u4 = nil
local u5 = nil

local function roundSec(n1: number) -- line: 17
	return math.floor(n1 * 1000 + 0.5) / 1000
end
local function timelineFields() -- line: 32
	-- upvalues: elapsed (ref), u4 (ref), u5 (ref)
	local elapsed2 = os.clock()
	local t1 = {
		tSec = math.floor((elapsed2 - (elapsed or elapsed2)) * 1000 + 0.5) / 1000
	}

	if u4 ~= nil then
		t1.timeline = u4
	end

	if u5 ~= nil then
		t1.dtSec = math.floor((elapsed2 - u5) * 1000 + 0.5) / 1000
	end

	u5 = elapsed2

	return t1
end
local function mergeTimeline(p1) -- line: 48
	-- upvalues: timelineFields (copy)
	local v17 = timelineFields()

	if p1 == nil then
		return v17
	end

	if typeof(p1) ~= "table" then
		return {
			detail = p1,
			tSec = v17.tSec,
			dtSec = v17.dtSec,
			timeline = v17.timeline
		}
	end

	local v18 = table.clone(p1)

	for v19, v20 in v17 do
		v18[v19] = v20
	end

	return v18
end
local function encode(p2) -- line: 68
	-- upvalues: HttpService (copy)
	local ok, result = pcall(HttpService.JSONEncode, HttpService, p2)

	if ok and typeof(result) == "string" then
		return result
	end

	return (tostring(p2))
end
local function previewString(p3, n2: number?) -- line: 76
	if typeof(p3) ~= "string" then
		return nil
	end

	local v26 = n2 or 120

	if v26 >= #p3 then
		return p3
	end

	return string.sub(p3, 1, v26) .. "..."
end
local function formatRequestState(p4) -- line: 153
	if typeof(p4) ~= "table" then
		return {
			raw = tostring(p4)
		}
	end

	return {
		status = p4.status,
		error = p4.error,
		errorCode = p4.errorCode,
		result = p4.result
	}
end

return {
	LOG_PREFIX = "[MyStats]",
	isEnabled = function() -- line: 21
		-- upvalues: v2 (copy)
		return v2
	end,
	log = function(s1: string, s2: string, p5) -- line: 87
		-- upvalues: v2 (copy), mergeTimeline (copy), HttpService (copy)
		if not v2 then
			return
		end

		local v30 = mergeTimeline(p5)
		local ok, result = pcall(HttpService.JSONEncode, HttpService, v30)
		local v33 = ` | { (if not ok or typeof(result) ~= "string" then tostring(v30) else result) }`

		if s1 == "warn" then
			warn(`[MyStats] { s2 }{ v33 }`)

			return
		end

		print(`[MyStats] { s2 }{ v33 }`)
	end,
	resetTimeline = function(s3: string?) -- line: 26
		-- upvalues: elapsed (ref), u4 (ref), u5 (ref)
		elapsed = os.clock()
		u4 = s3
		u5 = nil
	end,
	timelineFields = timelineFields,
	formatStudioAskUserQuestions = function(p6) -- line: 99
		if typeof(p6) ~= "table" then
			return {
				raw = tostring(p6)
			}
		end

		local n3 = 0
		local n4 = 0
		local v37 = nil
		local v38 = nil

		for _, v40 in p6 do
			if typeof(v40) == "table" then
				n3 += 1

				if v37 == nil then
					local question = v40.question

					v37 = if typeof(question) == "string" then if not (#question <= 120) then string.sub(question, 1, 120) .. "..." else question else nil
				end

				local options = v40.options

				if typeof(options) == "table" then
					for _, v44 in options do
						n4 += 1

						if v38 == nil and typeof(v44) == "table" then
							local title = v44.title

							v38 = if typeof(title) == "string" then if not (#title <= 120) then string.sub(title, 1, 120) .. "..." else title else nil
						end
					end
				end
			end
		end

		return {
			questionCount = n3,
			totalOptionCount = n4,
			firstQuestion = v37,
			firstOption = v38
		}
	end,
	formatToolResultPayload = function(p7) -- line: 136
		if typeof(p7) ~= "table" then
			return {
				raw = tostring(p7)
			}
		end

		local content = p7.content
		local v48 = if typeof(content) ~= "table" then nil else content.text

		return {
			sessionId = p7.sessionId,
			turnId = p7.turnId,
			referenceId = p7.referenceId,
			isError = p7.isError,
			textLength = if typeof(v48) ~= "string" then nil else #v48,
			textPreview = if typeof(v48) == "string" then if not (#v48 <= 160) then string.sub(v48, 1, 160) .. "..." else v48 else nil
		}
	end,
	formatRequestState = formatRequestState,
	formatTurnState = function(p8) -- line: 165
		if typeof(p8) ~= "table" then
			return {
				raw = tostring(p8)
			}
		end

		return {
			status = p8.status,
			isDone = p8.isDone,
			error = p8.error,
			errorCode = p8.errorCode,
			stopReason = p8.stopReason,
			assistantTextLength = if typeof(p8.assistantText) ~= "string" then nil else #p8.assistantText,
			toolCallCount = p8.toolCallCount,
			sessionId = p8.sessionId
		}
	end,
	rpcFailureMessage = function(s4: string, p9) -- line: 181
		-- upvalues: formatRequestState (copy)
		local v53 = formatRequestState(p9)
		local status = v53.status

		if status == "failed" then
			local errorCode = v53.errorCode
			local v56 = v53.error or "unknown error"

			if errorCode ~= nil then
				return `{ s4 } failed ({ errorCode }): { v56 }`
			end

			return `{ s4 } failed: { v56 }`
		end

		if status == "pending" then
			return `{ s4 } timed out (still pending)`
		end

		return `{ s4 } ended with unexpected state (status={ tostring(status) })`
	end
}
