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
local t3 = {
	[SubagentTaskStatus.InProgress] = 1,
	[SubagentTaskStatus.Done] = 2,
	[SubagentTaskStatus.Pending] = 3,
	[SubagentTaskStatus.Error] = 4,
	[SubagentTaskStatus.Deleted] = 5
}

local function toTaskStatus(p1) -- line: 47
	-- upvalues: SubagentTaskStatus (copy), t1 (copy)
	if typeof(p1) ~= "string" then
		return SubagentTaskStatus.Pending
	end

	return t1[string.lower(p1)] or p1
end
local function toTaskCategory(p2) -- line: 54
	-- upvalues: t2 (copy)
	if typeof(p2) ~= "string" then
		return nil
	end

	return t2[string.lower(p2)] or p2
end
local function valueLooksLikeToolName(p3) -- line: 61
	return typeof(p3) == "string" and string.lower(p3) == "manage_tasks"
end
local function toolCallLooksLikeManageTasks(p4) -- line: 65
	local kind = p4.kind

	if typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks" then
		local title = p4.title

		if not (typeof(title) == "string" and string.lower(title) == "manage_tasks") then
			local rawInput = p4.rawInput

			if typeof(rawInput) == "table" then
				local name = rawInput.name
				local v31 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

				if not v31 then
					local toolName = rawInput.toolName

					v31 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
				end

				return v31
			end

			return false
		end
	end

	return true
end
local function toTaskMetadata(p5) -- line: 78
	-- upvalues: HttpService (copy)
	if p5 == nil then
		return nil
	end

	if typeof(p5) == "table" then
		return p5
	end

	if typeof(p5) == "string" then
		local ok, result = pcall(function() -- line: 85
			-- upvalues: HttpService (copy), p5 (copy)
			return HttpService:JSONDecode(p5)
		end)

		if ok and typeof(result) == "table" then
			return result
		end
	end

	return nil
end
local function toTaskItem(p6) -- line: 95
	-- upvalues: t2 (copy), SubagentTaskStatus (copy), t1 (copy), toTaskMetadata (copy)
	if typeof(p6) ~= "table" or (typeof(p6.text) ~= "string" or p6.text == "") then
		return nil
	end

	local category = p6.category
	local v38 = if typeof(category) == "string" then t2[string.lower(category)] or category else nil

	if v38 == nil then
		return nil
	end

	local t4 = {
		text = p6.text,
		description = p6.description
	}
	local status = p6.status

	t4.status = if typeof(status) == "string" then t1[string.lower(status)] or status else SubagentTaskStatus.Pending
	t4.category = v38
	t4.metadata = toTaskMetadata(p6.metadata)
	t4.created_timestamp = if typeof(p6.created_timestamp) ~= "string" then nil else p6.created_timestamp

	return t4
end
local function getTaskStatusPriority(p7) -- line: 123
	-- upvalues: t3 (copy)
	if p7 == nil then
		return 6
	end

	return t3[p7] or 6
end
local function sortTasksByStatus(t5: {[any]: any}) -- line: 130
	-- upvalues: t3 (copy)
	local v45 = table.clone(t5)

	table.sort(v45, function(p8, p9) -- line: 132
		-- upvalues: t3 (copy)
		local status = p8.status
		local v145 = if status ~= nil then t3[status] or 6 else 6
		local status2 = p9.status

		return v145 < if status2 ~= nil then t3[status2] or 6 else 6
	end)

	return v45
end
local function appendTasksFromPayload(p10, t6: {[any]: any}) -- line: 138
	-- upvalues: toTaskItem (copy)
	local v48 = if typeof(p10) ~= "table" then nil else p10.tasks

	if typeof(v48) ~= "table" then
		return
	end

	for _, v50 in v48 do
		local v51 = toTaskItem(v50)

		if v51 ~= nil then
			table.insert(t6, v51)
		end
	end
