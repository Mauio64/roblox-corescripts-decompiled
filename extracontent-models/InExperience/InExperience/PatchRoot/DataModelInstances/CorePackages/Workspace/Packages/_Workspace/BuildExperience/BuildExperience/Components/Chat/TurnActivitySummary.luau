local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Localization2 = require(parent.Localization)
local LocalizationRoactContext = Localization2.LocalizationRoactContext

local ChatScrollAnchorContext = require(BuildExperience.Chat.ChatScrollAnchorContext)
require(BuildExperience.Chat.chatTypes)
local chatConstants = require(BuildExperience.Chat.chatConstants)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceManageMonetizationTool = SharedFlags.FFlagBuildExperienceManageMonetizationTool

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)
local FFlagBuildExperiencePromptStallMessage = require(BuildExperience.Flags.FFlagBuildExperiencePromptStallMessage)

local Icon = Foundation.Icon
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local v = {}

local function constantSource(): number
	return 0
end

local function useReactiveValue(callback)
	local v2 = React.useCallback(function(callback2)
		if typeof(callback) == "function" then
			return (callback(callback2))
		end

		if typeof(callback2) == "function" then
			callback2(constantSource)
		end

		return callback
	end, { callback })

	return (SignalsReact.useSignalState(v2))
end

local function createThinkingGradient(object, enabled: boolean)
	return React.createElement("UIGradient", {
		Enabled = enabled,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.55),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 0.55)
		}),
		Offset = object:map(function(p: number)
			return Vector2.new(
				p * chatConstants.THINKING_GRADIENT_ANIMATION_SPEED % chatConstants.THINKING_GRADIENT_OFFSET - chatConstants.THINKING_GRADIENT_OFFSET / 2,
				0
			)
		end)
	})
end

local function createActivityText(text: string, layoutOrder: number)
	return React.createElement(Text, {
		LayoutOrder = layoutOrder,
		Text = text,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
	})
end

local function createActivitySummaryActionText(text, layoutOrder: number, clockBinding, enabled: boolean)
	return React.createElement(
		Text,
		{
			LayoutOrder = layoutOrder,
			Text = text,
			Size = UDim2.new(1, 0, 0, 0),
			tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-muted"
		},
		{
			ThinkingGradient = createThinkingGradient(clockBinding, enabled)
		}
	)
end

local function getActivitySummaryActionText(p: string, flag: boolean, assistantLoading: string, assistantStillWorking: string, clockBinding, current, object, current2, p2: string?) -- 1 equivalent call inferred from this helper
	if flag then
		return clockBinding:map(function(startedAt: number)
			if not current.isThinking then
				return assistantLoading
			end

			if current.startedAt == nil then
				current.startedAt = startedAt
			end

			local v2 = math.max(0, startedAt - current.startedAt)

			if FFlagBuildExperiencePromptStallMessage and current2 ~= nil and p2 ~= nil then
				local lastProgressAt = current2.lastProgressAt or startedAt
				current2.lastProgressAt = lastProgressAt

				if startedAt - lastProgressAt >= chatConstants.PROMPT_STALL_SECONDS then
					return p2
				end
			end

			local ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = chatConstants.ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS
			local v3 = assistantLoading

			if chatConstants.ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS <= v2 then
				v3 = object:Format(LocalizationStrings.CHAT_THINKING_SECONDS, {
					SECONDS = math.max(0, (math.floor(v2)))
				})
			end

			if math.floor(v2 / ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS) % 2 == 0 then
				return v3
			end

			return assistantStillWorking
		end)
	end

	return p
end

local function localizeActivityLabel(p: string, data, p2, tool: string, object)
	local v2 = p2[p]

	if v2 ~= nil then
		return v2
	end

	if data == nil or data.kind ~= "tool_call" then
		return p
	end

	local title

	if typeof(data.title) == "string" and data.title ~= "" then
		title = data.title
	else
		title = LocalizationStrings.CHAT_TOOL
	end

	local chatToolActivityLocalizationKey = LocalizationStrings.getChatToolActivityLocalizationKey(
		data.title,
		data.status
	)

	if chatToolActivityLocalizationKey ~= nil then
		if not FFlagBuildExperienceManageMonetizationTool then
			return object:Format(chatToolActivityLocalizationKey)
		end

		local success, result = pcall(object.Format, object, chatToolActivityLocalizationKey)

		if success then
			return result
		end
	end

	if title == LocalizationStrings.CHAT_TOOL then
		title = tool
	end

	if data.status == "completed" then
		return object:Format(LocalizationStrings.CHAT_TOOL_FINISHED, { TITLE = title })
	end

	if data.status == "failed" then
		return object:Format(LocalizationStrings.CHAT_TOOL_FAILED, { TITLE = title })
	end

	return object:Format(LocalizationStrings.CHAT_TOOL_RUNNING, { title = title })
