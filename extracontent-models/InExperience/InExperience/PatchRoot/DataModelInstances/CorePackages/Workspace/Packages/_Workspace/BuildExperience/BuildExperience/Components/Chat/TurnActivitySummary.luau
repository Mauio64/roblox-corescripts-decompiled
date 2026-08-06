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

local function constantSource() -- line: 41
	return 0
end
local function useReactiveValue(p1) -- line: 45
	-- upvalues: React (copy), constantSource (copy), SignalsReact (copy)
	local v25 = React.useCallback(function(p2) -- line: 46
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
local function createThinkingGradient(p3, b1: boolean) -- line: 59
	-- upvalues: React (copy), chatConstants (copy)
	return React.createElement("UIGradient", {
		Enabled = b1,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.55),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 0.55)
		}),
		Offset = p3:map(function(n1: number) -- line: 67
			-- upvalues: chatConstants (copy)
			return Vector2.new(n1 * chatConstants.THINKING_GRADIENT_ANIMATION_SPEED % chatConstants.THINKING_GRADIENT_OFFSET - chatConstants.THINKING_GRADIENT_OFFSET / 2, 0)
		end)
	})
end
local function createActivityText(s1: string, n2: number) -- line: 77
	-- upvalues: React (copy), FoundationText (copy)
	return React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
		LayoutOrder = n2,
		Text = s1
	})
end
local function createActivityItem(p4, n3: number) -- line: 85
	-- upvalues: createActivityText (copy), turnDisplay (copy)
	if p4.kind == "tool_call" then
		return createActivityText(turnDisplay.getToolActivityLabel(p4), n3)
	end

	return nil
end
local function createActivitySummaryActionText(p5, n4: number, p6, b2: boolean) -- line: 93
	-- upvalues: React (copy), FoundationText (copy), createThinkingGradient (copy)
	return React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-muted",
		LayoutOrder = n4,
		Text = p5,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		ThinkingGradient = createThinkingGradient(p6, b2)
	})
end
local function getActivitySummaryActionText(s2: string, p7, t2: {[any]: any}) -- line: 109
	-- upvalues: chatConstants (copy)
	if s2 ~= chatConstants.ASSISTANT_LOADING_TEXT then
		return s2
	end

	return p7:map(function(n5: number) -- line: 118
		-- upvalues: t2 (copy), chatConstants (copy)
		if not t2.isThinking then
			return chatConstants.ASSISTANT_LOADING_TEXT
		end

		if t2.startedAt == nil then
			t2.startedAt = n5
		end

		local v76 = math.max(0, n5 - t2.startedAt)
		local ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = chatConstants.ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS
		local v78 = if not (v76 >= chatConstants.ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS) then chatConstants.ASSISTANT_LOADING_TEXT else chatConstants.formatAssistantLoadingText(v76)

		if math.floor(v76 / ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS) % 2 == 0 then
			return v78
		end

		return chatConstants.ASSISTANT_STILL_WORKING_TEXT
	end)
