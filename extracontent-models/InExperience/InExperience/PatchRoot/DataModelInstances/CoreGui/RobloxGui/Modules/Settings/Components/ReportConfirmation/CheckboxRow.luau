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
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
	return withFoundationOrUIBloxStyle(function(p2)
		local tokens

		if FoundationFontFaceMigration then
			tokens = p2
		end

		return {
			Tokens = tokens,
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

		local createElement = Roact.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 0, p.props.height),
			BackgroundTransparency = 1,
			LayoutOrder = p.props.LayoutOrder
		}
		local children = {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			image = image,
			text = 0,
			checkbox = 0
		}

		local createElement2 = Roact.createElement
		local v4 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -(p.props.height + 12) * 4, 1, 0),
			Text = p.props.descriptionText,
			TextColor3 = v.Color,
			TextTransparency = v.Transparency,
			TextSize = props.Font.Header2.RelativeSize * baseSize,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			LayoutOrder = 2
		}
		local font

		if not FoundationFontFaceMigration then
			font = props.Font.Header2.Font
		end

		v4.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
		end

		v4.FontFace = fontFace

		v4.TextXAlignment = Enum.TextXAlignment.Left
		children.text = createElement2("TextLabel", v4)

		children.checkbox = Roact.createElement(Checkbox, {
			isDisabled = p.props.actionDisabled,
			isChecked = p.props.checkboxSelected,
			onActivated = p.props.onCheckboxActivated,
			label = "",
			LayoutOrder = 3
		})
		return createElement("Frame", v3, children)
	end)
end

return extended
