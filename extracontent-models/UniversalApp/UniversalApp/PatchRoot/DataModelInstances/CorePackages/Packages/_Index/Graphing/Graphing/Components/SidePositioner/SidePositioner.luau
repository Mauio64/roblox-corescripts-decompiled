local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

local Types = require(Graphing.Types)
local useViewportBinding = require(Graphing.Util.useViewportBinding)
local useViewportBinding2 = useViewportBinding.useViewportBinding
local useViewportVisibility = useViewportBinding.useViewportVisibility

local function isX(side): boolean -- 2 equivalent calls inferred from this helper
	return side == Types.SIDE_TOP or side == Types.SIDE_BOTTOM
end

function SidePositioner(props)
	local position = useViewportBinding2(function(p)
		local v = 0
		local v2 = 0

		if isX(props.Side) then -- inferred equivalent call
			v = p.plotToViewX(props.Position)

			if props.Side == Types.SIDE_BOTTOM then
				v2 = 1
			end
		else
			v2 = p.plotToViewY(props.Position)

			if props.Side == Types.SIDE_RIGHT then
				v = 1
			end
		end

		return UDim2.fromScale(v, v2)
	end, { props.Side, props.Position })

	if useViewportVisibility(function(p)
		if isX(props.Side) then -- inferred equivalent call
			return (p.isPointInViewportX(props.Position))
		end

		return (p.isPointInViewportY(props.Position))
	end, { props.Side, props.Position }) then
		return React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = position,
			Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = props.ZIndex
		}, props.children)
	end

	return nil
end

return SidePositioner
