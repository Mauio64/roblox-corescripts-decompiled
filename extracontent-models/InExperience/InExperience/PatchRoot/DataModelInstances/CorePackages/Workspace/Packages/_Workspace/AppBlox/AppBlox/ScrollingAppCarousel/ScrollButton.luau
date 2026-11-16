local parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local t = require(parent.t)

local withStyle = UIBlox.Core.Style.withStyle
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Interactable = UIBlox.Core.Control.Interactable
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("ScrollButton")

extended.validateProps = t.strictInterface({ icon = t.table, callback = t.callback })

function extended.render(p)
	return withStyle(function(p2)
		return Roact.createElement(Interactable, {
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p2.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p2.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = p.props.callback,
			onStateChanged = function() end
		}, {
			Icon = Roact.createElement(ImageSetLabel, {
				Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = p.props.icon,
				ImageColor3 = p2.Theme.IconEmphasis.Color,
				ImageTransparency = p2.Theme.IconEmphasis.Transparency
			})
		})
	end)
end

return extended
