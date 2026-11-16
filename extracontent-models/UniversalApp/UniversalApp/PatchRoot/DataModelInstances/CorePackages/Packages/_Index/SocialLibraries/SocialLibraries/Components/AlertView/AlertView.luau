local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local FitFrameVertical = require(script.Parent.Parent.FitFrameVertical)

local extended = roact.Component:extend("AlertView")

extended.defaultProps = {
	Visible = false,
	width = UDim.new(0.5, 0),
	contentPaddingLeft = 12,
	contentPaddingRight = 12,
	contentPaddingTop = 12,
	contentPaddingBottom = 12
}

function extended.render(p)
	return uiBlox.Style.withStyle(function(p2)
		return roact.createElement(FitFrameVertical, {
			Visible = p.props.Visible,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			width = p.props.width
		}, {
			InnerFrame = roact.createElement(FitFrameVertical, {
				margin = {
					top = p.props.contentPaddingTop,
					bottom = p.props.contentPaddingBottom,
					left = p.props.contentPaddingLeft,
					right = p.props.contentPaddingRight
				},
				width = UDim.new(1, 0),
				BackgroundTransparency = 1,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}, p.props[roact.Children])
		})
	end)
end

return extended
