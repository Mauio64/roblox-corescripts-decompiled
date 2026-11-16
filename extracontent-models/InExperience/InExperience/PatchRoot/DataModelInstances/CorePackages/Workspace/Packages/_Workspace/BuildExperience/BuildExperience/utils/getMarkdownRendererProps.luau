local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.Foundation)

local rbxassetfontsfamiliesBuilderMonojson = Font.new(
	"rbxasset://fonts/families/BuilderMono.json",
	Enum.FontWeight.Regular
)

local function colorToHex(p) -- 3 equivalent calls inferred from this helper
	return `#{p.Color3:ToHex()}`
end

local function typographyToTextStyles(p, p2)
	local font = p.Font
	local v = { textSize = p.FontSize, color = colorToHex(p2), transparency = p2.Transparency } -- inferred equivalent call

	if typeof(font) == "EnumItem" then
		v.font = font
		return v
	end

	if typeof(font) == "Font" then
		v.fontFace = font
		return v
	end

	if typeof(font) == "table" then
		v.fontFace = Font.new(font.Family, font.Weight, font.Style)
	end

	return v
end

local function getTextSize(p) -- 1 equivalent call inferred from this helper
	return p.FontSize
end

local function getLineHeight(p) -- 1 equivalent call inferred from this helper
	return p.LineHeight
end

local function getColor3(p) -- 1 equivalent call inferred from this helper
	return p.Color3
end

local function getTransparency(p) -- 2 equivalent calls inferred from this helper
	return p.Transparency
end

local function getSize(p: number)
	return p
end

local function getMarkdownRendererProps(data, p)
	local typography = data.Typography
	local content = data.Color.Content
	local surface = data.DarkMode.Surface

	return {
		textStyles = typographyToTextStyles(typography.BodyMedium, p),
		headerStyles = {
			typographyToTextStyles(typography.HeadingLarge, content.Emphasis),
			typographyToTextStyles(typography.HeadingMedium, content.Emphasis),
			typographyToTextStyles(typography.HeadingSmall, content.Emphasis),
			typographyToTextStyles(typography.TitleLarge, content.Emphasis),
			typographyToTextStyles(typography.TitleMedium, content.Emphasis),
			typographyToTextStyles(typography.TitleMedium, content.Emphasis)
		},
		codeStyles = {
			fontFace = rbxassetfontsfamiliesBuilderMonojson,
			textSize = getTextSize(typography.BodyMedium), -- inferred equivalent call
			lineHeight = getLineHeight(typography.BodyMedium), -- inferred equivalent call
			color = colorToHex(content.Emphasis), -- inferred equivalent call
			transparency = getTransparency(content.Emphasis) -- inferred equivalent call
		},
		codeBackgroundStyles = {
			backgroundColor3 = getColor3(surface.Surface_300), -- inferred equivalent call
			backgroundTransparency = getTransparency(surface.Surface_300) -- inferred equivalent call
		},
		linkStyles = { linkColor = colorToHex(content.Link) }, -- inferred equivalent call
		imageStyles = {
			size = UDim2.fromOffset(data.Size.Size_400, data.Size.Size_400)
		}
	}
end

return getMarkdownRendererProps
