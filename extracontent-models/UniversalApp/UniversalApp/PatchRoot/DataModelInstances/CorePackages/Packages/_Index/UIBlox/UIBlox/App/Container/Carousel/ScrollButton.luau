local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local Core = ParentParentParent.Core
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local Interactable = require(Core.Control.Interactable)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local v12 = Roact.PureComponent:extend("ScrollButton")

v12.validateProps = t.strictInterface({
	icon = t.table,
	callback = t.callback
})

function v12.render(p1) -- line: 28
	-- upvalues: withStyle (copy), Roact (copy), Interactable (copy), ImageSetComponent (copy), getIconSize (copy), IconSize (copy)
	return withStyle(function(p2) -- line: 29
		-- upvalues: Roact (copy), Interactable (copy), p1 (copy), ImageSetComponent (copy), getIconSize (copy), IconSize (copy)
		return Roact.createElement(Interactable, {
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p2.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p2.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = p1.props.callback,
			onStateChanged = function() -- line: 38
			end
		}, {
			Icon = Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = p1.props.icon,
				ImageColor3 = p2.Theme.IconEmphasis.Color,
				ImageTransparency = p2.Theme.IconEmphasis.Transparency
			})
		})
	end)
end

return v12
