local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

local StyleUtil = require(Graphing.Util.StyleUtil)
require(Graphing.Types)
local useViewportBinding = require(Graphing.Util.useViewportBinding)
local useViewportBinding2 = useViewportBinding.useViewportBinding
local useViewportVisibility = useViewportBinding.useViewportVisibility

function Panel(props)
	local v = useViewportBinding2(function(p)
		local plotToView = p.plotToView(props.Rect.Min)
		local plotToView2 = p.plotToView(props.Rect.Max)
		return {
			position = UDim2.fromScale(plotToView.X, plotToView.Y),
			size = UDim2.fromScale(plotToView2.X - plotToView.X, plotToView2.Y - plotToView.Y)
		}
	end, { props.Rect })

	if not useViewportVisibility(function(p)
		return p.isRectInViewport(props.Rect)
	end, { props.Rect }) then
		return nil
	end

	if props.Image then
		return React.createElement("ImageLabel", {
			Position = v:map(function(p)
				return p.position
			end),
			Size = v:map(function(p)
				return p.size
			end),
			Image = props.Image,
			ImageColor3 = props.ImageColor3,
			ImageTransparency = props.ImageTransparency,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = props.ZIndex,
			[React.Tag] = props.Tag
		}, props.children)
	end

	return React.createElement("Frame", {
		Position = v:map(function(p)
			return p.position
		end),
		Size = v:map(function(p)
			return p.size
		end),
		BackgroundColor3 = props.BackgroundColor3 or StyleUtil.GRID_BOX_BACKGROUND_COLOR3,
		BackgroundTransparency = props.BackgroundTransparency or StyleUtil.GRID_BOX_BACKGROUND_TRANSPARENCY,
		BorderColor3 = props.BorderColor3 or StyleUtil.GRID_BOX_BORDER_COLOR3,
		BorderSizePixel = props.BorderThickness or StyleUtil.GRID_BOX_BORDER_THICKNESS,
		ZIndex = props.ZIndex,
		[React.Tag] = props.Tag
	}, props.children)
end

return Panel