end

local function TurnActivitySummary(props)
	local segment = props.segment
	local actionCount = segment.actionCount
	local v2 = {
		assigningTasks = LocalizationStrings.CHAT_ASSIGNING_TASKS,
		assistantLoading = LocalizationStrings.CHAT_ASSISTANT_LOADING,
		assistantStillWorking = LocalizationStrings.CHAT_ASSISTANT_STILL_WORKING,
		assistantTakingLonger = 0,
		questionComposerAnswer = 0,
		questionMultiple = 0,
		questionSingle = 0,
		taskCount = 0,
		tool = 0
	}
	local assistantTakingLonger

	if FFlagBuildExperiencePromptStallMessage then
		assistantTakingLonger = LocalizationStrings.CHAT_ASSISTANT_TAKING_LONGER
	end

	v2.assistantTakingLonger = assistantTakingLonger

	v2.questionComposerAnswer = LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER
	v2.questionMultiple = LocalizationStrings.CHAT_QUESTION_MULTIPLE
	v2.questionSingle = LocalizationStrings.CHAT_QUESTION_SINGLE
	v2.taskCount = actionCount ~= nil and actionCount > 1 and {
		LocalizationStrings.CHAT_TASKS_COMPLETED,
		NUM_COMPLETED_TASKS = actionCount
	} or nil

	v2.tool = LocalizationStrings.CHAT_TOOL
	local v3 = useLocalization(v2)

	local v4 = React.useContext(LocalizationRoactContext)
	local label = useReactiveValue(segment.label or "")

	local v5 = useReactiveValue(segment.activityItems or v)

	local assistantLoading = v3.assistantLoading
	local assistantStillWorking = v3.assistantStillWorking
	local v6 = {
		[LocalizationStrings.CHAT_ASSIGNING_TASKS] = v3.assigningTasks,
		[LocalizationStrings.CHAT_ASSISTANT_LOADING] = assistantLoading,
		[LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER] = v3.questionComposerAnswer,
		[LocalizationStrings.CHAT_QUESTION_MULTIPLE] = v3.questionMultiple,
		[LocalizationStrings.CHAT_QUESTION_SINGLE] = v3.questionSingle
	}
	local text

	if actionCount == nil or not (actionCount > 1) or segment.summaryToolActivity ~= nil then
		text = localizeActivityLabel(label, segment.summaryToolActivity, v6, v3.tool, v4)
	else
		text = v3.taskCount
	end

	local function fn(p, k: number)
		if p.kind == "tool_call" then
			return createActivityText(localizeActivityLabel(LocalizationStrings.CHAT_TOOL, p, v6, v3.tool, v4), k)
		end

		return nil
	end

	local v7 = useReactiveValue(segment.isLoading or false)
	local state, setState = React.useState(false)
	local v8, v9 = React.useBinding(0)
	local ref = React.useRef(nil)
	local ref2, v10

	if FFlagBuildExperienceChatAccordionScrollAnchor then
		ref2 = React.useRef(nil)
		v10 = React.useContext(ChatScrollAnchorContext)
	else
		v10 = nil
		ref2 = nil
	end

	local ref3 = React.useRef({ isThinking = false, startedAt = nil })

	local v11 = Foundation.Hooks.useTokens()

	local isThinking = label == chatConstants.ASSISTANT_LOADING_TEXT
	local current = ref3.current

	if current.isThinking ~= isThinking then
		current.isThinking = isThinking
		current.startedAt = nil
	end

	local current2

	if FFlagBuildExperiencePromptStallMessage then
		current2 = React.useRef({
			segment = nil,
			label = "",
			activityCount = 0,
			lastProgressAt = nil
		}).current
		local count = #v5

		if current2.segment ~= segment or current2.label ~= label or current2.activityCount ~= count then
			current2.segment = segment
			current2.label = label
			current2.activityCount = count
			current2.lastProgressAt = nil
		end
	end

	local onActivated = React.useCallback(function()
		if FFlagBuildExperienceChatAccordionScrollAnchor and v10 ~= nil and ref2 ~= nil then
			v10(ref2.current)
		end

		setState(function(flag: boolean): boolean
			return not flag
		end)
	end, { v10 })

	local v12 = React.useCallback(function(state2)
		if state2 == nil then
			return
		end

		task.defer(function()
			if ref.current ~= state2 then
				return
			end

			local v12 = math.max(0, state2.AbsoluteCanvasSize.Y - state2.AbsoluteWindowSize.Y)
			state2.CanvasPosition = Vector2.new(0, v12)
		end)
	end, {})

	local scrollingFrameRef = React.useCallback(function(current3)
		ref.current = current3

		if current3 then
			v12(current3)
		end
	end, { v12 })

	local onAbsoluteCanvasSizeChanged = React.useCallback(function(p)
		v9(p.AbsoluteCanvasSize.Y)
		v12(p)
	end, { v9, v12 })

	local onAbsoluteWindowSizeChanged = React.useCallback(function(p)
		v12(p)
	end, { v12 })

	React.useEffect(function()
		v12(ref.current)
		return function() end
	end, { v12, v5 })

	local v13 = {}
	local count = 0

	for k, v14 in v5 do
		local v15 = fn(v14, k)

		if v15 == nil then
			continue
		end

		v13[`Tool{k}`] = v15
		count += 1
	end

	local v14 = next(v13) ~= nil
	local v15 = count > 1
	local label2

	if v7 then
		local createElement = React.createElement

		local clockBinding = props.clockBinding
		local v16

		if FFlagBuildExperiencePromptStallMessage and segment.isWaitingForLocalTool ~= true then
			v16 = v3.assistantTakingLonger
		end

		text = getActivitySummaryActionText( -- inferred equivalent call
			text,
			isThinking,
			assistantLoading,
			assistantStillWorking,
			clockBinding,
			current,
			v4,
			current2,
			v16
		)
		label2 = createElement(View, { LayoutOrder = 2, tag = "col fill gap-xxsmall auto-y" }, {
			CurrentAction = createActivitySummaryActionText(
				text,
				1,
				props.clockBinding,
				segment.isWaitingForLocalTool ~= true
			)
		})
	else
		label2 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = text,
			tag = "fill text-body-medium text-wrap text-align-x-left content-muted"
		})
	end

	local createElement = React.createElement
	local v16 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = "TurnActivitySummary"
	}

	local createElement2 = React.createElement
	local v17 = {
		LayoutOrder = 1,
		ref = ref2,
		onActivated = nil,
		stateLayer = 0,
		tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
		testId = "TurnActivitySummary.Summary"
	}

	if not v15 then
		onActivated = nil
	end

	v17.onActivated = onActivated
	v17.stateLayer = { affordance = StateLayerAffordance.None }
	local chevron

	if v15 then
		local createElement3 = React.createElement
		local name

		if state then
			name = IconName.ChevronLargeDown
		else
			name = IconName.ChevronLargeRight
		end

		chevron = createElement3(Icon, {
			LayoutOrder = 1,
			name = name,
			size = IconSize.XSmall,
			style = v11.Color.Content.Muted,
			testId = "TurnActivitySummary.Chevron"
		})
	end

	local v18 = {
		ActivitySummary = createElement2(View, v17, { Chevron = chevron, Label = label2 }),
		ActivityHistory = 0
	}
	local activityHistory

	if state and v14 and v15 then
		activityHistory = React.createElement(ScrollView, {
			LayoutOrder = 2,
			Size = v8:map(function(value: number)
				return UDim2.new(1, 0, 0, (math.clamp(value, 24, 220)))
			end),
			scrollingFrameRef = scrollingFrameRef,
			onAbsoluteCanvasSizeChanged = onAbsoluteCanvasSizeChanged,
			onAbsoluteWindowSizeChanged = onAbsoluteWindowSizeChanged,
			tag = "size-full-0 clip",
			testId = "TurnActivitySummary.ActivityHistory",
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			ActivityColumn = React.createElement(
				View,
				{ tag = "col gap-xsmall size-full-0 auto-y padding-left-large" },
				v13
			)
		})
	end

	v18.ActivityHistory = activityHistory
	return createElement(View, v16, v18)
end

return TurnActivitySummary
