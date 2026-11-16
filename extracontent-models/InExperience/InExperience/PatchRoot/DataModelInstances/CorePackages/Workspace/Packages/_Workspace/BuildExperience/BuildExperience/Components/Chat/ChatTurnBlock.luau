local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Markdown = require(parent.Markdown)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationRoactContext = Localization.LocalizationRoactContext
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local ChatPermissionsContext = require(BuildExperience.Chat.ChatPermissionsContext)
local ChatScrollAnchorContext = require(BuildExperience.Chat.ChatScrollAnchorContext)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local ChatCardEmphasisPositionProvider = require(script.Parent.ChatCardEmphasis.ChatCardEmphasisPositionProvider)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)
require(BuildExperience.Chat.chatTypes)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local AnswersCardContainer

if FFlagBuildExperienceAnswerForm then
	AnswersCardContainer = require(script.Parent.AnswersCardContainer)
else
	AnswersCardContainer = nil
end

local turnProjection = require(BuildExperience.Chat.turnProjection)

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local FFlagBuildAgentAdCampaignRefreshEligibility = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignRefreshEligibility)
local FFlagBuildEventsUpdate1 = require(BuildExperience.Flags.FFlagBuildEventsUpdate1)

local FFlagBuildExperiencePlaytestCardPublishCta = require(BuildExperience.Flags.FFlagBuildExperiencePlaytestCardPublishCta)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local reportTurnActivityGap = require(BuildExperience.Telemetry.reportTurnActivityGap)
local getMarkdownRendererProps = require(BuildExperience.utils.getMarkdownRendererProps)
local AgentPlanCard = require(BuildExperience.Components.AgentCard.AgentPlanCard)
local AgentDevProductCard

if FFlagBuildExperienceManageDevProduct then
	AgentDevProductCard = require(BuildExperience.Components.AgentCard.AgentDevProductCard)
else
	AgentDevProductCard = nil
end

local AnswerStack = require(BuildExperience.Components.AnswerStack.AnswerStack)
local OptionSelector = require(BuildExperience.Components.AnswerStack.OptionSelector)
local AgentTurnFeedback = require(script.Parent.AgentTurnFeedback)
local ChatUserMessage = require(script.Parent.ChatUserMessage)
local PlaytestCompletedCard = require(script.Parent.PlaytestCompletedCard)
local useIsPlaceVersionLive

if FFlagBuildExperiencePlaytestCardPublishCta then
	useIsPlaceVersionLive = require(script.Parent.useIsPlaceVersionLive)
else
	useIsPlaceVersionLive = nil
end

local AdUpsellCard

if FFlagBuildAgentAdCampaignCard then
	AdUpsellCard = require(BuildExperience.Components.Ads.AdUpsellCard)
else
	AdUpsellCard = nil
end

local AdCampaignIsActiveCard

if FFlagBuildAgentAdCampaignCard then
	AdCampaignIsActiveCard = require(BuildExperience.Components.Ads.AdCampaignIsActiveCard)
else
	AdCampaignIsActiveCard = nil
end

local useAgentAdCampaignTurnCards

if FFlagBuildAgentAdCampaignCard then
	useAgentAdCampaignTurnCards = require(script.Parent.useAgentAdCampaignTurnCards)
else
	useAgentAdCampaignTurnCards = nil
end

local TurnActivitySummary = require(script.Parent.TurnActivitySummary)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local MarkdownViewer = Markdown.Components.MarkdownViewer

local v = {}
local v2 = {
	onAnswerSelectedByToolCallId = {},
	onAnswerConfirmedByToolCallId = {},
	onPlanAcceptedByToolCallId = {},
	onDevProductApprovedByToolCallId = {},
	onDevProductRejectedByToolCallId = {}
}

local function constantSource(): number
	return 0
end

local function useReactiveValue(callback)
	local v3 = React.useCallback(function(callback2)
		if typeof(callback) == "function" then
			return (callback(callback2))
		end

		if typeof(callback2) == "function" then
			callback2(constantSource)
		end

		return callback
	end, { callback })

	return (SignalsReact.useSignalState(v3))
