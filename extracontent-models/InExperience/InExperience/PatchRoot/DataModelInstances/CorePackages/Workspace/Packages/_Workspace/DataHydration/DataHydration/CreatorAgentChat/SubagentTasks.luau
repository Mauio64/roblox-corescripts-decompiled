local HttpService = game:GetService("HttpService")
local types = require(script.Parent.types)
local SubagentTaskStatus = types.SubagentTaskStatus
local SubagentTaskCategory = types.SubagentTaskCategory
local t1 = {
	pending = SubagentTaskStatus.Pending,
	in_progress = SubagentTaskStatus.InProgress,
	done = SubagentTaskStatus.Done,
	error = SubagentTaskStatus.Error,
	deleted = SubagentTaskStatus.Deleted
}
local t2 = {
	gameplay = SubagentTaskCategory.Gameplay,
	art = SubagentTaskCategory.Art,
	audio = SubagentTaskCategory.Audio,
	marketing = SubagentTaskCategory.Marketing
}

local function toTaskStatus(p1) -- line: 39
	-- upvalues: SubagentTaskStatus (copy), t1 (copy)
	if typeof(p1) ~= "string" then
		return SubagentTaskStatus.Pending
	end

	return t1[string.lower(p1)] or p1
end
local function toTaskCategory(p2) -- line: 46
	-- upvalues: t2 (copy)
	if typeof(p2) ~= "string" then
		return nil
	end

	return t2[string.lower(p2)] or p2
end
local function valueLooksLikeToolName(p3) -- line: 53
	return typeof(p3) == "string" and string.lower(p3) == "manage_tasks"
end
local function toolCallLooksLikeManageTasks(p4) -- line: 57
	local kind = p4.kind

	if typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks" then
		local title = p4.title

		if not (typeof(title) == "string" and string.lower(title) == "manage_tasks") then
			local rawInput = p4.rawInput

			if typeof(rawInput) == "table" then
				local name = rawInput.name
				local v28 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

				if not v28 then
					local toolName = rawInput.toolName

					v28 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
				end

				return v28
			end

			return false
		end
	end

	return true
end
local function toTaskMetadata(p5) -- line: 70
	-- upvalues: HttpService (copy)
	if p5 == nil then
		return nil
	end

	if typeof(p5) == "table" then
		return p5
	end

	if typeof(p5) == "string" then
		local ok, result = pcall(function() -- line: 77
			-- upvalues: HttpService (copy), p5 (copy)
			return HttpService:JSONDecode(p5)
		end)

		if ok and typeof(result) == "table" then
			return result
		end
	end

	return nil
end
local function toTaskItem(p6) -- line: 87
	-- upvalues: t2 (copy), SubagentTaskStatus (copy), t1 (copy), toTaskMetadata (copy)
	if typeof(p6) ~= "table" or (typeof(p6.text) ~= "string" or p6.text == "") then
		return nil
	end

	local category = p6.category
	local v35 = if typeof(category) == "string" then t2[string.lower(category)] or category else nil

	if v35 == nil then
		return nil
	end

	local t3 = {
		text = p6.text,
		description = p6.description
	}
	local status = p6.status

	t3.status = if typeof(status) == "string" then t1[string.lower(status)] or status else SubagentTaskStatus.Pending
	t3.category = v35
	t3.metadata = toTaskMetadata(p6.metadata)
	t3.created_timestamp = if typeof(p6.created_timestamp) ~= "string" then nil else p6.created_timestamp

	return t3
end
local function appendTasksFromPayload(p7, t4: {[any]: any}) -- line: 115
	-- upvalues: toTaskItem (copy)
	local v42 = if typeof(p7) ~= "table" then nil else p7.tasks

	if typeof(v42) ~= "table" then
		return
	end

	for _, v44 in v42 do
		local v45 = toTaskItem(v44)

		if v45 ~= nil then
			table.insert(t4, v45)
		end
	end
end
local function appendTasksFromMaybeJson(p8, t5: {[any]: any}) -- line: 129
	-- upvalues: appendTasksFromPayload (copy), HttpService (copy)
	if typeof(p8) == "table" then
		appendTasksFromPayload(p8, t5)

		return
	end

	if typeof(p8) == "string" then
		local ok, result = pcall(function() -- line: 133
			-- upvalues: HttpService (copy), p8 (copy)
			return HttpService:JSONDecode(p8)
		end)

		if not ok then
			return
		end

		local v50 = if typeof(result) ~= "table" then nil else result.text

		if typeof(v50) == "string" then
			local ok2, result2 = pcall(function() -- line: 142
				-- upvalues: HttpService (copy), v50 (copy)
				return HttpService:JSONDecode(v50)
			end)

			if ok2 then
				appendTasksFromPayload(result2, t5)
			end
		end

		appendTasksFromPayload(result, t5)
	end
