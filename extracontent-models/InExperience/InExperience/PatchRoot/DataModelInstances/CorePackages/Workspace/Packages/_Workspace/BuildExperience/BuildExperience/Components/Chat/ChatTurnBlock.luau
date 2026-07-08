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
	onPlanAcceptedByToolCallId = {}
}

local function constantSource() -- line: 75
	return 0
end
local function useReactiveValue(p1) -- line: 79
	-- upvalues: React (copy), constantSource (copy), SignalsReact (copy)
	local v37 = React.useCallback(function(p2) -- line: 80
		-- upvalues: p1 (copy), constantSource (copy)
		if typeof(p1) == "function" then
			return (p1(p2))
		end

		if typeof(p2) == "function" then
			p2(constantSource)
		end

		return p1
	end, { p1 })

	return (SignalsReact.useSignalState(v37))
end
local function AnswerStackSection(t3: {[any]: any}) -- line: 93
	-- upvalues: React (copy), View (copy), FoundationText (copy), OptionSelector (copy), AnswerStack (copy)
	local prompt = t3.prompt
	local question = prompt.question
	local customResponseText = prompt.customResponseText

	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y padding-top-small",
		LayoutOrder = t3.LayoutOrder,
		testId = `ChatTurnBlock.AnswerStack.{ question.id }`
	}, {
		Question = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
			Text = question.question
		}),
		Answers = if customResponseText == nil then if not (#question.options > 0) then nil else React.createElement(AnswerStack, {
			LayoutOrder = 2,
			options = question.options,
			selectedOptionId = prompt.selectedOptionId,
			testId = `AnswerStack.{ question.id }`,
			onOptionSelected = function(p3) -- line: 122
				-- upvalues: t3 (copy), prompt (copy), question (copy)
				if t3.onAnswerSelected ~= nil and prompt.selectedOptionId == nil then
					t3.onAnswerSelected(question, p3)
				end
			end
		}) else React.createElement(OptionSelector, {
			LayoutOrder = 2,
			title = "Custom Answer",
			isSelected = true,
			description = customResponseText,
			testId = `AnswerStack.{ question.id }.CustomAnswer`,
			onActivated = function() -- line: 115
			end
		})
	})
end
local function PlanProposalSection(t4: {[any]: any}) -- line: 132
	-- upvalues: React (copy), AgentPlanCard (copy), View (copy), ChatUserMessage (copy)
	local planProposal = t4.planProposal
	local v44 = planProposal.isAccepted ~= true and planProposal.feedbackText == nil
	local v45 = React.createElement(AgentPlanCard, {
		layoutOrder = 1,
		testId = "ChatTurnBlock.PlanProposal",
		title = planProposal.title,
		textContent = planProposal.textContent,
		summary = planProposal.summary,
		onBuild = t4.onPlanAccepted or function() -- line: 140
		end,
		isBuildDisabled = not v44
	})

	if planProposal.feedbackText == nil then
		return React.createElement(View, {
			tag = "col gap-xsmall size-full-0 auto-y",
			LayoutOrder = t4.LayoutOrder
		}, {
			Plan = v45
		})
	end

	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		LayoutOrder = t4.LayoutOrder
	}, {
		Plan = v45,
		Feedback = React.createElement(ChatUserMessage, {
			LayoutOrder = 2,
			message = {
				kind = "user_message",
				text = planProposal.feedbackText
			}
		})
	})
end
local function AgentMessageSegment(t5: {[any]: any}) -- line: 169
	-- upvalues: useReactiveValue (copy), Foundation (copy), React (copy), getMarkdownRendererProps (copy), MarkdownViewer (copy)
	local v47 = useReactiveValue(t5.segment.text)
	local v48 = Foundation.Hooks.useTokens()
	local v49 = React.useMemo(function() -- line: 172
		-- upvalues: getMarkdownRendererProps (copy), v48 (copy), t5 (copy)
		return getMarkdownRendererProps(v48, t5.markdownTextStyle)
	end, {
		v48,
		t5.markdownTextStyle
	})

	if v47 == "" then
		return nil
	end

	return React.createElement(MarkdownViewer, {
		Markdown = v47,
		WrapperProps = {
			tag = "size-full-0 auto-y text-body-medium content-emphasis",
			LayoutOrder = t5.LayoutOrder
		},
		MarkdownRendererProps = v49
	})
