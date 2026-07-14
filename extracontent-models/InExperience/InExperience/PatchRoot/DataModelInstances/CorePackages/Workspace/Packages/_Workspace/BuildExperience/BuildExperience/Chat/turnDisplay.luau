local Parent = script:FindFirstAncestor("BuildExperience").Parent
local SubagentTasks = require(Parent.DataHydration.CreatorAgentChat).SubagentTasks

local function normalizeToolTitle(s1: string) -- line: 33
	return string.lower((string.gsub(s1, "[_%-%s]", "")))
end
local function isManageTasksToolTitle(s2: string?) -- line: 37
	-- upvalues: SubagentTasks (copy)
	local v13 = false

	if typeof(s2) == "string" then
		local v14 = string.lower((string.gsub(s2, "[_%-%s]", "")))
		local TOOL_NAME = SubagentTasks.TOOL_NAME

		v13 = v14 == string.lower((string.gsub(TOOL_NAME, "[_%-%s]", "")))
	end

	return v13
end
local function parseEmittedTimeMillis(s3: string?) -- line: 58
	if typeof(s3) ~= "string" or s3 == "" then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(s3)

	if dateTime ~= nil then
		return dateTime.UnixTimestampMillis
	end

	return nil
end
local function isActiveToolActivity(p1) -- line: 84
	if p1.kind ~= "tool_call" then
		return false
	end

	return p1.status == "pending" or (p1.status == "in_progress" or p1.status == nil)
end
local function getToolActivityLabel(p2) -- line: 91
	-- upvalues: SubagentTasks (copy)
	if p2.kind ~= "tool_call" then
		return "tool"
	end

	local v36 = (typeof(p2.title) ~= "string" or p2.title == "") and "tool" or p2.title
	local v37 = false

	if typeof(v36) == "string" then
		local v38 = string.lower((string.gsub(v36, "[_%-%s]", "")))
		local TOOL_NAME = SubagentTasks.TOOL_NAME

		v37 = v38 == string.lower((string.gsub(TOOL_NAME, "[_%-%s]", "")))
	end

	if v37 then
		return "Assigning tasks to agents"
	end

	if p2.status == "completed" then
		return `Finished { v36 }`
	end

	if p2.status == "failed" then
		return `Failed { v36 }`
	end

	return `Running { v36 }`
end
local function getActiveActivityLabel(t1: {[any]: any}, _: boolean) -- line: 119
	-- upvalues: getToolActivityLabel (copy)
	for i = #t1, 1, -1 do
		local v47 = t1[i]

		if v47.kind == "tool_call" and (v47.kind == "tool_call" and (v47.status == "pending" or (v47.status == "in_progress" or v47.status == nil))) then
			return (getToolActivityLabel(v47))
		end
	end

	return "Thinking"
end

return {
	ASSISTANT_STOPPED_TEXT = "You stopped the agent.",
	countToolCalls = function(t2: {[any]: any}) -- line: 109
		local n1 = 0

		for _, v43 in t2 do
			if v43.kind == "tool_call" then
				n1 += 1
			end
		end

		return n1
	end,
	formatTurnFailureMessage = function(p3) -- line: 25
		local v10 = p3.error or "Assistant response failed."

		if p3.errorCode ~= nil then
			v10 = `({ p3.errorCode }) { v10 }`
		end

		return v10
	end,
	formatStepCount = function(n2: number) -- line: 42
		if n2 == 1 then
			return "1 Action completed"
		end

		return `{ n2 } Actions completed`
	end,
	formatWorkedDuration = function(n3: number) -- line: 48
		local v18 = math.max(0, (math.floor(n3 + 0.5)))

		if v18 < 60 then
			return `Worked for { v18 }s`
		end

		return `Worked for { math.floor(v18 / 60) }m{ v18 % 60 }s`
	end,
	getActiveActivityLabel = getActiveActivityLabel,
	getAskUserActivityLabel = function(n4: number, n5: number?) -- line: 137
		if n5 == 0 then
			return "Answer the agent's question in the composer below"
		end

		if n4 == 1 then
			return "Agent has a question"
		end

		return "Agent has some questions"
	end,
	getCompletedActivityLabel = function(t3: {[any]: any}) -- line: 129
		-- upvalues: getActiveActivityLabel (copy)
		local n6 = 0

		for _, v51 in t3 do
			if v51.kind == "tool_call" then
				n6 += 1
			end
		end

		if n6 > 0 then
			if n6 == 1 then
				return "1 Action completed"
			end

			return `{ n6 } Actions completed`
		end

		return (getActiveActivityLabel(t3, false))
	end,
	getToolActivityLabel = getToolActivityLabel,
	getTurnWorkedDurationLabel = function(t4: {[any]: any}?, n7: number?, n8: number?, n9: number) -- line: 66
		if t4 ~= nil and (n7 ~= nil and n8 ~= nil) then
			local v25 = t4[n7]
			local v26 = t4[n8]
			local v28

			if v25 ~= nil then
				local emittedTime = v25.emittedTime

				if typeof(emittedTime) ~= "string" or emittedTime == "" then
					v28 = nil
				else
					local dateTime = DateTime.fromIsoDate(emittedTime)

					v28 = if dateTime == nil then nil else dateTime.UnixTimestampMillis
				end
			else
				v28 = nil
			end

			local v31

			if v26 ~= nil then
				local emittedTime = v26.emittedTime

				if typeof(emittedTime) ~= "string" or emittedTime == "" then
					v31 = nil
				else
					local dateTime = DateTime.fromIsoDate(emittedTime)

					v31 = if dateTime == nil then nil else dateTime.UnixTimestampMillis
				end
			else
				v31 = nil
			end

			if v28 ~= nil and v31 ~= nil then
				local v33 = math.max(0, (math.floor((v31 - v28) / 1000 + 0.5)))

				if v33 < 60 then
					return `Worked for { v33 }s`
				end

				return `Worked for { math.floor(v33 / 60) }m{ v33 % 60 }s`
			end
		end

		if n9 > 0 then
			if n9 == 1 then
				return "1 Action completed"
			end

			return `{ n9 } Actions completed`
		end

		return "Turn activity"
	end
}