end

local function useIsChatReadOnly(): boolean -- 3 equivalent calls inferred from this helper
	if not FFlagBuildCheckGamePermissions then
		return false
	end

	local v3 = React.useContext(ChatPermissionsContext)
	return v3 ~= nil and not v3.canEditOnBuild
end

local function hasSelectedOptions(selectedOptionId): boolean -- 1 equivalent call inferred from this helper
	if typeof(selectedOptionId) == "string" then
		return true
	end

	return typeof(selectedOptionId) == "table" and #selectedOptionId > 0
end

local function AnswerStackSection(props)
	local v3 = useLocalization({
		customAnswer = LocalizationStrings.ANSWER_STACK_CUSTOM_ANSWER,
		next = LocalizationStrings.ANSWER_STACK_NEXT,
		submit = LocalizationStrings.ANSWER_STACK_SUBMIT
	})
	local v4 = useIsChatReadOnly() -- inferred equivalent call
	local prompt = props.prompt
	local question = prompt.question
	local customResponseText = prompt.customResponseText
	local v5

	if props.isActive == true then
		v5 = not v4
	else
		v5 = false
	end

	local onAnswerSelected

	if v4 then
		onAnswerSelected = nil
	else
		onAnswerSelected = props.onAnswerSelected
	end

	local v6 = question.responseType == "multi_select"
	local confirmLabel

	if prompt.isLastQuestion == false then
		confirmLabel = v3.next
	else
		confirmLabel = v3.submit
	end

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = `ChatTurnBlock.AnswerStack.{question.id}`
	}
	local v8 = {
		Question = React.createElement(Text, {
			LayoutOrder = 1,
			Text = question.question,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Answers = 0
	}
	local answers

	if customResponseText == nil then
		if #question.options > 0 then
			local createElement2 = React.createElement
			local v9 = {
				LayoutOrder = 2,
				options = question.options,
				selectedOptionId = prompt.selectedOptionId,
				selectionMode = v6 and "multi" or "single",
				confirmLabel = confirmLabel,
				isConfirmDisabled = not hasSelectedOptions(prompt.selectedOptionId), -- inferred equivalent call
				onConfirm = 0,
				testId = 0,
				onOptionSelected = 0
			}
			local onConfirm

			if v6 and v5 then
				onConfirm = props.onAnswerConfirmed
			end

			v9.onConfirm = onConfirm
			v9.testId = `AnswerStack.{question.id}`
			function v9.onOptionSelected(p)
				if onAnswerSelected == nil then
					return
				end

				if v6 then
					if v5 then
						onAnswerSelected(question, p)
					end
				elseif prompt.selectedOptionId == nil then
					onAnswerSelected(question, p)
				end
			end

			answers = createElement2(AnswerStack, v9)
		end
	else
		answers = React.createElement(OptionSelector, {
			LayoutOrder = 2,
			title = v3.customAnswer,
			description = customResponseText,
			isSelected = true,
			testId = `AnswerStack.{question.id}.CustomAnswer`,
			onActivated = function() end
		})
	end

	v8.Answers = answers
	return createElement(View, v7, v8)
end

local function PlanProposalSection(props)
	local v3 = useIsChatReadOnly() -- inferred equivalent call
	local planProposal = props.planProposal
	local v4

	if planProposal.isAccepted == true then
		v4 = false
	else
		v4 = planProposal.feedbackText == nil
	end

	local element = React.createElement(AgentPlanCard, {
		layoutOrder = 1,
		title = planProposal.title,
		textContent = planProposal.textContent,
		summary = planProposal.summary,
		onBuild = props.onPlanAccepted or function() end,
		isBuildDisabled = not v4 or v3,
		testId = "ChatTurnBlock.PlanProposal"
	})

	if planProposal.feedbackText == nil then
		return React.createElement(
			View,
			{ LayoutOrder = props.LayoutOrder, tag = "col gap-medium size-full-0 auto-y" },
			{ Plan = element }
		)
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y"
	}, {
		Plan = element,
		Feedback = React.createElement(ChatUserMessage, {
			LayoutOrder = 2,
			message = { kind = "user_message", text = planProposal.feedbackText }
		})
	})
