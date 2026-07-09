require(script.Parent.types)

local StudioAskUserTool = require(script.Parent.StudioAskUserTool)
local StudioProposePlanTool = require(script.Parent.StudioProposePlanTool)
local SubagentTasks = require(script.Parent.SubagentTasks)

return {
	getAskItemKey = function(p1, n1: number) -- line: 14
		return `ask-{ p1.toolCallId or p1.question.id }-{ p1.question.id }-{ n1 }`
	end,
	getPlanItemKey = function(p2) -- line: 18
		return `plan-{ p2.toolCallId or p2.title }`
	end,
	getSubagentTasksItemKey = function() -- line: 22
		return "subagent-tasks"
	end,
	getSubagentTasksCallOrder = function(p3) -- line: 26
		-- upvalues: SubagentTasks (copy)
		for v8, v9 in p3.activityItems do
			if v9.kind == "tool_call" and v9.title == SubagentTasks.TOOL_NAME then
				return v8
			end
		end

		return 0
	end,
	sortClientToolItems = function(t1: {[any]: any}) -- line: 35
		table.sort(t1, function(p4, p5) -- line: 36
			if p4.callOrder == p5.callOrder then
				return p4.key < p5.key
			end

			return p4.callOrder < p5.callOrder
		end)

		return t1
	end,
	makeAskItem = function(p6, n2: number, b1: boolean, p7: ((...any) -> ...any)?) -- line: 45
		return {
			kind = "ask_user",
			key = `ask-{ p6.toolCallId or p6.question.id }-{ p6.question.id }-{ n2 }`,
			toolCallId = p6.toolCallId,
			callOrder = (p6.callOrder or n2) * 1000 + n2,
			isActive = b1,
			answerStackPrompt = p6,
			onAnswerSelected = if not b1 then nil else p7
		}
	end,
	makePlanItem = function(p8, b2: boolean, p9: ((...any) -> ...any)?) -- line: 62
		return {
			kind = "plan",
			key = `plan-{ p8.toolCallId or p8.title }`,
			toolCallId = p8.toolCallId,
			callOrder = (p8.callOrder or 0) * 1000,
			isActive = b2,
			planProposal = p8,
			onPlanAccepted = if not b2 then nil else p9
		}
	end,
	makeSubagentTasksItem = function(p10, n3: number, b3: boolean) -- line: 74
		return {
			kind = "subagent_tasks",
			toolCallId = nil,
			key = "subagent-tasks",
			callOrder = n3 * 1000,
			isActive = b3,
			subagentTaskState = p10
		}
	end,
	getCompletedItemsFromTurnState = function(p11) -- line: 85
		-- upvalues: StudioAskUserTool (copy), StudioProposePlanTool (copy), SubagentTasks (copy)
		local t2 = {}
		local g31 = nil
		local v30 = nil

		for v23, v24 in StudioAskUserTool.getAnsweredPromptsFromTurnState(p11) do
			table.insert(t2, {
				kind = "ask_user",
				isActive = false,
				onAnswerSelected = nil,
				key = `ask-{ v24.toolCallId or v24.question.id }-{ v24.question.id }-{ v23 }`,
				toolCallId = v24.toolCallId,
				callOrder = (v24.callOrder or v23) * 1000 + v23,
				answerStackPrompt = v24
			})
		end

		for _, v26 in StudioProposePlanTool.getCompletedPlansFromTurnState(p11) do
			table.insert(t2, {
				kind = "plan",
				isActive = false,
				onPlanAccepted = nil,
				key = `plan-{ v26.toolCallId or v26.title }`,
				toolCallId = v26.toolCallId,
				callOrder = (v26.callOrder or 0) * 1000,
				planProposal = v26
			})
		end

		local v27 = SubagentTasks.fromTurnState(p11)

		if v27 ~= nil then
			for v28, v29 in p11.activityItems do
				if v29.kind == "tool_call" and v29.title == SubagentTasks.TOOL_NAME then
					v30 = v28
					g31 = true
				end

				if g31 then
					break
				end
			end

			if not g31 then
				v30 = 0
			end

			g31 = false
			table.insert(t2, {
				kind = "subagent_tasks",
				toolCallId = nil,
				isActive = false,
				key = "subagent-tasks",
				callOrder = v30 * 1000,
				subagentTaskState = v27
			})
		end

		table.sort(t2, function(p12, p13) -- line: 36
			if p12.callOrder == p13.callOrder then
				return p12.key < p13.key
			end

			return p12.callOrder < p13.callOrder
		end)

		return t2
	end
}
