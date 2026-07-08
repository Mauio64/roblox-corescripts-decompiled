local Parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local t = require(Parent.t)
local withStyle = UIBlox.Core.Style.withStyle
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Interactable = UIBlox.Core.Control.Interactable
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v10 = Roact.PureComponent:extend("ScrollButton")

v10.validateProps = t.strictInterface({
	icon = t.table,
	callback = t.callback
})

function v10.render(p1) -- line: 24
	-- upvalues: withStyle (copy), Roact (copy), Interactable (copy), ImageSetLabel (copy), getIconSize (copy), IconSize (copy)
	return withStyle(function(p2) -- line: 25
		-- upvalues: Roact (copy), Interactable (copy), p1 (copy), ImageSetLabel (copy), getIconSize (copy), IconSize (copy)
		return Roact.createElement(Interactable, {
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p2.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p2.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = p1.props.callback,
			onStateChanged = function() -- line: 34
			end
		}, {
			Icon = Roact.createElement(ImageSetLabel, {
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

return v10
