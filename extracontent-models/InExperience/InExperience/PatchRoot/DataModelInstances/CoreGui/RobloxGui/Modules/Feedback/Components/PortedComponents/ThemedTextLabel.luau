local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local t = InGameMenuDependencies.t

local withStyle = UIBlox.Core.Style.withStyle
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local parent = script.Parent.Parent.Parent
local GlobalConfig = require(parent.GlobalConfig)

local v = {
	Title = "HeadingLarge",
	Header1 = "HeadingSmall",
	Header2 = "TitleLarge",
	SubHeader1 = "TitleLarge",
	Body = "BodyLarge",
	CaptionHeader = "CaptionMedium",
	CaptionSubHeader = "CaptionMedium",
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

	return withStyle(function(props)
		local v3 = props.Theme[p.themeKey or "TextDefault"]
		local v4 = props.Font[p.fontKey or "Body"]

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
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography[v[p.fontKey or "Body"]].Font)
		end

		v6.FontFace = fontFace

		v6.TextSize = v4.RelativeSize * props.Font.BaseSize
		local v7 = join(v5, p, v6)

		return Roact.createElement("TextLabel", v7)
	end)
end

return ThemedTextLabel
