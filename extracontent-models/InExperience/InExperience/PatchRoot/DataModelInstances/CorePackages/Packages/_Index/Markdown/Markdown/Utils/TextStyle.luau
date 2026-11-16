local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
local Dash = require(parent.Dash)
require(Markdown.Types)
require(parent.InlineLayout)
local MarkdownCore = require(parent.MarkdownCore)
local InlineEngineTag = MarkdownCore.Enums.InlineEngineTag
local TextStyle = {}

function TextStyle.getCodeTextStyles(p)
	return Dash.joinDeep(p.textStyles, p.codeStyles)
end

function TextStyle.getBaseTextElementEngineTags(data)
	if not data then
		return nil
	end

	local v = {}

	if data.bold then
		table.insert(v, { name = InlineEngineTag.BOLD, attributes = {} })
	end

	if data.italic then
		table.insert(v, { name = InlineEngineTag.ITALIC, attributes = {} })
	end

	if data.strike then
		table.insert(v, { name = InlineEngineTag.STRIKE, attributes = {} })
	end

	if data.color then
		table.insert(v, {
			name = InlineEngineTag.FONT,
			attributes = { color = data.color }
		})
	end

	if data.underline then
		table.insert(v, { name = InlineEngineTag.UNDERLINE, attributes = {} })
	end

	return v
end

function TextStyle.normalizeStyleFont(p)
	if not p then
		return p
	end

	local omit = Dash.omit(p, { "font" })

	if omit.fontFace ~= nil or p.font == nil then
		return omit
	end

	local fontFace

	if typeof(p.font) == "Font" then
		fontFace = p.font
	else
		fontFace = Font.fromEnum(p.font)
	end

	omit.fontFace = fontFace

	return omit
end

return TextStyle
