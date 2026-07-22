local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local ReactOtter = require(GenericAbuseReportingParent.ReactOtter)
local SlideTransitionContext = require(GenericAbuseReporting.BeduiV2.Components.SlideTransitionContext)
local View = Foundation.View
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}
local t2 = {
	inExpChatSelection = true,
	inExpSceneSelection = true
}

local function SlidePane(t3: {[any]: any}) -- line: 54
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "size-full",
		Position = t3.position,
		testId = not t3.withInputSink and "SlideTransitionIncoming" or "SlideTransitionOutgoing"
	}, {
		Content = React.createElement(View, {
			tag = "col size-full"
		}, {
			Page = t3.content
		}),
		InputSink = if not t3.withInputSink then nil else React.createElement("TextButton", {
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
	})
end
local function SlideTransition(t4: {[any]: any}) -- line: 98
	-- upvalues: t2 (copy), React (copy), ReactOtter (copy), t1 (copy), SlidePane (copy), SlideTransitionContext (copy), View (copy)
	local v14 = t2[t4.nodeType] or false
	local v15, v16 = React.useState(false)
	local v17, v18 = React.useBinding(false)
	local v19 = React.useRef({
		prevNodeId = nil,
		prevContent = nil,
		outgoing = nil,
		direction = "forward",
		needsAnimationStart = false,
		needsAnimationCancel = false,
		transitionId = 0,
		springId = 0
	})
	local v20 = React.useCallback(function() -- line: 120
		-- upvalues: v19 (copy), v16 (copy), v18 (copy)
		local current = v19.current

		if current.springId ~= current.transitionId then
			return
		end

		current.outgoing = nil
		v16(false)
		v18(false)
	end, {})
	local v21, v22 = ReactOtter.useAnimatedBinding(1, v20)
	local current = v19.current

	if current.prevNodeId ~= nil and current.prevNodeId ~= t4.nodeId then
		local v24 = v14 and true
		local v25 = t4.direction ~= nil

		if not v24 and current.prevContent and v25 then
			current.outgoing = {
				nodeId = current.prevNodeId,
				content = current.prevContent
			}
			current.direction = t4.direction or "forward"
			current.needsAnimationStart = true
			current.needsAnimationCancel = false
			current.transitionId = current.transitionId + 1
			current.springId = -1
		elseif not v25 then
			current.outgoing = nil
			current.needsAnimationStart = false
			current.transitionId = current.transitionId + 1
			current.springId = -1

			if v15 then
				current.needsAnimationCancel = true
			end
		end
	end

	if not v14 then
		current.prevNodeId = t4.nodeId
		current.prevContent = t4.nodeContent
	end

	React.useLayoutEffect(function() -- line: 166
		-- upvalues: v19 (copy), v16 (copy), v18 (copy), t1 (copy), v22 (copy), ReactOtter (copy)
		local current2 = v19.current

		if current2.needsAnimationCancel then
			current2.needsAnimationCancel = false
			v16(false)
			v18(false)
		end

		if current2.needsAnimationStart then
			current2.needsAnimationStart = false
			current2.springId = current2.transitionId
			v16(true)
			v18(true)

			local v34 = table.clone(t1)

			v34.startingValue = 0
			v22(ReactOtter.spring(1, v34))
		end
	end, { t4.nodeId })

	local t5 = {}
	local v27 = current.outgoing ~= nil
	local v28 = v27 and (current.needsAnimationStart or not v15)

	if current.outgoing then
		local v29 = if not v28 then v21:map(function(n1: number) -- line: 197
			-- upvalues: v19 (copy)
			local v36 = v19.current.direction ~= "forward" and 1 or -1

			return UDim2.new(n1 * v36, 0, 0, 0)
		end) else UDim2.new(0, 0, 0, 0)

		t5[current.outgoing.nodeId] = React.createElement(SlidePane, {
			withInputSink = true,
			content = current.outgoing.content,
			position = v29
		})
	end

	local uDim2

	if v28 then
		local v30 = current.direction ~= "forward" and -1 or 1

		uDim2 = UDim2.new(v30, 0, 0, 0)
	else
		uDim2 = if not v27 then nil else v21:map(function(n2: number) -- line: 214
			-- upvalues: v19 (copy)
			local v38 = v19.current.direction ~= "forward" and -1 or 1

			return UDim2.new((1 - n2) * v38, 0, 0, 0)
		end)
	end

	t5[t4.nodeId] = React.createElement(SlidePane, {
		withInputSink = false,
		content = t4.nodeContent,
		position = uDim2
	})

	return React.createElement(SlideTransitionContext.Provider, {
		value = v17
	}, React.createElement(View, {
		tag = "fill size-full-0",
		ClipsDescendants = true
	}, t5))
end

return React.memo(SlideTransition)
