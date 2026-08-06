local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Markdown = require(BuildExperienceParent.Markdown)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

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
local IconVariant = Foundation.Enums.IconVariant
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
	local v40 = React.useCallback(function(p2) -- line: 83
		-- upvalues: p1 (copy), constantSource (copy)
		if typeof(p1) == "function" then
			return (p1(p2))
		end

		if typeof(p2) == "function" then
			p2(constantSource)
		end

		return p1
	end, { p1 })

	return (SignalsReact.useSignalState(v40))
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
	-- upvalues: LocalizationStrings (copy), React (copy), View (copy), FoundationText (copy), OptionSelector (copy), AnswerStack (copy)
	local prompt = t3.prompt
	local question = prompt.question
	local customResponseText = prompt.customResponseText
	local v46 = t3.isActive == true
	local v47 = question.responseType == "multi_select"
	local v48 = if prompt.isLastQuestion ~= false then LocalizationStrings.ANSWER_STACK_SUBMIT else LocalizationStrings.ANSWER_STACK_NEXT
	local createElement = React.createElement
	local v50 = View
	local t4 = {
		tag = "col gap-medium size-full-0 auto-y",
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
	local v53

	if customResponseText ~= nil then
		v53 = React.createElement(OptionSelector, {
			LayoutOrder = 2,
			isSelected = true,
			title = LocalizationStrings.ANSWER_STACK_CUSTOM_ANSWER,
			description = customResponseText,
			testId = `AnswerStack.{ question.id }.CustomAnswer`,
			onActivated = function() -- line: 133
			end
		})
	elseif #question.options > 0 then
		local createElement2 = React.createElement
		local v55 = AnswerStack
		local t6 = {
			LayoutOrder = 2,
			options = question.options,
			selectedOptionId = prompt.selectedOptionId,
			selectionMode = not v47 and "single" or "multi",
			confirmLabel = v48
		}
		local selectedOptionId = prompt.selectedOptionId

		t6.isConfirmDisabled = not (typeof(selectedOptionId) == "string" or typeof(selectedOptionId) == "table" and #selectedOptionId > 0)
		t6.onConfirm = if not v47 or not v46 then nil else t3.onAnswerConfirmed
		t6.testId = `AnswerStack.{ question.id }`

		function t6.onOptionSelected(p4) -- line: 144
			-- upvalues: t3 (copy), v47 (copy), v46 (copy), question (copy), prompt (copy)
			if t3.onAnswerSelected == nil then
				return
			end

			if v47 then
				if v46 then
					t3.onAnswerSelected(question, p4)
				end

				return
			end

			if prompt.selectedOptionId == nil then
				t3.onAnswerSelected(question, p4)
			end
		end

		v53 = createElement2(v55, t6)
	else
		v53 = nil
	end

	t5.Answers = v53

	return createElement(v50, t4, t5)
end
local function PlanProposalSection(t7: {[any]: any}) -- line: 163
	-- upvalues: React (copy), AgentPlanCard (copy), View (copy), ChatUserMessage (copy)
	local planProposal = t7.planProposal
	local v60 = planProposal.isAccepted ~= true and planProposal.feedbackText == nil
	local v61 = React.createElement(AgentPlanCard, {
		layoutOrder = 1,
		testId = "ChatTurnBlock.PlanProposal",
		title = planProposal.title,
		textContent = planProposal.textContent,
		summary = planProposal.summary,
		onBuild = t7.onPlanAccepted or function() -- line: 171
		end,
		isBuildDisabled = not v60
	})

	if planProposal.feedbackText == nil then
		return React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = t7.LayoutOrder
		}, {
			Plan = v61
		})
	end

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = t7.LayoutOrder
	}, {
		Plan = v61,
		Feedback = React.createElement(ChatUserMessage, {
			LayoutOrder = 2,
			message = {
				kind = "user_message",
				text = planProposal.feedbackText
			}
		})
	})
