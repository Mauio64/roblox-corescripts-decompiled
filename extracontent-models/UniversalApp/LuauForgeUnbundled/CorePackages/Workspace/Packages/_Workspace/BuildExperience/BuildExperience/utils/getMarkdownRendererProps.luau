require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local rbxassetfontsfamiliesBuilderMonojson = Font.new(
	"rbxasset://fonts/families/BuilderMono.json",
	Enum.FontWeight.Regular
)

local function colorToHex(p2)
	return `#{p2.Color3:ToHex()}`
end

local function typographyToTextStyles(p2, p3)
	local font = p2.Font
	local v5 = {
		textSize = p2.FontSize,
		color = `#{p3.Color3:ToHex()}`,
		transparency = p3.Transparency
	}

	if typeof(font) == "EnumItem" then
		v5.font = font
		return v5
	end

	if typeof(font) == "Font" then
		v5.fontFace = font
		return v5
	end

	if typeof(font) == "table" then
		v5.fontFace = Font.new(font.Family, font.Weight, font.Style)
	end

	return v5
end

local function getTextSize(p2)
	return p2.FontSize
end

local function getLineHeight(p2)
	return p2.LineHeight
end

local function getColor3(p2)
	return p2.Color3
end

local function getTransparency(p2)
	return p2.Transparency
end

local function getSize(p2)
	return p2
end

local function getMarkdownRendererProps(data, p2)
	local typography = data.Typography
	local content = data.Color.Content
	local surface = data.DarkMode.Surface
	return {
		textStyles = typographyToTextStyles(typography.BodyMedium, p2),
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
			textSize = typography.BodyMedium.FontSize,
			lineHeight = typography.BodyMedium.LineHeight,
			color = `#{content.Emphasis.Color3:ToHex()}`,
			transparency = content.Emphasis.Transparency
		},
		codeBackgroundStyles = {
			backgroundColor3 = surface.Surface_300.Color3,
			backgroundTransparency = surface.Surface_300.Transparency
		},
		linkStyles = {
			linkColor = `#{content.Link.Color3:ToHex()}`
		},
		imageStyles = {
			size = UDim2.fromOffset(data.Size.Size_400, data.Size.Size_400)
		}
	}
end

return getMarkdownRendererProps
