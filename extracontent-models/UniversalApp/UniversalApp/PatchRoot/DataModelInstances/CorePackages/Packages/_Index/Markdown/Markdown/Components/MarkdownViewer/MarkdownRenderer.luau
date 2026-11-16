local MessageBusService = game:GetService("MessageBusService")

local parent = script:FindFirstAncestor("Components").Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Dash = require(parent2.Dash)
local Foundation = require(parent2.Foundation)
local InlineLayout = require(parent2.InlineLayout)
local MarkdownCore = require(parent2.MarkdownCore)

local View = Foundation.View
local Text = Foundation.Text
local Divider = Foundation.Divider

local utils = parent.Utils

local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement
local SelectableTextElement = InlineLayout.Components.InlineLayoutElements.SelectableTextElement
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local ImageElement = InlineLayout.Components.InlineLayoutElements.ImageElement
local HardBreakElement = InlineLayout.Components.InlineLayoutElements.HardBreakElement
local mergeContexts = require(utils.mergeContexts)
local processSoftBreaks = require(utils.processSoftBreaks)
local shouldUseTopPadding = require(utils.shouldUseTopPadding)
local TextStyle = require(utils.TextStyle)
local MarkdownTable = require(script.Parent.Parent.NodeRenderers.MarkdownTable)
local renderInline = require(script.Parent.Parent.NodeRenderers.renderInline)
local renderTag = require(script.Parent.Parent.NodeRenderers.renderTag)
local BulletList = MarkdownCore.Components.BulletList

local getBaseTextElementEngineTags = TextStyle.getBaseTextElementEngineTags
local getCodeTextStyles = TextStyle.getCodeTextStyles
local normalizeStyleFont = TextStyle.normalizeStyleFont

require(parent.Types)
local Highlighter = MarkdownCore.Utils.Highlighter
local getNodeTypeConfig = require(parent.Utils.getNodeTypeConfig)
local isInlineElement = InlineLayout.Utils.isInlineElement
local Flags = MarkdownCore.Flags
local fFlagMarkdownTables = Flags.FFlagMarkdownTables or Flags.FFlagMarkdownTagFallbacks

local BuilderSans = Enum.Font.BuilderSans
local udim = UDim2.fromOffset(16, 16)

local Code = Enum.Font.Code

local rbxassetfontsfamiliesBuilderMonojson = Font.new(
	"rbxasset://fonts/families/BuilderMono.json",
	Enum.FontWeight.Regular,
	Enum.FontStyle.Normal
)

local function fn(p: string)
	print(`[Default link callback]: URL [{p}] is clicked`)
end

local MarkdownRenderer = { renderers = {} }

local function getFontFace(p, p2)
	local fontFace = p.fontFace or p.font

	if typeof(fontFace) == "Font" then
		return fontFace
	end

	if fontFace then
		return Font.fromEnum(fontFace)
	end

	return Font.fromEnum(p2)
end

local function render(data, p)
	if not data then
		return nil
	end

	local v

	if fFlagMarkdownTables and p.renderers then
		v = p.renderers
	else
		v = MarkdownRenderer.renderers
	end

	local v2 = v[data.name]

	if not v2 then
		warn(`No renderer found for node: {data.name}`)
		return nil
	end

	local v3 = v2(data, p)
	local nodeTypeConfig = getNodeTypeConfig(data)

	if nodeTypeConfig and not nodeTypeConfig.validateRenderResult(v3) then
		warn(`Invalid render result for node: {data.name} {data.text} of type: {data.type}`)
	end

	return v3
end

local function processChildren(data, p)
	local children = data.children

	if not children then
		return {}
	end

	local nodeTypeConfig = getNodeTypeConfig(data)
	local children2 = nodeTypeConfig and nodeTypeConfig.children or {}

	local result = {}

	for _, child in children do
		local kind = child.type

		if not children2[kind] then
			warn(`Invalid child node type. Parent node: {data.name} {data.text} of type: {data.type} has invalid child node: {child.name} {child.text} of type: {kind}`)
		end

		local v = render(child, p)

		if not v then
			continue
		end

		if #v > 0 then
			for _, v2 in v do
				table.insert(result, v2)
			end
		else
			table.insert(result, v)
		end
	end

	return result
end

