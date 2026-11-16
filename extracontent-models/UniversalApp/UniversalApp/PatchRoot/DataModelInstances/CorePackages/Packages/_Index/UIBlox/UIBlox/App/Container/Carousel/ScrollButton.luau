local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local withStyle = require(parent2.Core.Style.withStyle)

local core = parent2.Core
local getIconSize = require(parent.ImageSet.getIconSize)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local Interactable = require(core.Control.Interactable)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)

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
			Icon = Roact.createElement(ImageSetComponent.Label, {
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
