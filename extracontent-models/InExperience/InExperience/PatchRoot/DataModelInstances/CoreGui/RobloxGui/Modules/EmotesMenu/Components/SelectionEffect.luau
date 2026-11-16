local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent

local Constants = require(parent.Constants)

local extended = Roact.PureComponent:extend("SelectionEffect")

function extended.render(p)
	local layout = Constants.Layouts[p.props.layout]
	local focusedSegmentIndex = p.props.emotesWheel.focusedSegmentIndex

	local rotation = 360 / Constants.EmotesPerPage * (focusedSegmentIndex - 1) + Constants.SegmentsStartRotation
	local halfInnerCircleSizeRatio = Constants.InnerCircleSizeRatio / 2

	local v = 360 / Constants.EmotesPerPage
	local v2 = Constants.InnerCircleSizeRatio * math.sin((math.rad(v / 2)))

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Rotation = rotation,
		Visible = focusedSegmentIndex ~= 0
	}, {
		SelectedLine = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.5 + halfInnerCircleSizeRatio, -layout.SelectedLinePadding, 0.5, 0),
			Size = UDim2.new(1, 0, v2, -layout.SelectedLinePadding),
			BackgroundTransparency = 1,
			Image = layout.SelectedLine,
			ZIndex = 4
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = layout.SelectedLineImageSize.X / layout.SelectedLineImageSize.Y
			})
		})
	})
end

local function mapStateToProps(p)
	return { emotesWheel = p.emotesWheel, layout = p.layout }
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