end
local function AgentMessageSegment(t8: {[any]: any}) -- line: 200
	-- upvalues: useReactiveValue (copy), Foundation (copy), React (copy), getMarkdownRendererProps (copy), View (copy), Icon (copy), IconName (copy), IconVariant (copy), IconSize (copy), FoundationText (copy), MarkdownViewer (copy)
	local v63 = useReactiveValue(t8.segment.text)
	local v64 = Foundation.Hooks.useTokens()
	local v65 = React.useMemo(function() -- line: 203
		-- upvalues: getMarkdownRendererProps (copy), v64 (copy), t8 (copy)
		return getMarkdownRendererProps(v64, t8.markdownTextStyle)
	end, {
		v64,
		t8.markdownTextStyle
	})

	if v63 == "" then
		return nil
	end

	if t8.segment.isError then
		return React.createElement(View, {
			tag = "row align-y-center gap-xsmall size-full-0 auto-y",
			testId = "ChatTurnBlock.ErrorMessage",
			LayoutOrder = t8.LayoutOrder
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				testId = "ChatTurnBlock.ErrorMessage.Icon",
				name = IconName.CircleX,
				variant = IconVariant.Filled,
				size = IconSize.Small,
				style = v64.Color.System.Alert
			}),
			Text = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill text-body-medium text-wrap text-align-x-left content-emphasis",
				Text = v63
			})
		})
	end

	return React.createElement(MarkdownViewer, {
		Markdown = v63,
		WrapperProps = {
			tag = "size-full-0 auto-y text-body-medium content-emphasis",
			LayoutOrder = t8.LayoutOrder
		},
		MarkdownRendererProps = v65
	})
end
local function renderClientToolSegment(p5, n1: number, p6) -- line: 245
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
local function renderWorkSegment(p7, n2: number, p8, p9, p10) -- line: 275
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
local function TurnWorkSegment(t9: {[any]: any}) -- line: 301
	-- upvalues: useReactiveValue (copy), React (copy), Foundation (copy), renderWorkSegment (copy), View (copy), StateLayerAffordance (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local v75 = useReactiveValue(t9.segment.label)
	local v76 = useReactiveValue(t9.segment.segments)
	local v77, v78 = React.useState(false)
	local v79 = Foundation.Hooks.useTokens()
	local isDone = t9.isDone
	local v81 = not t9.isDone or v77
	local v82 = React.useCallback(function() -- line: 309
		-- upvalues: v78 (copy)
		v78(function(b1: boolean) -- line: 310
			return not b1
		end)
	end, {})
	local t10 = {}

	if v81 then
		local n3 = 1

		for _, v86 in v76 do
			local v87 = renderWorkSegment(v86, n3, t9.markdownTextStyle, t9.clockBinding, t9.localToolActions)

			if v87 ~= nil then
				t10[v86.key] = v87
				n3 += 1
			end
		end
	end

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		testId = "ChatTurnBlock.TurnWork",
		LayoutOrder = t9.LayoutOrder
	}, {
		Summary = if not isDone then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
			testId = "ChatTurnBlock.TurnWork.Summary",
			onActivated = v82,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			Chevron = React.createElement(Icon, {
				LayoutOrder = 1,
				name = if not v77 then IconName.ChevronLargeRight else IconName.ChevronLargeDown,
				size = IconSize.XSmall,
				style = v79.Color.Content.Muted
			}),
			Label = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill text-body-medium text-wrap text-align-x-left content-muted",
				Text = v75
			})
		}),
		Work = if not v81 then nil else React.createElement(View, {
			testId = "ChatTurnBlock.TurnWork.Content",
			LayoutOrder = not isDone and 1 or 2,
			tag = {
				["col gap-xlarge size-full-0 auto-y padding-left-large"] = isDone,
				["col gap-xlarge size-full-0 auto-y"] = not isDone
			}
		}, t10)
	})
