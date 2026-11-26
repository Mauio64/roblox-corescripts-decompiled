local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Markdown")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = Localization.Hooks.useLocalization
local localizationRoactContext = Localization.LocalizationRoactContext
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local ChatPermissionsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatPermissionsContext")
local ChatScrollAnchorContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatScrollAnchorContext")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local ChatCardEmphasisPositionProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisPositionProvider")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")

local v5 = if FFlagBuildExperienceAnswerForm then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AnswersCardContainer") else nil

local turnProjection = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/turnProjection")

local FFlagBuildExperienceChatAccordionScrollAnchor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatAccordionScrollAnchor")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local FFlagBuildAgentAdCampaignRefreshEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignRefreshEligibility")
local FFlagBuildEventsUpdate1 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildEventsUpdate1")

local FFlagBuildExperiencePlaytestCardPublishCta = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePlaytestCardPublishCta")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local reportTurnActivityGap = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/reportTurnActivityGap")
local getMarkdownRendererProps = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getMarkdownRendererProps")
local AgentPlanCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentCard/AgentPlanCard")

local v6 = if FFlagBuildExperienceManageDevProduct then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentCard/AgentDevProductCard") else nil

local AnswerStack = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerStack/AnswerStack")
local OptionSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerStack/OptionSelector")
local AgentTurnFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AgentTurnFeedback")
local ChatUserMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatUserMessage")
local PlaytestCompletedCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/PlaytestCompletedCard")

local v7 = if FFlagBuildExperiencePlaytestCardPublishCta then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/useIsPlaceVersionLive") else nil

local v8 = if FFlagBuildAgentAdCampaignCard then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellCard") else nil

local v9 = if FFlagBuildAgentAdCampaignCard then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdCampaignIsActiveCard") else nil

local v10 = if FFlagBuildAgentAdCampaignCard then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/useAgentAdCampaignTurnCards") else nil

local TurnActivitySummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/TurnActivitySummary")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local markdownViewer = module3.Components.MarkdownViewer