local function renderRoot(p, p2)
	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		BorderSizePixel = 0,
		backgroundStyle = { Transparency = 1 }
	}, (p2.processChildren(p, p2)))
end

local function renderHeading(p, p2)
	local v = math.clamp(
		(not p.attributes or type(p.attributes.depth) ~= "number") and 1 or p.attributes.depth,
		1,
		#p2.headerStyles
	)

	return React.createElement(View, {
		key = tostring(p.index),
		LayoutOrder = p.index,
		tag = "size-full-0 auto-y"
	}, {
		UIPadding = shouldUseTopPadding(p) and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 20)
		}),
		InlineLayout = renderInline(p, mergeContexts(p2, { textStyles = p2.headerStyles[v] }))
	})
end

local function renderParagraph(p, p2)
	return React.createElement(View, {
		key = tostring(p.index),
		LayoutOrder = p.index,
		tag = "size-full-0 auto-y"
	}, {
		UIPadding = shouldUseTopPadding(p) and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 10)
		}),
		InlineLayout = renderInline(p, p2)
	})
end

local function computeLineNumbers(text: string)
	local v = #text
	local v2 = 0
	local v3 = 1
	local v4 = {}

	while true do
		local v5 = v2 <= v and string.find(text, "\n", v2, true)

		if not v5 then
			break
		end

		v4[v3] = tostring(v3)
		v3 += 1
		v2 = v5 + 1
	end

	v4[v3] = tostring(v3)
	return table.concat(v4, "\n")
end

local function copyToClipboard(text) -- 1 equivalent call inferred from this helper
	pcall(function()
		return MessageBusService:Publish(MessageBusService:GetMessageId("ExternalContentSharing", "setClipboardText"), {
			text = text
		})
	end)
end
local memoize = Dash.memoize(function(text)
	return function()
		copyToClipboard(text) -- inferred equivalent call
	end
end)

