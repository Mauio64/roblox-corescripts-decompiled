local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

require(Graphing.Types)
local useViewportBinding = require(Graphing.Util.useViewportBinding)
local useViewportBinding2 = useViewportBinding.useViewportBinding
local useViewportVisibility = useViewportBinding.useViewportVisibility

function Positioner(props, ref)
	if typeof(props.Position) == "Vector2" then
		local position = props.Position

		local position2 = useViewportBinding2(function(p)
			local plotToView = p.plotToView(position)
			return UDim2.fromScale(plotToView.X, plotToView.Y)
		end, { position })

		if not useViewportVisibility(function(p)
			return p.isPointInViewport(position)
		end, { position }) then
			return nil
		end

		return React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = position2,
			Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = props.ZIndex,
			ref = ref,
			[React.Tag] = props.Tag
		}, props.children)
	end

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = props.Position,
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		ref = ref,
		[React.Tag] = props.Tag
	}, props.children)
end

return React.forwardRef(Positioner)
