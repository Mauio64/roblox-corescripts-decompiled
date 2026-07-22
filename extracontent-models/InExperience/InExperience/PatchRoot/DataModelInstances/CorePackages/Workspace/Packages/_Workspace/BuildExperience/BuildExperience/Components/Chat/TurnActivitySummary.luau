local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)

require(BuildExperience.Chat.chatTypes)

local chatConstants = require(BuildExperience.Chat.chatConstants)
local turnDisplay = require(BuildExperience.Chat.turnDisplay)
local Icon = Foundation.Icon
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local t1 = {}

local function constantSource() -- line: 43
	return 0
end
local function useReactiveValue(p1) -- line: 47
	-- upvalues: React (copy), constantSource (copy), SignalsReact (copy)
	local v25 = React.useCallback(function(p2) -- line: 48
		-- upvalues: p1 (copy), constantSource (copy)
		if typeof(p1) == "function" then
			return (p1(p2))
		end

		if typeof(p2) == "function" then
			p2(constantSource)
		end

		return p1
	end, { p1 })

	return (SignalsReact.useSignalState(v25))
end
local function createThinkingGradient(p3) -- line: 61
	-- upvalues: React (copy), chatConstants (copy)
	return React.createElement("UIGradient", {
		Enabled = true,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.55),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 0.55)
		}),
		Offset = p3:map(function(n1: number) -- line: 69
			-- upvalues: chatConstants (copy)
			return Vector2.new(n1 * chatConstants.THINKING_GRADIENT_ANIMATION_SPEED % chatConstants.THINKING_GRADIENT_OFFSET - chatConstants.THINKING_GRADIENT_OFFSET / 2, 0)
		end)
	})
end
local function createActivityText(s1: string, n2: number) -- line: 79
	-- upvalues: React (copy), FoundationText (copy)
	return React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
		LayoutOrder = n2,
		Text = s1
	})
end
local function createActivityItem(p4, n3: number) -- line: 87
	-- upvalues: createActivityText (copy), turnDisplay (copy)
	if p4.kind == "tool_call" then
		return createActivityText(turnDisplay.getToolActivityLabel(p4), n3)
	end

	return nil
end
local function createActivitySummaryActionText(p5, n4: number, p6, b1: boolean?) -- line: 95
	-- upvalues: React (copy), FoundationText (copy), createThinkingGradient (copy)
	return React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-muted",
		LayoutOrder = n4,
		Text = p5,
		Size = UDim2.new(1, 0, 0, 0)
	}, if not b1 then nil else {
		ThinkingGradient = createThinkingGradient(p6)
	})
end
local function getActivitySummaryActionText(s2: string, p7, t2: {[any]: any}) -- line: 117
	-- upvalues: chatConstants (copy)
	if s2 ~= chatConstants.ASSISTANT_LOADING_TEXT then
		return s2
	end

	return p7:map(function(n5: number) -- line: 126
		-- upvalues: t2 (copy), chatConstants (copy)
		if not t2.isThinking then
			return chatConstants.ASSISTANT_LOADING_TEXT
		end

		if t2.startedAt == nil then
			t2.startedAt = n5
		end

		local v73 = math.max(0, n5 - t2.startedAt)
		local ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = chatConstants.ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS
		local v75 = if not (v73 >= chatConstants.ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS) then chatConstants.ASSISTANT_LOADING_TEXT else chatConstants.formatAssistantLoadingText(v73)

		if math.floor(v73 / ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS) % 2 == 0 then
			return v75
		end

		return chatConstants.ASSISTANT_STILL_WORKING_TEXT
	end)
