local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v8 = Images["component_assets/circle_9"]
local v9 = Roact.PureComponent:extend("NewItemNotification")

v9.validateProps = t.strictInterface({
	isSelected = t.optional(t.boolean)
})
v9.defaultProps = {
	isSelected = false
}

function v9.render(p1) -- line: 26
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), v8 (copy)
	return withStyle(function(p2) -- line: 27
		-- upvalues: p1 (copy), Roact (copy), ImageSetLabel (copy), v8 (copy)
		local Theme = p2.Theme
		local v13 = p1.props.isSelected and Theme.TextEmphasis.Color or Theme.TextMuted.Color
		local v14 = p1.props.isSelected and Theme.TextEmphasis.Transparency or Theme.TextMuted.Transparency

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = v8,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -3, 0, 6),
			Size = UDim2.fromOffset(6, 6),
			ImageColor3 = v13,
			ImageTransparency = v14
		})
	end)
end

return v9
