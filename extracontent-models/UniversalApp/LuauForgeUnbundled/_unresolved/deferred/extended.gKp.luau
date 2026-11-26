local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameHorizontal = roactFitComponents.FitFrameHorizontal
local fitTextLabel = roactFitComponents.FitTextLabel

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("RobuxAmountDisplay")

local iconscommonrobux = images["icons/common/robux"]

extended.validateProps = t.strictInterface({
	robuxAmountText = t.string,
	iconSize = t.number,
	textSize = t.number,
	padding = t.number,
	showRobuxIcon = t.optional(t.boolean)
})

extended.defaultProps = { showRobuxIcon = true }

function extended.render(p2)
	return withStyle(function(p3)
		local theme = p3.Theme
		local font = p3.Font

		return Roact.createElement(fitFrameHorizontal, {
			height = UDim.new(1, 0),
			contentPadding = UDim.new(0, p2.props.padding),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, {
			Icon = Roact.createElement(imageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(p2.props.iconSize, p2.props.iconSize),
				Image = iconscommonrobux,
				ImageColor3 = theme.TextDefault.Color,
				ImageTransparency = theme.TextDefault.Transparency,
				Visible = p2.props.showRobuxIcon
			}),
			Text = Roact.createElement(fitTextLabel, {
				width = fitTextLabel.Width.FitToText,
				LayoutOrder = 2,
				Text = p2.props.robuxAmountText,
				Font = font.Body.Font,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.Transparency,
				TextSize = p2.props.textSize,
				BackgroundTransparency = 1
			})
		})
	end)
end

return extended
