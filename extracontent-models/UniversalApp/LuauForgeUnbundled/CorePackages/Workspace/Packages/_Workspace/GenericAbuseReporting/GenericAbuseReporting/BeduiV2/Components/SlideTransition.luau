local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactOtter")

local SlideTransitionContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/SlideTransitionContext")
local view = Foundation.View

local v5 = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local v6 = { inExpChatSelection = true, inExpSceneSelection = true }

local function SlidePane(props)
	local createElement = React.createElement
	local v8 = {
		tag = "size-full",
		Position = props.position,
		testId = props.withInputSink and "SlideTransitionOutgoing" or "SlideTransitionIncoming"
	}
	local v9 = {
		Content = React.createElement(view, { tag = "col size-full" }, {
			Page = props.content
		}),
		InputSink = 0
	}
	local v10

	if props.withInputSink then
		v10 = React.createElement("TextButton", {
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

	v9.InputSink = v10
	return createElement(view, v8, v9)
end

local function SlideTransition(props)
	local v7 = v6[props.nodeType] or false

	local state, setState = React.useState(false)
	local v8, v9 = React.useBinding(false)

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

	local v10 = React.useCallback(function()
		local current = ref.current

		if current.springId ~= current.transitionId then
			return
		end

		current.outgoing = nil
		setState(false)
		v9(false)
	end, {})

	local v11, v12 = ReactOtter.useAnimatedBinding(1, v10)

	local current = ref.current

	if current.prevNodeId ~= nil and current.prevNodeId ~= props.nodeId then
		local v13 = props.direction ~= nil

		if v7 or not (current.prevContent and v13) then
			if not v13 then
				current.outgoing = nil
				current.needsAnimationStart = false
				current.transitionId += 1
				current.springId = -1

				if state then
					current.needsAnimationCancel = true
				end
			end
		else
			current.outgoing = {
				nodeId = current.prevNodeId,
				content = current.prevContent
			}
			current.direction = props.direction or "forward"
			current.needsAnimationStart = true
			current.needsAnimationCancel = false

			current.transitionId += 1
			current.springId = -1
		end
	end

	if not v7 then
		current.prevNodeId = props.nodeId
		current.prevContent = props.nodeContent
	end

	React.useLayoutEffect(function()
		local current2 = ref.current

		if current2.needsAnimationCancel then
			current2.needsAnimationCancel = false
			setState(false)
			v9(false)
		end

		if current2.needsAnimationStart then
			current2.needsAnimationStart = false
			current2.springId = current2.transitionId
			setState(true)
			v9(true)
			local clone = table.clone(v5)
			clone.startingValue = 0
			v12(ReactOtter.spring(1, clone))
		end
	end, { props.nodeId })

	local children = {}

	local v13 = current.outgoing ~= nil
	local needsAnimationStart = v13 and (current.needsAnimationStart or not state)

	if current.outgoing then
		local v14

		if needsAnimationStart then
			v14 = UDim2.new(0, 0, 0, 0)
		else
			v14 = v11:map(function(p2)
				local v15 = ref.current.direction == "forward" and -1 or 1
				return UDim2.new(p2 * v15, 0, 0, 0)
			end)
		end

		children[current.outgoing.nodeId] = React.createElement(SlidePane, {
			content = current.outgoing.content,
			position = v14,
			withInputSink = true
		})
	end

	local v14

	if needsAnimationStart then
		local v15 = current.direction == "forward" and 1 or -1
		v14 = UDim2.new(v15, 0, 0, 0)
	elseif v13 then
		v14 = v11:map(function(p2)
			local v15 = ref.current.direction == "forward" and 1 or -1
			return UDim2.new((1 - p2) * v15, 0, 0, 0)
		end)
	end

	children[props.nodeId] = React.createElement(SlidePane, {
		content = props.nodeContent,
		position = v14,
		withInputSink = false
	})

	return React.createElement(
		SlideTransitionContext.Provider,
		{ value = v8 },
		React.createElement(view, {
			tag = "fill size-full-0",
			ClipsDescendants = true
		}, children)
	)
end

return React.memo(SlideTransition)
