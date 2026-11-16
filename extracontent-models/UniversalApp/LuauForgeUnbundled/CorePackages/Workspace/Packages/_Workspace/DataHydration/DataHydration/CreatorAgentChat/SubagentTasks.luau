local HttpService = game:GetService("HttpService")

local types = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local subagentTaskStatus = types.SubagentTaskStatus
local subagentTaskCategory = types.SubagentTaskCategory

local v5 = {
	pending = subagentTaskStatus.Pending,
	in_progress = subagentTaskStatus.InProgress,
	done = subagentTaskStatus.Done,
	error = subagentTaskStatus.Error,
	deleted = subagentTaskStatus.Deleted
}

local v6 = {
	gameplay = subagentTaskCategory.Gameplay,
	art = subagentTaskCategory.Art,
	audio = subagentTaskCategory.Audio,
	marketing = subagentTaskCategory.Marketing
}

local v7 = {
	[subagentTaskStatus.InProgress] = 1,
	[subagentTaskStatus.Done] = 2,
	[subagentTaskStatus.Pending] = 3,
	[subagentTaskStatus.Error] = 4,
	[subagentTaskStatus.Deleted] = 5
}

local function toTaskStatus(value)
	if typeof(value) == "string" then
		return v5[string.lower(value)] or value
	end

	return subagentTaskStatus.Pending
end

local function toTaskCategory(value)
	if typeof(value) == "string" then
		return v6[string.lower(value)] or value
	end

	return nil
end

local function valueLooksLikeToolName(value): boolean
	return typeof(value) == "string" and string.lower(value) == "manage_tasks"
end

local function toolCallLooksLikeManageTasks(data)
	local kind = data.kind
	local v8 = typeof(kind) == "string" and string.lower(kind) == "manage_tasks"

	if v8 then
		return true
	end

	local title = data.title
	local v9 = typeof(title) == "string" and string.lower(title) == "manage_tasks"

	if v9 then
		return true
	end

	local rawInput = data.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	local name = rawInput.name
	local v10 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

	if v10 then
		return v10
	end

	local toolName = rawInput.toolName
	v10 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
	return v10
end

local function toTaskMetadata(metadata)
	if metadata == nil then
		return nil
	end

	if typeof(metadata) == "table" then
		return metadata
	end

	if typeof(metadata) == "string" then
		local success, result = pcall(function()
			return HttpService:JSONDecode(metadata)
		end)

		if success and typeof(result) == "table" then
			return result
		end
	end

	return nil
end

local function toTaskItem(data)
	if typeof(data) ~= "table" or typeof(data.text) ~= "string" or data.text == "" then
		return nil
	end

	local category = data.category
	local v8 = if typeof(category) == "string" then v6[string.lower(category)] or category else nil

	if v8 == nil then
		return nil
	end

	local v9 = {
		text = data.text,
		description = data.description,
		status = 0,
		category = 0,
		metadata = 0,
		created_timestamp = 0
	}
	local status = data.status
	local v10 = if typeof(status) == "string" then v5[string.lower(status)] or status else subagentTaskStatus.Pending

	v9.status = v10
	v9.category = v8
	v9.metadata = toTaskMetadata(data.metadata)
	local v11 = if typeof(data.created_timestamp) == "string" then data.created_timestamp else nil
	v9.created_timestamp = v11
	return v9
end

local function getTaskStatusPriority(p2)
	if p2 == nil then
		return 6
	end

	return v7[p2] or 6
end

local function sortTasksByStatus(p2)
	local clone = table.clone(p2)
	table.sort(clone, function(a, b): boolean
		local status = a.status
		local v8 = status == nil and 6 or v7[status] or 6

		local status2 = b.status
		return v8 < (status2 == nil and 6 or v7[status2] or 6)
	end)

	return clone
end

local function appendTasksFromPayload(p2, list)
	local tasks = if typeof(p2) == "table" then p2.tasks else nil

	if typeof(tasks) ~= "table" then
		return
	end

	for k, task2 in tasks do
		local v8 = toTaskItem(task2)

		if v8 ~= nil then
			table.insert(list, v8)
		end
	end
end

local function appendTasksFromMaybeJson(rawInput, p2)
	if typeof(rawInput) == "table" then
		appendTasksFromPayload(rawInput, p2)
	elseif typeof(rawInput) == "string" then
		local success, result = pcall(function()
			return HttpService:JSONDecode(rawInput)
		end)

		if not success then
			return
		end

		local text = if typeof(result) == "table" then result.text else nil

		if typeof(text) == "string" then
			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(text)
			end)

			if success2 then
				appendTasksFromPayload(result2, p2)
			end
		end

		appendTasksFromPayload(result, p2)
	end
end

