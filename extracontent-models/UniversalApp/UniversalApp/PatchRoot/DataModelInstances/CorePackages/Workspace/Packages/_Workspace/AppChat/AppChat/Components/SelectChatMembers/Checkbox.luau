local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local v6 = Roact.PureComponent:extend("Checkbox")

v6.defaultProps = {
	activated = false
}

function v6.render(p1) -- line: 17
	-- upvalues: UIBlox (copy), Roact (copy), ImageSetLabel (copy), Images (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 18
		-- upvalues: Roact (copy), ImageSetLabel (copy), p1 (copy), Images (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 64, 1, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			image = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 20, 0, 20),
				Image = if not p1.props.activated then Images["squircles/hollow"] else Images["squircles/fill"],
				ImageColor3 = if not p1.props.activated then p2.Theme.IconEmphasis.Color else p2.Tokens.Color.System.Emphasis.Color3,
				ImageTransparency = if not p1.props.activated then p2.Theme.IconEmphasis.Transparency else 0
			}, {
				FillImage = if not p1.props.activated then nil else Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.fromOffset(16, 16),
					Image = Images["icons/status/success_small"]
				})
			})
		})
	end)
end

return v6
