local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Otter")

function LUAUFORGE_MODULE_GLOBALS_bLY_ZoomAnimatedFrame(props)
	local isZoomEnabled = props.isZoomEnabled

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = Otter.createSingleMotor(0)
	end

	assert(ref.current, "zoomMotorRef should always exist; assert only needed for the linter")

	local v5, v6 = React.useBinding(0)

	React.useEffect(function()
		ref.current:onStep(v6)
	end, {})

	React.useEffect(function()
		ref.current:setGoal(Otter.spring(isZoomEnabled and 1 or 0, {
			frequency = props.reducedMotion and 200 or 6.5
		}))
	end, { isZoomEnabled })

	return React.createElement("Frame", {
		Position = v5:map(function(p2)
			local v7 = p2 > 0.9 and 1 or p2
			return UDim2.fromOffset(-props.expansionOffsetX * v7 / 2, -props.expansionOffsetTop * v7)
		end),
		Size = v5:map(function(p2)
			local v7 = p2 > 0.9 and 1 or p2
			return UDim2.new(
				1,
				props.expansionOffsetX * v7,
				1,
				props.expansionOffsetTop * v7 + props.expansionOffsetBottom * v7
			)
		end),
		BackgroundTransparency = 1
	}, props.children)
end

return LUAUFORGE_MODULE_GLOBALS_bLY_ZoomAnimatedFrame
