local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.Component:extend("CircularButton")

function extended.render(p)
	local visible

	if typeof(p.props.Transparency) == "table" then
		visible = p.props.Transparency:map(function(p2)
			return p2 < 1 and p.props.Visible
		end)
	else
		visible = p.props.Visible and p.props.Transparency < 1
	end

	return Roact.createElement("TextButton", {
		Size = UDim2.fromScale(p.props.HorizontalScale, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = p.props.Position,
		AnchorPoint = p.props.AnchorPoint,
		BackgroundColor3 = Color3.fromRGB(17, 18, 19),
		Transparency = p.props.Transparency,
		Text = "",
		Visible = visible,
		AutoButtonColor = p.props.AutoButtonColor,
		[Roact.Event.Activated] = p.props.onActivated
	}, {
		UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize
		}),
		UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		ImageLabel = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = p.props.ImageSize,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = p.props.Image,
			ImageTransparency = p.props.Transparency
		})
	})
end

return extended