local function orderedManageTasksToolCalls(p2)
	local result = {}
	local toolCallIdSet = {}

	for k, activityItem in p2.activityItems do
		if activityItem.kind ~= "tool_call" then
			continue
		end

		local toolCall = p2.toolCalls[activityItem.toolCallId]

		if toolCall == nil then
			continue
		end

		local kind = toolCall.kind
		local v8 = typeof(kind) == "string" and string.lower(kind) == "manage_tasks"
		local v9

		if v8 then
			v9 = true
		else
			local title = toolCall.title
			local v10 = typeof(title) == "string" and string.lower(title) == "manage_tasks"

			if v10 then
				v9 = true
			else
				local rawInput = toolCall.rawInput

				if typeof(rawInput) == "table" then
					local name = rawInput.name
					v9 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

					if not v9 then
						local toolName = rawInput.toolName
						v9 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
					end
				else
					v9 = false
				end
			end
		end

		if not v9 then
			continue
		end

		table.insert(result, toolCall)
		toolCallIdSet[toolCall.toolCallId] = true
	end

	local v8 = {}

	for k, toolCall in p2.toolCalls do
		if toolCallIdSet[k] then
			continue
		end

		local kind = toolCall.kind
		local v9 = typeof(kind) == "string" and string.lower(kind) == "manage_tasks"
		local v10

		if v9 then
			v10 = true
		else
			local title = toolCall.title
			local v11 = typeof(title) == "string" and string.lower(title) == "manage_tasks"

			if v11 then
				v10 = true
			else
				local rawInput = toolCall.rawInput

				if typeof(rawInput) == "table" then
					local name = rawInput.name
					v10 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

					if not v10 then
						local toolName = rawInput.toolName
						v10 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
					end
				else
					v10 = false
				end
			end
		end

		if v10 then
			table.insert(v8, k)
		end
	end

	table.sort(v8)

	for k, v9 in v8 do
		table.insert(result, p2.toolCalls[v9])
	end

	return result
end

local function taskKey(p2)
	return `{p2.category}:{p2.text}`
end

local function applyTasks(items, list, p2)
	for k, item in items do
		local formatted = `{item.category}:{item.text}`

		if p2[formatted] == nil then
			table.insert(list, item)
		end

		p2[formatted] = item
	end
end

local function groupTasks(items)
	local v8 = {}
	local result = {}

	for k, item in items do
		local v9 = v8[item.category]

		if v9 == nil then
			v9 = {
				name = item.category,
				tasks = {},
				isComplete = true,
				isLoading = false
			}

			v8[item.category] = v9
			table.insert(result, v9)
		end

		table.insert(v9.tasks, item)

		if item.status ~= subagentTaskStatus.Done then
			v9.isComplete = false
		end
	end

	for k, v9 in result do
		local tasks = v9.tasks
		local clone = table.clone(tasks)
		table.sort(clone, function(a, b): boolean
			local status = a.status
			local v10 = status == nil and 6 or v7[status] or 6

			local status2 = b.status
			return v10 < (status2 == nil and 6 or v7[status2] or 6)
		end)

		v9.tasks = clone
		v9.isLoading = false

		for k2, task2 in v9.tasks do
			if task2.status == subagentTaskStatus.InProgress then
				v9.isLoading = true
				break
			end
		end
	end

	return result
end

local function toTaskState(list, p2)
	if #list == 0 then
		return nil
	end

	local v8 = {}

	for k, item in list do
		table.insert(v8, p2[`{item.category}:{item.text}`])
	end

	local v9 = groupTasks(v8)
	local v10 = #v9 > 0

	for k, v12 in v9 do
		if not v12.isComplete then
			v10 = false
			break
		end
	end

	return { groups = v9, allComplete = v10 }
end

return {
	TOOL_NAME = "manage_tasks",
	extractTasksFromToolCall = function(data)
		local kind = data.kind
		local v8 = typeof(kind) == "string" and string.lower(kind) == "manage_tasks"
		local v9

		if v8 then
			v9 = true
		else
			local title = data.title
			local v10 = typeof(title) == "string" and string.lower(title) == "manage_tasks"

			if v10 then
				v9 = true
			else
				local rawInput = data.rawInput

				if typeof(rawInput) == "table" then
					local name = rawInput.name
					v9 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

					if not v9 then
						local toolName = rawInput.toolName
						v9 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
					end
				else
					v9 = false
				end
			end
		end

		if not v9 then
			return nil
		end

		local v10 = {}
		appendTasksFromMaybeJson(data.rawInput, v10)

		if #v10 > 0 then
			return v10
		end

		return nil
	end,
	fromTasks = function(items)
		if typeof(items) ~= "table" then
			return nil
		end

		local v8 = {}
		local v9 = {}
		local v10 = {}

		for k, item in items do
			local v11 = toTaskItem(item)

			if v11 ~= nil then
				table.insert(v8, v11)
			end
		end

		applyTasks(v8, v9, v10)
		return toTaskState(v9, v10)
	end,
	fromTurnState = function(p2)
		local v8 = {}
		local v9 = {}

		for k, v10 in orderedManageTasksToolCalls(p2) do
			local kind = v10.kind
			local v11 = typeof(kind) == "string" and string.lower(kind) == "manage_tasks"
			local v12

			if v11 then
				v12 = true
			else
				local title = v10.title
				local v13 = typeof(title) == "string" and string.lower(title) == "manage_tasks"

				if v13 then
					v12 = true
				else
					local rawInput = v10.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name
						v12 = typeof(name) == "string" and string.lower(name) == "manage_tasks"

						if not v12 then
							local toolName = rawInput.toolName
							v12 = typeof(toolName) == "string" and string.lower(toolName) == "manage_tasks"
						end
					else
						v12 = false
					end
				end
			end

			local v13

			if v12 then
				v13 = {}
				appendTasksFromMaybeJson(v10.rawInput, v13)

				if not (#v13 > 0) then
					v13 = nil
				end
			end

			if v13 ~= nil then
				applyTasks(v13, v8, v9)
			end
		end

		return toTaskState(v8, v9)
	end,
	isTaskComplete = function(p2): boolean
		return p2.status == subagentTaskStatus.Done
	end,
	isTaskLoading = function(p2): boolean
		return p2.status == subagentTaskStatus.InProgress
	end
}