end

local function AgentMessageSegment(props)
	local v3 = useReactiveValue(props.segment.text)

	local v4 = useLocalization({
		assistantResponseFailed = LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED,
		assistantStopped = LocalizationStrings.CHAT_ASSISTANT_STOPPED
	})

	local v5 = React.useContext(LocalizationRoactContext)

	if v3 == LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED then
		v3 = v4.assistantResponseFailed
	elseif v3 == LocalizationStrings.CHAT_ASSISTANT_STOPPED then
		v3 = v4.assistantStopped
	end

	if props.segment.errorCode ~= nil then
		v3 = v5:Format(LocalizationStrings.CHAT_ERROR_CODE_TEXT, {
			ERROR_CODE = props.segment.errorCode,
			ERROR_TEXT = v3
		})
	end

	local v6 = Foundation.Hooks.useTokens()
	local markdownRendererProps = React.useMemo(function()
		return getMarkdownRendererProps(v6, props.markdownTextStyle)
	end, { v6, props.markdownTextStyle })

	if v3 == "" then
		return nil
	end

	if props.segment.isError then
		return React.createElement(
			View,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y",
				testId = "ChatTurnBlock.ErrorMessage"
			},
			{
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = IconName.CircleX,
					variant = IconVariant.Filled,
					size = IconSize.Small,
					style = v6.Color.System.Alert,
					testId = "ChatTurnBlock.ErrorMessage.Icon"
				}),
				Text = React.createElement(Text, {
					LayoutOrder = 2,
					Text = v3,
					tag = "fill text-body-medium text-wrap text-align-x-left content-emphasis"
				})
			}
		)
	end

	return React.createElement(MarkdownViewer, {
		Markdown = v3,
		WrapperProps = {
			LayoutOrder = props.LayoutOrder,
			tag = "size-full-0 auto-y text-body-medium content-emphasis"
		},
		MarkdownRendererProps = markdownRendererProps
	})
end

local function PlaytestCardSection(props)
	local v3

	if props.onPublish ~= nil then
		v3 = props.placeId
	end

	local v4 = useIsPlaceVersionLive(v3, props.publishedVersionNumber)
	return React.createElement(PlaytestCompletedCard, {
		LayoutOrder = props.LayoutOrder,
		onPlaytest = props.onPlaytest,
		onPublish = props.onPublish,
		isPublishDisabled = v4 or props.isPublishDisabled == true,
		isPlaytestDisabled = props.isPlaytestDisabled,
		isLoading = props.isLoading
	})
end

local function DevProductProposalSection(props)
	local isReadOnly = useIsChatReadOnly() -- inferred equivalent call
	local devProductProposal = props.devProductProposal
	local v3

	if devProductProposal.isApproved == true then
		v3 = false
	else
		v3 = devProductProposal.isRejected ~= true
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y"
	}, {
		DevProduct = React.createElement(AgentDevProductCard, {
			layoutOrder = 1,
			action = devProductProposal.action,
			name = devProductProposal.name,
			description = devProductProposal.description,
			priceInRobux = devProductProposal.priceInRobux,
			productId = devProductProposal.productId,
			imageAssetId = devProductProposal.imageAssetId,
			productType = devProductProposal.productType,
			itemKind = devProductProposal.itemKind,
			itemId = devProductProposal.itemId,
			cancelRenewals = devProductProposal.cancelRenewals,
			onApprove = props.onApprove or function() end,
			onReject = props.onReject or function() end,
			isActionDisabled = not v3,
			isReadOnly = isReadOnly,
			isPending = devProductProposal.isPending,
			hasError = devProductProposal.hasError,
			errorCause = devProductProposal.errorCause,
			canRetry = devProductProposal.canRetry,
			testId = "ChatTurnBlock.DevProductProposal"
		})
	})
end