end
local function TurnActivitySummary(t3: {[any]: any}) -- line: 144
	-- upvalues: useReactiveValue (copy), t1 (copy), React (copy), Foundation (copy), chatConstants (copy), turnDisplay (copy), FoundationText (copy), View (copy), createActivitySummaryActionText (copy), StateLayerAffordance (copy), Icon (copy), IconName (copy), IconSize (copy), ScrollView (copy)
	local segment = t3.segment
	local v40 = useReactiveValue(segment.label)
	local v41 = useReactiveValue(segment.activityItems or t1)
	local v42 = useReactiveValue(segment.isLoading or false)
	local v43, v44 = React.useState(false)
	local v45, v46 = React.useBinding(0)
	local v47 = React.useRef(nil)
	local v48 = React.useRef({
		isThinking = false,
		startedAt = nil
	})
	local v49 = Foundation.Hooks.useTokens()
	local v50 = v40 == chatConstants.ASSISTANT_LOADING_TEXT
	local current = v48.current

	if v50 ~= current.isThinking then
		current.isThinking = v50
		current.startedAt = nil
	end

	local v52 = React.useCallback(function() -- line: 165
		-- upvalues: v44 (copy)
		v44(function(b2: boolean) -- line: 166
			return not b2
		end)
	end, {})
	local v53 = React.useCallback(function(p8) -- line: 171
		-- upvalues: v47 (copy)
		if p8 == nil then
			return
		end

		task.defer(function() -- line: 176
			-- upvalues: v47 (copy), p8 (copy)
			if v47.current ~= p8 then
				return
			end

			local v86 = math.max(0, p8.AbsoluteCanvasSize.Y - p8.AbsoluteWindowSize.Y)

			p8.CanvasPosition = Vector2.new(0, v86)
		end)
	end, {})
	local v54 = React.useCallback(function(p9) -- line: 187
		-- upvalues: v47 (copy), v53 (copy)
		v47.current = p9

		if p9 then
			v53(p9)
		end
	end, { v53 })
	local v55 = React.useCallback(function(p10) -- line: 194
		-- upvalues: v46 (copy), v53 (copy)
		v46(p10.AbsoluteCanvasSize.Y)
		v53(p10)
	end, {
		v46,
		v53
	})
	local v56 = React.useCallback(function(p11) -- line: 199
		-- upvalues: v53 (copy)
		v53(p11)
	end, { v53 })

	React.useEffect(function() -- line: 203
		-- upvalues: v53 (copy), v47 (copy)
		v53(v47.current)

		return function() -- line: 205
		end
	end, {
		v53,
		v41
	})

	local t4 = {}

	for v58, v59 in v41 do
		local v61

		if v59.kind == "tool_call" then
			local v60 = turnDisplay.getToolActivityLabel(v59)

			v61 = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
				LayoutOrder = v58,
				Text = v60
			})
		else
			v61 = nil
		end

		if v61 ~= nil then
			t4[`Tool{ v58 }`] = v61
		end
	end

	local v62 = next(t4) ~= nil
	local v69

	if v42 then
		local createElement = React.createElement
		local v64 = View
		local t5 = {
			LayoutOrder = 2,
			tag = "col fill gap-xxsmall auto-y"
		}
		local t6 = {}
		local v67 = createActivitySummaryActionText
		local clockBinding = t3.clockBinding

		t6.CurrentAction = v67(if v40 == chatConstants.ASSISTANT_LOADING_TEXT then clockBinding:map(function(n6: number) -- line: 126
			-- upvalues: current (copy), chatConstants (copy)
			if not current.isThinking then
				return chatConstants.ASSISTANT_LOADING_TEXT
			end

			if current.startedAt == nil then
				current.startedAt = n6
			end

			local v81 = math.max(0, n6 - current.startedAt)
			local ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = chatConstants.ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS
			local v83 = if not (v81 >= chatConstants.ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS) then chatConstants.ASSISTANT_LOADING_TEXT else chatConstants.formatAssistantLoadingText(v81)

			if math.floor(v81 / ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS) % 2 == 0 then
				return v83
			end

			return chatConstants.ASSISTANT_STILL_WORKING_TEXT
		end) else v40, 1, t3.clockBinding, true)
		v69 = createElement(v64, t5, t6)
	else
		v69 = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "fill text-body-medium text-wrap text-align-x-left content-muted",
			Text = v40
		})
	end

	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = "TurnActivitySummary",
		LayoutOrder = t3.LayoutOrder
	}, {
		ActivitySummary = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
			testId = "TurnActivitySummary.Summary",
			onActivated = v52,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			Chevron = React.createElement(Icon, {
				LayoutOrder = 1,
				name = if not v43 then IconName.ChevronLargeRight else IconName.ChevronLargeDown,
				size = IconSize.XSmall,
				style = v49.Color.Content.Muted
			}),
			Label = v69
		}),
		ActivityHistory = if not v43 or not v62 then nil else React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "size-full-0 clip",
			testId = "TurnActivitySummary.ActivityHistory",
			Size = v45:map(function(n7: number) -- line: 258
				return UDim2.new(1, 0, 0, (math.clamp(n7, 24, 220)))
			end),
			scrollingFrameRef = v54,
			onAbsoluteCanvasSizeChanged = v55,
			onAbsoluteWindowSizeChanged = v56,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			ActivityColumn = React.createElement(View, {
				tag = "col gap-xsmall size-full-0 auto-y padding-left-large"
			}, t4)
		})
	})
end

return TurnActivitySummary
