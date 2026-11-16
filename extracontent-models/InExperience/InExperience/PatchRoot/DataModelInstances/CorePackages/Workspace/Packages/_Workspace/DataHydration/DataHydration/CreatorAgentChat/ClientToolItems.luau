require(script.Parent.types)
local StudioAskUserTool = require(script.Parent.StudioAskUserTool)
local StudioProposePlanTool = require(script.Parent.StudioProposePlanTool)
local SubagentTasks = require(script.Parent.SubagentTasks)

local function getAskItemKey(p, p2: number) -- 2 equivalent calls inferred from this helper
	return `ask-{p.toolCallId or p.question.id}-{p.question.id}-{p2}`
end

local function getPlanItemKey(p) -- 2 equivalent calls inferred from this helper
	return `plan-{p.toolCallId or p.title}`
end

local function getSubagentTasksCallOrder(p) -- 1 equivalent call inferred from this helper
	for k, activityItem in p.activityItems do
		if activityItem.kind == "tool_call" and activityItem.title == SubagentTasks.TOOL_NAME then
			return k
		end
	end

	return 0
end

local function makeSubagentTasksItem(subagentTaskState, p: number, isActive: boolean) -- 1 equivalent call inferred from this helper
	return {
		kind = "subagent_tasks",
		key = "subagent-tasks",
		toolCallId = nil,
		callOrder = p * 1000,
		isActive = isActive,
		subagentTaskState = subagentTaskState
	}
end

local ClientToolItems = {}
ClientToolItems.getAskItemKey = getAskItemKey
ClientToolItems.getPlanItemKey = getPlanItemKey

function ClientToolItems.getSubagentTasksItemKey(): string
	return "subagent-tasks"
end

ClientToolItems.getSubagentTasksCallOrder = getSubagentTasksCallOrder

function ClientToolItems.sortClientToolItems(list)
	table.sort(list, function(a, b): boolean
		if a.callOrder == b.callOrder then
			return a.key < b.key
		end

		return a.callOrder < b.callOrder
	end)

	return list
end

function ClientToolItems.makeAskItem(answerStackPrompt, p: number, isActive: boolean, onAnswerSelected)
	local askItem = {
		kind = "ask_user",
		key = getAskItemKey(answerStackPrompt, p), -- inferred equivalent call
		toolCallId = answerStackPrompt.toolCallId,
		callOrder = (answerStackPrompt.callOrder or p) * 1000 + p,
		isActive = isActive,
		answerStackPrompt = answerStackPrompt,
		onAnswerSelected = 0
	}

	if not isActive then
		onAnswerSelected = nil
	end

	askItem.onAnswerSelected = onAnswerSelected
	return askItem
end

function ClientToolItems.makePlanItem(planProposal, isActive: boolean, onPlanAccepted)
	local planItem = {
		kind = "plan",
		key = getPlanItemKey(planProposal), -- inferred equivalent call
		toolCallId = planProposal.toolCallId,
		callOrder = (planProposal.callOrder or 0) * 1000,
		isActive = isActive,
		planProposal = planProposal,
		onPlanAccepted = 0
	}

	if not isActive then
		onPlanAccepted = nil
	end

	planItem.onPlanAccepted = onPlanAccepted
	return planItem
end

ClientToolItems.makeSubagentTasksItem = makeSubagentTasksItem

function ClientToolItems.getCompletedItemsFromTurnState(p)
	local completedItems = {}

	for k, answerStackPrompt in StudioAskUserTool.getAnsweredPromptsFromTurnState(p) do
		table.insert(completedItems, {
			kind = "ask_user",
			key = getAskItemKey(answerStackPrompt, k), -- inferred equivalent call
			toolCallId = answerStackPrompt.toolCallId,
			callOrder = (answerStackPrompt.callOrder or k) * 1000 + k,
			isActive = false,
			answerStackPrompt = answerStackPrompt,
			onAnswerSelected = nil
		})
	end

	for _, planProposal in StudioProposePlanTool.getCompletedPlansFromTurnState(p) do
		table.insert(completedItems, {
			kind = "plan",
			key = getPlanItemKey(planProposal), -- inferred equivalent call
			toolCallId = planProposal.toolCallId,
			callOrder = (planProposal.callOrder or 0) * 1000,
			isActive = false,
			planProposal = planProposal,
			onPlanAccepted = nil
		})
	end

	local subagentTaskState = SubagentTasks.fromTurnState(p)

	if subagentTaskState ~= nil then
		table.insert(completedItems, makeSubagentTasksItem(subagentTaskState, getSubagentTasksCallOrder(p), false)) -- inferred equivalent call
	end

	table.sort(completedItems, function(a, b): boolean
		if a.callOrder == b.callOrder then
			return a.key < b.key
		end

		return a.callOrder < b.callOrder
	end)

	return completedItems
end

return ClientToolItems