end
local function TurnActivitySummary(t3: {[any]: any}) -- line: 136
	-- upvalues: useReactiveValue (copy), t1 (copy), React (copy), Foundation (copy), chatConstants (copy), turnDisplay (copy), FoundationText (copy), View (copy), createActivitySummaryActionText (copy), StateLayerAffordance (copy), Icon (copy), IconName (copy), IconSize (copy), ScrollView (copy)
	local segment = t3.segment
	local v41 = useReactiveValue(segment.label)
	local v42 = useReactiveValue(segment.activityItems or t1)
	local v43 = useReactiveValue(segment.isLoading or false)
	local v44, v45 = React.useState(false)
	local v46, v47 = React.useBinding(0)
	local v48 = React.useRef(nil)
	local v49 = React.useRef({
		isThinking = false,
		startedAt = nil
	})
	local v50 = Foundation.Hooks.useTokens()
	local v51 = v41 == chatConstants.ASSISTANT_LOADING_TEXT
	local current = v49.current

	if v51 ~= current.isThinking then
		current.isThinking = v51
		current.startedAt = nil
	end

	local v53 = React.useCallback(function() -- line: 157
		-- upvalues: v45 (copy)
		v45(function(b3: boolean) -- line: 158
			return not b3
		end)
	end, {})
	local v54 = React.useCallback(function(p8) -- line: 163
		-- upvalues: v48 (copy)
		if p8 == nil then
			return
		end

		task.defer(function() -- line: 168
			-- upvalues: v48 (copy), p8 (copy)
			if v48.current ~= p8 then
				return
			end

			local v89 = math.max(0, p8.AbsoluteCanvasSize.Y - p8.AbsoluteWindowSize.Y)

			p8.CanvasPosition = Vector2.new(0, v89)
		end)
	end, {})
	local v55 = React.useCallback(function(p9) -- line: 179
		-- upvalues: v48 (copy), v54 (copy)
		v48.current = p9

		if p9 then
			v54(p9)
		end
	end, { v54 })
	local v56 = React.useCallback(function(p10) -- line: 186
		-- upvalues: v47 (copy), v54 (copy)
		v47(p10.AbsoluteCanvasSize.Y)
		v54(p10)
	end, {
		v47,
		v54
	})
	local v57 = React.useCallback(function(p11) -- line: 191
		-- upvalues: v54 (copy)
		v54(p11)
	end, { v54 })

	React.useEffect(function() -- line: 195
		-- upvalues: v54 (copy), v48 (copy)
		v54(v48.current)

		return function() -- line: 197
		end
	end, {
		v54,
		v42
	})

	local t4 = {}
	local n6 = 0

	for v60, v61 in v42 do
		local v63

		if v61.kind == "tool_call" then
			local v62 = turnDisplay.getToolActivityLabel(v61)

			v63 = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
				LayoutOrder = v60,
				Text = v62
			})
		else
			v63 = nil
		end

		if v63 ~= nil then
			t4[`Tool{ v60 }`] = v63
			n6 += 1
		end
	end

	local v64 = next(t4) ~= nil
	local v65 = n6 > 1
	local v72

	if v43 then
		local createElement = React.createElement
		local v67 = View
		local t5 = {
			LayoutOrder = 2,
			tag = "col fill gap-xxsmall auto-y"
		}
		local t6 = {}
		local v70 = createActivitySummaryActionText
		local clockBinding = t3.clockBinding

		t6.CurrentAction = v70(if v41 == chatConstants.ASSISTANT_LOADING_TEXT then clockBinding:map(function(n7: number) -- line: 118
			-- upvalues: current (copy), chatConstants (copy)
			if not current.isThinking then
				return chatConstants.ASSISTANT_LOADING_TEXT
			end

			if current.startedAt == nil then
				current.startedAt = n7
			end

			local v84 = math.max(0, n7 - current.startedAt)
			local ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = chatConstants.ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS
			local v86 = if not (v84 >= chatConstants.ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS) then chatConstants.ASSISTANT_LOADING_TEXT else chatConstants.formatAssistantLoadingText(v84)

			if math.floor(v84 / ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS) % 2 == 0 then
				return v86
			end

			return chatConstants.ASSISTANT_STILL_WORKING_TEXT
		end) else v41, 1, t3.clockBinding, segment.isWaitingForLocalTool ~= true)
		v72 = createElement(v67, t5, t6)
	else
		v72 = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "fill text-body-medium text-wrap text-align-x-left content-muted",
			Text = v41
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
			onActivated = if not v65 then nil else v53,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			Chevron = if not v65 then nil else React.createElement(Icon, {
				LayoutOrder = 1,
				testId = "TurnActivitySummary.Chevron",
				name = if not v44 then IconName.ChevronLargeRight else IconName.ChevronLargeDown,
				size = IconSize.XSmall,
				style = v50.Color.Content.Muted
			}),
			Label = v72
		}),
		ActivityHistory = if not v44 or (not v64 or not v65) then nil else React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "size-full-0 clip",
			testId = "TurnActivitySummary.ActivityHistory",
			Size = v46:map(function(n8: number) -- line: 258
				return UDim2.new(1, 0, 0, (math.clamp(n8, 24, 220)))
			end),
			scrollingFrameRef = v55,
			onAbsoluteCanvasSizeChanged = v56,
			onAbsoluteWindowSizeChanged = v57,
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
