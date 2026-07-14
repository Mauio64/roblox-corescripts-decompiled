local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Markdown = require(BuildExperienceParent.Markdown)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)

require(BuildExperience.Chat.chatTypes)

local turnProjection = require(BuildExperience.Chat.turnProjection)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local reportTurnActivityGap = require(BuildExperience.Telemetry.reportTurnActivityGap)
local getMarkdownRendererProps = require(BuildExperience.utils.getMarkdownRendererProps)
local AgentPlanCard = require(BuildExperience.Components.AgentCard.AgentPlanCard)
local AnswerStack = require(BuildExperience.Components.AnswerStack.AnswerStack)
local OptionSelector = require(BuildExperience.Components.AnswerStack.OptionSelector)
local AgentTurnFeedback = require(script.Parent.AgentTurnFeedback)
local ChatUserMessage = require(script.Parent.ChatUserMessage)
local PlaytestCompletedCard = require(script.Parent.PlaytestCompletedCard)
local TurnActivitySummary = require(script.Parent.TurnActivitySummary)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local MarkdownViewer = Markdown.Components.MarkdownViewer
local t1 = {}
local t2 = {
	onAnswerSelectedByToolCallId = {},
	onAnswerConfirmedByToolCallId = {},
	onPlanAcceptedByToolCallId = {}
}

local function constantSource() -- line: 78
	return 0
end
local function useReactiveValue(p1) -- line: 82
	-- upvalues: React (copy), constantSource (copy), SignalsReact (copy)
	local v38 = React.useCallback(function(p2) -- line: 83
		-- upvalues: p1 (copy), constantSource (copy)
		if typeof(p1) == "function" then
			return (p1(p2))
		end

		if typeof(p2) == "function" then
			p2(constantSource)
		end

		return p1
	end, { p1 })

	return (SignalsReact.useSignalState(v38))
end
local function hasSelectedOptions(p3) -- line: 96
	if typeof(p3) == "string" then
		return true
	end

	if typeof(p3) ~= "table" then
		return false
	end

	return #p3 > 0
end
local function AnswerStackSection(t3: {[any]: any}) -- line: 106
	-- upvalues: React (copy), View (copy), FoundationText (copy), OptionSelector (copy), AnswerStack (copy)
	local prompt = t3.prompt
	local question = prompt.question
	local customResponseText = prompt.customResponseText
	local v44 = t3.isActive == true
	local v45 = question.responseType == "multi_select"
	local v46 = prompt.isLastQuestion ~= false and "Submit" or "Next"
	local createElement = React.createElement
	local v48 = View
	local t4 = {
		tag = "col gap-xsmall size-full-0 auto-y padding-top-small",
		LayoutOrder = t3.LayoutOrder,
		testId = `ChatTurnBlock.AnswerStack.{ question.id }`
	}
	local t5 = {
		Question = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
			Text = question.question
		})
	}
	local v51

	if customResponseText ~= nil then
		v51 = React.createElement(OptionSelector, {
			LayoutOrder = 2,
			title = "Custom Answer",
			isSelected = true,
			description = customResponseText,
			testId = `AnswerStack.{ question.id }.CustomAnswer`,
			onActivated = function() -- line: 131
			end
		})
	elseif #question.options > 0 then
		local createElement2 = React.createElement
		local v53 = AnswerStack
		local t6 = {
			LayoutOrder = 2,
			options = question.options,
			selectedOptionId = prompt.selectedOptionId,
			selectionMode = not v45 and "single" or "multi",
			confirmLabel = v46
		}
		local selectedOptionId = prompt.selectedOptionId

		t6.isConfirmDisabled = not (typeof(selectedOptionId) == "string" or typeof(selectedOptionId) == "table" and #selectedOptionId > 0)
		t6.onConfirm = if not v45 or not v44 then nil else t3.onAnswerConfirmed
		t6.testId = `AnswerStack.{ question.id }`

		function t6.onOptionSelected(p4) -- line: 142
			-- upvalues: t3 (copy), v45 (copy), v44 (copy), question (copy), prompt (copy)
			if t3.onAnswerSelected == nil then
				return
			end

			if v45 then
				if v44 then
					t3.onAnswerSelected(question, p4)
				end

				return
			end

			if prompt.selectedOptionId == nil then
				t3.onAnswerSelected(question, p4)
			end
		end

		v51 = createElement2(v53, t6)
	else
		v51 = nil
	end

	t5.Answers = v51

	return createElement(v48, t4, t5)
end
local function PlanProposalSection(t7: {[any]: any}) -- line: 161
	-- upvalues: React (copy), AgentPlanCard (copy), View (copy), ChatUserMessage (copy)
	local planProposal = t7.planProposal
	local v58 = planProposal.isAccepted ~= true and planProposal.feedbackText == nil
	local v59 = React.createElement(AgentPlanCard, {
		layoutOrder = 1,
		testId = "ChatTurnBlock.PlanProposal",
		title = planProposal.title,
		textContent = planProposal.textContent,
		summary = planProposal.summary,
		onBuild = t7.onPlanAccepted or function() -- line: 169
		end,
		isBuildDisabled = not v58
	})

	if planProposal.feedbackText == nil then
		return React.createElement(View, {
			tag = "col gap-xsmall size-full-0 auto-y",
			LayoutOrder = t7.LayoutOrder
		}, {
			Plan = v59
		})
	end

	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		LayoutOrder = t7.LayoutOrder
	}, {
		Plan = v59,
		Feedback = React.createElement(ChatUserMessage, {
			LayoutOrder = 2,
			message = {
				kind = "user_message",
				text = planProposal.feedbackText
			}
		})
	})
