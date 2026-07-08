local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local v6 = Roact.PureComponent:extend("SelectionEffect")

function v6.render(p1) -- line: 13
	-- upvalues: Constants (copy), Roact (copy)
	local v9 = Constants.Layouts[p1.props.layout]
	local focusedSegmentIndex = p1.props.emotesWheel.focusedSegmentIndex
	local v11 = 360 / Constants.EmotesPerPage * (focusedSegmentIndex - 1) + Constants.SegmentsStartRotation
	local v12 = Constants.InnerCircleSizeRatio / 2
	local v13 = 360 / Constants.EmotesPerPage
	local v14 = Constants.InnerCircleSizeRatio * math.sin((math.rad(v13 / 2)))

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Rotation = v11,
		Visible = focusedSegmentIndex ~= 0
	}, {
		SelectedLine = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = 4,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.5 + v12, -v9.SelectedLinePadding, 0.5, 0),
			Size = UDim2.new(1, 0, v14, -v9.SelectedLinePadding),
			Image = v9.SelectedLine
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = v9.SelectedLineImageSize.X / v9.SelectedLineImageSize.Y
			})
		})
	})
end

local function mapStateToProps(p2) -- line: 46
	return {
		emotesWheel = p2.emotesWheel,
		layout = p2.layout
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v6)
