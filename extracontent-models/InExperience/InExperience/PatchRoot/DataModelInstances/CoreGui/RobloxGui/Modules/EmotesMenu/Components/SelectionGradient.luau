local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local v6 = Roact.PureComponent:extend("SelectionGradient")

function v6.render(p1) -- line: 13
	-- upvalues: Constants (copy), Roact (copy)
	local v9 = Constants.Layouts[p1.props.layout]
	local focusedSegmentIndex = p1.props.emotesWheel.focusedSegmentIndex
	local v11 = 360 / Constants.EmotesPerPage * (focusedSegmentIndex - 1) + Constants.SegmentsStartRotation

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Rotation = v11,
		Visible = focusedSegmentIndex ~= 0
	}, {
		SelectedGradient = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.5, 0, 1, 0),
			ImageTransparency = Constants.GradientTransparency,
			Image = v9.SelectedGradient
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = v9.SelectedGradientImageSize.X / v9.SelectedGradientImageSize.Y
			}),
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = v9.SelectedGradientImageSize
			})
		})
	})
end

local function mapStateToProps(p2) -- line: 47
	return {
		emotesWheel = p2.emotesWheel,
		layout = p2.layout
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v6)
