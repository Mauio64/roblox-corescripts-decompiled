local module = require("@luauforge/bundled/hTe")
local module2 = require("@luauforge/bundled/hTj")
local module3 = require("@luauforge/bundled/hTk")
local module4 = require("@luauforge/bundled/hTl")
local module5 = require("@luauforge/bundled/hTm")
local module6 = require("@luauforge/bundled/hTh")

local markdownViewer = module4.Components.MarkdownViewer

local fFlagMarkdownFormattingTags = module6.FFlagSduiMarkdownRobloxProfile
	and module4.Flags.FFlagMarkdownFormattingTags

local rbxassetfontsfamiliesBuilderMonojson = Font.new(
	"rbxasset://fonts/families/BuilderMono.json",
	Enum.FontWeight.Regular,
	Enum.FontStyle.Normal
)

local function MarkdownCodeSpan(props)
	local fontStyle = props.fontStyle
	local textStyle = props.textStyle
	return module.createElement(module2.View, {
		LayoutOrder = props.LayoutOrder,
		backgroundStyle = { Transparency = 1 },
		stroke = props.stroke,
		cornerRadius = props.cornerRadius,
		padding = {
			top = UDim.new(0, props.verticalPadding),
			bottom = UDim.new(0, props.verticalPadding)
		},
		tag = "size-full-0 auto-y",
		testId = "--sdui-markdown-code-span"
	}, {
		Text = module.createElement("TextBox", {
			Text = props.Text,
			FontFace = fontStyle.Font,
			TextSize = fontStyle.FontSize,
			TextColor3 = textStyle.Color3,
			TextTransparency = textStyle.Transparency,
			TextEditable = false,
			ClearTextOnFocus = false,
			RichText = false,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(props.horizontalPadding, 0),
			Size = UDim2.new(1, -2 * props.horizontalPadding, 0, props.textHeight)
		})
	})
end

local baseTextElement = module3.Components.InlineLayoutElements.BaseTextElement
local object = setmetatable({}, { __index = baseTextElement })
object.__index = object
object.__type = baseTextElement.__type

function object.new(p2)
	return (setmetatable(baseTextElement.new(MarkdownCodeSpan, p2), object))
end

function object:_clone(p3)
	return object.new(p3)
end

function object.getWidth(p2)
	return baseTextElement.getWidth(p2) + 2 * p2.props.horizontalPadding
end

function object.split(p2, p3, p4)
	return baseTextElement.split(p2, math.max(0, p3 - 2 * p2.props.horizontalPadding), p4)
end

local v5 = {
	BOLD = { italic = true },
	BOLD_2 = { bold = true },
	ITALIC = { italic = true },
	ITALIC_2 = { underline = true },
	STRIKE = { strike = true },
	UNDERLINE = { underline = true }
}
local function underlineElement(object2)
	if not module3.Utils.isInlineElement(object2) or getmetatable(object2) == object then
		return object2
	end

	if object2.Elements then
		local clone = table.clone(object2)
		clone.Elements = {}

		for k, element in object2.Elements do
			table.insert(clone.Elements, underlineElement(element))
		end

		return clone
	else
		if not (object2.props and object2.props.Text and object2._clone) then
			return object2
		end

		local clone = table.clone(object2.props)
		local clone2 = table.clone(clone.EngineTags or {})

		for k, v6 in clone2 do
			if v6.name == "u" then
				return object2
			end
		end

		table.insert(clone2, { name = "u", attributes = {} })
		clone.EngineTags = clone2
		return object2:_clone(clone)
	end
end

local function appendCodeText(p2, texts)
	if #p2.children > 0 then
		for k, child in p2.children do
			appendCodeText(child, texts)
		end
	elseif p2.text then
		table.insert(texts, p2.text)
	end
end

