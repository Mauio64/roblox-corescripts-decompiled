local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local parent = script.Parent.Parent
local GlobalConfig = require(parent.GlobalConfig)

local v = {
	Title = "HeadingLarge",
	Header1 = "HeadingSmall",
	Header2 = "TitleLarge",
	SubHeader1 = "TitleLarge",
	Body = "BodyLarge",
	CaptionHeader = "CaptionLarge",
	CaptionSubHeader = "CaptionLarge",
	CaptionBody = "BodySmall",
	Footer = "CaptionSmall"
}

local v2 = t.strictInterface({
	themeKey = t.optional(t.string),
	fontKey = t.optional(t.string),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	Text = t.string,
	TextColor3 = t.optional(t.Color3),
	TextTransparency = t.optional(t.numberConstrained(0, 1)),
	TextWrapped = t.optional(t.boolean),
	TextXAlignment = t.optional(t.enum(Enum.TextXAlignment)),
	TextYAlignment = t.optional(t.enum(Enum.TextYAlignment)),
	TextTruncate = t.optional(t.enum(Enum.TextTruncate)),
	Visible = t.optional(t.boolean),
	ZIndex = t.optional(t.integer),
	AutomaticSize = t.optional(t.enum(Enum.AutomaticSize)),
	[Roact.Children] = t.optional(t.table)
})

