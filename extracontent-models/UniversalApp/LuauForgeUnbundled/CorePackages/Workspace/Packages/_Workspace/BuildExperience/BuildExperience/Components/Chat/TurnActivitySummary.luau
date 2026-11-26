local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").LocalizationRoactContext

local ChatScrollAnchorContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatScrollAnchorContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local fFlagBuildExperienceManageMonetizationTool = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceManageMonetizationTool

local FFlagBuildExperienceChatAccordionScrollAnchor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatAccordionScrollAnchor")
local FFlagBuildExperiencePromptStallMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePromptStallMessage")
local FFlagBuildExperienceToolDisplaySummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceToolDisplaySummary")

local icon = Foundation.Icon
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local v5 = {}

local function constantSource(): number
	return 0
end

local function useReactiveValue(callback)
	local v6 = React.useCallback(function(callback2)
		if typeof(callback) == "function" then
			return callback(callback2)
		end

		if typeof(callback2) == "function" then
			callback2(constantSource)
		end

		return callback
	end, { callback })

	return SignalsReact.useSignalState(v6)
end

local function createThinkingGradient(object, p2)
	return React.createElement("UIGradient", {
		Enabled = p2,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.55),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 0.55)
		}),
		Offset = object:map(function(p3)
			return Vector2.new(
				p3 * chatConstants.THINKING_GRADIENT_ANIMATION_SPEED % chatConstants.THINKING_GRADIENT_OFFSET - chatConstants.THINKING_GRADIENT_OFFSET / 2,
				0
			)
		end)
	})
end

local function createActivityText(p2, p3)
	return React.createElement(text, {
		LayoutOrder = p3,
		Text = p2,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
	})
end

local function createActivitySummaryActionText(p2, p3, p4, p5)
	return React.createElement(
		text,
		{
			LayoutOrder = p3,
			Text = p2,
			Size = UDim2.new(1, 0, 0, 0),
			tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-muted"
		},
		{ ThinkingGradient = createThinkingGradient(p4, p5) }
	)
end

local function getActivitySummaryActionText(p2, p3, p4, p5, object, state, object2, p6, p7)
	if p3 then
		return object:map(function(startedAt)
			if not state.isThinking then
				return p4
			end

			if state.startedAt == nil then
				state.startedAt = startedAt
			end

			local v6 = math.max(0, startedAt - state.startedAt)

			if FFlagBuildExperiencePromptStallMessage and p6 ~= nil and p7 ~= nil then
				local lastProgressAt = p6.lastProgressAt or startedAt
				p6.lastProgressAt = lastProgressAt

				if startedAt - lastProgressAt >= chatConstants.PROMPT_STALL_SECONDS then
					return p7
				end
			end

			local ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = chatConstants.ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS
			local v7 = p4

			if chatConstants.ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS <= v6 then
				v7 = object2:Format(LocalizationStrings.CHAT_THINKING_SECONDS, {
					SECONDS = math.max(0, (math.floor(v6)))
				})
			end

			if math.floor(v6 / ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS) % 2 == 0 then
				return v7
			end

			return p5
		end)
	end

	return p2
end

local function localizeActivityLabel(p2, data, p3, tool, object)
	local v6 = p3[p2]

	if v6 ~= nil then
		return v6
	end

	if data == nil or data.kind ~= "tool_call" then
		return p2
	end

	if
		FFlagBuildExperienceToolDisplaySummary
		and data.status ~= "failed"
		and typeof(data.displaySummary) == "string"
		and data.displaySummary ~= ""
	then
		return data.displaySummary
	end

	local v7

	if typeof(data.title) == "string" and data.title ~= "" then
		v7 = data.title
	else
		v7 = LocalizationStrings.CHAT_TOOL
	end

	local chatToolActivityLocalizationKey = LocalizationStrings.getChatToolActivityLocalizationKey(
		data.title,
		data.status
	)

	if chatToolActivityLocalizationKey ~= nil then
		if not fFlagBuildExperienceManageMonetizationTool then
			return object:Format(chatToolActivityLocalizationKey)
		end

		local success, result = pcall(object.Format, object, chatToolActivityLocalizationKey)

		if success then
			return result
		end
	end

	if v7 == LocalizationStrings.CHAT_TOOL then
		v7 = tool
	end

	if data.status == "completed" then
		return object:Format(LocalizationStrings.CHAT_TOOL_FINISHED, { TITLE = v7 })
	end

	if data.status == "failed" then
		return object:Format(LocalizationStrings.CHAT_TOOL_FAILED, { TITLE = v7 })
	end

	return object:Format(LocalizationStrings.CHAT_TOOL_RUNNING, { title = v7 })