local function getCodeSpanStyle(data, textSize)
	local scale = data.Config.UI.Scale
	local v6 = {
		Color = data.Color.Stroke.Default.Color3,
		Transparency = data.Color.Stroke.Default.Transparency,
		Thickness = data.Stroke.Thin,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner
	}

	local v7 = if data.Config.ColorMode.Name == module2.Enums.ColorMode.Dark then data.Color.Extended.Orange.Orange_700 else data.Color.Extended.Orange.Orange_900
	return {
		color = v7,
		fontSize = math.max(1, textSize - scale),
		horizontalPadding = data.Padding.XXSmall + data.Stroke.Thin,
		verticalPadding = scale + data.Stroke.Thin,
		cornerRadius = UDim.new(0, data.Radius.Small),
		stroke = v6
	}
end

local function renderStyledText(p2, data, p3)
	local style = if p2.attributes then p2.attributes.style else nil

	if style == "INLINE_CODE" then
		local v6 = {}
		appendCodeText(p2, v6)
		local textSize = data.textStyles.textSize or p3.Typography.BodySmall.FontSize
		local codeSpanStyle = getCodeSpanStyle(p3, textSize)
		local new = object.new
		local v7 = {
			Text = table.concat(v6),
			fontStyle = 0,
			textStyle = 0,
			textHeight = 0,
			horizontalPadding = 0,
			verticalPadding = 0,
			cornerRadius = 0,
			stroke = 0
		}

		local v9 = if data.codeStyles and data.codeStyles.fontFace then data.codeStyles.fontFace else rbxassetfontsfamiliesBuilderMonojson
		v7.fontStyle = { Font = v9, FontSize = codeSpanStyle.fontSize }

		v7.textStyle = codeSpanStyle.color
		v7.textHeight = textSize
		v7.horizontalPadding = codeSpanStyle.horizontalPadding
		v7.verticalPadding = codeSpanStyle.verticalPadding
		v7.cornerRadius = codeSpanStyle.cornerRadius
		v7.stroke = codeSpanStyle.stroke
		return new(v7)
	else
		if module5.Renderers and module5.Renderers.STYLED_TEXT then
			return module5.Renderers.STYLED_TEXT(p2, data)
		end

		local v6 = v5[style] or {}
		local v7 = data.processChildren(p2, module4.Utils.mergeContexts(data, {
			textStyles = v6
		}))

		if not v6.underline then
			return v7
		end

		local result = {}

		for k, v8 in v7 do
			table.insert(result, underlineElement(v8))
		end

		return result
	end
end

local function MarkdownQuote(props)
	local v6 = module2.Hooks.useTokens()

	return module.createElement(module2.View, {
		LayoutOrder = props.layoutOrder,
		backgroundStyle = { Transparency = 1 },
		padding = props.topPadding and { top = UDim.new(0, 10) } or nil,
		tag = "size-full-0 auto-y"
	}, {
		Quote = module.createElement(module2.View, {
			backgroundStyle = { Transparency = 1 },
			tag = "size-full-0 auto-y",
			testId = "--sdui-markdown-quote"
		}, {
			Content = module.createElement(module2.View, {
				backgroundStyle = { Transparency = 1 },
				padding = { left = UDim.new(0, v6.Padding.Large) },
				tag = "col size-full-0 auto-y",
				testId = "--sdui-markdown-quote-content"
			}, props.children),
			Bar = module.createElement(module2.View, {
				Size = UDim2.new(0, v6.Size.Size_100, 1, 0),
				backgroundStyle = v6.Color.Content.Default,
				tag = "radius-small",
				testId = "--sdui-markdown-quote-bar"
			})
		})
	})
end

local function textNode(p2)
	return { name = "TEXT", text = p2, children = {}, type = "InlineLeaf" }
end