end
local function ChatTurnBlock(t11: {[any]: any}) -- line: 372
	-- upvalues: React (copy), turnProjection (copy), reportTurnActivityGap (copy), useReactiveValue (copy), t1 (copy), t2 (copy), Foundation (copy), sendBuildExperienceEvent (copy), renderWorkSegment (copy), TurnWorkSegment (copy), PlaytestCompletedCard (copy), View (copy), AgentTurnFeedback (copy)
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
	local v99 = React.useMemo(function() -- line: 386
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
	local v100 = React.useRef(nil)

	React.useEffect(function() -- line: 415
		-- upvalues: isDone (copy), v100 (copy), reportTurnActivityGap (copy), universeId (copy)
		if isDone then
			v100.current = nil

			return
		end

		local elapsed = os.clock()
		local v115 = v100.current == nil
		local v116 = v100.current == nil and 0 or (elapsed - v100.current) * 1000

		reportTurnActivityGap.log(v116, v115, universeId)
		v100.current = elapsed
	end, {
		isDone,
		v99,
		universeId
	})

	local v101 = useReactiveValue(turn.turnFeedbackIds or t1)
	local v102 = t11.localToolActions or t2
	local Emphasis = Foundation.Hooks.useTokens().Color.Content.Emphasis
	local onPlaytest = t11.onPlaytest
	local v105 = React.useCallback(function() -- line: 434
		-- upvalues: sendBuildExperienceEvent (copy), v101 (copy), onPlaytest (copy)
		sendBuildExperienceEvent("PLAYTEST_CLICK", {
			universeId = v101.universeId,
			placeId = v101.placeId,
			conversationId = v101.sessionId,
			messageId = v101.sequenceId
		})

		if onPlaytest ~= nil then
			onPlaytest()
		end
	end, {
		onPlaytest,
		v101
	})
	local v106 = React.useRef(false)

	React.useEffect(function() -- line: 447
		-- upvalues: v106 (copy), onPlaytest (copy), v99 (copy), sendBuildExperienceEvent (copy), v101 (copy)
		if v106.current or onPlaytest == nil then
			return
		end

		local v117 = false

		for _, v119 in v99 do
			if v119.kind == "playtest_cta" then
				v117 = true

				break
			end
		end

		if not v117 then
			return
		end

		v106.current = true
		sendBuildExperienceEvent("PLAYTEST_IMPRESSION", {
			universeId = v101.universeId,
			placeId = v101.placeId,
			conversationId = v101.sessionId,
			messageId = v101.sequenceId
		})
	end, {
		v99,
		onPlaytest,
		v101
	})

	local t12 = {}
	local n4 = 1

	for _, v110 in v99 do
		local v111 = nil

		if v110.kind == "agent_message" or v110.kind == "activity_summary" or v110.kind == "client_tool" then
			v111 = renderWorkSegment(v110, n4, Emphasis, t11.clockBinding, v102)
		elseif v110.kind == "turn_work" then
			v111 = React.createElement(TurnWorkSegment, {
				LayoutOrder = n4,
				segment = v110,
				isDone = isDone,
				markdownTextStyle = Emphasis,
				clockBinding = t11.clockBinding,
				localToolActions = v102
			})
		elseif v110.kind == "playtest_cta" and onPlaytest ~= nil then
			v111 = React.createElement(PlaytestCompletedCard, {
				LayoutOrder = n4,
				onPlaytest = v105,
				isLoading = t11.isPlaytestLoading
			})
		end

		if v111 ~= nil then
			t12[v110.key] = v111
			n4 += 1
		end
	end

	return React.createElement(View, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = t11.LayoutOrder
	}, {
		Message = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y",
			testId = "ChatTurnBlock.Message"
		}, {
			Content = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col gap-xlarge size-full-0 auto-y",
				testId = "ChatTurnBlock.Message.Content"
			}, t12),
			Feedback = if not isDone then nil else React.createElement(AgentTurnFeedback, {
				LayoutOrder = 2,
				testId = "ChatTurnBlock.UserFeedback",
				turnFeedbackIds = v101
			})
		})
	})
end

return React.memo(ChatTurnBlock)
