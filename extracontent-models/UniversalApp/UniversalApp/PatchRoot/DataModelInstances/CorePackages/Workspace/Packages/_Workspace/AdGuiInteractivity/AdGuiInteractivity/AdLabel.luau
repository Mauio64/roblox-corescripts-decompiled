local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local v3 = require(ParentParent.RobloxTranslator):FormatByKey("Feature.NativeAds.Label.Ad")
local UIBlox = require(ParentParent.UIBlox)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local v7 = Images["icons/menu/more_on"]
local v8 = Images["icons/menu/more_off"]
local v9 = Roact.Component:extend("AdLabel")

function v9.render(p1) -- line: 19
	-- upvalues: Roact (copy), v3 (copy), ImageSetButton (copy), v7 (copy), v8 (copy)
	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.995, 0.995),
		BackgroundColor3 = Color3.new(0, 0, 0),
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromScale(0.11447368421, 0.10108771929),
		Visible = p1.props.Visible
	}, {
		Label = Roact.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			TextSize = 100,
			TextScaled = true,
			TextWrapped = false,
			Text = v3,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Gotham,
			Position = UDim2.fromScale(0.134084726, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromScale(0.40808394869, 0.77610536218)
		}),
		MenuButton = Roact.createElement(ImageSetButton, {
			LayoutOrder = 2,
			Image = p1.props.isMenuOpen and v7 or v8,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.4, 0),
			Position = UDim2.fromScale(0.76, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[Roact.Event.Activated] = p1.props.onActivated
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize
			})
		})
	})
end

return v9
