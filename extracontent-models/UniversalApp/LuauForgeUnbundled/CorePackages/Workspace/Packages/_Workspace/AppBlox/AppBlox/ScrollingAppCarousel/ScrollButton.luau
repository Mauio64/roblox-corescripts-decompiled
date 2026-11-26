local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

local withStyle = UIBlox.Core.Style.withStyle
local getIconSize = UIBlox.App.ImageSet.getIconSize
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local interactable = UIBlox.Core.Control.Interactable
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("ScrollButton")

extended.validateProps = t.strictInterface({
	icon = t.table,
	callback = t.callback
})

function extended.render(p2)
	return withStyle(function(p3)
		return Roact.createElement(interactable, {
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p3.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p3.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = p2.props.callback,
			onStateChanged = function() end
		}, {
			Icon = Roact.createElement(imageSetLabel, {
				Size = UDim2.fromOffset(getIconSize(iconSize.Medium), getIconSize(iconSize.Medium)),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = p2.props.icon,
				ImageColor3 = p3.Theme.IconEmphasis.Color,
				ImageTransparency = p3.Theme.IconEmphasis.Transparency
			})
		})
	end)
end

return extended