end
local function AgentMessageSegment(t8: {[any]: any}) -- line: 198
	-- upvalues: useReactiveValue (copy), Foundation (copy), React (copy), getMarkdownRendererProps (copy), MarkdownViewer (copy)
	local v61 = useReactiveValue(t8.segment.text)
	local v62 = Foundation.Hooks.useTokens()
	local v63 = React.useMemo(function() -- line: 201
		-- upvalues: getMarkdownRendererProps (copy), v62 (copy), t8 (copy)
		return getMarkdownRendererProps(v62, t8.markdownTextStyle)
	end, {
		v62,
		t8.markdownTextStyle
	})

	if v61 == "" then
		return nil
	end

	return React.createElement(MarkdownViewer, {
		Markdown = v61,
		WrapperProps = {
			tag = "size-full-0 auto-y text-body-medium content-emphasis",
			LayoutOrder = t8.LayoutOrder
		},
		MarkdownRendererProps = v63
	})
end
local function renderClientToolSegment(p5, n1: number, p6) -- line: 221
	-- upvalues: React (copy), AnswerStackSection (copy), PlanProposalSection (copy)
	if p5.answerStackPrompt ~= nil then
		return React.createElement(AnswerStackSection, {
			LayoutOrder = n1,
			prompt = p5.answerStackPrompt,
			isActive = p5.isActive,
			onAnswerSelected = if not p5.isActive then nil else p6.onAnswerSelectedByToolCallId[p5.toolCallId],
			onAnswerConfirmed = if not p5.isActive then nil else p6.onAnswerConfirmedByToolCallId[p5.toolCallId]
		})
	end

	if p5.planProposal ~= nil then
		return React.createElement(PlanProposalSection, {
			LayoutOrder = n1,
			planProposal = p5.planProposal,
			onPlanAccepted = if not p5.isActive then nil else p6.onPlanAcceptedByToolCallId[p5.toolCallId]
		})
	end

	return nil
end
local function renderWorkSegment(p7, n2: number, p8, p9, p10) -- line: 251
	-- upvalues: React (copy), AgentMessageSegment (copy), TurnActivitySummary (copy), renderClientToolSegment (copy)
	if p7.kind == "agent_message" then
		return React.createElement(AgentMessageSegment, {
			LayoutOrder = n2,
			segment = p7,
			markdownTextStyle = p8
		})
	end

	if p7.kind == "activity_summary" then
		return React.createElement(TurnActivitySummary, {
			LayoutOrder = n2,
			segment = p7,
			clockBinding = p9
		})
	end

	if p7.kind == "client_tool" then
		return renderClientToolSegment(p7, n2, p10)
	end

	return nil
end
local function TurnWorkSegment(t9: {[any]: any}) -- line: 277
	-- upvalues: useReactiveValue (copy), React (copy), Foundation (copy), renderWorkSegment (copy), View (copy), StateLayerAffordance (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local v73 = useReactiveValue(t9.segment.label)
	local v74 = useReactiveValue(t9.segment.segments)
	local v75, v76 = React.useState(false)
	local v77 = Foundation.Hooks.useTokens()
	local isDone = t9.isDone
	local v79 = not t9.isDone or v75
	local v80 = React.useCallback(function() -- line: 285
		-- upvalues: v76 (copy)
		v76(function(b1: boolean) -- line: 286
			return not b1
		end)
	end, {})
	local t10 = {}

	if v79 then
		local n3 = 1

		for _, v84 in v74 do
			local v85 = renderWorkSegment(v84, n3, t9.markdownTextStyle, t9.clockBinding, t9.localToolActions)

			if v85 ~= nil then
				t10[v84.key] = v85
				n3 += 1
			end
		end
	end

	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = "ChatTurnBlock.TurnWork",
		LayoutOrder = t9.LayoutOrder
	}, {
		Summary = if not isDone then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
			testId = "ChatTurnBlock.TurnWork.Summary",
			onActivated = v80,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			Chevron = React.createElement(Icon, {
				LayoutOrder = 1,
				name = if not v75 then IconName.ChevronLargeRight else IconName.ChevronLargeDown,
				size = IconSize.XSmall,
				style = v77.Color.Content.Muted
			}),
			Label = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill text-body-medium text-wrap text-align-x-left content-muted",
				Text = v73
			})
		}),
		Work = if not v79 then nil else React.createElement(View, {
			testId = "ChatTurnBlock.TurnWork.Content",
			LayoutOrder = not isDone and 1 or 2,
			tag = {
				["col gap-xsmall size-full-0 auto-y padding-left-large"] = isDone,
				["col gap-xsmall size-full-0 auto-y"] = not isDone
			}
		}, t10)
	})