local function renderCodeBlock(props, props2)
	local language

	if props.attributes then
		language = props.attributes.language
	end

	local text = props.text
	local text2

	if language == "lua" then
		text2 = Highlighter.highlight(text, props2.colorScheme)
	else
		text2 = text
	end

	local codeTextStyles = getCodeTextStyles(props2)

	local fontStyle = { FontSize = codeTextStyles.textSize, Font = 0, LineHeight = 0 }
	local font

	if Flags.FFlagMarkdownAssistantParity then
		font = codeTextStyles.fontFace or rbxassetfontsfamiliesBuilderMonojson
	else
		font = codeTextStyles.fontFace or codeTextStyles.font

		if typeof(font) ~= "Font" then
			if font then
				font = Font.fromEnum(font)
			else
				font = Font.fromEnum(Code)
			end
		end
	end

	fontStyle.Font = font

	fontStyle.LineHeight = codeTextStyles.lineHeight
	local v = {
		TextWrapped = false,
		fontStyle = fontStyle,
		TextXAlignment = Enum.TextXAlignment.Left,
		tag = "auto-xy padding-small align-y-top"
	}

	local v2 = {
		Text = text2,
		textStyle = {
			Color3 = Highlighter.getTokenColor("iden")
		},
		RichText = true,
		ZIndex = 1
	}

	local v3 = {
		Text = text,
		textStyle = {
			Color3 = Highlighter.getTokenColor("iden"),
			Transparency = 0.4
		},
		ZIndex = 0,
		TextSelectable = true
	}

	local codeBackgroundStyles = props2.codeBackgroundStyles or {}
	local backgroundColor3 = codeBackgroundStyles.backgroundColor3 or Highlighter.getTokenColor("background")
	local backgroundTransparency = codeBackgroundStyles.backgroundTransparency or 0

	local showLineNumbers = props2.codeSettings and props2.codeSettings.showLineNumbers
	local text3

	if showLineNumbers then
		text3 = computeLineNumbers(text)
	end

	local showCopyButton = props2.codeSettings and props2.codeSettings.showCopyButton

	local createElement = React.createElement
	local v4 = {
		key = tostring(props.index),
		LayoutOrder = props.index,
		tag = "size-full-0 auto-y col",
		backgroundStyle = { Transparency = 1 },
		BorderSizePixel = 0
	}

	local createElement2 = React.createElement
	local paddingTop

	if shouldUseTopPadding(props) then
		paddingTop = UDim.new(0, 10)
	end

	local children = {
		UIPadding = createElement2("UIPadding", {
			PaddingTop = paddingTop,
			PaddingBottom = UDim.new(0, 10)
		}),
		TitleBar = 0,
		CodeWrapper = 0
	}
	local titleBar

	if showCopyButton then
		titleBar = React.createElement(
			Foundation.View,
			{
				tag = "size-full-0 auto-y row align-x-right bg-shift-300 radius-small",
				LayoutOrder = 1
			},
			{
				CopyToClipboardButton = React.createElement(Foundation.IconButton, {
					size = Foundation.Enums.InputSize.Small,
					icon = { name = Foundation.Enums.IconName.TwoStackedSquares },
					onActivated = memoize(text)
				})
			}
		)
	end

	children.TitleBar = titleBar

	local createElement3 = React.createElement
	local view = Foundation.View
	local lineNumbers

	if showLineNumbers then
		lineNumbers = React.createElement(Foundation.Text, {
			Text = text3,
			fontStyle = v.fontStyle,
			LayoutOrder = 1,
			tag = "size-0-0 auto-xy text-align-x-right text-align-y-center padding-small bg-shift-100 content-emphasis"
		})
	end

	children.CodeWrapper = createElement3(view, {
		LayoutOrder = 2,
		tag = { ["size-full-0 auto-y"] = true, ["row align-y-center"] = showLineNumbers }
	}, {
		LineNumbers = lineNumbers,
		ScrollFrameWrapper = React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y fill", Size = UDim2.fromScale(1, 0), LayoutOrder = 2 },
			{
				ScrollFrame = React.createElement("ScrollingFrame", {
					BackgroundColor3 = backgroundColor3,
					BackgroundTransparency = backgroundTransparency,
					BorderSizePixel = 0,
					ScrollingDirection = Enum.ScrollingDirection.X,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.X
				}, {
					HighlightedCode = React.createElement(Text, Dash.join(v, v2)),
					SelectableCodeWrapper = React.createElement(Foundation.View, { tag = v.tag }, {
						SelectableCode = React.createElement("TextBox", {
							Text = v3.Text,
							FontFace = v.fontStyle.Font,
							TextSize = v.fontStyle.FontSize,
							TextColor3 = v3.textStyle.Color3,
							TextTransparency = v3.textStyle.Transparency,
							BackgroundTransparency = 1,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextEditable = false,
							ZIndex = v3.ZIndex,
							Size = UDim2.fromScale(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							TextWrapped = false,
							ClearTextOnFocus = false,
							LineHeight = props2.codeStyles.lineHeight
						})
					})
				})
			}
		)
	})
	return createElement(View, v4, children)
end

local function renderList(p, p2)
	local v = nil
	local items = {}

	for i = #p.children, 1, -1 do
		local child = p.children[i]

		if child.name == "LIST" then
			v = child
		elseif v then
			local prefix

			if child.attributes then
				prefix = child.attributes.prefix
			end

			local children = {
				Prefix = prefix,
				Item = React.createElement(View, {
					tag = "size-full-0 auto-y col",
					BorderSizePixel = 0,
					backgroundStyle = { Transparency = 1 }
				}, {
					Item = render(Dash.join(child, { index = 1 }), p2),
					List = render(Dash.join(v, { index = 2 }), p2)
				})
			}
			table.insert(items, 1, children)
			v = nil
		else
			local prefix

			if child.attributes then
				prefix = child.attributes.prefix
			end

			local v2 = { Prefix = prefix, Item = render(child, p2) }
			table.insert(items, 1, v2)
		end
	end

	local createElement = React.createElement
	local v2 = {
		key = tostring(p.index),
		LayoutOrder = p.index,
		Items = items,
		TextWrapped = true,
		ListStyle = 0,
		tag = "size-full-0 auto-y"
	}
	local font

	if Flags.FFlagMarkdownAssistantParity then
		font = p2.textStyles.fontFace
	else
		local textStyles = p2.textStyles
		font = textStyles.fontFace or textStyles.font

		if typeof(font) ~= "Font" then
			if font then
				font = Font.fromEnum(font)
			else
				font = Font.fromEnum(BuilderSans)
			end
		end
	end

	local textColor

	if typeof(p2.textStyles.color) == "string" then
		textColor = Color3.fromHex(p2.textStyles.color)
	else
		textColor = p2.textStyles.color
	end

	v2.ListStyle = {
		Font = font,
		TextColor = textColor,
		TextSize = p2.textStyles.textSize,
		LineHeight = p2.textStyles.textSize
	}
	return createElement(BulletList, v2, {
		UIPadding = shouldUseTopPadding(p) and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 10)
		})
	})