local function renderClientToolSegment(props, layoutOrder: number, props2)
	if FFlagBuildExperienceAnswerForm and props.answeredPrompts ~= nil then
		return React.createElement(AnswersCardContainer, {
			LayoutOrder = layoutOrder,
			prompts = props.answeredPrompts
		})
	end

	if FFlagBuildExperienceAnswerForm and props.answerStackPrompt ~= nil then
		return nil
	end

	if props.answerStackPrompt == nil then
		if props.planProposal == nil then
			if not FFlagBuildExperienceManageDevProduct or props.devProductProposal == nil then
				return nil
			end

			local createElement = React.createElement
			local v3 = {
				LayoutOrder = layoutOrder,
				devProductProposal = props.devProductProposal,
				onApprove = 0,
				onReject = 0
			}
			local onApprove

			if props.isActive then
				onApprove = props2.onDevProductApprovedByToolCallId[props.toolCallId]
			end

			v3.onApprove = onApprove
			local onReject

			if props.isActive then
				onReject = props2.onDevProductRejectedByToolCallId[props.toolCallId]
			end

			v3.onReject = onReject
			return createElement(DevProductProposalSection, v3)
		else
			local createElement = React.createElement
			local v3 = {
				LayoutOrder = layoutOrder,
				planProposal = props.planProposal,
				onPlanAccepted = 0
			}
			local onPlanAccepted

			if props.isActive then
				onPlanAccepted = props2.onPlanAcceptedByToolCallId[props.toolCallId]
			end

			v3.onPlanAccepted = onPlanAccepted
			return createElement(PlanProposalSection, v3)
		end
	else
		local createElement = React.createElement
		local v3 = {
			LayoutOrder = layoutOrder,
			prompt = props.answerStackPrompt,
			isActive = props.isActive,
			onAnswerSelected = 0,
			onAnswerConfirmed = 0
		}
		local onAnswerSelected

		if props.isActive then
			onAnswerSelected = props2.onAnswerSelectedByToolCallId[props.toolCallId]
		end

		v3.onAnswerSelected = onAnswerSelected
		local onAnswerConfirmed

		if props.isActive then
			onAnswerConfirmed = props2.onAnswerConfirmedByToolCallId[props.toolCallId]
		end

		v3.onAnswerConfirmed = onAnswerConfirmed
		return createElement(AnswerStackSection, v3)
	end
end

local function renderWorkSegment(segment, layoutOrder: number, markdownTextStyle, clockBinding, localToolActions)
	if segment.kind == "agent_message" then
		return React.createElement(AgentMessageSegment, {
			LayoutOrder = layoutOrder,
			segment = segment,
			markdownTextStyle = markdownTextStyle
		})
	end

	if segment.kind == "activity_summary" then
		return React.createElement(TurnActivitySummary, {
			LayoutOrder = layoutOrder,
			segment = segment,
			clockBinding = clockBinding
		})
	end

	if segment.kind == "client_tool" then
		return renderClientToolSegment(segment, layoutOrder, localToolActions)
	end

	return nil
end