local function ThemedTextLabel(p)
	if GlobalConfig.propValidation then
		assert(v2(p))
	end

	return withFoundationOrUIBloxStyle(function(data)
		local tokens

		if FoundationFontFaceMigration then
			tokens = data
		end

		return {
			Tokens = tokens,
			Theme = {
				BackgroundDefault = {
					Color = data.Color.Surface.Surface_0.Color3,
					Transparency = data.Color.Surface.Surface_0.Transparency
				},
				BackgroundContrast = {
					Color = data.Color.Surface.Surface_100.Color3,
					Transparency = data.Color.Surface.Surface_100.Transparency
				},
				BackgroundMuted = {
					Color = data.Color.Surface.Surface_200.Color3,
					Transparency = data.Color.Surface.Surface_200.Transparency
				},
				BackgroundUIDefault = {
					Color = data.Color.Surface.Surface_300.Color3,
					Transparency = data.Color.Surface.Surface_300.Transparency
				},
				BackgroundUIContrast = {
					Color = data.Color.OverMedia.OverMedia_0.Color3,
					Transparency = data.Color.OverMedia.OverMedia_0.Transparency
				},
				BackgroundOnHover = {
					Color = data.Color.State.Hover.Color3,
					Transparency = data.Color.State.Hover.Transparency
				},
				BackgroundOnPress = {
					Color = data.Color.State.Press.Color3,
					Transparency = data.Color.State.Press.Transparency
				},
				UIDefault = {
					Color = data.Color.Shift.Shift_200.Color3,
					Transparency = data.Color.Shift.Shift_200.Transparency
				},
				UIMuted = {
					Color = data.Color.Shift.Shift_100.Color3,
					Transparency = data.Color.Shift.Shift_100.Transparency
				},
				UIEmphasis = {
					Color = data.Color.Shift.Shift_400.Color3,
					Transparency = data.Color.Shift.Shift_400.Transparency
				},
				ContextualPrimaryDefault = {
					Color = data.Color.ActionEmphasis.Background.Color3,
					Transparency = data.Color.ActionEmphasis.Background.Transparency
				},
				ContextualPrimaryContent = {
					Color = data.Color.ActionEmphasis.Foreground.Color3,
					Transparency = data.Color.ActionEmphasis.Foreground.Transparency
				},
				SystemPrimaryDefault = {
					Color = data.Color.ActionSubEmphasis.Background.Color3,
					Transparency = data.Color.ActionSubEmphasis.Background.Transparency
				},
				SystemPrimaryContent = {
					Color = data.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = data.Color.ActionSubEmphasis.Foreground.Transparency
				},
				IconDefault = {
					Color = data.Color.Content.Default.Color3,
					Transparency = data.Color.Content.Default.Transparency
				},
				IconEmphasis = {
					Color = data.Color.Content.Emphasis.Color3,
					Transparency = data.Color.Content.Emphasis.Transparency
				},
				IconOnHover = {
					Color = data.Color.Content.Emphasis.Color3,
					Transparency = data.Color.Content.Emphasis.Transparency
				},
				TextEmphasis = {
					Color = data.Color.Content.Emphasis.Color3,
					Transparency = data.Color.Content.Emphasis.Transparency
				},
				TextDefault = {
					Color = data.Color.Content.Default.Color3,
					Transparency = data.Color.Content.Default.Transparency
				},
				TextMuted = {
					Color = data.Color.Content.Muted.Color3,
					Transparency = data.Color.Content.Muted.Transparency
				},
				TextLink = {
					Color = data.Color.Content.Link.Color3,
					Transparency = data.Color.Content.Link.Transparency
				},
				Divider = {
					Color = data.Color.Stroke.Emphasis.Color3,
					Transparency = data.Color.Stroke.Emphasis.Transparency
				},
				Overlay = {
					Color = data.Color.Common.Scrim.Color3,
					Transparency = data.Color.Common.Scrim.Transparency
				},
				DropShadow = {
					Color = data.Color.Common.Shadow.Color3,
					Transparency = data.Color.Common.Shadow.Transparency
				},
				NavigationBar = {
					Color = data.Color.Common.NavigationBar.Color3,
					Transparency = data.Color.Common.NavigationBar.Transparency
				},
				PlaceHolder = {
					Color = data.Color.Common.Shimmer.Color3,
					Transparency = data.Color.Common.Shimmer.Transparency
				},
				OnlineStatus = {
					Color = data.Color.System.Success.Color3,
					Transparency = data.Color.System.Success.Transparency
				},
				OfflineStatus = {
					Color = data.Color.System.Neutral.Color3,
					Transparency = data.Color.System.Neutral.Transparency
				},
				Success = {
					Color = data.Color.System.Success.Color3,
					Transparency = data.Color.System.Success.Transparency
				},
				Alert = {
					Color = data.Color.System.Alert.Color3,
					Transparency = data.Color.System.Alert.Transparency
				},
				Badge = {
					Color = data.Color.System.Contrast.Color3,
					Transparency = data.Color.System.Contrast.Transparency
				},
				BadgeContent = {
					Color = data.Inverse.Content.Emphasis.Color3,
					Transparency = data.Inverse.Content.Emphasis.Transparency
				},
				SecondaryContent = {
					Color = data.Color.Extended.White.White_70.Color3,
					Transparency = data.Color.Extended.White.White_70.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Title = {
					Font = data.Typography.HeadingLarge.Font,
					RelativeSize = data.Typography.HeadingLarge.FontSize
				},
				Header1 = {
					Font = data.Typography.HeadingSmall.Font,
					RelativeSize = data.Typography.HeadingSmall.FontSize
				},
				Header2 = {
					Font = data.Typography.TitleLarge.Font,
					RelativeSize = data.Typography.TitleLarge.FontSize
				},
				SubHeader1 = {
					Font = data.Typography.TitleLarge.Font,
					RelativeSize = data.Typography.TitleLarge.FontSize
				},
				Body = {
					Font = data.Typography.BodyLarge.Font,
					RelativeSize = data.Typography.BodyLarge.FontSize
				},
				CaptionHeader = {
					Font = data.Typography.CaptionLarge.Font,
					RelativeSize = data.Typography.CaptionLarge.FontSize
				},
				CaptionSubHeader = {
					Font = data.Typography.CaptionLarge.Font,
					RelativeSize = data.Typography.CaptionLarge.FontSize
				},
				CaptionBody = {
					Font = data.Typography.BodySmall.Font,
					RelativeSize = data.Typography.BodySmall.FontSize
				},
				Footer = {
					Font = data.Typography.CaptionSmall.Font,
					RelativeSize = data.Typography.CaptionSmall.FontSize
				}
			}
		}
	end, function(props)
		local v3 = props.Theme[p.themeKey or "TextDefault"]
		local v4 = props.Font[p.fontKey or "Body"]
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace((props.Tokens.Typography[v[p.fontKey or "Body"]] or v4).Font)
		end

		local join = Cryo.Dictionary.join
		local v5 = { TextColor3 = v3.Color, TextTransparency = v3.Transparency }

		local v6 = {
			fontKey = Cryo.None,
			themeKey = Cryo.None,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextSize = 0
		}
		local font

		if FoundationFontFaceMigration then
			font = Cryo.None
		else
			font = v4.Font
		end

		v6.Font = font
		v6.FontFace = fontFace
		v6.TextSize = v4.RelativeSize * props.Font.BaseSize
		local v7 = join(v5, p, v6)

		return Roact.createElement("TextLabel", v7)
	end)
end

return ThemedTextLabel