end

local function renderListItem(p, p2)
	return React.createElement(View, {
		key = tostring(p.index),
		LayoutOrder = p.index,
		tag = "size-full-0 auto-y"
	}, {
		InlineLayout = renderInline(p, p2)
	})
end

local function renderStyledText(p, p2)
	local style

	if p.attributes and p.attributes.style then
		style = p.attributes.style
	end

	local textStyles = {}

	if style == "BOLD" or style == "BOLD_2" then
		textStyles.bold = true
	elseif style == "ITALIC" or style == "ITALIC_2" then
		textStyles.italic = true
	elseif style == "UNDERLINE" then
		textStyles.underline = true
	elseif style == "STRIKE" then
		textStyles.strike = true
	elseif style == "INLINE_CODE" then
		local codeStyles = p2.codeStyles
		textStyles = Dash.joinDeep(codeStyles, { selectable = true })
	end

	return (p2.processChildren(p, mergeContexts(p2, { textStyles = textStyles })))
end

local function renderText(p, p2)
	local v = {
		LayoutOrder = p.index,
		Text = processSoftBreaks(p.text),
		EngineTags = getBaseTextElementEngineTags(p2.textStyles),
		fontStyle = 0,
		textStyle = 0,
		viewTags = 0,
		tag = 0
	}
	local font

	if Flags.FFlagMarkdownAssistantParity then
		font = p2.textStyles.fontFace
	else
		local textStyles = p2.textStyles
		font = textStyles.fontFace or textStyles.font

		if typeof(font) ~= "Font" then
			if font then
				font = Font.fromEnum(font)
			else
				font = Font.fromEnum(BuilderSans)
			end
		end
	end

	v.fontStyle = { Font = font, FontSize = p2.textStyles.textSize }
	local color

	if typeof(p2.textStyles.color) == "string" then
		color = Color3.fromHex(p2.textStyles.color)
	else
		color = p2.textStyles.color
	end

	v.textStyle = { Color3 = color, Transparency = p2.textStyles.transparency }

	v.viewTags = p2.textStyles.viewTags
	local tag

	if Flags.FFlagMarkdownTables then
		tag = p2.textStyles.textTags
	end

	v.tag = tag

	if p2.textStyles.selectable then
		return SelectableTextElement.new(v)
	end

	return TextElement.new(v)
end

local function renderHardBreak()
	return HardBreakElement
end

local function renderLink(p, data)
	local url = p.attributes and p.attributes.url or p.url or ""
	local v = data.processChildren(p, mergeContexts(data, {
		textStyles = { color = data.linkStyles.linkColor }
	}))

	local filtered = Dash.filter(v, function(p2)
		return isInlineElement(p2) and p2 ~= HardBreakElement
	end)

	return LinkElement.new(filtered, {
		onActivated = function()
			data.linkCallback(url)
		end
	})
end

local function renderThematicBreak(p)
	return React.createElement(View, {
		key = tostring(p.index),
		tag = "size-full-0 auto-y",
		LayoutOrder = p.index
	}, {
		UIPadding = shouldUseTopPadding(p) and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 10)
		}),
		Divider = React.createElement(Divider)
	})
end

local function renderBlockquote(p, p2)
	return React.createElement(View, {
		key = tostring(p.index),
		LayoutOrder = p.index,
		tag = "size-full-0 auto-y padding-small",
		backgroundStyle = { Transparency = 1 }
	}, {
		InlineLayoutWrapper = React.createElement(View, {
			backgroundStyle = { Transparency = 0.9, Color3 = Color3.fromRGB(163, 162, 165) },
			tag = "size-full-0 auto-y"
		}, {
			InlineLayout = renderInline(p, mergeContexts(p2, {
				textStyles = { italic = true, transparency = 0.5 }
			}))
		})
	})
end

