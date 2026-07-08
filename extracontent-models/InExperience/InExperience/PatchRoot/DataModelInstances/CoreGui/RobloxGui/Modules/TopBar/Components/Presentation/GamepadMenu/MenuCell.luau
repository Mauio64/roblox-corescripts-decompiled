local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v8 = Roact.PureComponent:extend("MenuCell")

v8.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	icon = t.optional(t.union(t.table, t.string)),
	iconComponent = t.optional(t.table),
	localizationKey = t.string,
	height = t.numberPositive,
	hasDivider = t.boolean,
	isSelected = t.boolean
})

function v8.render(p1) -- line: 33
	-- upvalues: withStyle (copy), RobloxTranslator (copy), Roact (copy), ImageSetLabel (copy)
	return withStyle(function(p2) -- line: 34
		-- upvalues: RobloxTranslator (copy), p1 (copy), Roact (copy), ImageSetLabel (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font
		local v13 = RobloxTranslator:FormatByKey(p1.props.localizationKey)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p1.props.layoutOrder,
			Size = UDim2.new(1, 0, 0, p1.props.height)
		}, {
			SelectedFrame = p1.props.isSelected and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 4, 1, 4),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}, {
				TopBorder = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 2),
					BackgroundTransparency = Theme.SystemPrimaryOnHover.Transparency,
					BackgroundColor3 = Theme.SystemPrimaryOnHover.Color
				}),
				LeftBorder = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, 2, 1, 0),
					BackgroundTransparency = Theme.SystemPrimaryOnHover.Transparency,
					BackgroundColor3 = Theme.SystemPrimaryOnHover.Color
				}),
				RightBorder = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, 2, 1, 0),
					Position = UDim2.fromScale(1, 0),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = Theme.SystemPrimaryOnHover.Transparency,
					BackgroundColor3 = Theme.SystemPrimaryOnHover.Color
				}),
				BottomBorder = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = Theme.SystemPrimaryOnHover.Transparency,
					BackgroundColor3 = Theme.SystemPrimaryOnHover.Color
				})
			}),
			CellContents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 12)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				IconFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.fromOffset(36, 36)
				}, {
					IconLabel = p1.props.icon ~= nil and Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = p1.props.icon,
						Size = UDim2.fromScale(1, 1),
						ImageTransparency = Theme.IconEmphasis.Transparency,
						ImageColor3 = Theme.IconEmphasis.Color
					}),
					IconComponent = p1.props.iconComponent ~= nil and Roact.createElement(p1.props.iconComponent)
				}),
				Text = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, -48, 1, 0),
					Text = v13,
					Font = p2Font.Header2.Font,
					TextSize = p2Font.BaseSize * p2Font.Header2.RelativeSize,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextEmphasis.TextTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd
				})
			}),
			Divider = p1.props.hasDivider and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = Theme.Divider.Transparency,
				BackgroundColor3 = Theme.Divider.Color
			})
		})
	end)
end

return v8
