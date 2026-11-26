require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local StudioAskUserTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioAskUserTool")
local StudioProposePlanTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioProposePlanTool")
local SubagentTasks = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/SubagentTasks")

return {
	getAskItemKey = function(p2, p3)
		return `ask-{p2.toolCallId or p2.question.id}-{p2.question.id}-{p3}`
	end,
	getPlanItemKey = function(p2)
		return `plan-{p2.toolCallId or p2.title}`
	end,
	getSubagentTasksItemKey = function(): string
		return "subagent-tasks"
	end,
	getSubagentTasksCallOrder = function(p2)
		for k, activityItem in p2.activityItems do
			if activityItem.kind == "tool_call" and activityItem.title == SubagentTasks.TOOL_NAME then
				return k
			end
		end

		return 0
	end,
	sortClientToolItems = function(list)
		table.sort(list, function(a, b): boolean
			if a.callOrder == b.callOrder then
				return a.key < b.key
			end

			return a.callOrder < b.callOrder
		end)

		return list
	end,
	makeAskItem = function(data, p2, p3, onAnswerSelected)
		local askItem = {
			kind = "ask_user",
			key = `ask-{data.toolCallId or data.question.id}-{data.question.id}-{p2}`,
			toolCallId = data.toolCallId,
			callOrder = (data.callOrder or p2) * 1000 + p2,
			isActive = p3,
			answerStackPrompt = data,
			onAnswerSelected = 0
		}

		if not p3 then
			onAnswerSelected = nil
		end

		askItem.onAnswerSelected = onAnswerSelected
		return askItem
	end,
	makePlanItem = function(data, p2, onPlanAccepted)
		local planItem = {
			kind = "plan",
			key = `plan-{data.toolCallId or data.title}`,
			toolCallId = data.toolCallId,
			callOrder = (data.callOrder or 0) * 1000,
			isActive = p2,
			planProposal = data,
			onPlanAccepted = 0
		}

		if not p2 then
			onPlanAccepted = nil
		end

		planItem.onPlanAccepted = onPlanAccepted
		return planItem
	end,
	makeSubagentTasksItem = function(p2, p3, p4)
		return {
			kind = "subagent_tasks",
			key = "subagent-tasks",
			toolCallId = nil,
			callOrder = p3 * 1000,
			isActive = p4,
			subagentTaskState = p2
		}
	end,
	getCompletedItemsFromTurnState = function(p2)
		local completedItems = {}

		for k, v5 in StudioAskUserTool.getAnsweredPromptsFromTurnState(p2) do
			table.insert(completedItems, {
				kind = "ask_user",
				key = `ask-{v5.toolCallId or v5.question.id}-{v5.question.id}-{k}`,
				toolCallId = v5.toolCallId,
				callOrder = (v5.callOrder or k) * 1000 + k,
				isActive = false,
				answerStackPrompt = v5,
				onAnswerSelected = nil
			})
		end

		for k, v5 in StudioProposePlanTool.getCompletedPlansFromTurnState(p2) do
			table.insert(completedItems, {
				kind = "plan",
				key = `plan-{v5.toolCallId or v5.title}`,
				toolCallId = v5.toolCallId,
				callOrder = (v5.callOrder or 0) * 1000,
				isActive = false,
				planProposal = v5,
				onPlanAccepted = nil
			})
		end

		local v5 = SubagentTasks.fromTurnState(p2)

		if v5 ~= nil then
			local v6 = nil
			local flag = true

			for k, activityItem in p2.activityItems do
				if activityItem.kind == "tool_call" and activityItem.title == SubagentTasks.TOOL_NAME then
					v6 = k
					flag = false
					break
				end
			end

			if flag then
				v6 = 0
			end

			table.insert(completedItems, {
				kind = "subagent_tasks",
				key = "subagent-tasks",
				toolCallId = nil,
				callOrder = v6 * 1000,
				isActive = false,
				subagentTaskState = v5
			})
		end

		table.sort(completedItems, function(a, b): boolean
			if a.callOrder == b.callOrder then
				return a.key < b.key
			end

			return a.callOrder < b.callOrder
		end)

		return completedItems
	end
}
