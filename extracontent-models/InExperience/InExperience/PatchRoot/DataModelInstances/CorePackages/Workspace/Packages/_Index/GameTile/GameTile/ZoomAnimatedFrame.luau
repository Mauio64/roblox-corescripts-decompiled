local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)
local Otter = require(Parent.Otter)

function ZoomAnimatedFrame(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), Otter (copy)
	local isZoomEnabled = t1.isZoomEnabled
	local v6 = React.useRef(nil)

	if v6.current == nil then
		v6.current = Otter.createSingleMotor(0)
	end

	assert(v6.current, "zoomMotorRef should always exist; assert only needed for the linter")

	local v7, v8 = React.useBinding(0)

	React.useEffect(function() -- line: 28
		-- upvalues: v6 (copy), v8 (copy)
		v6.current:onStep(v8)
	end, {})
	React.useEffect(function() -- line: 33
		-- upvalues: v6 (copy), Otter (copy), isZoomEnabled (copy), t1 (copy)
		v6.current:setGoal(Otter.spring(not isZoomEnabled and 0 or 1, {
			frequency = not t1.reducedMotion and 6.5 or 200
		}))
	end, { isZoomEnabled })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = v7:map(function(p1) -- line: 41
			-- upvalues: t1 (copy)
			local v10 = if not (p1 > 0.9) then p1 else 1

			return UDim2.fromOffset(-t1.expansionOffsetX * v10 / 2, -t1.expansionOffsetTop * v10)
		end),
		Size = v7:map(function(p2) -- line: 48
			-- upvalues: t1 (copy)
			local v12 = if not (p2 > 0.9) then p2 else 1

			return UDim2.new(1, t1.expansionOffsetX * v12, 1, t1.expansionOffsetTop * v12 + t1.expansionOffsetBottom * v12)
		end)
	}, t1.children)
end

return ZoomAnimatedFrame
