local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local v6 = Roact.PureComponent:extend("SlotNumbers")

function v6.render(p1) -- line: 13
	-- upvalues: Constants (copy), Roact (copy)
	local v9 = Constants.Layouts[p1.props.layout]
	local t1 = {}

	for i = 1, Constants.EmotesPerPage do
		local v12 = 360 / Constants.EmotesPerPage * (i - 1) + Constants.SegmentsStartRotation
		local v13 = Constants.InnerCircleSizeRatio / 2
		local SlotNumberSize = Constants.SlotNumberSize
		local v15 = SlotNumberSize / 2
		local v16 = math.cos((math.rad(v12)))
		local v17 = v13 * v16
		local v18 = v15 * v16
		local v19 = 0.5 + v17 + v18
		local v20 = math.sin((math.rad(v12)))
		local v21 = v13 * v20
		local v22 = v15 * v20
		local v23 = 0.5 + v21 + v22

		t1[i] = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextScaled = true,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(v19, 0, v23, 0),
			Size = UDim2.new(SlotNumberSize, 0, SlotNumberSize, 0),
			TextSize = v9.SlotNumberTextSize,
			TextColor3 = Constants.Colors.White,
			Text = i,
			Font = v9.SlotNumberFont
		}, {
			TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v9.SlotNumberTextSize
			})
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, t1)
end

local function mapStateToProps(p2) -- line: 61
	return {
		layout = p2.layout
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v6)
