local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent

local Constants = require(parent.Constants)

local extended = Roact.PureComponent:extend("SelectionGradient")

function extended.render(p)
	local layout = Constants.Layouts[p.props.layout]

	local focusedSegmentIndex = p.props.emotesWheel.focusedSegmentIndex
	local rotation = 360 / Constants.EmotesPerPage * (focusedSegmentIndex - 1) + Constants.SegmentsStartRotation

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Rotation = rotation,
		Visible = focusedSegmentIndex ~= 0
	}, {
		SelectedGradient = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.5, 0, 1, 0),
			BackgroundTransparency = 1,
			ImageTransparency = Constants.GradientTransparency,
			Image = layout.SelectedGradient,
			ZIndex = 2
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = layout.SelectedGradientImageSize.X / layout.SelectedGradientImageSize.Y
			}),
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = layout.SelectedGradientImageSize
			})
		})
	})
end

local function mapStateToProps(p)
	return { emotesWheel = p.emotesWheel, layout = p.layout }
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