end
local function orderedManageTasksToolCalls(p9) -- line: 163
	local t6 = {}
	local t7 = {}
	local g69 = nil
	local v73 = nil
	local g79 = nil
	local v83 = nil

	for _, v66 in p9.activityItems do
		if v66.kind ~= "tool_call" then
			continue
		end

		local v67 = p9.toolCalls[v66.toolCallId]

		if v67 == nil then
			continue
		end

		local kind = v67.kind

		repeat
			if not g69 and (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
				local title = v67.title

				if typeof(title) == "string" and string.lower(title) == "manage_tasks" then
					g69 = true
				end

				if not g69 then
					local rawInput = v67.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name

						v73 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

						if not v73 then
							local toolName = rawInput.toolName

							v73 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
						end
					else
						v73 = false
					end
				end
			else
				g69 = false
				v73 = true
			end
		until not g69

		if v73 then
			table.insert(t6, v67)
			t7[v67.toolCallId] = true
		end
	end

	local t8 = {}

	for v76, v77 in p9.toolCalls do
		if t7[v76] then
			continue
		end

		local kind = v77.kind

		repeat
			if not g79 and (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
				local title = v77.title

				if typeof(title) == "string" and string.lower(title) == "manage_tasks" then
					g79 = true
				end

				if not g79 then
					local rawInput = v77.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name

						v83 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

						if not v83 then
							local toolName = rawInput.toolName

							v83 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
						end
					else
						v83 = false
					end
				end
			else
				g79 = false
				v83 = true
			end
		until not g79

		if v83 then
			table.insert(t8, v76)
		end
	end

	table.sort(t8)

	for _, v86 in t8 do
		table.insert(t6, p9.toolCalls[v86])
	end

	return t6
end
local function taskKey(p10) -- line: 191
	return `{ p10.category }:{ p10.text }`
end
local function applyTasks(t9: {[any]: any}, t10: {[any]: any}, t11: {[any]: any}) -- line: 195
	for _, v92 in t9 do
		local v93 = `{ v92.category }:{ v92.text }`

		if t11[v93] == nil then
			table.insert(t10, v92)
		end

		t11[v93] = v92
	end
end
local function groupTasks(t12: {[any]: any}) -- line: 205
	-- upvalues: SubagentTaskStatus (copy)
	local t13 = {}
	local t14 = {}

	for _, v98 in t12 do
		local v99 = t14[v98.category]

		if v99 == nil then
			v99 = {
				isComplete = true,
				isLoading = false,
				name = v98.category,
				tasks = {}
			}
			t14[v98.category] = v99
			table.insert(t13, v99)
		end

		table.insert(v99.tasks, v98)

		if v98.status ~= SubagentTaskStatus.Done then
			v99.isComplete = false
		end
	end

	for _, v101 in t13 do
		v101.isLoading = false

		for _, v103 in v101.tasks do
			if v103.status == SubagentTaskStatus.InProgress then
				v101.isLoading = true

				break
			end
		end
	end

	return t13
end
local function toTaskState(t15: {[any]: any}, t16: {[any]: any}) -- line: 241
	-- upvalues: groupTasks (copy)
	if #t15 == 0 then
		return nil
	end

	local t17 = {}

	for _, v108 in t15 do
		table.insert(t17, t16[`{ v108.category }:{ v108.text }`])
	end

	local v109 = groupTasks(t17)
	local v110 = #v109 > 0

	for _, v112 in v109 do
		if not v112.isComplete then
			v110 = false

			return {
				groups = v109,
				allComplete = v110
			}
		end
	end

	return {
		groups = v109,
		allComplete = v110
	}
end

return {
	TOOL_NAME = "manage_tasks",
	extractTasksFromToolCall = function(p11) -- line: 153
		-- upvalues: appendTasksFromMaybeJson (copy)
		local kind = p11.kind
		local g55 = nil
		local title = nil
		local v59 = nil

		repeat
			if g55 or (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
				if not g55 then
					title = p11.title
				end

				if g55 or not (typeof(title) == "string" and string.lower(title) == "manage_tasks") then
					if not g55 then
						local rawInput = p11.rawInput

						if typeof(rawInput) == "table" then
							local name = rawInput.name

							v59 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

							if not v59 then
								local toolName = rawInput.toolName

								v59 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
							end
						else
							v59 = false
						end
					end

					g55 = false

					if not v59 then
						return nil
					end

					local t18 = {}

					appendTasksFromMaybeJson(p11.rawInput, t18)

					if #t18 > 0 then
						return t18
					end

					return nil
				end
			end

			v59 = true
			g55 = true
		until not g55
	end,
	fromTasks = function(p12) -- line: 266
		-- upvalues: toTaskItem (copy), applyTasks (copy), toTaskState (copy)
		if typeof(p12) ~= "table" then
			return nil
		end

		local t19 = {}
		local t20 = {}
		local t21 = {}

		for _, v118 in p12 do
			local v119 = toTaskItem(v118)

			if v119 ~= nil then
				table.insert(t21, v119)
			end
		end

		applyTasks(t21, t19, t20)

		return (toTaskState(t19, t20))
	end,
	fromTurnState = function(p13) -- line: 284
		-- upvalues: orderedManageTasksToolCalls (copy), appendTasksFromMaybeJson (copy), applyTasks (copy), toTaskState (copy)
		local t22 = {}
		local t23 = {}
		local g126 = nil
		local v130 = nil

		for _, v124 in orderedManageTasksToolCalls(p13) do
			local kind = v124.kind

			repeat
				if not g126 and (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
					local title = v124.title

					if typeof(title) == "string" and string.lower(title) == "manage_tasks" then
						g126 = true
					end

					if not g126 then
						local rawInput = v124.rawInput

						if typeof(rawInput) == "table" then
							local name = rawInput.name

							v130 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

							if not v130 then
								local toolName = rawInput.toolName

								v130 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
							end
						else
							v130 = false
						end
					end
				else
					g126 = false
					v130 = true
				end
			until not g126

			local v132

			if not v130 then
				v132 = nil
			else
				local t24 = {}

				appendTasksFromMaybeJson(v124.rawInput, t24)
				v132 = if not (#t24 > 0) then nil else t24
			end

			if v132 ~= nil then
				applyTasks(v132, t22, t23)
			end
		end

		return (toTaskState(t22, t23))
	end,
	isTaskComplete = function(p14) -- line: 107
		-- upvalues: SubagentTaskStatus (copy)
		return p14.status == SubagentTaskStatus.Done
	end,
	isTaskLoading = function(p15) -- line: 111
		-- upvalues: SubagentTaskStatus (copy)
		return p15.status == SubagentTaskStatus.InProgress
	end
}
