local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitTextLabel = RoactFitComponents.FitTextLabel
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v11 = Roact.PureComponent:extend("RobuxAmountDisplay")
local v12 = Images["icons/common/robux"]

v11.validateProps = t.strictInterface({
	robuxAmountText = t.string,
	iconSize = t.number,
	textSize = t.number,
	padding = t.number,
	showRobuxIcon = t.optional(t.boolean)
})
v11.defaultProps = {
	showRobuxIcon = true
}

function v11.render(p1) -- line: 33
	-- upvalues: withStyle (copy), Roact (copy), FitFrameHorizontal (copy), ImageSetLabel (copy), v12 (copy), FitTextLabel (copy)
	return withStyle(function(p2) -- line: 34
		-- upvalues: Roact (copy), FitFrameHorizontal (copy), p1 (copy), ImageSetLabel (copy), v12 (copy), FitTextLabel (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font

		return Roact.createElement(FitFrameHorizontal, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			height = UDim.new(1, 0),
			contentPadding = UDim.new(0, p1.props.padding),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}, {
			Icon = Roact.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(p1.props.iconSize, p1.props.iconSize),
				Image = v12,
				ImageColor3 = Theme.TextDefault.Color,
				ImageTransparency = Theme.TextDefault.Transparency,
				Visible = p1.props.showRobuxIcon
			}),
			Text = Roact.createElement(FitTextLabel, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				width = FitTextLabel.Width.FitToText,
				Text = p1.props.robuxAmountText,
				Font = p2Font.Body.Font,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency,
				TextSize = p1.props.textSize
			})
		})
	end)
end

return v11
