local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

require(script.Parent.chatTypes)

local function createLocalToolOverlay()
	local signal, v = Signals.createSignal({
		submittedToolCallIds = {},
		askUserByToolCallId = {},
		planByToolCallId = {},
		devProductByToolCallId = {}
	})

	local signal2, v2 = Signals.createSignal({
		onAnswerSelectedByToolCallId = {},
		onAnswerConfirmedByToolCallId = {},
		onPlanAcceptedByToolCallId = {},
		onDevProductApprovedByToolCallId = {},
		onDevProductRejectedByToolCallId = {}
	})

	local function updateOptimistic(fn)
		local v3 = signal(false)
		local v4 = {
			submittedToolCallIds = table.clone(v3.submittedToolCallIds),
			askUserByToolCallId = table.clone(v3.askUserByToolCallId),
			planByToolCallId = table.clone(v3.planByToolCallId),
			devProductByToolCallId = table.clone(v3.devProductByToolCallId)
		}

		fn(v4)
		v(v4)
	end

	local function updateActions(fn)
		local v3 = signal2(false)
		local v4 = {
			onAnswerSelectedByToolCallId = table.clone(v3.onAnswerSelectedByToolCallId),
			onAnswerConfirmedByToolCallId = table.clone(v3.onAnswerConfirmedByToolCallId),
			onPlanAcceptedByToolCallId = table.clone(v3.onPlanAcceptedByToolCallId),
			onDevProductApprovedByToolCallId = table.clone(v3.onDevProductApprovedByToolCallId),
			onDevProductRejectedByToolCallId = table.clone(v3.onDevProductRejectedByToolCallId)
		}

		fn(v4)
		v2(v4)
	end

	return {
		getOptimisticLocalTools = signal,
		getLocalToolActions = signal2,
		markSubmitted = function(p)
			updateOptimistic(function(p2)
				p2.submittedToolCallIds[p] = true
			end)
		end,
		clearSubmitted = function(p)
			updateOptimistic(function(p2)
				p2.submittedToolCallIds[p] = nil
			end)
		end,
		setAskUserTool = function(p)
			updateOptimistic(function(p2)
				p2.askUserByToolCallId[p.toolCallId] = p
			end)
		end,
		removeAskUserTool = function(p)
			updateOptimistic(function(p2)
				p2.askUserByToolCallId[p] = nil
			end)
		end,
		setPlanTool = function(p)
			updateOptimistic(function(p2)
				p2.planByToolCallId[p.toolCallId] = p
			end)
		end,
		removePlanTool = function(p)
			updateOptimistic(function(p2)
				p2.planByToolCallId[p] = nil
			end)
		end,
		setAnswerAction = function(p, p2, p3)
			updateActions(function(p4)
				p4.onAnswerSelectedByToolCallId[p] = p2

				if p3 == nil then
					p4.onAnswerConfirmedByToolCallId[p] = nil
				else
					p4.onAnswerConfirmedByToolCallId[p] = p3
				end
			end)
		end,
		removeAnswerAction = function(p)
			updateActions(function(p2)
				p2.onAnswerSelectedByToolCallId[p] = nil
				p2.onAnswerConfirmedByToolCallId[p] = nil
			end)
		end,
		setPlanAction = function(p, p2)
			updateActions(function(p3)
				p3.onPlanAcceptedByToolCallId[p] = p2
			end)
		end,
		removePlanAction = function(p)
			updateActions(function(p2)
				p2.onPlanAcceptedByToolCallId[p] = nil
			end)
		end,
		setDevProductTool = function(p)
			updateOptimistic(function(p2)
				p2.devProductByToolCallId[p.toolCallId] = p
			end)
		end,
		removeDevProductTool = function(p)
			updateOptimistic(function(p2)
				p2.devProductByToolCallId[p] = nil
			end)
		end,
		setDevProductAction = function(p, p2, p3)
			updateActions(function(p4)
				p4.onDevProductApprovedByToolCallId[p] = p2
				p4.onDevProductRejectedByToolCallId[p] = p3
			end)
		end,
		removeDevProductAction = function(p)
			updateActions(function(p2)
				p2.onDevProductApprovedByToolCallId[p] = nil
				p2.onDevProductRejectedByToolCallId[p] = nil
			end)
		end
	}
end

return createLocalToolOverlay
