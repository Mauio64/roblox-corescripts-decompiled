local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent

local Constants = require(parent.Constants)

local extended = Roact.PureComponent:extend("SlotNumbers")

function extended.render(p)
	local layout = Constants.Layouts[p.props.layout]

	local children = {}

	for i = 1, Constants.EmotesPerPage do
		local v = 360 / Constants.EmotesPerPage * (i - 1) + Constants.SegmentsStartRotation
		local halfInnerCircleSizeRatio = Constants.InnerCircleSizeRatio / 2

		local slotNumberSize = Constants.SlotNumberSize
		local halfSlotNumberSize = slotNumberSize / 2

		local v2 = math.cos((math.rad(v)))
		local v3 = halfInnerCircleSizeRatio * v2

		local v4 = halfSlotNumberSize * v2
		local v5 = 0.5 + v3 + v4

		local v6 = math.sin((math.rad(v)))
		local v7 = halfInnerCircleSizeRatio * v6

		local v8 = halfSlotNumberSize * v6
		local v9 = 0.5 + v7 + v8

		children[i] = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(v5, 0, v9, 0),
			Size = UDim2.new(slotNumberSize, 0, slotNumberSize, 0),
			BackgroundTransparency = 1,
			TextScaled = true,
			TextSize = layout.SlotNumberTextSize,
			TextColor3 = Constants.Colors.White,
			Text = i,
			Font = layout.SlotNumberFont,
			ZIndex = 2
		}, {
			TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = layout.SlotNumberTextSize
			})
		})
	end

	return Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, children)
end

local function mapStateToProps(p)
	return { layout = p.layout }
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