local function renderImage(data, p)
	local url = data.attributes and data.attributes.url or data.url or nil
	return ImageElement.new({
		LayoutOrder = data.index,
		Image = url,
		Size = p.imageStyles.size,
		backgroundStyle = {
			Transparency = p.imageStyles.backgroundTransparency,
			Color3 = p.imageStyles.backgroundColor3
		},
		imageStyle = { Transparency = p.imageStyles.transparency },
		ScaleType = p.imageStyles.scaleType,
		ResampleMode = p.imageStyles.resampleMode,
		tag = p.imageStyles.tags
	})
end

MarkdownRenderer.defaultRenderers = {
	["ROOT"] = renderRoot,
	HEADING = renderHeading,
	PARAGRAPH = renderParagraph,
	CODE_BLOCK = renderCodeBlock,
	STYLED_TEXT = renderStyledText,
	TEXT = renderText,
	LINK = renderLink,
	LIST = renderList,
	LIST_ITEM = renderListItem,
	DIVIDER = renderThematicBreak,
	QUOTE = renderBlockquote,
	IMAGE = renderImage,
	TAG = renderTag,
	BREAK = renderHardBreak,
	LINE_BREAK = renderHardBreak
}

if Flags.FFlagMarkdownTables then
	MarkdownRenderer.defaultRenderers.TABLE = MarkdownTable.renderTable
	MarkdownRenderer.defaultRenderers.TABLE_ROW = MarkdownTable.renderTableRow
	MarkdownRenderer.defaultRenderers.TABLE_HEADER = MarkdownTable.renderTableRow
	MarkdownRenderer.defaultRenderers.TABLE_CELL = MarkdownTable.renderTableCell
end

if Flags.FFlagMarkdownTagFallbacks then
	MarkdownRenderer.defaultRenderers.ACTION = renderText
end

function MarkdownRenderer.render(p, data)
	MarkdownRenderer.renderers = data.userRenderers

	local clone = table.clone(data.markdownRendererProps or {})
	local v

	if Flags.FFlagMarkdownAssistantParity then
		clone.textStyles = normalizeStyleFont(clone.textStyles)
		clone.codeStyles = normalizeStyleFont(clone.codeStyles)

		if clone.headerStyles then
			clone.headerStyles = Dash.map(clone.headerStyles, normalizeStyleFont)
		end

		local bodyMedium = data.tokens.Typography.BodyMedium
		local fontFace = normalizeStyleFont({ font = bodyMedium.Font }).fontFace
		local fontSize = bodyMedium.FontSize

		v = {
			textStyles = { textSize = fontSize, fontFace = fontFace },
			codeStyles = {
				textSize = fontSize,
				fontFace = rbxassetfontsfamiliesBuilderMonojson,
				lineHeight = 1.111
			},
			headerStyles = {
				{
					textSize = fontSize * 3,
					fontFace = fontFace
				},
				{
					textSize = fontSize * 2.5,
					fontFace = fontFace
				},
				{
					textSize = fontSize * 2,
					fontFace = fontFace
				},
				{
					textSize = fontSize * 1.5,
					fontFace = fontFace
				},
				{
					textSize = fontSize * 1.5,
					fontFace = fontFace
				},
				{
					textSize = fontSize * 1.5,
					fontFace = fontFace
				}
			}
		}
	else
		v = {
			textStyles = { textSize = 18, font = BuilderSans },
			codeStyles = { textSize = 18, font = Code, lineHeight = 1.111 },
			headerStyles = {
				{ textSize = 54, font = BuilderSans },
				{ textSize = 45, font = BuilderSans },
				{ textSize = 36, font = BuilderSans },
				{ textSize = 27, font = BuilderSans }
			}
		}
	end

	local joinDeep = Dash.joinDeep({
		textStyles = v.textStyles,
		codeStyles = v.codeStyles,
		headerStyles = v.headerStyles,
		imageStyles = { size = udim },
		linkStyles = {
			linkColor = `#{data.tokens.Color.Content.Link.Color3:ToHex()}`
		},
		isInline = false,
		linkCallback = data.linkCallback or fn,
		colorScheme = data.colorScheme,
		processChildren = processChildren
	}, clone)

	if fFlagMarkdownTables then
		joinDeep.renderers = data.userRenderers
	end

	table.freeze(joinDeep)

	return render(p, joinDeep)
end

return MarkdownRenderer
