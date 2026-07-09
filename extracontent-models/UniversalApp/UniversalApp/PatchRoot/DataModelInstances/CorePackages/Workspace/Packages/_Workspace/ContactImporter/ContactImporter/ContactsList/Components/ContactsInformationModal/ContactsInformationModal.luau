local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local t = dependencies.t
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Style.withStyle
local v10 = Roact.PureComponent:extend("ContactsInformationModal")

v10.validateProps = t.strictInterface({
	text = t.string,
	image = t.table,
	layoutOrder = t.optional(t.number)
})

function v10.render(p1) -- line: 32
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), StyledTextLabel (copy)
	return withStyle(function(p2) -- line: 33
		-- upvalues: p1 (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), StyledTextLabel (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font
		local props = p1.props

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = props.layoutOrder
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12),
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 36)
			}),
			IconContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.fromOffset(120, 132)
			}, {
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageColor3 = p2.Theme.IconEmphasis.Color,
					ImageTransparency = p2.Theme.IconEmphasis.Transparency,
					Image = props.image,
					Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			}),
			Description = Roact.createElement(StyledTextLabel, {
				lineHeight = 1.2,
				layoutOrder = 2,
				text = props.text,
				fontStyle = p2Font.CaptionBody,
				colorStyle = Theme.TextEmphasis,
				size = UDim2.fromScale(1, 0),
				automaticSize = Enum.AutomaticSize.Y,
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Top
			})
		})
	end)
end

return v10