local function TurnWorkSegment(props)
	local text = useReactiveValue(props.segment.label or "")
	local workedDurationSeconds = props.segment.workedDurationSeconds
	local seconds

	if workedDurationSeconds ~= nil then
		seconds = math.max(0, (math.floor(workedDurationSeconds + 0.5)))
	end

	local actionCount = props.segment.actionCount or 0
	local summary

	if seconds == nil or not (seconds < 60) then
		if seconds == nil then
			if actionCount == 1 then
				summary = LocalizationStrings.CHAT_ONE_TASK_COMPLETED
			else
				summary = actionCount > 1 and {
					LocalizationStrings.CHAT_TASKS_COMPLETED,
					NUM_COMPLETED_TASKS = actionCount
				} or nil
			end
		else
			summary = {
				LocalizationStrings.CHAT_WORKED_MINUTES_SECONDS,
				MINUTES = math.floor(seconds / 60),
				REM_SECONDS = seconds % 60
			}
		end
	else
		summary = {
			LocalizationStrings.CHAT_WORKED_SECONDS,
			SECONDS = seconds
		}
	end

	local v3 = useLocalization({
		summary = summary,
		turnActivity = LocalizationStrings.CHAT_TURN_ACTIVITY
	})

	if seconds == nil and not (actionCount > 0) then
		if text == LocalizationStrings.CHAT_TURN_ACTIVITY then
			text = v3.turnActivity
		end
	else
		text = v3.summary
	end

	local v4 = useReactiveValue(props.segment.segments)
	local state, setState = React.useState(false)
	local ref, v5

	if FFlagBuildExperienceChatAccordionScrollAnchor then
		ref = React.useRef(nil)
		v5 = React.useContext(ChatScrollAnchorContext)
	else
		v5 = nil
		ref = nil
	end

	local v6 = Foundation.Hooks.useTokens()
	local isDone = props.isDone
	local v7 = not props.isDone or state

	local onActivated = React.useCallback(function()
		if FFlagBuildExperienceChatAccordionScrollAnchor and v5 ~= nil and ref ~= nil then
			v5(ref.current)
		end

		setState(function(flag: boolean): boolean
			return not flag
		end)
	end, { v5 })

	local v8 = {}

	if v7 then
		local childOrder = 1

		for _, v9 in v4 do
			local v10 = renderWorkSegment(
				v9,
				childOrder,
				props.markdownTextStyle,
				props.clockBinding,
				props.localToolActions
			)

			if v10 == nil then
				continue
			end

			if FFlagBuildExperienceChatCardEmphasis then
				v10 = React.createElement(ChatCardEmphasisPositionProvider, {
					childOrder = childOrder
				}, v10)
			end

			v8[v9.key] = v10
			childOrder += 1
		end
	end

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = "ChatTurnBlock.TurnWork"
	}
	local summary2

	if isDone then
		local createElement2 = React.createElement
		local v10 = {
			LayoutOrder = 1,
			ref = ref,
			onActivated = onActivated,
			stateLayer = { affordance = StateLayerAffordance.None },
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
			testId = "ChatTurnBlock.TurnWork.Summary"
		}

		local createElement3 = React.createElement
		local name

		if state then
			name = IconName.ChevronLargeDown
		else
			name = IconName.ChevronLargeRight
		end

		summary2 = createElement2(View, v10, {
			Chevron = createElement3(Icon, {
				LayoutOrder = 1,
				name = name,
				size = IconSize.XSmall,
				style = v6.Color.Content.Muted
			}),
			Label = React.createElement(Text, {
				LayoutOrder = 2,
				Text = text,
				tag = "fill text-body-medium text-wrap text-align-x-left content-muted"
			})
		})
	end

	local work

	if v7 then
		work = React.createElement(View, {
			LayoutOrder = isDone and 2 or 1,
			tag = {
				["col gap-xlarge size-full-0 auto-y padding-left-large"] = isDone,
				["col gap-xlarge size-full-0 auto-y"] = not isDone
			},
			testId = "ChatTurnBlock.TurnWork.Content"
		}, v8)
	end

	return createElement(View, v9, { Summary = summary2, Work = work })
end

