local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local function createLocalToolOverlay()
	local signal, v5 = Signals.createSignal({
		submittedToolCallIds = {},
		askUserByToolCallId = {},
		planByToolCallId = {},
		devProductByToolCallId = {}
	})

	local signal2, v6 = Signals.createSignal({
		onAnswerSelectedByToolCallId = {},
		onAnswerConfirmedByToolCallId = {},
		onPlanAcceptedByToolCallId = {},
		onDevProductApprovedByToolCallId = {},
		onDevProductRejectedByToolCallId = {}
	})

	local function updateOptimistic(fn)
		local v7 = signal(false)
		local v8 = {
			submittedToolCallIds = table.clone(v7.submittedToolCallIds),
			askUserByToolCallId = table.clone(v7.askUserByToolCallId),
			planByToolCallId = table.clone(v7.planByToolCallId),
			devProductByToolCallId = table.clone(v7.devProductByToolCallId)
		}

		fn(v8)
		v5(v8)
	end

	local function updateActions(fn)
		local v7 = signal2(false)
		local v8 = {
			onAnswerSelectedByToolCallId = table.clone(v7.onAnswerSelectedByToolCallId),
			onAnswerConfirmedByToolCallId = table.clone(v7.onAnswerConfirmedByToolCallId),
			onPlanAcceptedByToolCallId = table.clone(v7.onPlanAcceptedByToolCallId),
			onDevProductApprovedByToolCallId = table.clone(v7.onDevProductApprovedByToolCallId),
			onDevProductRejectedByToolCallId = table.clone(v7.onDevProductRejectedByToolCallId)
		}

		fn(v8)
		v6(v8)
	end

	return {
		getOptimisticLocalTools = signal,
		getLocalToolActions = signal2,
		markSubmitted = function(p2)
			updateOptimistic(function(p3)
				p3.submittedToolCallIds[p2] = true
			end)
		end,
		clearSubmitted = function(p2)
			updateOptimistic(function(p3)
				p3.submittedToolCallIds[p2] = nil
			end)
		end,
		setAskUserTool = function(p2)
			updateOptimistic(function(p3)
				p3.askUserByToolCallId[p2.toolCallId] = p2
			end)
		end,
		removeAskUserTool = function(p2)
			updateOptimistic(function(p3)
				p3.askUserByToolCallId[p2] = nil
			end)
		end,
		setPlanTool = function(p2)
			updateOptimistic(function(p3)
				p3.planByToolCallId[p2.toolCallId] = p2
			end)
		end,
		removePlanTool = function(p2)
			updateOptimistic(function(p3)
				p3.planByToolCallId[p2] = nil
			end)
		end,
		setAnswerAction = function(p2, p3, p4)
			updateActions(function(p5)
				p5.onAnswerSelectedByToolCallId[p2] = p3

				if p4 == nil then
					p5.onAnswerConfirmedByToolCallId[p2] = nil
				else
					p5.onAnswerConfirmedByToolCallId[p2] = p4
				end
			end)
		end,
		removeAnswerAction = function(p2)
			updateActions(function(p3)
				p3.onAnswerSelectedByToolCallId[p2] = nil
				p3.onAnswerConfirmedByToolCallId[p2] = nil
			end)
		end,
		setPlanAction = function(p2, p3)
			updateActions(function(p4)
				p4.onPlanAcceptedByToolCallId[p2] = p3
			end)
		end,
		removePlanAction = function(p2)
			updateActions(function(p3)
				p3.onPlanAcceptedByToolCallId[p2] = nil
			end)
		end,
		setDevProductTool = function(p2)
			updateOptimistic(function(p3)
				p3.devProductByToolCallId[p2.toolCallId] = p2
			end)
		end,
		removeDevProductTool = function(p2)
			updateOptimistic(function(p3)
				p3.devProductByToolCallId[p2] = nil
			end)
		end,
		setDevProductAction = function(p2, p3, p4)
			updateActions(function(p5)
				p5.onDevProductApprovedByToolCallId[p2] = p3
				p5.onDevProductRejectedByToolCallId[p2] = p4
			end)
		end,
		removeDevProductAction = function(p2)
			updateActions(function(p3)
				p3.onDevProductApprovedByToolCallId[p2] = nil
				p3.onDevProductRejectedByToolCallId[p2] = nil
			end)
		end
	}
end

return createLocalToolOverlay
