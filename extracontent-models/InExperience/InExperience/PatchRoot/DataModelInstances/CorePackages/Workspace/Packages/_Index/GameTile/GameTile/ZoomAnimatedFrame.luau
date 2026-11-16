local parent = script:FindFirstAncestor("GameTile").Parent
local React = require(parent.React)
local Otter = require(parent.Otter)

function ZoomAnimatedFrame(props)
	local isZoomEnabled = props.isZoomEnabled

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = Otter.createSingleMotor(0)
	end

	assert(ref.current, "zoomMotorRef should always exist; assert only needed for the linter")

	local v, v2 = React.useBinding(0)

	React.useEffect(function()
		ref.current:onStep(v2)
	end, {})

	React.useEffect(function()
		ref.current:setGoal(Otter.spring(isZoomEnabled and 1 or 0, {
			frequency = props.reducedMotion and 200 or 6.5
		}))
	end, { isZoomEnabled })

	return React.createElement("Frame", {
		Position = v:map(function(p)
			local v3 = p > 0.9 and 1 or p
			return UDim2.fromOffset(-props.expansionOffsetX * v3 / 2, -props.expansionOffsetTop * v3)
		end),
		Size = v:map(function(p)
			local v3 = p > 0.9 and 1 or p
			return UDim2.new(
				1,
				props.expansionOffsetX * v3,
				1,
				props.expansionOffsetTop * v3 + props.expansionOffsetBottom * v3
			)
		end),
		BackgroundTransparency = 1
	}, props.children)
end

return ZoomAnimatedFrame