local v11 = {}
local v12 = {
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
	local v13 = React.useCallback(function(callback2)
		if typeof(callback) == "function" then
			return callback(callback2)
		end

		if typeof(callback2) == "function" then
			callback2(constantSource)
		end

		return callback
	end, { callback })

	return SignalsReact.useSignalState(v13)
end

local function useIsChatReadOnly(): boolean
	if not FFlagBuildCheckGamePermissions then
		return false
	end

	local v13 = React.useContext(ChatPermissionsContext)
	return v13 ~= nil and not v13.canEditOnBuild
end

local function hasSelectedOptions(value): boolean
	if typeof(value) == "string" then
		return true
	end

	if typeof(value) == "table" then
		return #value > 0
	end

	return false
end

local function AnswerStackSection(props)
	local v13 = useLocalization({
		customAnswer = LocalizationStrings.ANSWER_STACK_CUSTOM_ANSWER,
		next = LocalizationStrings.ANSWER_STACK_NEXT,
		submit = LocalizationStrings.ANSWER_STACK_SUBMIT
	})
	local v14

	if FFlagBuildCheckGamePermissions then
		local v15 = React.useContext(ChatPermissionsContext)
		v14 = not (v15 == nil) and not v15.canEditOnBuild
	else
		v14 = false
	end

	local prompt = props.prompt
	local question = prompt.question
	local customResponseText = prompt.customResponseText
	local v15 = props.isActive == true and not v14
	local onAnswerSelected = if not v14 then props.onAnswerSelected else nil
	local v16 = question.responseType == "multi_select"
	local v17 = if prompt.isLastQuestion == false then v13.next else v13.submit
	local createElement = React.createElement
	local v19 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = `ChatTurnBlock.AnswerStack.{question.id}`
	}
	local v20 = {
		Question = React.createElement(text, {
			LayoutOrder = 1,
			Text = question.question,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Answers = 0
	}
	local v21

	if customResponseText == nil then
		if #question.options > 0 then
			local createElement2 = React.createElement
			local v23 = {
				LayoutOrder = 2,
				options = question.options,
				selectedOptionId = prompt.selectedOptionId,
				selectionMode = v16 and "multi" or "single",
				confirmLabel = v17,
				isConfirmDisabled = 0,
				onConfirm = 0,
				testId = 0,
				onOptionSelected = 0
			}

			local selectedOptionId = prompt.selectedOptionId
			local v24

			if typeof(selectedOptionId) == "string" then
				v24 = true
			else
				v24 = typeof(selectedOptionId) == "table" and #selectedOptionId > 0
			end

			v23.isConfirmDisabled = not v24
			local v25 = if v16 and v15 then props.onAnswerConfirmed else nil
			v23.onConfirm = v25
			v23.testId = `AnswerStack.{question.id}`
			function v23.onOptionSelected(p2)
				if onAnswerSelected == nil then
					return
				end

				if v16 then
					if v15 then
						onAnswerSelected(question, p2)
					end
				elseif prompt.selectedOptionId == nil then
					onAnswerSelected(question, p2)
				end
			end

			v21 = createElement2(AnswerStack, v23)
		end
	else
		v21 = React.createElement(OptionSelector, {
			LayoutOrder = 2,
			title = v13.customAnswer,
			description = customResponseText,
			isSelected = true,
			testId = `AnswerStack.{question.id}.CustomAnswer`,
			onActivated = function() end
		})
	end

	v20.Answers = v21
	return createElement(view, v19, v20)
end

local function PlanProposalSection(props)
	local v13

	if FFlagBuildCheckGamePermissions then
		local v14 = React.useContext(ChatPermissionsContext)
		v13 = not (v14 == nil) and not v14.canEditOnBuild
	else
		v13 = false
	end

	local planProposal = props.planProposal
	local v14 = not (planProposal.isAccepted == true) and planProposal.feedbackText == nil
	local element = React.createElement(AgentPlanCard, {
		layoutOrder = 1,
		title = planProposal.title,
		textContent = planProposal.textContent,
		summary = planProposal.summary,
		onBuild = props.onPlanAccepted or function() end,
		isBuildDisabled = not v14 or v13,
		testId = "ChatTurnBlock.PlanProposal"
	})

	if planProposal.feedbackText == nil then
		return React.createElement(
			view,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "col gap-medium size-full-0 auto-y"
			},
			{ Plan = element }
		)
	end

	return React.createElement(
		view,
		{ LayoutOrder = props.LayoutOrder, tag = "col gap-medium size-full-0 auto-y" },
		{
			Plan = element,
			Feedback = React.createElement(ChatUserMessage, {
				LayoutOrder = 2,
				message = { kind = "user_message", text = planProposal.feedbackText }
			})
		}
	)
end

local function AgentMessageSegment(props)
	local v13 = useReactiveValue(props.segment.text)

	local v14 = useLocalization({
		assistantResponseFailed = LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED,
		assistantStopped = LocalizationStrings.CHAT_ASSISTANT_STOPPED
	})

	local v15 = React.useContext(localizationRoactContext)

	if v13 == LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED then
		v13 = v14.assistantResponseFailed
	elseif v13 == LocalizationStrings.CHAT_ASSISTANT_STOPPED then
		v13 = v14.assistantStopped
	end

	if props.segment.errorCode ~= nil then
		v13 = v15:Format(LocalizationStrings.CHAT_ERROR_CODE_TEXT, {
			ERROR_CODE = props.segment.errorCode,
			ERROR_TEXT = v13
		})
	end

	local v16 = Foundation.Hooks.useTokens()
	local v17 = React.useMemo(function()
		return getMarkdownRendererProps(v16, props.markdownTextStyle)
	end, { v16, props.markdownTextStyle })

	if v13 == "" then
		return nil
	end

	if props.segment.isError then
		return React.createElement(
			view,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y",
				testId = "ChatTurnBlock.ErrorMessage"
			},
			{
				Icon = React.createElement(icon, {
					LayoutOrder = 1,
					name = iconName.CircleX,
					variant = iconVariant.Filled,
					size = iconSize.Small,
					style = v16.Color.System.Alert,
					testId = "ChatTurnBlock.ErrorMessage.Icon"
				}),
				Text = React.createElement(text, {
					LayoutOrder = 2,
					Text = v13,
					tag = "fill text-body-medium text-wrap text-align-x-left content-emphasis"
				})
			}
		)
	end

	return React.createElement(markdownViewer, {
		Markdown = v13,
		WrapperProps = {
			LayoutOrder = props.LayoutOrder,
			tag = "size-full-0 auto-y text-body-medium content-emphasis"
		},
		MarkdownRendererProps = v17
	})