local function splitQuoteLines(p2)
	local clones = {}
	local v6 = {}
	local function addLine()
		local clone = table.clone(p2)
		clone.index = #clones + 1
		clone.children = v6
		table.insert(clones, clone)
		v6 = {}
	end

	for k, v7 in p2.children or {} do
		if v7.name == "BREAK" then
			local clone = table.clone(p2)
			clone.index = #clones + 1
			clone.children = v6
			table.insert(clones, clone)
			v6 = {}
		elseif
			fFlagMarkdownFormattingTags
			and v7.name == "TEXT"
			and string.find(v7.text or "", "\n", 1, true)
		then
			for k2, v8 in string.split(v7.text, "\n") do
				if k2 > 1 then
					local clone = table.clone(p2)
					clone.index = #clones + 1
					clone.children = v6
					table.insert(clones, clone)
					v6 = {}
				end

				if v8 ~= "" then
					table.insert(v6, {
						name = "TEXT",
						text = v8,
						children = {},
						type = "InlineLeaf"
					})
				end
			end
		else
			table.insert(v6, v7)
		end
	end

	if #clones == 0 then
		return nil
	end

	local clone = table.clone(p2)
	clone.index = #clones + 1
	clone.children = v6
	table.insert(clones, clone)
	v6 = {}

	return clones
end

local function renderQuote(p2, p3)
	local v6 = splitQuoteLines(p2)
	local children

	if v6 then
		children = {}

		for k, v7 in v6 do
			table.insert(children, module.createElement(module2.View, {
				key = tostring(v7.index),
				LayoutOrder = v7.index,
				backgroundStyle = { Transparency = 1 },
				tag = "size-full-0 auto-y"
			}, module4.Components.NodeRenderers.renderInline(v7, p3)))
		end
	else
		children = module4.Components.NodeRenderers.renderInline(p2, p3)
	end

	return module.createElement(MarkdownQuote, {
		key = tostring(p2.index),
		layoutOrder = p2.index,
		topPadding = p2.offset ~= 0
	}, children)
end

local function getTextFont(p2)
	local v6 = p2.fontFace or p2.font

	if typeof(v6) == "Font" then
		return v6
	end

	local fromEnum = Font.fromEnum

	if typeof(v6) ~= "EnumItem" then
		v6 = Enum.Font.BuilderSans
	end

	return fromEnum(v6)
end

local function getListMarker(p2)
	local prefix = if p2.attributes then p2.attributes.prefix else nil

	if type(prefix) == "string" and not string.find(prefix, "^[%*%-%+]") then
		return `{prefix}.`
	end

	return nil
end

local function MarkdownListItem(props)
	local v6 = module2.Hooks.useTokens()
	local textStyles = props.textStyles
	local v8 = textStyles.fontFace or textStyles.font

	if typeof(v8) ~= "Font" then
		local fromEnum = Font.fromEnum

		if typeof(v8) ~= "EnumItem" then
			v8 = Enum.Font.BuilderSans
		end

		v8 = fromEnum(v8)
	end

	local v7 = { Font = v8, FontSize = textStyles.textSize }
	local v9 = textStyles.color

	if typeof(v9) == "string" then
		v9 = Color3.fromHex(v9)
	elseif typeof(v9) ~= "Color3" then
		v9 = v6.Color.Content.Default.Color3
	end

	local v10 = { Color3 = v9, Transparency = textStyles.transparency }

	local children = {}

	for k, markerSizer in props.markerSizers do
		children[`Sizer{k}`] = module.createElement(module2.Text, {
			Text = markerSizer,
			fontStyle = v7,
			textStyle = { Transparency = 1 },
			tag = "auto-xy"
		})
	end

	if props.marker then
		children.Number = module.createElement(module2.View, {
			backgroundStyle = { Transparency = 1 },
			tag = "row align-x-right size-full"
		}, {
			Label = module.createElement(module2.Text, {
				Text = props.marker,
				fontStyle = v7,
				textStyle = v10,
				TextXAlignment = Enum.TextXAlignment.Right,
				tag = "auto-xy"
			})
		})
	elseif props.showBullet then
		children.Bullet = module.createElement(module2.View, {
			backgroundStyle = { Transparency = 1 },
			tag = "row align-y-center size-full"
		}, {
			Dot = module.createElement(module2.Image, {
				Image = "rbxasset://textures/StudioSharedUI/dot.png",
				imageStyle = v10,
				Size = UDim2.fromOffset(4, 4),
				testId = "--sdui-markdown-list-bullet"
			})
		})
	end

	return module.createElement(module2.View, {
		LayoutOrder = props.layoutOrder,
		backgroundStyle = { Transparency = 1 },
		tag = "row align-y-top gap-small size-full-0 auto-y"
	}, {
		Marker = module.createElement(module2.View, {
			LayoutOrder = 1,
			backgroundStyle = { Transparency = 1 },
			tag = "auto-xy"
		}, children),
		Content = module.createElement(module2.View, {
			LayoutOrder = 2,
			backgroundStyle = { Transparency = 1 },
			tag = "col fill gap-xsmall size-full-0 auto-y"
		}, props.children)
	})
