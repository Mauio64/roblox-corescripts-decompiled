local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local Checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images

local extended = Roact.PureComponent:extend("CheckboxRow")

extended.defaultProps = {
	height = 28,
	image = "icons/controls/microphone",
	descriptionText = "Description Text",
	checkboxSelected = false,
	actionDisabled = false,
	onCheckboxActivated = function() end,
	LayoutOrder = 1
}

extended.validateProps = t.interface({
	height = t.number,
	image = t.string,
	descriptionText = t.string,
	checkboxSelected = t.boolean,
	actionDisabled = t.boolean,
	onCheckboxActivated = t.callback,
	LayoutOrder = t.optional(t.number)
})

function extended.render(p)
	return withFoundationOrUIBloxStyle(function(tokens)
		return {
			Tokens = tokens,
			Theme = {
				IconDefault = {
					Color = tokens.Color.Content.Default.Color3,
					Transparency = tokens.Color.Content.Default.Transparency
				},
				IconEmphasis = {
					Color = tokens.Color.Content.Emphasis.Color3,
					Transparency = tokens.Color.Content.Emphasis.Transparency
				},
				TextEmphasis = {
					Color = tokens.Color.Content.Emphasis.Color3,
					Transparency = tokens.Color.Content.Emphasis.Transparency
				},
				TextMuted = {
					Color = tokens.Color.Content.Muted.Color3,
					Transparency = tokens.Color.Content.Muted.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Header2 = {
					Font = tokens.Typography.TitleLarge.Font,
					RelativeSize = tokens.Typography.TitleLarge.FontSize
				}
			}
		}
	end, function(props)
		local baseSize = props.Font.BaseSize
		local v, v2

		if p.props.actionDisabled then
			v = props.Theme.TextMuted
			v2 = props.Theme.IconDefault
		else
			v = props.Theme.TextEmphasis
			v2 = props.Theme.IconEmphasis
		end

		local image

		if FFlagCoreUiMigrateUIBloxToFoundation then
			image = Roact.createElement(Foundation.Icon, {
				name = p.props.image,
				size = Foundation.Enums.IconSize.Medium,
				style = { Color3 = v2.Color, Transparency = v2.Transparency },
				LayoutOrder = 1
			})
		else
			image = Roact.createElement(ImageSetLabel, {
				Size = UDim2.fromOffset(p.props.height, p.props.height),
				Image = Images[p.props.image],
				ImageColor3 = v2.Color,
				ImageTransparency = v2.Transparency,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		end

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, p.props.height),
				BackgroundTransparency = 1,
				LayoutOrder = p.props.LayoutOrder
			},
			{
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 12),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				image = image,
				text = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -(p.props.height + 12) * 4, 1, 0),
					Text = p.props.descriptionText,
					TextColor3 = v.Color,
					TextTransparency = v.Transparency,
					TextSize = props.Font.Header2.RelativeSize * baseSize,
					FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 2
				}),
				checkbox = Roact.createElement(Checkbox, {
					isDisabled = p.props.actionDisabled,
					isChecked = p.props.checkboxSelected,
					onActivated = p.props.onCheckboxActivated,
					label = "",
					LayoutOrder = 3
				})
			}
		)
	end)
end

return extended
