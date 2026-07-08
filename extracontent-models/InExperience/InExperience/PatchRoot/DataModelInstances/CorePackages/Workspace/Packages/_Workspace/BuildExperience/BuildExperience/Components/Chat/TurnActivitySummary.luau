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

local function constantSource() -- line: 38
	return 0
end
local function useReactiveValue(p1) -- line: 42
	-- upvalues: React (copy), constantSource (copy), SignalsReact (copy)
	local v24 = React.useCallback(function(p2) -- line: 43
		-- upvalues: p1 (copy), constantSource (copy)
		if typeof(p1) == "function" then
			return (p1(p2))
		end

		if typeof(p2) == "function" then
			p2(constantSource)
		end

		return p1
	end, { p1 })

	return (SignalsReact.useSignalState(v24))
end
local function createThinkingGradient(p3) -- line: 56
	-- upvalues: React (copy), chatConstants (copy)
	return React.createElement("UIGradient", {
		Enabled = true,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.55),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 0.55)
		}),
		Offset = p3:map(function(n1: number) -- line: 64
			-- upvalues: chatConstants (copy)
			return Vector2.new(n1 * chatConstants.THINKING_GRADIENT_ANIMATION_SPEED % chatConstants.THINKING_GRADIENT_OFFSET - chatConstants.THINKING_GRADIENT_OFFSET / 2, 0)
		end)
	})
end
local function createActivityText(s1: string, n2: number) -- line: 74
	-- upvalues: React (copy), FoundationText (copy)
	return React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
		LayoutOrder = n2,
		Text = s1
	})
end
local function createActivityItem(p4, n3: number) -- line: 82
	-- upvalues: createActivityText (copy), turnDisplay (copy)
	if p4.kind == "thought" then
		return createActivityText(p4.text, n3)
	end

	if p4.kind == "tool_call" then
		return createActivityText(turnDisplay.getToolActivityLabel(p4), n3)
	end

	return nil
end
local function createActivitySummaryActionText(s2: string, n4: number, p5, b1: boolean?) -- line: 92
	-- upvalues: React (copy), FoundationText (copy), createThinkingGradient (copy)
	return React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-muted",
		LayoutOrder = n4,
		Text = s2,
		Size = UDim2.new(1, 0, 0, 0)
	}, if not b1 then nil else {
		ThinkingGradient = createThinkingGradient(p5)
	})
end
local function TurnActivitySummary(t2: {[any]: any}) -- line: 114
	-- upvalues: useReactiveValue (copy), t1 (copy), React (copy), Foundation (copy), FoundationText (copy), turnDisplay (copy), View (copy), createActivitySummaryActionText (copy), StateLayerAffordance (copy), Icon (copy), IconName (copy), IconSize (copy), ScrollView (copy)
	local segment = t2.segment
	local v36 = useReactiveValue(segment.label)
	local v37 = useReactiveValue(segment.activityItems or t1)
	local v38 = useReactiveValue(segment.isLoading or false)
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useBinding(0)
	local v43 = React.useRef(nil)
	local v44 = Foundation.Hooks.useTokens()
	local v45 = React.useCallback(function() -- line: 124
		-- upvalues: v40 (copy)
		v40(function(b2: boolean) -- line: 125
			return not b2
		end)
	end, {})
	local v46 = React.useCallback(function(p6) -- line: 130
		-- upvalues: v43 (copy)
		if p6 == nil then
			return
		end

		task.defer(function() -- line: 135
			-- upvalues: v43 (copy), p6 (copy)
			if v43.current ~= p6 then
				return
			end

			local v66 = math.max(0, p6.AbsoluteCanvasSize.Y - p6.AbsoluteWindowSize.Y)

			p6.CanvasPosition = Vector2.new(0, v66)
		end)
	end, {})
	local v47 = React.useCallback(function(p7) -- line: 146
		-- upvalues: v43 (copy), v46 (copy)
		v43.current = p7

		if p7 then
			v46(p7)
		end
	end, { v46 })
	local v48 = React.useCallback(function(p8) -- line: 153
		-- upvalues: v42 (copy), v46 (copy)
		v42(p8.AbsoluteCanvasSize.Y)
		v46(p8)
	end, {
		v42,
		v46
	})
	local v49 = React.useCallback(function(p9) -- line: 158
		-- upvalues: v46 (copy)
		v46(p9)
	end, { v46 })

	React.useEffect(function() -- line: 162
		-- upvalues: v46 (copy), v43 (copy)
		v46(v43.current)

		return function() -- line: 164
		end
	end, {
		v46,
		v37
	})

	local t3 = {}

	for v51, v52 in v37 do
		local v54

		if v52.kind == "thought" then
			local text = v52.text

			v54 = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
				LayoutOrder = v51,
				Text = text
			})
		elseif v52.kind == "tool_call" then
			local v55 = turnDisplay.getToolActivityLabel(v52)

			v54 = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
				LayoutOrder = v51,
				Text = v55
			})
		else
			v54 = nil
		end

		if v54 ~= nil then
			t3[if v52.kind ~= "thought" then `Tool{ v51 }` else `Thought{ v51 }`] = v54
		end
	end

	local v56 = next(t3) ~= nil
	local v57 = if not v38 then React.createElement(FoundationText, {
		LayoutOrder = 2,
		tag = "fill text-body-medium text-wrap text-align-x-left content-muted",
		Text = v36
	}) else React.createElement(View, {
		LayoutOrder = 2,
		tag = "col fill gap-xxsmall auto-y"
	}, {
		CurrentAction = createActivitySummaryActionText(v36, 1, t2.clockBinding, true)
	})

	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = "TurnActivitySummary",
		LayoutOrder = t2.LayoutOrder
	}, {
		ActivitySummary = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-xxsmall",
			testId = "TurnActivitySummary.Summary",
			onActivated = v45,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			Chevron = React.createElement(Icon, {
				LayoutOrder = 1,
				name = if not v39 then IconName.ChevronLargeRight else IconName.ChevronLargeDown,
				size = IconSize.XSmall,
				style = v44.Color.Content.Muted
			}),
			Label = v57
		}),
		ActivityHistory = if not v39 or not v56 then nil else React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "size-full-0 clip",
			testId = "TurnActivitySummary.ActivityHistory",
			Size = v41:map(function(n5: number) -- line: 213
				return UDim2.new(1, 0, 0, (math.clamp(n5, 24, 220)))
			end),
			scrollingFrameRef = v47,
			onAbsoluteCanvasSizeChanged = v48,
			onAbsoluteWindowSizeChanged = v49,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			ActivityColumn = React.createElement(View, {
				tag = "col gap-xsmall size-full-0 auto-y padding-left-large"
			}, t3)
		})
	})
end

return TurnActivitySummary
