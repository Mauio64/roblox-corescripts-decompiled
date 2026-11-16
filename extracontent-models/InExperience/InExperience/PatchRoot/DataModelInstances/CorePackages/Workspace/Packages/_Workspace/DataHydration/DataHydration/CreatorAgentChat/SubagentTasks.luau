local HttpService = game:GetService("HttpService")

local types = require(script.Parent.types)

local subagentTaskStatus = types.SubagentTaskStatus
local subagentTaskCategory = types.SubagentTaskCategory

local v = {
	pending = subagentTaskStatus.Pending,
	in_progress = subagentTaskStatus.InProgress,
	done = subagentTaskStatus.Done,
	error = subagentTaskStatus.Error,
	deleted = subagentTaskStatus.Deleted
}

local v2 = {
	gameplay = subagentTaskCategory.Gameplay,
	art = subagentTaskCategory.Art,
	audio = subagentTaskCategory.Audio,
	marketing = subagentTaskCategory.Marketing
}

local v3 = {
	[subagentTaskStatus.InProgress] = 1,
	[subagentTaskStatus.Done] = 2,
	[subagentTaskStatus.Pending] = 3,
	[subagentTaskStatus.Error] = 4,
	[subagentTaskStatus.Deleted] = 5
}

local function toTaskStatus(status) -- 1 equivalent call inferred from this helper
	if typeof(status) == "string" then
		return v[string.lower(status)] or status
	end

	return subagentTaskStatus.Pending
end

local function toTaskCategory(category) -- 1 equivalent call inferred from this helper
	if typeof(category) == "string" then
		return v2[string.lower(category)] or category
	end

	return nil
end

local function valueLooksLikeToolName(value): boolean -- 16 equivalent calls inferred from this helper
	return typeof(value) == "string" and string.lower(value) == "manage_tasks"
end

local function toolCallLooksLikeManageTasks(data)
	if valueLooksLikeToolName(data.kind) then -- inferred equivalent call
		return true
	end

	if valueLooksLikeToolName(data.title) then -- inferred equivalent call
		return true
	end

	local rawInput = data.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	return valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
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

	local category = toTaskCategory(data.category) -- inferred equivalent call

	if category == nil then
		return nil
	end

	local v4 = {
		text = data.text,
		description = data.description,
		status = toTaskStatus(data.status), -- inferred equivalent call
		category = category,
		metadata = toTaskMetadata(data.metadata),
		created_timestamp = 0
	}
	local created_timestamp

	if typeof(data.created_timestamp) == "string" then
		created_timestamp = data.created_timestamp
	end

	v4.created_timestamp = created_timestamp
	return v4
end

local function isTaskLoading(task): boolean -- 1 equivalent call inferred from this helper
	return task.status == subagentTaskStatus.InProgress
end

local function getTaskStatusPriority(status) -- 4 equivalent calls inferred from this helper
	if status == nil then
		return 6
	end

	return v3[status] or 6
end

local function sortTasksByStatus(p)
	local clone = table.clone(p)
	table.sort(clone, function(a, b): boolean
		return getTaskStatusPriority(a.status) < getTaskStatusPriority(b.status) -- inferred equivalent call
	end)

	return clone
end

local function appendTasksFromPayload(p, list)
	local tasks

	if typeof(p) == "table" then
		tasks = p.tasks
	end

	if typeof(tasks) ~= "table" then
		return
	end

	for _, task in tasks do
		local v4 = toTaskItem(task)

		if v4 ~= nil then
			table.insert(list, v4)
		end
	end
end

local function appendTasksFromMaybeJson(rawInput, p)
	if typeof(rawInput) == "table" then
		appendTasksFromPayload(rawInput, p)
	elseif typeof(rawInput) == "string" then
		local success, result = pcall(function()
			return HttpService:JSONDecode(rawInput)
		end)

		if not success then
			return
		end

		local text

		if typeof(result) == "table" then
			text = result.text
		else
			text = nil
		end

		if typeof(text) == "string" then
			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(text)
			end)

			if success2 then
				appendTasksFromPayload(result2, p)
			end
		end

		appendTasksFromPayload(result, p)
	end
end

local function extractTasksFromToolCall(data) -- 1 equivalent call inferred from this helper
	local v4 = valueLooksLikeToolName(data.kind) -- inferred equivalent call
	local v5

	if v4 then
		v5 = true
	elseif valueLooksLikeToolName(data.title) then -- inferred equivalent call
		v5 = true
	else
		local rawInput = data.rawInput

		if typeof(rawInput) == "table" then
			v5 = valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
		else
			v5 = false
		end
	end

	if not v5 then
		return nil
	end

	local v6 = {}
	appendTasksFromMaybeJson(data.rawInput, v6)
	return if #v6 > 0 then v6 else nil