end
local function ChatTurnBlock(t11: {[any]: any}) -- line: 348
	-- upvalues: React (copy), turnProjection (copy), reportTurnActivityGap (copy), useReactiveValue (copy), t1 (copy), t2 (copy), Foundation (copy), sendBuildExperienceEvent (copy), renderWorkSegment (copy), TurnWorkSegment (copy), PlaytestCompletedCard (copy), AgentTurnFeedback (copy), View (copy)
	local turn = t11.turn
	local turnState = turn.turnState
	local turnKey = turn.turnKey
	local startSequenceId = turn.startSequenceId
	local endSequenceId = turn.endSequenceId
	local optimisticLocalTools = turn.optimisticLocalTools
	local setupErrorText = turn.setupErrorText
	local universeId = turn.universeId
	local sessionId = turn.sessionId
	local isDone = turn.isDone
	local v97 = React.useMemo(function() -- line: 362
		-- upvalues: turnState (copy), turnProjection (copy), turnKey (copy), universeId (copy), sessionId (copy), startSequenceId (copy), endSequenceId (copy), optimisticLocalTools (copy), setupErrorText (copy)
		if turnState ~= nil then
			return turnProjection.projectActiveTurnSegments(turnState, {
				turnKey = turnKey,
				universeId = universeId,
				sessionId = sessionId,
				startSequenceId = startSequenceId,
				endSequenceId = endSequenceId,
				optimisticLocalTools = optimisticLocalTools
			})
		end

		if setupErrorText ~= nil then
			return turnProjection.projectSetupErrorSegments(setupErrorText, {
				turnKey = turnKey
			})
		end

		return turnProjection.projectLoadingTurnSegments({
			turnKey = turnKey
		})
	end, {
		turnState,
		turnKey,
		startSequenceId,
		endSequenceId,
		optimisticLocalTools,
		setupErrorText,
		universeId,
		sessionId
	})
	local v98 = React.useRef(nil)

	React.useEffect(function() -- line: 391
		-- upvalues: isDone (copy), v98 (copy), reportTurnActivityGap (copy), universeId (copy)
		if isDone then
			v98.current = nil

			return
		end

		local elapsed = os.clock()
		local v112 = v98.current == nil
		local v113 = v98.current == nil and 0 or (elapsed - v98.current) * 1000

		reportTurnActivityGap.log(v113, v112, universeId)
		v98.current = elapsed
	end, {
		isDone,
		v97,
		universeId
	})

	local v99 = useReactiveValue(turn.turnFeedbackIds or t1)
	local v100 = t11.localToolActions or t2
	local Emphasis = Foundation.Hooks.useTokens().Color.Content.Emphasis
	local onPlaytest = t11.onPlaytest
	local v103 = React.useCallback(function() -- line: 410
		-- upvalues: sendBuildExperienceEvent (copy), v99 (copy), onPlaytest (copy)
		sendBuildExperienceEvent("PLAYTEST_CLICK", {
			universeId = v99.universeId,
			placeId = v99.placeId,
			conversationId = v99.sessionId,
			messageId = v99.sequenceId
		})

		if onPlaytest ~= nil then
			onPlaytest()
		end
	end, {
		onPlaytest,
		v99
	})
	local t12 = {}
	local n4 = 1

	for _, v107 in v97 do
		local v108 = nil

		if v107.kind == "agent_message" or v107.kind == "activity_summary" or v107.kind == "client_tool" then
			v108 = renderWorkSegment(v107, n4, Emphasis, t11.clockBinding, v100)
		elseif v107.kind == "turn_work" then
			v108 = React.createElement(TurnWorkSegment, {
				LayoutOrder = n4,
				segment = v107,
				isDone = isDone,
				markdownTextStyle = Emphasis,
				clockBinding = t11.clockBinding,
				localToolActions = v100
			})
		elseif v107.kind == "playtest_cta" and onPlaytest ~= nil then
			v108 = React.createElement(PlaytestCompletedCard, {
				LayoutOrder = n4,
				onPlaytest = v103,
				isLoading = t11.isPlaytestLoading
			})
		end

		if v108 ~= nil then
			t12[v107.key] = v108
			n4 += 1
		end
	end

	if isDone then
		t12.Feedback = React.createElement(AgentTurnFeedback, {
			testId = "ChatTurnBlock.UserFeedback",
			LayoutOrder = n4,
			turnFeedbackIds = v99
		})
	end

	return React.createElement(View, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = t11.LayoutOrder
	}, {
		Message = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, t12)
	})
end

return React.memo(ChatTurnBlock)
