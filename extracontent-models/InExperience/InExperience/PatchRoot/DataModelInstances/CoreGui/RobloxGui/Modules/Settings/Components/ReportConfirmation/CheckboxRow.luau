local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Checkbox = Foundation.Checkbox
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local v11 = Roact.PureComponent:extend("CheckboxRow")

v11.defaultProps = {
	height = 28,
	image = "icons/controls/microphone",
	descriptionText = "Description Text",
	checkboxSelected = false,
	actionDisabled = false,
	LayoutOrder = 1,
	onCheckboxActivated = function() -- line: 27
	end
}
v11.validateProps = t.interface({
	height = t.number,
	image = t.string,
	descriptionText = t.string,
	checkboxSelected = t.boolean,
	actionDisabled = t.boolean,
	onCheckboxActivated = t.callback,
	LayoutOrder = t.optional(t.number)
})

function v11.render(p1) -- line: 41
	-- upvalues: withFoundationOrUIBloxStyle (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), Foundation (copy), ImageSetLabel (copy), Images (copy), Checkbox (copy)
	return withFoundationOrUIBloxStyle(function(p2) -- line: 42
		return {
			Theme = {
				IconDefault = {
					Color = p2.Color.Content.Default.Color3,
					Transparency = p2.Color.Content.Default.Transparency
				},
				IconEmphasis = {
					Color = p2.Color.Content.Emphasis.Color3,
					Transparency = p2.Color.Content.Emphasis.Transparency
				},
				TextEmphasis = {
					Color = p2.Color.Content.Emphasis.Color3,
					Transparency = p2.Color.Content.Emphasis.Transparency
				},
				TextMuted = {
					Color = p2.Color.Content.Muted.Color3,
					Transparency = p2.Color.Content.Muted.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Header2 = {
					Font = p2.Typography.TitleLarge.Font,
					RelativeSize = p2.Typography.TitleLarge.FontSize
				}
			}
		}
	end, function(p3) -- line: 70
		-- upvalues: p1 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), Foundation (copy), ImageSetLabel (copy), Images (copy), Checkbox (copy)
		local BaseSize = p3.Font.BaseSize
		local TextMuted, IconDefault

		if p1.props.actionDisabled then
			TextMuted = p3.Theme.TextMuted
			IconDefault = p3.Theme.IconDefault
		else
			TextMuted = p3.Theme.TextEmphasis
			IconDefault = p3.Theme.IconEmphasis
		end

		local v18 = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(p1.props.height, p1.props.height),
			Image = Images[p1.props.image],
			ImageColor3 = IconDefault.Color,
			ImageTransparency = IconDefault.Transparency
		}) else Roact.createElement(Foundation.Icon, {
			LayoutOrder = 1,
			name = p1.props.image,
			size = Foundation.Enums.IconSize.Medium,
			style = {
				Color3 = IconDefault.Color,
				Transparency = IconDefault.Transparency
			}
		})

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, p1.props.height),
			LayoutOrder = p1.props.LayoutOrder
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			image = v18,
			text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, -(p1.props.height + 12) * 4, 1, 0),
				Text = p1.props.descriptionText,
				TextColor3 = TextMuted.Color,
				TextTransparency = TextMuted.Transparency,
				TextSize = p3.Font.Header2.RelativeSize * BaseSize,
				Font = p3.Font.Header2.Font,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			checkbox = Roact.createElement(Checkbox, {
				label = "",
				LayoutOrder = 3,
				isDisabled = p1.props.actionDisabled,
				isChecked = p1.props.checkboxSelected,
				onActivated = p1.props.onCheckboxActivated
			})
		})
	end)
end

return v11
