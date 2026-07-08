local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local FitFrameVertical = require(script.Parent.Parent.FitFrameVertical)
local v6 = Roact.Component:extend("AlertView")

v6.defaultProps = {
	Visible = false,
	contentPaddingLeft = 12,
	contentPaddingRight = 12,
	contentPaddingTop = 12,
	contentPaddingBottom = 12,
	width = UDim.new(0.5, 0)
}

function v6.render(p1) -- line: 18
	-- upvalues: UIBlox (copy), Roact (copy), FitFrameVertical (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 19
		-- upvalues: Roact (copy), FitFrameVertical (copy), p1 (copy)
		return Roact.createElement(FitFrameVertical, {
			Visible = p1.props.Visible,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			width = p1.props.width
		}, {
			InnerFrame = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				margin = {
					top = p1.props.contentPaddingTop,
					bottom = p1.props.contentPaddingBottom,
					left = p1.props.contentPaddingLeft,
					right = p1.props.contentPaddingRight
				},
				width = UDim.new(1, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}, p1.props[Roact.Children])
		})
	end)
end

return v6
