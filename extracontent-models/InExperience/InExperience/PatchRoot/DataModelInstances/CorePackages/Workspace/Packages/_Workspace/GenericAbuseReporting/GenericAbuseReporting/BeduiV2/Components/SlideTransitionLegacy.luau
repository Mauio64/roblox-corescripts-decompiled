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

local function SlideTransitionLegacy(t3: {[any]: any}) -- line: 49
	-- upvalues: t2 (copy), React (copy), ReactOtter (copy), t1 (copy), View (copy), SlideTransitionContext (copy)
	local v12 = t2[t3.nodeType] or false
	local v13, v14 = React.useState(false)
	local v15, v16 = React.useBinding(false)
	local v17 = React.useRef({
		prevNodeId = nil,
		prevContent = nil,
		outgoing = nil,
		direction = "forward",
		needsAnimationStart = false
	})
	local v18 = React.useCallback(function() -- line: 66
		-- upvalues: v17 (copy), v14 (copy), v16 (copy)
		v17.current.outgoing = nil
		v14(false)
		v16(false)
	end, {})
	local v19, v20 = ReactOtter.useAnimatedBinding(1, v18)
	local current = v17.current

	if current.prevNodeId ~= nil and current.prevNodeId ~= t3.nodeId then
		local v22 = v12 and true
		local v23 = t3.direction ~= nil

		if not v22 and current.prevContent and v23 then
			current.outgoing = {
				nodeId = current.prevNodeId,
				content = current.prevContent
			}
			current.direction = t3.direction or "forward"
			current.needsAnimationStart = true
		end
	end

	if not v12 then
		current.prevNodeId = t3.nodeId
		current.prevContent = t3.nodeContent
	end

	React.useLayoutEffect(function() -- line: 94
		-- upvalues: v17 (copy), v14 (copy), v16 (copy), t1 (copy), v20 (copy), ReactOtter (copy)
		if v17.current.needsAnimationStart then
			v17.current.needsAnimationStart = false
			v14(true)
			v16(true)

			local v25 = table.clone(t1)

			v25.startingValue = 0
			v20(ReactOtter.spring(1, v25))
		end
	end, { t3.nodeId })

	local t4 = {}

	if current.outgoing then
		t4[current.outgoing.nodeId] = React.createElement(View, {
			tag = "col size-full",
			Position = if not v13 then nil else v19:map(function(n1: number) -- line: 111
				-- upvalues: v17 (copy)
				local v27 = v17.current.direction ~= "forward" and 1 or -1

				return UDim2.new(n1 * v27, 0, 0, 0)
			end)
		}, {
			Content = current.outgoing.content
		})
	end

	t4[t3.nodeId] = React.createElement(View, {
		tag = "col size-full",
		Position = if not v13 then nil else v19:map(function(n2: number) -- line: 122
			-- upvalues: v17 (copy)
			local v29 = v17.current.direction ~= "forward" and -1 or 1

			return UDim2.new((1 - n2) * v29, 0, 0, 0)
		end)
	}, {
		Content = t3.nodeContent
	})

	return React.createElement(SlideTransitionContext.Provider, {
		value = v15
	}, React.createElement(View, {
		tag = "fill size-full-0",
		ClipsDescendants = true
	}, t4))
end

return React.memo(SlideTransitionLegacy)
