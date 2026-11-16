local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local RobloxTranslator = require(parent.RobloxTranslator)
local formatByKey = RobloxTranslator:FormatByKey("Feature.NativeAds.Label.Ad")

local UIBlox = require(parent.UIBlox)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local Images = UIBlox.App.ImageSet.Images
local iconsmenumore_on = Images["icons/menu/more_on"]
local iconsmenumore_off = Images["icons/menu/more_off"]

local extended = Roact.Component:extend("AdLabel")

function extended.render(p)
	return Roact.createElement("Frame", {
		Position = UDim2.fromScale(0.995, 0.995),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromScale(0.11447368421, 0.10108771929),
		Visible = p.props.Visible
	}, {
		Label = Roact.createElement("TextLabel", {
			LayoutOrder = 1,
			Text = formatByKey,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 100,
			TextScaled = true,
			TextWrapped = false,
			Position = UDim2.fromScale(0.134084726, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromScale(0.40808394869, 0.77610536218)
		}),
		MenuButton = Roact.createElement(ImageSetButton, {
			LayoutOrder = 2,
			Image = p.props.isMenuOpen and iconsmenumore_on or iconsmenumore_off,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.4, 0),
			Position = UDim2.fromScale(0.76, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[Roact.Event.Activated] = p.props.onActivated
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize
			})
		})
	})
end

return extended
