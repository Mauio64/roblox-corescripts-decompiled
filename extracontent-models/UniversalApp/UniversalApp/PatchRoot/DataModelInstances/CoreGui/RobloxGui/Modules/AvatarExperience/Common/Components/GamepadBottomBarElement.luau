local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v9 = Roact.PureComponent:extend("GamepadBottomBarElement")

v9.validateProps = t.strictInterface({
	elementIcon = t.string,
	elementText = t.string,
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.number),
	forwardRef = t.optional(t.table),
	width = t.optional(t.number),
	disabled = t.optional(t.boolean)
})
v9.defaultValue = {
	layoutOrder = 1,
	position = UDim2.new(0, 0, 0, 0)
}

function v9.render(p1) -- line: 33
	-- upvalues: withStyle (copy), UIBlox (copy), Text (copy), Roact (copy), ImageSetLabel (copy)
	return withStyle(function(p2) -- line: 34
		-- upvalues: UIBlox (copy), Text (copy), p1 (copy), Roact (copy), ImageSetLabel (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font
		local Header2Font = p2Font.Header2.Font
		local v17 = p2Font.BaseSize * p2Font.Header2.RelativeSize
		local Regular = UIBlox.App.Constant.IconSize.Regular
		local v19 = Text.GetTextWidth(p1.props.elementText, Header2Font, v17)
		local width

		if p1.props.width and v19 > p1.props.width then
			v19 = p1.props.width - (Regular + 8)
			width = p1.props.width
		else
			width = v19 + Regular + 8
		end

		local forwardRef = p1.props.forwardRef

		return Roact.createElement("Frame", {
			Size = UDim2.new(0, width, 1, 0),
			BackgroundTransparency = 1,
			Position = p1.props.position,
			LayoutOrder = p1.props.layoutOrder,
			[Roact.Ref] = forwardRef
		}, {
			Icon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(0, Regular, 0, Regular),
				Image = p1.props.elementIcon,
				ImageColor3 = Theme.IconEmphasis.Color,
				ImageTransparency = if not p1.props.disabled then Theme.IconEmphasis.Transparency else 0.5
			}),
			TextFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v19, 1, 0),
				Position = UDim2.new(0, Regular + 8, 0, 0)
			}, {
				Text = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextScaled = true,
					Text = p1.props.elementText,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, v17),
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = if not p1.props.disabled then Theme.TextEmphasis.Transparency else 0.5,
					Font = Header2Font,
					TextSize = v17,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})
		})
	end)
end

return Roact.forwardRef(function(p3, p4) -- line: 91
	-- upvalues: Roact (copy), v9 (copy), Cryo (copy)
	return Roact.createElement(v9, Cryo.Dictionary.join(p3, {
		forwardRef = p4
	}))
end)
