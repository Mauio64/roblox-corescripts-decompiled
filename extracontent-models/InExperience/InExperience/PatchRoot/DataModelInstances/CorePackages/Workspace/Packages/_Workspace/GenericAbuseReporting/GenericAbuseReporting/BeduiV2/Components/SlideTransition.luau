local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local SlideTransitionContext = require(GenericAbuseReporting.BeduiV2.Components.SlideTransitionContext)
local View = Foundation.View

local v = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local v2 = { inExpChatSelection = true, inExpSceneSelection = true }

local function SlidePane(props)
	local createElement = React.createElement
	local v3 = {
		tag = "size-full",
		Position = props.position,
		testId = props.withInputSink and "SlideTransitionOutgoing" or "SlideTransitionIncoming"
	}
	local v4 = {
		Content = React.createElement(View, { tag = "col size-full" }, { Page = props.content }),
		InputSink = 0
	}
	local inputSink

	if props.withInputSink then
		inputSink = React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Selectable = false,
			Active = true,
			ZIndex = 100,
			[React.Tag] = "data-testid=SlideTransitionInputSink"
		})
	end

	v4.InputSink = inputSink
	return createElement(View, v3, v4)
end

local function SlideTransition(props)
	local v3 = v2[props.nodeType] or false

	local state, setState = React.useState(false)
	local v4, v5 = React.useBinding(false)

	local ref = React.useRef({
		prevNodeId = nil,
		prevContent = nil,
		outgoing = nil,
		direction = "forward",
		needsAnimationStart = false,
		needsAnimationCancel = false,
		transitionId = 0,
		springId = 0
	})

	local v6 = React.useCallback(function()
		local current = ref.current

		if current.springId ~= current.transitionId then
			return
		end

		current.outgoing = nil
		setState(false)
		v5(false)
	end, {})

	local v7, v8 = ReactOtter.useAnimatedBinding(1, v6)

	local current = ref.current

	if current.prevNodeId ~= nil and current.prevNodeId ~= props.nodeId then
		local v9 = props.direction ~= nil

		if v3 or not (current.prevContent and v9) then
			if not v9 then
				current.outgoing = nil
				current.needsAnimationStart = false
				current.transitionId += 1
				current.springId = -1

				if state then
					current.needsAnimationCancel = true
				end
			end
		else
			current.outgoing = { nodeId = current.prevNodeId, content = current.prevContent }
			current.direction = props.direction or "forward"
			current.needsAnimationStart = true
			current.needsAnimationCancel = false

			current.transitionId += 1
			current.springId = -1
		end
	end

	if not v3 then
		current.prevNodeId = props.nodeId
		current.prevContent = props.nodeContent
	end

	React.useLayoutEffect(function()
		local current2 = ref.current

		if current2.needsAnimationCancel then
			current2.needsAnimationCancel = false
			setState(false)
			v5(false)
		end

		if current2.needsAnimationStart then
			current2.needsAnimationStart = false
			current2.springId = current2.transitionId
			setState(true)
			v5(true)
			local clone = table.clone(v)
			clone.startingValue = 0
			v8(ReactOtter.spring(1, clone))
		end
	end, { props.nodeId })

	local children = {}

	local v9 = current.outgoing ~= nil
	local needsAnimationStart = v9 and (current.needsAnimationStart or not state)

	if current.outgoing then
		local position

		if needsAnimationStart then
			position = UDim2.new(0, 0, 0, 0)
		else
			position = v7:map(function(p: number)
				local v10 = ref.current.direction == "forward" and -1 or 1
				return UDim2.new(p * v10, 0, 0, 0)
			end)
		end

		children[current.outgoing.nodeId] = React.createElement(SlidePane, {
			content = current.outgoing.content,
			position = position,
			withInputSink = true
		})
	end

	local position

	if needsAnimationStart then
		local v10 = current.direction == "forward" and 1 or -1
		position = UDim2.new(v10, 0, 0, 0)
	elseif v9 then
		position = v7:map(function(p: number)
			local v10 = ref.current.direction == "forward" and 1 or -1
			return UDim2.new((1 - p) * v10, 0, 0, 0)
		end)
	end

	children[props.nodeId] = React.createElement(SlidePane, {
		content = props.nodeContent,
		position = position,
		withInputSink = false
	})

	return React.createElement(
		SlideTransitionContext.Provider,
		{ value = v4 },
		React.createElement(View, { tag = "fill size-full-0", ClipsDescendants = true }, children)
	)
end

return React.memo(SlideTransition)
