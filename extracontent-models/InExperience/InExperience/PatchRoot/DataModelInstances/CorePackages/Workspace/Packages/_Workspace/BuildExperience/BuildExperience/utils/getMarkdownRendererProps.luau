local Parent = script:FindFirstAncestor("BuildExperience").Parent

require(Parent.Foundation)

local font = Font.new("rbxasset://fonts/families/BuilderMono.json", Enum.FontWeight.Regular)

local function colorToHex(p1) -- line: 46
	return `#{ p1.Color3:ToHex() }`
end
local function typographyToTextStyles(p2, p3) -- line: 51
	local p2Font = p2.Font
	local t1 = {
		textSize = p2.FontSize,
		color = `#{ p3.Color3:ToHex() }`,
		transparency = p3.Transparency
	}

	if typeof(p2Font) == "EnumItem" then
		t1.font = p2Font

		return t1
	end

	if typeof(p2Font) == "Font" then
		t1.fontFace = p2Font

		return t1
	end

	if typeof(p2Font) == "table" then
		t1.fontFace = Font.new(p2Font.Family, p2Font.Weight, p2Font.Style)
	end

	return t1
end
local function getTextSize(p4) -- line: 70
	return p4.FontSize
end
local function getLineHeight(p5) -- line: 74
	return p5.LineHeight
end
local function getColor3(p6) -- line: 78
	return p6.Color3
end
local function getTransparency(p7) -- line: 82
	return p7.Transparency
end
local function getSize(n1: number) -- line: 86
	return n1
end
local function getMarkdownRendererProps(p8, p9) -- line: 90
	-- upvalues: typographyToTextStyles (copy), font (copy)
	local Typography = p8.Typography
	local Content = p8.Color.Content
	local Surface = p8.DarkMode.Surface

	return {
		textStyles = typographyToTextStyles(Typography.BodyMedium, p9),
		headerStyles = {
			typographyToTextStyles(Typography.HeadingLarge, Content.Emphasis),
			typographyToTextStyles(Typography.HeadingMedium, Content.Emphasis),
			typographyToTextStyles(Typography.HeadingSmall, Content.Emphasis),
			typographyToTextStyles(Typography.TitleLarge, Content.Emphasis),
			typographyToTextStyles(Typography.TitleMedium, Content.Emphasis),
			(typographyToTextStyles(Typography.TitleMedium, Content.Emphasis))
		},
		codeStyles = {
			fontFace = font,
			textSize = Typography.BodyMedium.FontSize,
			lineHeight = Typography.BodyMedium.LineHeight,
			color = `#{ Content.Emphasis.Color3:ToHex() }`,
			transparency = Content.Emphasis.Transparency
		},
		codeBackgroundStyles = {
			backgroundColor3 = Surface.Surface_300.Color3,
			backgroundTransparency = Surface.Surface_300.Transparency
		},
		linkStyles = {
			linkColor = `#{ Content.Link.Color3:ToHex() }`
		},
		imageStyles = {
			size = UDim2.fromOffset(p8.Size.Size_400, p8.Size.Size_400)
		}
	}
end

return getMarkdownRendererProps