local function ChatTurnBlock(props)
	local turn = props.turn
	local turnState = turn.turnState
	local turnKey = turn.turnKey
	local startSequenceId = turn.startSequenceId
	local endSequenceId = turn.endSequenceId
	local optimisticLocalTools = turn.optimisticLocalTools
	local setupErrorText = turn.setupErrorText
	local universeId = turn.universeId
	local sessionId = turn.sessionId
	local isDone = turn.isDone
	local isLatestPublishTurn = turn.isLatestPublishTurn

	local segments = React.useMemo(function()
		if turnState ~= nil then
			return turnProjection.projectActiveTurnSegments(turnState, {
				turnKey = turnKey,
				universeId = universeId,
				sessionId = sessionId,
				startSequenceId = startSequenceId,
				endSequenceId = endSequenceId,
				optimisticLocalTools = optimisticLocalTools,
				showPlaytestCta = isLatestPublishTurn
			})
		end

		if setupErrorText == nil then
			return turnProjection.projectLoadingTurnSegments({ turnKey = turnKey })
		end

		return turnProjection.projectSetupErrorSegments(setupErrorText, { turnKey = turnKey })
	end, {
		turnState,
		turnKey,
		startSequenceId,
		endSequenceId,
		optimisticLocalTools,
		setupErrorText,
		universeId,
		sessionId,
		isLatestPublishTurn
	})

	local ref = React.useRef(nil)

	React.useEffect(function()
		if isDone then
			ref.current = nil
			return
		end

		local now = os.clock()
		local v3 = ref.current == nil
		local v4 = ref.current == nil and 0 or (now - ref.current) * 1000
		reportTurnActivityGap.log(v4, v3, universeId)
		ref.current = now
	end, { isDone, segments, universeId })

	local turnFeedbackIds = useReactiveValue(turn.turnFeedbackIds or v)

	local v3 = not FFlagBuildAgentAdCampaignCard and {} or useAgentAdCampaignTurnCards({
		segments = segments,
		sessionId = sessionId,
		universeId = universeId,
		isPageVisible = props.isPageVisible,
		scrollingFrameRef = props.scrollingFrameRef,
		getCardState = props.getAgentAdCampaignCardState,
		isCreateDisabled = props.isAgentAdCampaignCreateDisabled,
		onOfferSelected = props.onAgentAdCampaignOfferSelected
	})
	local localToolActions = props.localToolActions or v2
	local emphasis = Foundation.Hooks.useTokens().Color.Content.Emphasis
	local messageText

	if turnState ~= nil then
		messageText = turnProjection.getFinalAssistantMessageText(turnState)
	end

	local v4

	if FFlagBuildCheckGamePermissions then
		v4 = React.useContext(ChatPermissionsContext)
	end

	local isPlaytestDisabled

	if v4 == nil then
		isPlaytestDisabled = false
	else
		isPlaytestDisabled = not v4.canEdit
	end

	local isPublishDisabled

	if v4 == nil then
		isPublishDisabled = false
	else
		isPublishDisabled = not v4.canPublish
	end

	local onPlaytest = props.onPlaytest
	local onPlaytest2 = React.useCallback(function()
		sendBuildExperienceEvent(
			"PLAYTEST_CLICK",
			{
				universeId = turnFeedbackIds.universeId,
				placeId = turnFeedbackIds.placeId,
				conversationId = turnFeedbackIds.sessionId,
				messageId = turnFeedbackIds.sequenceId
			},
			FFlagBuildEventsUpdate1 and { context = "chat_widget" } or nil
		)

		if onPlaytest ~= nil then
			onPlaytest()
		end
	end, { onPlaytest, turnFeedbackIds })

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if ref2.current or onPlaytest == nil then
			return
		end

		local v5 = false

		for _, v6 in segments do
			if v6.kind == "playtest_cta" then
				v5 = true
				break
			end
		end

		if not v5 then
			return
		end

		ref2.current = true
		sendBuildExperienceEvent("PLAYTEST_IMPRESSION", {
			universeId = turnFeedbackIds.universeId,
			placeId = turnFeedbackIds.placeId,
			conversationId = turnFeedbackIds.sessionId,
			messageId = turnFeedbackIds.sequenceId
		})
	end, { segments, onPlaytest, turnFeedbackIds })
	local v5 = 1
	local v6 = {}

	for _, segment in segments do
		local v7 = nil

		if segment.kind == "agent_message" or segment.kind == "activity_summary" or segment.kind == "client_tool" then
			v7 = renderWorkSegment(segment, v5, emphasis, props.clockBinding, localToolActions)
		elseif segment.kind == "turn_work" then
			v7 = React.createElement(TurnWorkSegment, {
				LayoutOrder = v5,
				segment = segment,
				isDone = isDone,
				markdownTextStyle = emphasis,
				clockBinding = props.clockBinding,
				localToolActions = localToolActions
			})
		elseif segment.kind == "playtest_cta" and onPlaytest ~= nil then
			if FFlagBuildExperiencePlaytestCardPublishCta then
				v7 = React.createElement(PlaytestCardSection, {
					LayoutOrder = v5,
					onPlaytest = onPlaytest2,
					onPublish = props.onPublish,
					isLoading = props.isPlaytestLoading,
					isPlaytestDisabled = isPlaytestDisabled,
					isPublishDisabled = isPublishDisabled,
					placeId = turnFeedbackIds.placeId,
					publishedVersionNumber = turnFeedbackIds.publishedVersionNumber
				})
			else
				v7 = React.createElement(PlaytestCompletedCard, {
					LayoutOrder = v5,
					onPlaytest = onPlaytest2,
					isLoading = props.isPlaytestLoading,
					isPlaytestDisabled = isPlaytestDisabled
				})
			end
		elseif segment.kind == "agent_ad_campaign_card" and FFlagBuildAgentAdCampaignCard then
			local v8 = v3[segment.toolCallId]
			local state = v8.state
			local v9

			if not (FFlagBuildAgentAdCampaignRefreshEligibility and state ~= nil and state.campaignId == nil) then
				v9 = state
			end

			if v9 == nil then
				if segment.offers ~= nil and not v8.isPending then
					local createElement = React.createElement
					local v10 = {
						LayoutOrder = v5,
						freePromotionsRemaining = segment.availableCreditsSnapshot,
						isCreatePending = 0,
						eligibilityError = 0,
						fundingType = 0,
						containerRef = 0,
						isCreateDisabled = 0,
						onCreate = 0
					}
					local isCreatePending

					if FFlagBuildAgentAdCampaignRefreshEligibility and state ~= nil then
						isCreatePending = state.eligibilityStatus == "loading"
					end

					v10.isCreatePending = isCreatePending
					local eligibilityError

					if
						FFlagBuildAgentAdCampaignRefreshEligibility
						and state ~= nil
						and state.eligibilityStatus ~= "loading"
					then
						eligibilityError = state.eligibilityStatus
					end

					v10.eligibilityError = eligibilityError

					v10.fundingType = v8.fundingType
					v10.containerRef = v8.cardRef
					v10.isCreateDisabled = v8.isCreateDisabled
					v10.onCreate = v8.onCreate
					v7 = createElement(AdUpsellCard, v10)
				end
			else
				v7 = React.createElement(AdCampaignIsActiveCard, {
					LayoutOrder = v5,
					variant = v9.variant,
					campaignStartDate = v9.campaignStartDate,
					campaignEndDate = v9.campaignEndDate,
					isDisabled = props.onAgentAdCampaignActive == nil,
					onActivated = function()
						if props.onAgentAdCampaignActive ~= nil then
							props.onAgentAdCampaignActive()
						end
					end
				})
			end
		end

		if v7 == nil then
			continue
		end

		if FFlagBuildExperienceChatCardEmphasis then
			v7 = React.createElement(ChatCardEmphasisPositionProvider, {
				messageOrder = props.LayoutOrder or 0,
				segmentOrder = v5
			}, v7)
		end

		v6[segment.key] = v7
		v5 += 1
	end

	local createElement = React.createElement
	local v7 = { LayoutOrder = props.LayoutOrder, tag = "row gap-small size-full-0 auto-y" }

	local createElement2 = React.createElement

	local v8 = {
		Content = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "col gap-xlarge size-full-0 auto-y",
				testId = "ChatTurnBlock.Message.Content"
			},
			v6
		),
		Feedback = 0
	}
	local feedback

	if isDone then
		feedback = React.createElement(AgentTurnFeedback, {
			LayoutOrder = 2,
			messageText = messageText,
			turnFeedbackIds = turnFeedbackIds,
			testId = "ChatTurnBlock.UserFeedback"
		})
	end

	v8.Feedback = feedback
	return createElement(View, v7, {
		Message = createElement2(
			View,
			{
				LayoutOrder = 1,
				tag = "col gap-xsmall size-full-0 auto-y",
				testId = "ChatTurnBlock.Message"
			},
			v8
		)
	})
end

return React.memo(ChatTurnBlock)