end

local function PlaytestCardSection(props)
	local v14 = if props.onPublish ~= nil then props.placeId else nil
	local v15 = v7(v14, props.publishedVersionNumber)
	return React.createElement(PlaytestCompletedCard, {
		LayoutOrder = props.LayoutOrder,
		onPlaytest = props.onPlaytest,
		onPublish = props.onPublish,
		isPublishDisabled = v15 or props.isPublishDisabled == true,
		isPlaytestDisabled = props.isPlaytestDisabled,
		isLoading = props.isLoading
	})
end

local function DevProductProposalSection(props)
	local v13

	if FFlagBuildCheckGamePermissions then
		local v14 = React.useContext(ChatPermissionsContext)
		v13 = not (v14 == nil) and not v14.canEditOnBuild
	else
		v13 = false
	end

	local devProductProposal = props.devProductProposal
	local v14 = not (devProductProposal.isApproved == true) and devProductProposal.isRejected ~= true
	return React.createElement(
		view,
		{ LayoutOrder = props.LayoutOrder, tag = "col gap-medium size-full-0 auto-y" },
		{
			DevProduct = React.createElement(v6, {
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
				isActionDisabled = not v14,
				isReadOnly = v13,
				isPending = devProductProposal.isPending,
				hasError = devProductProposal.hasError,
				errorCause = devProductProposal.errorCause,
				canRetry = devProductProposal.canRetry,
				testId = "ChatTurnBlock.DevProductProposal"
			})
		}
	)
end

