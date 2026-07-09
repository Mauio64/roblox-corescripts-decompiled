local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)

require(script.Parent.chatTypes)

local function createLocalToolOverlay() -- line: 35
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal({
		submittedToolCallIds = {},
		askUserByToolCallId = {},
		planByToolCallId = {}
	})
	local v6, v7 = Signals.createSignal({
		onAnswerSelectedByToolCallId = {},
		onPlanAcceptedByToolCallId = {}
	})

	local function updateOptimistic(p1: ((...any) -> ...any)) -- line: 46
		-- upvalues: v4 (copy), v5 (copy)
		local v11 = v4(false)
		local t1 = {
			submittedToolCallIds = table.clone(v11.submittedToolCallIds),
			askUserByToolCallId = table.clone(v11.askUserByToolCallId),
			planByToolCallId = table.clone(v11.planByToolCallId)
		}

		p1(t1)
		v5(t1)
	end
	local function updateActions(p2: ((...any) -> ...any)) -- line: 57
		-- upvalues: v6 (copy), v7 (copy)
		local v14 = v6(false)
		local t2 = {
			onAnswerSelectedByToolCallId = table.clone(v14.onAnswerSelectedByToolCallId),
			onPlanAcceptedByToolCallId = table.clone(v14.onPlanAcceptedByToolCallId)
		}

		p2(t2)
		v7(t2)
	end

	return {
		getOptimisticLocalTools = v4,
		getLocalToolActions = v6,
		markSubmitted = function(p3) -- line: 70
			-- upvalues: updateOptimistic (copy)
			updateOptimistic(function(p4) -- line: 71
				-- upvalues: p3 (copy)
				p4.submittedToolCallIds[p3] = true
			end)
		end,
		setAskUserTool = function(p5) -- line: 75
			-- upvalues: updateOptimistic (copy)
			updateOptimistic(function(p6) -- line: 76
				-- upvalues: p5 (copy)
				p6.askUserByToolCallId[p5.toolCallId] = p5
			end)
		end,
		removeAskUserTool = function(p7) -- line: 80
			-- upvalues: updateOptimistic (copy)
			updateOptimistic(function(p8) -- line: 81
				-- upvalues: p7 (copy)
				p8.askUserByToolCallId[p7] = nil
			end)
		end,
		setPlanTool = function(p9) -- line: 85
			-- upvalues: updateOptimistic (copy)
			updateOptimistic(function(p10) -- line: 86
				-- upvalues: p9 (copy)
				p10.planByToolCallId[p9.toolCallId] = p9
			end)
		end,
		removePlanTool = function(p11) -- line: 90
			-- upvalues: updateOptimistic (copy)
			updateOptimistic(function(p12) -- line: 91
				-- upvalues: p11 (copy)
				p12.planByToolCallId[p11] = nil
			end)
		end,
		setAnswerAction = function(p13, p14) -- line: 95
			-- upvalues: updateActions (copy)
			updateActions(function(p15) -- line: 96
				-- upvalues: p13 (copy), p14 (copy)
				p15.onAnswerSelectedByToolCallId[p13] = p14
			end)
		end,
		removeAnswerAction = function(p16) -- line: 100
			-- upvalues: updateActions (copy)
			updateActions(function(p17) -- line: 101
				-- upvalues: p16 (copy)
				p17.onAnswerSelectedByToolCallId[p16] = nil
			end)
		end,
		setPlanAction = function(p18, p19) -- line: 105
			-- upvalues: updateActions (copy)
			updateActions(function(p20) -- line: 106
				-- upvalues: p18 (copy), p19 (copy)
				p20.onPlanAcceptedByToolCallId[p18] = p19
			end)
		end,
		removePlanAction = function(p21) -- line: 110
			-- upvalues: updateActions (copy)
			updateActions(function(p22) -- line: 111
				-- upvalues: p21 (copy)
				p22.onPlanAcceptedByToolCallId[p21] = nil
			end)
		end
	}
end

return createLocalToolOverlay