end
local function appendTasksFromMaybeJson(p11, t7: {[any]: any}) -- line: 152
	-- upvalues: appendTasksFromPayload (copy), HttpService (copy)
	if typeof(p11) == "table" then
		appendTasksFromPayload(p11, t7)

		return
	end

	if typeof(p11) == "string" then
		local ok, result = pcall(function() -- line: 156
			-- upvalues: HttpService (copy), p11 (copy)
			return HttpService:JSONDecode(p11)
		end)

		if not ok then
			return
		end

		local v56 = if typeof(result) ~= "table" then nil else result.text

		if typeof(v56) == "string" then
			local ok2, result2 = pcall(function() -- line: 165
				-- upvalues: HttpService (copy), v56 (copy)
				return HttpService:JSONDecode(v56)
			end)

			if ok2 then
				appendTasksFromPayload(result2, t7)
			end
		end

		appendTasksFromPayload(result, t7)
	end
end
local function orderedManageTasksToolCalls(p12) -- line: 186
	local t8 = {}
	local t9 = {}
	local g75 = nil
	local v79 = nil
	local g85 = nil
	local v89 = nil

	for _, v72 in p12.activityItems do
		if v72.kind ~= "tool_call" then
			continue
		end

		local v73 = p12.toolCalls[v72.toolCallId]

		if v73 == nil then
			continue
		end

		local kind = v73.kind

		repeat
			if not g75 and (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
				local title = v73.title

				if typeof(title) == "string" and string.lower(title) == "manage_tasks" then
					g75 = true
				end

				if not g75 then
					local rawInput = v73.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name

						v79 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

						if not v79 then
							local toolName = rawInput.toolName

							v79 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
						end
					else
						v79 = false
					end
				end
			else
				g75 = false
				v79 = true
			end
		until not g75

		if v79 then
			table.insert(t8, v73)
			t9[v73.toolCallId] = true
		end
	end

	local t10 = {}

	for v82, v83 in p12.toolCalls do
		if t9[v82] then
			continue
		end

		local kind = v83.kind

		repeat
			if not g85 and (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
				local title = v83.title

				if typeof(title) == "string" and string.lower(title) == "manage_tasks" then
					g85 = true
				end

				if not g85 then
					local rawInput = v83.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name

						v89 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

						if not v89 then
							local toolName = rawInput.toolName

							v89 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
						end
					else
						v89 = false
					end
				end
			else
				g85 = false
				v89 = true
			end
		until not g85

		if v89 then
			table.insert(t10, v82)
		end
	end

	table.sort(t10)

	for _, v92 in t10 do
		table.insert(t8, p12.toolCalls[v92])
	end

	return t8
end
local function taskKey(p13) -- line: 214
	return `{ p13.category }:{ p13.text }`
end
local function applyTasks(t11: {[any]: any}, t12: {[any]: any}, t13: {[any]: any}) -- line: 218
	for _, v98 in t11 do
		local v99 = `{ v98.category }:{ v98.text }`

		if t13[v99] == nil then
			table.insert(t12, v98)
		end

		t13[v99] = v98
	end
end
local function groupTasks(t14: {[any]: any}) -- line: 228
	-- upvalues: SubagentTaskStatus (copy), t3 (copy)
	local t15 = {}
	local t16 = {}

	for _, v104 in t14 do
		local v105 = t16[v104.category]

		if v105 == nil then
			v105 = {
				isComplete = true,
				isLoading = false,
				name = v104.category,
				tasks = {}
			}
			t16[v104.category] = v105
			table.insert(t15, v105)
		end

		table.insert(v105.tasks, v104)

		if v104.status ~= SubagentTaskStatus.Done then
			v105.isComplete = false
		end
	end

	for _, v107 in t15 do
		local tasks = v107.tasks
		local v109 = table.clone(tasks)

		table.sort(v109, function(p14, p15) -- line: 132
			-- upvalues: t3 (copy)
			local status = p14.status
			local v150 = if status ~= nil then t3[status] or 6 else 6
			local status3 = p15.status

			return v150 < if status3 ~= nil then t3[status3] or 6 else 6
		end)
		v107.tasks = v109
		v107.isLoading = false

		for _, v111 in v107.tasks do
			if v111.status == SubagentTaskStatus.InProgress then
				v107.isLoading = true

				break
			end
		end
	end

	return t15
end
local function toTaskState(t17: {[any]: any}, t18: {[any]: any}) -- line: 265
	-- upvalues: groupTasks (copy)
	if #t17 == 0 then
		return nil
	end

	local t19 = {}

	for _, v116 in t17 do
		table.insert(t19, t18[`{ v116.category }:{ v116.text }`])
	end

	local v117 = groupTasks(t19)
	local v118 = #v117 > 0

	for _, v120 in v117 do
		if not v120.isComplete then
			v118 = false

			return {
				groups = v117,
				allComplete = v118
			}
		end
	end

	return {
		groups = v117,
		allComplete = v118
	}
end

return {
	TOOL_NAME = "manage_tasks",
	extractTasksFromToolCall = function(p16) -- line: 176
		-- upvalues: appendTasksFromMaybeJson (copy)
		local kind = p16.kind
		local g61 = nil
		local title = nil
		local v65 = nil

		repeat
			if g61 or (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
				if not g61 then
					title = p16.title
				end

				if g61 or not (typeof(title) == "string" and string.lower(title) == "manage_tasks") then
					if not g61 then
						local rawInput = p16.rawInput

						if typeof(rawInput) == "table" then
							local name = rawInput.name

							v65 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

							if not v65 then
								local toolName = rawInput.toolName

								v65 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
							end
						else
							v65 = false
						end
					end

					g61 = false

					if not v65 then
						return nil
					end

					local t20 = {}

					appendTasksFromMaybeJson(p16.rawInput, t20)

					if #t20 > 0 then
						return t20
					end

					return nil
				end
			end

			v65 = true
			g61 = true
		until not g61
	end,
	fromTasks = function(p17) -- line: 290
		-- upvalues: toTaskItem (copy), applyTasks (copy), toTaskState (copy)
		if typeof(p17) ~= "table" then
			return nil
		end

		local t21 = {}
		local t22 = {}
		local t23 = {}

		for _, v126 in p17 do
			local v127 = toTaskItem(v126)

			if v127 ~= nil then
				table.insert(t23, v127)
			end
		end

		applyTasks(t23, t21, t22)

		return (toTaskState(t21, t22))
	end,
	fromTurnState = function(p18) -- line: 308
		-- upvalues: orderedManageTasksToolCalls (copy), appendTasksFromMaybeJson (copy), applyTasks (copy), toTaskState (copy)
		local t24 = {}
		local t25 = {}
		local g134 = nil
		local v138 = nil

		for _, v132 in orderedManageTasksToolCalls(p18) do
			local kind = v132.kind

			repeat
				if not g134 and (typeof(kind) ~= "string" or string.lower(kind) ~= "manage_tasks") then
					local title = v132.title

					if typeof(title) == "string" and string.lower(title) == "manage_tasks" then
						g134 = true
					end

					if not g134 then
						local rawInput = v132.rawInput

						if typeof(rawInput) == "table" then
							local name = rawInput.name

							v138 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

							if not v138 then
								local toolName = rawInput.toolName

								v138 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
							end
						else
							v138 = false
						end
					end
				else
					g134 = false
					v138 = true
				end
			until not g134

			local v140

			if not v138 then
				v140 = nil
			else
				local t26 = {}

				appendTasksFromMaybeJson(v132.rawInput, t26)
				v140 = if not (#t26 > 0) then nil else t26
			end

			if v140 ~= nil then
				applyTasks(v140, t24, t25)
			end
		end

		return (toTaskState(t24, t25))
	end,
	isTaskComplete = function(p19) -- line: 115
		-- upvalues: SubagentTaskStatus (copy)
		return p19.status == SubagentTaskStatus.Done
	end,
	isTaskLoading = function(p20) -- line: 119
		-- upvalues: SubagentTaskStatus (copy)
		return p20.status == SubagentTaskStatus.InProgress
	end
}