end
local function renderClientToolSegment(p4, n1: number, p5) -- line: 192
	-- upvalues: React (copy), AnswerStackSection (copy), PlanProposalSection (copy)
	if p4.answerStackPrompt ~= nil then
		return React.createElement(AnswerStackSection, {
			LayoutOrder = n1,
			prompt = p4.answerStackPrompt,
			onAnswerSelected = if not p4.isActive then nil else p5.onAnswerSelectedByToolCallId[p4.toolCallId]
		})
	end

	if p4.planProposal ~= nil then
		return React.createElement(PlanProposalSection, {
			LayoutOrder = n1,
			planProposal = p4.planProposal,
			onPlanAccepted = if not p4.isActive then nil else p5.onPlanAcceptedByToolCallId[p4.toolCallId]
		})
	end

	return nil
end
local function renderWorkSegment(p6, n2: number, p7, p8, p9) -- line: 218
	-- upvalues: React (copy), AgentMessageSegment (copy), TurnActivitySummary (copy), renderClientToolSegment (copy)
	if p6.kind == "agent_message" then
		return React.createElement(AgentMessageSegment, {
			LayoutOrder = n2,
			segment = p6,
			markdownTextStyle = p7
		})
	end

	if p6.kind == "activity_summary" then
		return React.createElement(TurnActivitySummary, {
			LayoutOrder = n2,
			segment = p6,
			clockBinding = p8
		})
	end

	if p6.kind == "client_tool" then
		return renderClientToolSegment(p6, n2, p9)
	end

	return nil
end
local function TurnWorkSegment(t6: {[any]: any}) -- line: 244
	-- upvalues: useReactiveValue (copy), React (copy), Foundation (copy), renderWorkSegment (copy), View (copy), StateLayerAffordance (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local v59 = useReactiveValue(t6.segment.label)
	local v60 = useReactiveValue(t6.segment.segments)
	local v61, v62 = React.useState(false)
	local v63 = Foundation.Hooks.useTokens()
	local isDone = t6.isDone
	local v65 = not t6.isDone or v61
	local v66 = React.useCallback(function() -- line: 252
		-- upvalues: v62 (copy)
		v62(function(b1: boolean) -- line: 253
			return not b1
		end)
	end, {})
	local t7 = {}

	if v65 then
		local n3 = 1

		for _, v70 in v60 do
			local v71 = renderWorkSegment(v70, n3, t6.markdownTextStyle, t6.clockBinding, t6.localToolActions)

			if v71 ~= nil then
				t7[v70.key] = v71
				n3 += 1
			end
		end
	end

	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = "ChatTurnBlock.TurnWork",
		LayoutOrder = t6.LayoutOrder
	}, {
		Summary = if not isDone then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
			testId = "ChatTurnBlock.TurnWork.Summary",
			onActivated = v66,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			Chevron = React.createElement(Icon, {
				LayoutOrder = 1,
				name = if not v61 then IconName.ChevronLargeRight else IconName.ChevronLargeDown,
				size = IconSize.XSmall,
				style = v63.Color.Content.Muted
			}),
			Label = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill text-body-medium text-wrap text-align-x-left content-muted",
				Text = v59
			})
		}),
		Work = if not v65 then nil else React.createElement(View, {
			testId = "ChatTurnBlock.TurnWork.Content",
			LayoutOrder = not isDone and 1 or 2,
			tag = {
				["col gap-xsmall size-full-0 auto-y padding-left-large"] = isDone,
				["col gap-xsmall size-full-0 auto-y"] = not isDone
			}
		}, t7)
	})
