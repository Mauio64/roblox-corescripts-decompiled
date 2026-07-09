local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local ImageSetLabel = require(ParentParent.UIBlox).Core.ImageSet.ImageSetLabel
local v4 = Roact.Component:extend("CircularButton")

function v4.render(p1) -- line: 10
	-- upvalues: Roact (copy), ImageSetLabel (copy)
	local v6 = if typeof(p1.props.Transparency) ~= "table" then p1.props.Visible and p1.props.Transparency < 1 else p1.props.Transparency:map(function(p2) -- line: 13
		-- upvalues: p1 (copy)
		return p2 < 1 and p1.props.Visible
	end)

	return Roact.createElement("TextButton", {
		Size = UDim2.fromScale(p1.props.HorizontalScale, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = p1.props.Position,
		AnchorPoint = p1.props.AnchorPoint,
		BackgroundColor3 = Color3.fromRGB(17, 18, 19),
		Transparency = p1.props.Transparency,
		Text = "",
		Visible = v6,
		AutoButtonColor = p1.props.AutoButtonColor,
		[Roact.Event.Activated] = p1.props.onActivated
	}, {
		UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize
		}),
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		ImageLabel = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = p1.props.ImageSize,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = p1.props.Image,
			ImageTransparency = p1.props.Transparency
		})
	})
end

return v4
