local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

require(Graphing.Types)
local InputDetector = require(Graphing.Components.InputDetector)
local StyleUtil = require(Graphing.Util.StyleUtil)

function ScrollbarButton(props)
	return React.createElement("ImageButton", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Rotation = props.Rotation,
		Size = props.Size,
		Image = props.Image,
		BackgroundColor3 = props.Color3 or StyleUtil.SCROLLBAR_BUTTON_COLOR3,
		ZIndex = props.ZIndex
	}, {
		MouseDetector = React.createElement(InputDetector, {
			AnchorPoint = props.AnchorPoint,
			OnClick = function()
				if props.OnClick then
					props.OnClick()
				end
			end,
			OnDragMoved = function(p)
				if props.OnMoved then
					props.OnMoved(p)
				end
			end
		})
	})
end

return ScrollbarButton