end

local function TurnActivitySummary(props)
	local segment = props.segment
	local actionCount = segment.actionCount
	local v7 = {
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

	local v8 = if FFlagBuildExperiencePromptStallMessage then LocalizationStrings.CHAT_ASSISTANT_TAKING_LONGER else nil
	v7.assistantTakingLonger = v8

	v7.questionComposerAnswer = LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER
	v7.questionMultiple = LocalizationStrings.CHAT_QUESTION_MULTIPLE
	v7.questionSingle = LocalizationStrings.CHAT_QUESTION_SINGLE
	v7.taskCount = actionCount ~= nil and actionCount > 1 and {
		LocalizationStrings.CHAT_TASKS_COMPLETED,
		NUM_COMPLETED_TASKS = actionCount
	} or nil

	v7.tool = LocalizationStrings.CHAT_TOOL
	local v9 = useLocalization(v7)

	local v10 = React.useContext(localizationRoactContext)
	local v11 = useReactiveValue(segment.label or "")

	local v12 = useReactiveValue(segment.activityItems or v5)

	local assistantLoading = v9.assistantLoading
	local assistantStillWorking = v9.assistantStillWorking
	local v13 = {
		[LocalizationStrings.CHAT_ASSIGNING_TASKS] = v9.assigningTasks,
		[LocalizationStrings.CHAT_ASSISTANT_LOADING] = assistantLoading,
		[LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER] = v9.questionComposerAnswer,
		[LocalizationStrings.CHAT_QUESTION_MULTIPLE] = v9.questionMultiple,
		[LocalizationStrings.CHAT_QUESTION_SINGLE] = v9.questionSingle
	}
	local v14

	if actionCount == nil or not (actionCount > 1) or segment.summaryToolActivity ~= nil then
		v14 = localizeActivityLabel(v11, segment.summaryToolActivity, v13, v9.tool, v10)
	else
		v14 = v9.taskCount
	end

	local function fn(p2, k)
		if p2.kind ~= "tool_call" then
			return nil
		end

		return createActivityText(localizeActivityLabel(LocalizationStrings.CHAT_TOOL, p2, v13, v9.tool, v10), k)
	end

	local v15 = useReactiveValue(segment.isLoading or false)
	local state, setState = React.useState(false)
	local v16, v17 = React.useBinding(0)
	local ref = React.useRef(nil)
	local ref2, v18

	if FFlagBuildExperienceChatAccordionScrollAnchor then
		ref2 = React.useRef(nil)
		v18 = React.useContext(ChatScrollAnchorContext)
	else
		v18 = nil
		ref2 = nil
	end

	local ref3 = React.useRef({ isThinking = false, startedAt = nil })

	local v19 = Foundation.Hooks.useTokens()

	local v20 = v11 == chatConstants.ASSISTANT_LOADING_TEXT
	local current = ref3.current

	if current.isThinking ~= v20 then
		current.isThinking = v20
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
		local count = #v12

		if current2.segment ~= segment or current2.label ~= v11 or current2.activityCount ~= count then
			current2.segment = segment
			current2.label = v11
			current2.activityCount = count
			current2.lastProgressAt = nil
		end
	else
		current2 = nil
	end

	local v21 = React.useCallback(function()
		if FFlagBuildExperienceChatAccordionScrollAnchor and v18 ~= nil and ref2 ~= nil then
			v18(ref2.current)
		end

		setState(function(p2): boolean
			return not p2
		end)
	end, { v18 })

	local v22 = React.useCallback(function(state2)
		if state2 == nil then
			return
		end

		task.defer(function()
			if ref.current ~= state2 then
				return
			end

			local v23 = math.max(0, state2.AbsoluteCanvasSize.Y - state2.AbsoluteWindowSize.Y)
			state2.CanvasPosition = Vector2.new(0, v23)
		end)
	end, {})

	local v23 = React.useCallback(function(current3)
		ref.current = current3

		if current3 then
			v22(current3)
		end
	end, { v22 })

	local v24 = React.useCallback(function(p2)
		v17(p2.AbsoluteCanvasSize.Y)
		v22(p2)
	end, { v17, v22 })

	local v25 = React.useCallback(function(p2)
		v22(p2)
	end, { v22 })

	React.useEffect(function()
		v22(ref.current)
		return function() end
	end, { v22, v12 })

	local v26 = {}
	local count = 0

	for k, v27 in v12 do
		local v28 = fn(v27, k)

		if v28 == nil then
			continue
		end

		v26[`Tool{k}`] = v28
		count += 1
	end

	local v27 = next(v26) ~= nil
	local v28 = count > 1
	local v29

	if v15 then
		local createElement = React.createElement

		local clockBinding = props.clockBinding
		local assistantTakingLonger

		if FFlagBuildExperiencePromptStallMessage and segment.isWaitingForLocalTool ~= true then
			assistantTakingLonger = v9.assistantTakingLonger
		else
			assistantTakingLonger = nil
		end

		if v20 then
			v14 = clockBinding:map(function(startedAt)
				if not current.isThinking then
					return assistantLoading
				end

				if current.startedAt == nil then
					current.startedAt = startedAt
				end

				local v34 = math.max(0, startedAt - current.startedAt)

				if FFlagBuildExperiencePromptStallMessage and current2 ~= nil and assistantTakingLonger ~= nil then
					local lastProgressAt = current2.lastProgressAt or startedAt
					current2.lastProgressAt = lastProgressAt

					if startedAt - lastProgressAt >= chatConstants.PROMPT_STALL_SECONDS then
						return assistantTakingLonger
					end
				end

				local ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = chatConstants.ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS
				local v35 = assistantLoading

				if chatConstants.ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS <= v34 then
					v35 = v10:Format(LocalizationStrings.CHAT_THINKING_SECONDS, {
						SECONDS = math.max(0, (math.floor(v34)))
					})
				end

				if math.floor(v34 / ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS) % 2 == 0 then
					return v35
				end

				return assistantStillWorking
			end)
		end

		v29 = createElement(view, {
			LayoutOrder = 2,
			tag = "col fill gap-xxsmall auto-y"
		}, {
			CurrentAction = createActivitySummaryActionText(
				v14,
				1,
				props.clockBinding,
				segment.isWaitingForLocalTool ~= true
			)
		})
	else
		v29 = React.createElement(text, {
			LayoutOrder = 2,
			Text = v14,
			tag = "fill text-body-medium text-wrap text-align-x-left content-muted"
		})
	end

	local createElement = React.createElement
	local v31 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = "TurnActivitySummary"
	}

	local createElement2 = React.createElement
	local v34 = {
		LayoutOrder = 1,
		ref = ref2,
		onActivated = nil,
		stateLayer = 0,
		tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
		testId = "TurnActivitySummary.Summary"
	}

	if not v28 then
		v21 = nil
	end

	v34.onActivated = v21
	v34.stateLayer = { affordance = stateLayerAffordance.None }
	local v36

	if v28 then
		local createElement3 = React.createElement

		local v39 = if state then iconName.ChevronLargeDown else iconName.ChevronLargeRight
		v36 = createElement3(icon, {
			LayoutOrder = 1,
			name = v39,
			size = iconSize.XSmall,
			style = v19.Color.Content.Muted,
			testId = "TurnActivitySummary.Chevron"
		})
	end

	local v32 = {
		ActivitySummary = createElement2(view, v34, { Chevron = v36, Label = v29 }),
		ActivityHistory = 0
	}
	local v37

	if state and v27 and v28 then
		v37 = React.createElement(scrollView, {
			LayoutOrder = 2,
			Size = v16:map(function(value)
				return UDim2.new(1, 0, 0, (math.clamp(value, 24, 220)))
			end),
			scrollingFrameRef = v23,
			onAbsoluteCanvasSizeChanged = v24,
			onAbsoluteWindowSizeChanged = v25,
			tag = "size-full-0 clip",
			testId = "TurnActivitySummary.ActivityHistory",
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			ActivityColumn = React.createElement(
				view,
				{ tag = "col gap-xsmall size-full-0 auto-y padding-left-large" },
				v26
			)
		})
	end

	v32.ActivityHistory = v37
	return createElement(view, v31, v32)
end

return TurnActivitySummary
