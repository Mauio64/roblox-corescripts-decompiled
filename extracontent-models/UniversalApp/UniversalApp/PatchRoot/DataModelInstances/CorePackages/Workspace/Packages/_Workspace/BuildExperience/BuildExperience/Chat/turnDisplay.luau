local Parent = script:FindFirstAncestor("BuildExperience").Parent
local SubagentTasks = require(Parent.DataHydration.CreatorAgentChat).SubagentTasks

local function normalizeToolTitle(s1: string) -- line: 29
	return string.lower((string.gsub(s1, "[_%-%s]", "")))
end
local function isManageTasksToolTitle(s2: string?) -- line: 33
	-- upvalues: SubagentTasks (copy)
	local v12 = false

	if typeof(s2) == "string" then
		local v13 = string.lower((string.gsub(s2, "[_%-%s]", "")))
		local TOOL_NAME = SubagentTasks.TOOL_NAME

		v12 = v13 == string.lower((string.gsub(TOOL_NAME, "[_%-%s]", "")))
	end

	return v12
end
local function isActiveToolActivity(p1) -- line: 42
	if p1.kind ~= "tool_call" then
		return false
	end

	return p1.status == "pending" or (p1.status == "in_progress" or p1.status == nil)
end
local function getToolActivityLabel(p2) -- line: 49
	-- upvalues: SubagentTasks (copy)
	if p2.kind ~= "tool_call" then
		return "tool"
	end

	local v18 = (typeof(p2.title) ~= "string" or p2.title == "") and "tool" or p2.title
	local v19 = false

	if typeof(v18) == "string" then
		local v20 = string.lower((string.gsub(v18, "[_%-%s]", "")))
		local TOOL_NAME = SubagentTasks.TOOL_NAME

		v19 = v20 == string.lower((string.gsub(TOOL_NAME, "[_%-%s]", "")))
	end

	if v19 then
		return "Assigning tasks to agents"
	end

	if p2.status == "completed" then
		return `Finished { v18 }`
	end

	if p2.status == "failed" then
		return `Failed { v18 }`
	end

	return `Running { v18 }`
end
local function getActiveActivityLabel(t1: {[any]: any}, b1: boolean) -- line: 77
	-- upvalues: getToolActivityLabel (copy)
	for i = #t1, 1, -1 do
		local v29 = t1[i]

		if v29.kind == "tool_call" and (v29.kind == "tool_call" and (v29.status == "pending" or (v29.status == "in_progress" or v29.status == nil))) then
			return (getToolActivityLabel(v29))
		end
	end

	if b1 then
		return "Thinking"
	end

	for i = #t1, 1, -1 do
		local v31 = t1[i]

		if v31.kind == "thought" and v31.text ~= "" then
			return v31.text
		end
	end

	return "Thinking"
end

return {
	ASSISTANT_STOPPED_TEXT = "You stopped the agent.",
	countToolCalls = function(t2: {[any]: any}) -- line: 67
		local n1 = 0

		for _, v25 in t2 do
			if v25.kind == "tool_call" then
				n1 += 1
			end
		end

		return n1
	end,
	formatTurnFailureMessage = function(p3) -- line: 21
		local v9 = p3.error or "Assistant response failed."

		if p3.errorCode ~= nil then
			v9 = `({ p3.errorCode }) { v9 }`
		end

		return v9
	end,
	formatStepCount = function(n2: number) -- line: 38
		if n2 == 1 then
			return "1 Action completed"
		end

		return `{ n2 } Actions completed`
	end,
	getActiveActivityLabel = getActiveActivityLabel,
	getCompletedActivityLabel = function(t3: {[any]: any}) -- line: 96
		-- upvalues: getActiveActivityLabel (copy)
		local n3 = 0

		for _, v35 in t3 do
			if v35.kind == "tool_call" then
				n3 += 1
			end
		end

		if n3 > 0 then
			if n3 == 1 then
				return "1 Action completed"
			end

			return `{ n3 } Actions completed`
		end

		return (getActiveActivityLabel(t3, false))
	end,
	getToolActivityLabel = getToolActivityLabel
}
