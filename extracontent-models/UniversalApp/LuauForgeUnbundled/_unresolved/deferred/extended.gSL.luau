local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local component_assetscircle_9 = images["component_assets/circle_9"]

local extended = Roact.PureComponent:extend("NewItemNotification")

extended.validateProps = t.strictInterface({ isSelected = t.optional(t.boolean) })

extended.defaultProps = { isSelected = false }

function extended.render(p2)
	return withStyle(function(p3)
		local theme = p3.Theme
		local color = p2.props.isSelected and theme.TextEmphasis.Color or theme.TextMuted.Color
		local transparency = p2.props.isSelected and theme.TextEmphasis.Transparency
			or theme.TextMuted.Transparency

		return Roact.createElement(imageSetLabel, {
			Image = component_assetscircle_9,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -3, 0, 6),
			Size = UDim2.fromOffset(6, 6),
			ImageColor3 = color,
			ImageTransparency = transparency,
			BackgroundTransparency = 1
		})
	end)
end

return extended