end
local function ChatTurnBlock(t8: {[any]: any}) -- line: 315
	-- upvalues: React (copy), turnProjection (copy), reportTurnActivityGap (copy), useReactiveValue (copy), t1 (copy), t2 (copy), Foundation (copy), sendBuildExperienceEvent (copy), renderWorkSegment (copy), TurnWorkSegment (copy), PlaytestCompletedCard (copy), AgentTurnFeedback (copy), View (copy)
	local turn = t8.turn
	local turnState = turn.turnState
	local turnKey = turn.turnKey
	local optimisticLocalTools = turn.optimisticLocalTools
	local setupErrorText = turn.setupErrorText
	local universeId = turn.universeId
	local sessionId = turn.sessionId
	local isDone = turn.isDone
	local v81 = React.useMemo(function() -- line: 326
		-- upvalues: turnState (copy), turnProjection (copy), turnKey (copy), universeId (copy), sessionId (copy), optimisticLocalTools (copy), setupErrorText (copy)
		if turnState ~= nil then
			return turnProjection.projectActiveTurnSegments(turnState, {
				turnKey = turnKey,
				universeId = universeId,
				sessionId = sessionId,
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
		optimisticLocalTools,
		setupErrorText,
		universeId,
		sessionId
	})
	local v82 = React.useRef(nil)

	React.useEffect(function() -- line: 342
		-- upvalues: isDone (copy), v82 (copy), reportTurnActivityGap (copy), universeId (copy)
		if isDone then
			v82.current = nil

			return
		end

		local elapsed = os.clock()
		local v96 = v82.current == nil
		local v97 = v82.current == nil and 0 or (elapsed - v82.current) * 1000

		reportTurnActivityGap.log(v97, v96, universeId)
		v82.current = elapsed
	end, {
		isDone,
		v81,
		universeId
	})

	local v83 = useReactiveValue(turn.turnFeedbackIds or t1)
	local v84 = t8.localToolActions or t2
	local Emphasis = Foundation.Hooks.useTokens().Color.Content.Emphasis
	local onPlaytest = t8.onPlaytest
	local v87 = React.useCallback(function() -- line: 361
		-- upvalues: sendBuildExperienceEvent (copy), v83 (copy), onPlaytest (copy)
		sendBuildExperienceEvent("PLAYTEST_CLICK", {
			universeId = v83.universeId,
			placeId = v83.placeId,
			conversationId = v83.sessionId,
			messageId = v83.sequenceId
		})

		if onPlaytest ~= nil then
			onPlaytest()
		end
	end, {
		onPlaytest,
		v83
	})
	local t9 = {}
	local n4 = 1

	for _, v91 in v81 do
		local v92 = nil

		if v91.kind == "agent_message" or v91.kind == "activity_summary" or v91.kind == "client_tool" then
			v92 = renderWorkSegment(v91, n4, Emphasis, t8.clockBinding, v84)
		elseif v91.kind == "turn_work" then
			v92 = React.createElement(TurnWorkSegment, {
				LayoutOrder = n4,
				segment = v91,
				isDone = isDone,
				markdownTextStyle = Emphasis,
				clockBinding = t8.clockBinding,
				localToolActions = v84
			})
		elseif v91.kind == "playtest_cta" and onPlaytest ~= nil then
			v92 = React.createElement(PlaytestCompletedCard, {
				LayoutOrder = n4,
				onPlaytest = v87,
				isLoading = t8.isPlaytestLoading
			})
		end

		if v92 ~= nil then
			t9[v91.key] = v92
			n4 += 1
		end
	end

	if isDone then
		t9.Feedback = React.createElement(AgentTurnFeedback, {
			testId = "ChatTurnBlock.UserFeedback",
			LayoutOrder = n4,
			turnFeedbackIds = v83
		})
	end

	return React.createElement(View, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = t8.LayoutOrder
	}, {
		Message = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, t9)
	})
end

return React.memo(ChatTurnBlock)