end

local function renderList(props, p2)
	local v6 = {}

	for k, child in props.children do
		if child.name == "LIST" and #v6 > 0 then
			table.insert(v6[#v6].sublists, child)
		else
			table.insert(v6, { node = child, sublists = {} })
		end
	end

	local v7 = { [" "] = true }
	local v8 = { " " }

	for k, v9 in v6 do
		local node = v9.node
		local prefix = if node.attributes then node.attributes.prefix else nil
		local v10

		if type(prefix) == "string" and not string.find(prefix, "^[%*%-%+]") then
			v10 = `{prefix}.`
		end

		local v11 = if v10 then string.gsub(v10, "%d", "0") else nil

		if not v11 or v7[v11] then
			continue
		end

		v7[v11] = true
		table.insert(v8, v11)
	end

	local children = {}

	for k, v9 in v6 do
		local v10 = { v9.node }

		for k2, sublist in v9.sublists do
			table.insert(v10, sublist)
		end

		for k2, v11 in v10 do
			local clone = table.clone(v11)
			clone.index = k2

			if k2 > 1 then
				clone.offset = 0
			end

			v10[k2] = clone
		end

		local v11 = p2.processChildren(
			{
				name = props.name,
				type = props.type,
				offset = props.offset,
				children = v10
			},
			p2
		)

		local v12 = tostring(k)
		local createElement = module.createElement

		local node = v9.node
		local prefix = if node.attributes then node.attributes.prefix else nil
		local v15 = if type(prefix) == "string" and not string.find(prefix, "^[%*%-%+]") then `{prefix}.` else nil

		children[v12] = createElement(MarkdownListItem, {
			layoutOrder = k,
			marker = v15,
			showBullet = v9.node.name == "LIST_ITEM",
			markerSizers = v8,
			textStyles = p2.textStyles
		}, v11)
	end

	return module.createElement(module2.View, {
		key = tostring(props.index),
		LayoutOrder = props.index,
		backgroundStyle = { Transparency = 1 },
		padding = props.offset ~= 0 and { top = UDim.new(0, 10) } or nil,
		tag = "col gap-xsmall size-full-0 auto-y"
	}, children)
end

local v6 = {
	inlineTags = { b = true, i = true, u = true, s = true }
}

local v7 = { b = "BOLD_2", i = "ITALIC", u = "ITALIC_2", s = "STRIKE" }
local v8 = { TABLE_HEADER = true, TABLE_HEADER_2 = true, TABLE_DIVIDER = true }
local function normalizeTagContent(children)
	local tagContent = {}

	for k, item in children do
		local v9 = tagContent[#tagContent]

		if v8[item.name] or item.name == "TEXT" then
			if v9 and v9.name == "TEXT" then
				tagContent[#tagContent] = {
					name = "TEXT",
					text = (v9.text or "") .. (item.text or ""),
					children = {},
					type = "InlineLeaf"
				}
			else
				table.insert(tagContent, {
					name = "TEXT",
					text = item.text or "",
					children = {},
					type = "InlineLeaf"
				})
			end
		elseif item.children and #item.children > 0 then
			local clone = table.clone(item)
			clone.children = normalizeTagContent(item.children)
			table.insert(tagContent, clone)
		else
			table.insert(tagContent, item)
		end
	end

	return tagContent
end

local function renderMarkTag(p2, p3, p4)
	return renderStyledText({
		name = "STYLED_TEXT",
		type = "InlineSpan",
		attributes = {
			style = v7[p2.text or ""]
		},
		children = normalizeTagContent(p2.children or {})
	}, p3, p4)
end

local clone = table.clone(module5.Renderers or {})
clone.LIST = renderList
clone.QUOTE = renderQuote

local function StyledMarkdownViewer(p2)
	local v9 = module2.Hooks.useTokens()
	local v10 = module.useMemo(function()
		local clone2 = table.clone(clone)
		function clone2.STYLED_TEXT(p3, p4)
			return renderStyledText(p3, p4, v9)
		end

		function clone2.TAG(p3, p4)
			return renderMarkTag(p3, p4, v9)
		end

		return clone2
	end, { v9 })
	local markdown = p2.Markdown or ""
	local v11 = module.useMemo(function()
		local v12, v13

		if fFlagMarkdownFormattingTags then
			v12, v13 = module4.Parsers.RobloxMarkdown.safeParse(markdown)
		else
			v12, v13 = module4.Parsers.CommonMarkComplianceParser.safeParse(markdown, v6)
		end

		if not v12 then
			v13 = nil
		end

		return { ok = v12, ast = v13 }
	end, { markdown })

	local element = module.createElement(module2.Text, {
		Text = string.gsub(markdown, "\\(%p)", "%1"),
		RichText = false,
		LayoutOrder = p2.WrapperProps and p2.WrapperProps.LayoutOrder,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
		testId = "--sdui-markdown-fallback"
	})

	if not v11.ok then
		return element
	end

	local clone2 = table.clone(p2)
	clone2.MarkdownRendererProps = module5.MarkdownRendererProps
	clone2.Renderers = v10

	clone2.Ast = v11.ast
	clone2.Fallback = element
	return module.createElement(markdownViewer, clone2)
end

local function MarkdownLineClamp(props)
	local v9 = module2.Hooks.useTokens()
	local textStyles = module5.MarkdownRendererProps and module5.MarkdownRendererProps.textStyles
	local bodyMedium = v9.Typography.BodyMedium
	local v10 = (textStyles and textStyles.textSize or bodyMedium.FontSize) * (bodyMedium.LineHeight or 1)
	local v11 = math.ceil((props.maxLines + 1) * v10)
	local state, setState = module.useState(0)
	local ref = module.useRef(nil)

	module.useEffect(function()
		local current = ref.current

		if not current then
			return nil
		end

		local function update()
			setState(current.AbsoluteSize.Y)
		end

		setState(current.AbsoluteSize.Y)

		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, {})

	local v12 = v11 + 0.5 < state
	local v13 = math.clamp(1 - 1 * v10 / v11, 0, 1)

	local createElement = module.createElement
	local v15 = {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, (math.min(state, v11))),
		[module.Tag] = "data-testid=--sdui-markdown-line-clamp"
	}

	local v17 = if v12 then module.createElement("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(v13, 0),
			NumberSequenceKeypoint.new(1, 1)
		})
	}) else nil
	return createElement("CanvasGroup", v15, {
		Fade = v17,
		Content = module.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = ref
		}, props.children)
	})
end

local function SduiMarkdownText(props)
	local v9 = not (props.maxLines == nil) and props.maxLines > 0
	local v10 = {
		Markdown = props.text or "",
		WrapperProps = 0
	}

	local v12 = if not v9 then props.layoutOrder else nil
	v10.WrapperProps = { LayoutOrder = v12, tag = "size-full-0 auto-y" }

	local element = module.createElement(StyledMarkdownViewer, v10)

	if v9 then
		return module.createElement(
			MarkdownLineClamp,
			{ maxLines = props.maxLines, layoutOrder = props.layoutOrder },
			element
		)
	end

	return element
end

return module.memo(SduiMarkdownText)