end

local function orderedManageTasksToolCalls(p)
	local result = {}
	local toolCallIdSet = {}

	for _, activityItem in p.activityItems do
		if activityItem.kind ~= "tool_call" then
			continue
		end

		local toolCall = p.toolCalls[activityItem.toolCallId]

		if toolCall == nil then
			continue
		end

		local v4 = valueLooksLikeToolName(toolCall.kind) -- inferred equivalent call
		local v5

		if v4 then
			v5 = true
		elseif valueLooksLikeToolName(toolCall.title) then -- inferred equivalent call
			v5 = true
		else
			local rawInput = toolCall.rawInput

			if typeof(rawInput) == "table" then
				v5 = valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
			else
				v5 = false
			end
		end

		if not v5 then
			continue
		end

		table.insert(result, toolCall)
		toolCallIdSet[toolCall.toolCallId] = true
	end

	local v4 = {}

	for k, toolCall in p.toolCalls do
		if toolCallIdSet[k] then
			continue
		end

		local v5 = valueLooksLikeToolName(toolCall.kind) -- inferred equivalent call
		local v6

		if v5 then
			v6 = true
		elseif valueLooksLikeToolName(toolCall.title) then -- inferred equivalent call
			v6 = true
		else
			local rawInput = toolCall.rawInput

			if typeof(rawInput) == "table" then
				v6 = valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
			else
				v6 = false
			end
		end

		if v6 then
			table.insert(v4, k)
		end
	end

	table.sort(v4)

	for _, v5 in v4 do
		table.insert(result, p.toolCalls[v5])
	end

	return result
end

local function taskKey(item) -- 2 equivalent calls inferred from this helper
	return `{item.category}:{item.text}`
end

local function applyTasks(items, list, p)
	for _, item in items do
		local v4 = taskKey(item) -- inferred equivalent call

		if p[v4] == nil then
			table.insert(list, item)
		end

		p[v4] = item
	end
end

local function groupTasks(items)
	local v4 = {}
	local result = {}

	for _, item in items do
		local v5 = v4[item.category]

		if v5 == nil then
			v5 = { name = item.category, tasks = {}, isComplete = true, isLoading = false }

			v4[item.category] = v5
			table.insert(result, v5)
		end

		table.insert(v5.tasks, item)

		if item.status ~= subagentTaskStatus.Done then
			v5.isComplete = false
		end
	end

	for _, v5 in result do
		local tasks = v5.tasks
		local clone = table.clone(tasks)
		table.sort(clone, function(a, b): boolean
			return getTaskStatusPriority(a.status) < getTaskStatusPriority(b.status) -- inferred equivalent call
		end)

		v5.tasks = clone
		v5.isLoading = false

		for _, task in v5.tasks do
			if isTaskLoading(task) then -- inferred equivalent call
				v5.isLoading = true
				break
			end
		end
	end

	return result
end

local function toTaskState(list, p)
	if #list == 0 then
		return nil
	end

	local v4 = {}

	for _, item in list do
		table.insert(v4, p[taskKey(item)]) -- inferred equivalent call
	end

	local groups = groupTasks(v4)
	local allComplete = #groups > 0

	for _, v5 in groups do
		if not v5.isComplete then
			allComplete = false
			break
		end
	end

	return { groups = groups, allComplete = allComplete }
end

local SubagentTasks = {}
SubagentTasks.TOOL_NAME = "manage_tasks"
SubagentTasks.extractTasksFromToolCall = extractTasksFromToolCall

function SubagentTasks.fromTasks(items)
	if typeof(items) ~= "table" then
		return nil
	end

	local v4 = {}
	local v5 = {}
	local v6 = {}

	for _, item in items do
		local v7 = toTaskItem(item)

		if v7 ~= nil then
			table.insert(v4, v7)
		end
	end

	applyTasks(v4, v5, v6)
	return toTaskState(v5, v6)
end

function SubagentTasks.fromTurnState(p)
	local v4 = {}
	local v5 = {}

	for _, v6 in orderedManageTasksToolCalls(p) do
		local tasksFromToolCall = extractTasksFromToolCall(v6) -- inferred equivalent call

		if tasksFromToolCall ~= nil then
			applyTasks(tasksFromToolCall, v4, v5)
		end
	end

	return toTaskState(v4, v5)
end

function SubagentTasks.isTaskComplete(p): boolean
	return p.status == subagentTaskStatus.Done
end

SubagentTasks.isTaskLoading = isTaskLoading
return SubagentTasks