local function renderClientToolSegment(props, p2, props2)
	if FFlagBuildExperienceAnswerForm and props.answeredPrompts ~= nil then
		return React.createElement(v5, {
			LayoutOrder = p2,
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
			local v14 = {
				LayoutOrder = p2,
				devProductProposal = props.devProductProposal,
				onApprove = 0,
				onReject = 0
			}
			local v15 = if props.isActive then props2.onDevProductApprovedByToolCallId[props.toolCallId] else nil
			v14.onApprove = v15

			local v16 = if props.isActive then props2.onDevProductRejectedByToolCallId[props.toolCallId] else nil
			v14.onReject = v16
			return createElement(DevProductProposalSection, v14)
		else
			local createElement = React.createElement
			local v14 = {
				LayoutOrder = p2,
				planProposal = props.planProposal,
				onPlanAccepted = 0
			}
			local v15 = if props.isActive then props2.onPlanAcceptedByToolCallId[props.toolCallId] else nil
			v14.onPlanAccepted = v15
			return createElement(PlanProposalSection, v14)
		end
	else
		local createElement = React.createElement
		local v14 = {
			LayoutOrder = p2,
			prompt = props.answerStackPrompt,
			isActive = props.isActive,
			onAnswerSelected = 0,
			onAnswerConfirmed = 0
		}
		local v15 = if props.isActive then props2.onAnswerSelectedByToolCallId[props.toolCallId] else nil
		v14.onAnswerSelected = v15

		local v16 = if props.isActive then props2.onAnswerConfirmedByToolCallId[props.toolCallId] else nil
		v14.onAnswerConfirmed = v16
		return createElement(AnswerStackSection, v14)
	end
end

local function renderWorkSegment(p2, p3, p4, clockBinding, localToolActions)
	if p2.kind == "agent_message" then
		return React.createElement(AgentMessageSegment, {
			LayoutOrder = p3,
			segment = p2,
			markdownTextStyle = p4
		})
	end

	if p2.kind == "activity_summary" then
		return React.createElement(TurnActivitySummary, {
			LayoutOrder = p3,
			segment = p2,
			clockBinding = clockBinding
		})
	end

	if p2.kind == "client_tool" then
		return renderClientToolSegment(p2, p3, localToolActions)
	end

	return nil
end

local function TurnWorkSegment(props)
	local v13 = useReactiveValue(props.segment.label or "")
	local workedDurationSeconds = props.segment.workedDurationSeconds
	local v14

	if workedDurationSeconds ~= nil then
		v14 = math.max(0, (math.floor(workedDurationSeconds + 0.5)))
	end

	local actionCount = props.segment.actionCount or 0
	local v17

	if v14 == nil or not (v14 < 60) then
		if v14 == nil then
			if actionCount == 1 then
				v17 = LocalizationStrings.CHAT_ONE_TASK_COMPLETED
			else
				v17 = actionCount > 1 and {
					LocalizationStrings.CHAT_TASKS_COMPLETED,
					NUM_COMPLETED_TASKS = actionCount
				} or nil
			end
		else
			v17 = {
				LocalizationStrings.CHAT_WORKED_MINUTES_SECONDS,
				MINUTES = math.floor(v14 / 60),
				REM_SECONDS = v14 % 60
			}
		end
	else
		v17 = {
			LocalizationStrings.CHAT_WORKED_SECONDS,
			SECONDS = v14
		}
	end

	local v18 = useLocalization({
		summary = v17,
		turnActivity = LocalizationStrings.CHAT_TURN_ACTIVITY
	})

	if v14 == nil and not (actionCount > 0) then
		if v13 == LocalizationStrings.CHAT_TURN_ACTIVITY then
			v13 = v18.turnActivity
		end
	else
		v13 = v18.summary
	end

	local v19 = useReactiveValue(props.segment.segments)
	local state, setState = React.useState(false)
	local ref, v20

	if FFlagBuildExperienceChatAccordionScrollAnchor then
		ref = React.useRef(nil)
		v20 = React.useContext(ChatScrollAnchorContext)
	else
		v20 = nil
		ref = nil
	end

	local v21 = Foundation.Hooks.useTokens()
	local isDone = props.isDone
	local v22 = not props.isDone or state

	local v23 = React.useCallback(function()
		if FFlagBuildExperienceChatAccordionScrollAnchor and v20 ~= nil and ref ~= nil then
			v20(ref.current)
		end

		setState(function(p2): boolean
			return not p2
		end)
	end, { v20 })

	local v24 = {}

	if v22 then
		local v25 = 1

		for k, v26 in v19 do
			local v27 = renderWorkSegment(
				v26,
				v25,
				props.markdownTextStyle,
				props.clockBinding,
				props.localToolActions
			)

			if v27 == nil then
				continue
			end

			if FFlagBuildExperienceChatCardEmphasis then
				v27 = React.createElement(ChatCardEmphasisPositionProvider, { childOrder = v25 }, v27)
			end

			v24[v26.key] = v27
			v25 += 1
		end
	end

	local createElement = React.createElement
	local v26 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = "ChatTurnBlock.TurnWork"
	}
	local v28

	if isDone then
		local createElement2 = React.createElement
		local v30 = {
			LayoutOrder = 1,
			ref = ref,
			onActivated = v23,
			stateLayer = { affordance = stateLayerAffordance.None },
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
			testId = "ChatTurnBlock.TurnWork.Summary"
		}

		local createElement3 = React.createElement

		local v33 = if state then iconName.ChevronLargeDown else iconName.ChevronLargeRight
		v28 = createElement2(view, v30, {
			Chevron = createElement3(icon, {
				LayoutOrder = 1,
				name = v33,
				size = iconSize.XSmall,
				style = v21.Color.Content.Muted
			}),
			Label = React.createElement(text, {
				LayoutOrder = 2,
				Text = v13,
				tag = "fill text-body-medium text-wrap text-align-x-left content-muted"
			})
		})
	end

	local v29 = if v22 then React.createElement(view, {
		LayoutOrder = isDone and 2 or 1,
		tag = {
			["col gap-xlarge size-full-0 auto-y padding-left-large"] = isDone,
			["col gap-xlarge size-full-0 auto-y"] = not isDone
		},
		testId = "ChatTurnBlock.TurnWork.Content"
	}, v24) else nil
	return createElement(view, v26, { Summary = v28, Work = v29 })
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

	local v13 = React.useMemo(function()
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
		local v14 = ref.current == nil
		local v15 = ref.current == nil and 0 or (now - ref.current) * 1000
		reportTurnActivityGap.log(v15, v14, universeId)
		ref.current = now
	end, { isDone, v13, universeId })

	local v14 = useReactiveValue(turn.turnFeedbackIds or v11)

	local v15 = not FFlagBuildAgentAdCampaignCard and {} or v10({
		segments = v13,
		sessionId = sessionId,
		universeId = universeId,
		isPageVisible = props.isPageVisible,
		scrollingFrameRef = props.scrollingFrameRef,
		getCardState = props.getAgentAdCampaignCardState,
		isCreateDisabled = props.isAgentAdCampaignCreateDisabled,
		onOfferSelected = props.onAgentAdCampaignOfferSelected
	})
	local localToolActions = props.localToolActions or v12
	local emphasis = Foundation.Hooks.useTokens().Color.Content.Emphasis

	local v16 = if turnState ~= nil then turnProjection.getFinalAssistantMessageText(turnState) else nil

	local v17 = if FFlagBuildCheckGamePermissions then React.useContext(ChatPermissionsContext) else nil
	local v18 = not (v17 == nil) and not v17.canEdit
	local v19 = not (v17 == nil) and not v17.canPublish

	local onPlaytest = props.onPlaytest
	local v20 = React.useCallback(function()
		sendBuildExperienceEvent(
			"PLAYTEST_CLICK",
			{
				universeId = v14.universeId,
				placeId = v14.placeId,
				conversationId = v14.sessionId,
				messageId = v14.sequenceId
			},
			FFlagBuildEventsUpdate1 and { context = "chat_widget" } or nil
		)

		if onPlaytest ~= nil then
			onPlaytest()
		end
	end, { onPlaytest, v14 })

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if ref2.current or onPlaytest == nil then
			return
		end

		local v21 = false

		for k, v23 in v13 do
			if v23.kind == "playtest_cta" then
				v21 = true
				break
			end
		end

		if not v21 then
			return
		end

		ref2.current = true
		sendBuildExperienceEvent("PLAYTEST_IMPRESSION", {
			universeId = v14.universeId,
			placeId = v14.placeId,
			conversationId = v14.sessionId,
			messageId = v14.sequenceId
		})
	end, { v13, onPlaytest, v14 })
	local v21 = 1
	local v22 = {}

	for k, v23 in v13 do
		local v24 = nil

		if v23.kind == "agent_message" or v23.kind == "activity_summary" or v23.kind == "client_tool" then
			v24 = renderWorkSegment(v23, v21, emphasis, props.clockBinding, localToolActions)
		elseif v23.kind == "turn_work" then
			v24 = React.createElement(TurnWorkSegment, {
				LayoutOrder = v21,
				segment = v23,
				isDone = isDone,
				markdownTextStyle = emphasis,
				clockBinding = props.clockBinding,
				localToolActions = localToolActions
			})
		elseif v23.kind == "playtest_cta" and onPlaytest ~= nil then
			if FFlagBuildExperiencePlaytestCardPublishCta then
				v24 = React.createElement(PlaytestCardSection, {
					LayoutOrder = v21,
					onPlaytest = v20,
					onPublish = props.onPublish,
					isLoading = props.isPlaytestLoading,
					isPlaytestDisabled = v18,
					isPublishDisabled = v19,
					placeId = v14.placeId,
					publishedVersionNumber = v14.publishedVersionNumber
				})
			else
				v24 = React.createElement(PlaytestCompletedCard, {
					LayoutOrder = v21,
					onPlaytest = v20,
					isLoading = props.isPlaytestLoading,
					isPlaytestDisabled = v18
				})
			end
		elseif v23.kind == "agent_ad_campaign_card" and FFlagBuildAgentAdCampaignCard then
			local v25 = v15[v23.toolCallId]
			local state = v25.state

			local v26 = if not (FFlagBuildAgentAdCampaignRefreshEligibility and state ~= nil and state.campaignId == nil) then state else nil

			if v26 == nil then
				if v23.offers ~= nil and not v25.isPending then
					local createElement = React.createElement
					local v28 = {
						LayoutOrder = v21,
						freePromotionsRemaining = v23.availableCreditsSnapshot,
						isCreatePending = 0,
						eligibilityError = 0,
						fundingType = 0,
						containerRef = 0,
						isCreateDisabled = 0,
						onCreate = 0
					}

					local v29 = if FFlagBuildAgentAdCampaignRefreshEligibility and state ~= nil then state.eligibilityStatus == "loading" else nil
					v28.isCreatePending = v29

					local v30 = if FFlagBuildAgentAdCampaignRefreshEligibility and state ~= nil and state.eligibilityStatus ~= "loading" then state.eligibilityStatus else nil
					v28.eligibilityError = v30

					v28.fundingType = v25.fundingType
					v28.containerRef = v25.cardRef
					v28.isCreateDisabled = v25.isCreateDisabled
					v28.onCreate = v25.onCreate
					v24 = createElement(v8, v28)
				end
			else
				v24 = React.createElement(v9, {
					LayoutOrder = v21,
					variant = v26.variant,
					campaignStartDate = v26.campaignStartDate,
					campaignEndDate = v26.campaignEndDate,
					isDisabled = props.onAgentAdCampaignActive == nil,
					onActivated = function()
						if props.onAgentAdCampaignActive ~= nil then
							props.onAgentAdCampaignActive()
						end
					end
				})
			end
		end

		if v24 == nil then
			continue
		end

		if FFlagBuildExperienceChatCardEmphasis then
			v24 = React.createElement(ChatCardEmphasisPositionProvider, {
				messageOrder = props.LayoutOrder or 0,
				segmentOrder = v21
			}, v24)
		end

		v22[v23.key] = v24
		v21 += 1
	end

	local createElement = React.createElement
	local v24 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row gap-small size-full-0 auto-y"
	}

	local createElement2 = React.createElement

	local v28 = {
		Content = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "col gap-xlarge size-full-0 auto-y",
				testId = "ChatTurnBlock.Message.Content"
			},
			v22
		),
		Feedback = 0
	}

	local v29 = if isDone then React.createElement(AgentTurnFeedback, {
		LayoutOrder = 2,
		messageText = v16,
		turnFeedbackIds = v14,
		testId = "ChatTurnBlock.UserFeedback"
	}) else nil
	v28.Feedback = v29
	return createElement(view, v24, {
		Message = createElement2(
			view,
			{
				LayoutOrder = 1,
				tag = "col gap-xsmall size-full-0 auto-y",
				testId = "ChatTurnBlock.Message"
			},
			v28
		)
	})
end

return React.memo(ChatTurnBlock)
