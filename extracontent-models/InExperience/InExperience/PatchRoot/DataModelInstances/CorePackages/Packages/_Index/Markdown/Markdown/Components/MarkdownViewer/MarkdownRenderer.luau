local MessageBusService = game:GetService("MessageBusService")
local Parent = script:FindFirstAncestor("Components").Parent
local ParentParent = Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)
local Foundation = require(ParentParent.Foundation)
local InlineLayout = require(ParentParent.InlineLayout)
local MarkdownCore = require(ParentParent.MarkdownCore)
local View = Foundation.View
local FoundationText = Foundation.Text
local Divider = Foundation.Divider
local Utils = Parent.Utils
local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement
local SelectableTextElement = InlineLayout.Components.InlineLayoutElements.SelectableTextElement
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local ImageElement = InlineLayout.Components.InlineLayoutElements.ImageElement
local HardBreakElement = InlineLayout.Components.InlineLayoutElements.HardBreakElement
local mergeContexts = require(Utils.mergeContexts)
local processSoftBreaks = require(Utils.processSoftBreaks)
local getCodeTextStyles = require(Utils.TextStyle).getCodeTextStyles
local getBaseTextElementEngineTags = require(Utils.TextStyle).getBaseTextElementEngineTags
local renderInline = require(script.Parent.Parent.NodeRenderers.renderInline)
local renderTag = require(script.Parent.Parent.NodeRenderers.renderTag)
local BulletList = MarkdownCore.Components.BulletList

require(Parent.Types)

local Highlighter = MarkdownCore.Utils.Highlighter
local getNodeTypeConfig = require(Parent.Utils.getNodeTypeConfig)
local isInlineElement = InlineLayout.Utils.isInlineElement
local BuilderSans = Enum.Font.BuilderSans
local uDim2 = UDim2.new(0, 16, 0, 16)
local Code = Enum.Font.Code

local function v31(s1: string) -- line: 43
	print(`[Default link callback]: URL [{ s1 }] is clicked`)
end

local t1 = {
	renderers = {}
}

local function getFontFace(p1, p2) -- line: 51
	if p1.fontFace then
		return p1.fontFace
	end

	if p1.font then
		return Font.fromEnum(p1.font)
	end

	return Font.fromEnum(p2)
end
local function shouldUseTopPadding(p3) -- line: 60
	return p3.offset ~= 0
end
local function render(p4, p5) -- line: 65
	-- upvalues: t1 (copy), getNodeTypeConfig (copy)
	if not p4 then
		return nil
	end

	local v59 = t1.renderers[p4.name]

	if not v59 then
		warn(`No renderer found for node: { p4.name }`)

		return nil
	end

	local v60 = v59(p4, p5)
	local v61 = getNodeTypeConfig(p4)

	if v61 and not v61.validateRenderResult(v60) then
		warn(`Invalid render result for node: { p4.name } { p4.text } of type: { p4.type }`)
	end

	return v60
end
local function processChildren(p6, p7) -- line: 85
	-- upvalues: getNodeTypeConfig (copy), render (copy)
	local children = p6.children

	if not children then
		return {}
	end

	local v65 = getNodeTypeConfig(p6)
	local v66 = v65 and v65.children or {}
	local t2 = {}

	for _, v69 in children do
		local type2 = v69.type

		if not v66[type2] then
			warn(`Invalid child node type. Parent node: { p6.name } { p6.text } of type: { p6.type } has invalid child node: { v69.name } { v69.text } of type: { type2 }`)
		end

		local v71 = render(v69, p7)

		if v71 then
			if #v71 > 0 then
				for _, v73 in v71 do
					table.insert(t2, v73)
				end
			else
				table.insert(t2, v71)
			end
		end
	end

	return t2
end
local function renderRoot(p8, p9) -- line: 117
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		BorderSizePixel = 0,
		backgroundStyle = {
			Transparency = 1
		}
	}, (p9.processChildren(p8, p9)))
end
local function renderHeading(p10, p11) -- line: 128
	-- upvalues: React (copy), View (copy), renderInline (copy), mergeContexts (copy)
	local v78 = math.clamp((not p10.attributes or type(p10.attributes.depth) ~= "number") and 1 or p10.attributes.depth, 1, #p11.headerStyles)

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		key = tostring(p10.index),
		LayoutOrder = p10.index
	}, {
		UIPadding = p10.offset ~= 0 and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 20)
		}),
		InlineLayout = renderInline(p10, mergeContexts(p11, {
			textStyles = p11.headerStyles[v78]
		}))
	})
end
local function renderParagraph(p12, p13) -- line: 147
	-- upvalues: React (copy), View (copy), renderInline (copy)
	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		key = tostring(p12.index),
		LayoutOrder = p12.index
	}, {
		UIPadding = p12.offset ~= 0 and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 10)
		}),
		InlineLayout = renderInline(p12, p13)
	})
end
local function computeLineNumbers(s2: string) -- line: 161
	local v82 = #s2
	local t3 = {}
	local n1 = 1
	local n2 = 0

	while n2 <= v82 do
		local v86 = string.find(s2, "\n", n2, true)

		if not v86 then
			break
		end

		t3[n1] = tostring(n1)
		n1 += 1
		n2 = v86 + 1
	end

	t3[n1] = tostring(n1)

	return table.concat(t3, "\n")
end
local function copyToClipboard(p14) -- line: 180
	-- upvalues: MessageBusService (copy)
	pcall(function() -- line: 181
		-- upvalues: MessageBusService (copy), p14 (copy)
		local MessageId = MessageBusService:GetMessageId("ExternalContentSharing", "setClipboardText")

		return MessageBusService:Publish(MessageId, {
			text = p14
		})
	end)
end

local v42 = Dash.memoize(function(p15) -- line: 189
	-- upvalues: MessageBusService (copy)
	return function() -- line: 190
		-- upvalues: p15 (copy), MessageBusService (copy)
		local v147 = p15

		pcall(function() -- line: 181
			-- upvalues: MessageBusService (copy), v147 (copy)
			local MessageId = MessageBusService:GetMessageId("ExternalContentSharing", "setClipboardText")

			return MessageBusService:Publish(MessageId, {
				text = v147
			})
		end)
	end
end)

local function renderCodeBlock(p16, p17) -- line: 195
	-- upvalues: Highlighter (copy), getCodeTextStyles (copy), Code (copy), computeLineNumbers (copy), React (copy), View (copy), Foundation (copy), v42 (copy), FoundationText (copy), Dash (copy)
	local v91 = if not p16.attributes then nil else p16.attributes.language
	local text = p16.text
	local v93 = text

	if v91 == "lua" then
		v93 = Highlighter.highlight(text, p17.colorScheme)
	end

	local v94 = getCodeTextStyles(p17)
	local t4 = {
		TextWrapped = false,
		tag = "auto-xy padding-small align-y-top"
	}
	local t5 = {
		FontSize = v94.textSize
	}
	local v97 = Code

	t5.Font = if not v94.fontFace then if not v94.font then Font.fromEnum(v97) else Font.fromEnum(v94.font) else v94.fontFace
	t5.LineHeight = v94.lineHeight
	t4.fontStyle = t5
	t4.TextXAlignment = Enum.TextXAlignment.Left

	local t6 = {
		RichText = true,
		ZIndex = 1,
		Text = v93,
		textStyle = {
			Color3 = Highlighter.getTokenColor("iden")
		}
	}
	local t7 = {
		ZIndex = 0,
		TextSelectable = true,
		Text = text,
		textStyle = {
			Transparency = 0.4,
			Color3 = Highlighter.getTokenColor("iden")
		}
	}
	local v100 = p17.codeBackgroundStyles or {}
	local v101 = v100.backgroundColor3 or Highlighter.getTokenColor("background")
	local v102 = v100.backgroundTransparency or 0
	local v103 = nil
	local v104 = p17.codeSettings and p17.codeSettings.showLineNumbers

	if v104 then
		v103 = computeLineNumbers(text)
	end

	local v105 = p17.codeSettings and p17.codeSettings.showCopyButton

	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		BorderSizePixel = 0,
		key = tostring(p16.index),
		LayoutOrder = p16.index,
		backgroundStyle = {
			Transparency = 1
		}
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = if p16.offset == 0 then nil else UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		TitleBar = if not v105 then nil else React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y row align-x-right bg-shift-300 radius-small",
			LayoutOrder = 1
		}, {
			CopyToClipboardButton = React.createElement(Foundation.IconButton, {
				size = Foundation.Enums.InputSize.Small,
				icon = {
					name = Foundation.Enums.IconName.TwoStackedSquares
				},
				onActivated = v42(text)
			})
		}),
		CodeWrapper = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = {
				["size-full-0 auto-y"] = true,
				["row align-y-center"] = v104
			}
		}, {
			LineNumbers = if not v104 then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "size-0-0 auto-xy text-align-x-right text-align-y-center padding-small bg-shift-100 content-emphasis",
				Text = v103,
				fontStyle = t4.fontStyle
			}),
			ScrollFrameWrapper = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y fill",
				LayoutOrder = 2,
				Size = UDim2.fromScale(1, 0)
			}, {
				ScrollFrame = React.createElement("ScrollingFrame", {
					BorderSizePixel = 0,
					BackgroundColor3 = v101,
					BackgroundTransparency = v102,
					ScrollingDirection = Enum.ScrollingDirection.X,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.X
				}, {
					HighlightedCode = React.createElement(FoundationText, Dash.join(t4, t6)),
					SelectableCodeWrapper = React.createElement(Foundation.View, {
						tag = t4.tag
					}, {
						SelectableCode = React.createElement("TextBox", {
							BackgroundTransparency = 1,
							TextEditable = false,
							TextWrapped = false,
							ClearTextOnFocus = false,
							Text = t7.Text,
							FontFace = t4.fontStyle.Font,
							TextSize = t4.fontStyle.FontSize,
							TextColor3 = t7.textStyle.Color3,
							TextTransparency = t7.textStyle.Transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							ZIndex = t7.ZIndex,
							Size = UDim2.fromScale(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							LineHeight = p17.codeStyles.lineHeight
						})
					})
				})
			})
		})
	})
end
local function renderList(p18, p19) -- line: 336
	-- upvalues: React (copy), View (copy), render (copy), Dash (copy), BulletList (copy), BuilderSans (copy)
	local t8 = {}
	local v109 = nil

	for i = #p18.children, 1, -1 do
		local v111 = p18.children[i]

		if v111.name == "LIST" then
			v109 = v111
		elseif v109 then
			table.insert(t8, 1, {
				Prefix = if not v111.attributes then nil else v111.attributes.prefix,
				Item = React.createElement(View, {
					tag = "size-full-0 auto-y col",
					BorderSizePixel = 0,
					backgroundStyle = {
						Transparency = 1
					}
				}, {
					Item = render(Dash.join(v111, {
						index = 1
					}), p19),
					List = render(Dash.join(v109, {
						index = 2
					}), p19)
				})
			})
			v109 = nil
		else
			table.insert(t8, 1, {
				Prefix = if not v111.attributes then nil else v111.attributes.prefix,
				Item = render(v111, p19)
			})
		end
	end

	local createElement = React.createElement
	local v113 = BulletList
	local t9 = {
		TextWrapped = true,
		tag = "size-full-0 auto-y",
		key = tostring(p18.index),
		LayoutOrder = p18.index,
		Items = t8
	}
	local t10 = {}
	local textStyles = p19.textStyles
	local v117 = BuilderSans

	t10.Font = if not textStyles.fontFace then if not textStyles.font then Font.fromEnum(v117) else Font.fromEnum(textStyles.font) else textStyles.fontFace
	t10.TextColor = if typeof(p19.textStyles.color) ~= "string" then p19.textStyles.color else Color3.fromHex(p19.textStyles.color)
	t10.TextSize = p19.textStyles.textSize
	t10.LineHeight = p19.textStyles.textSize
	t9.ListStyle = t10

	return createElement(v113, t9, {
		UIPadding = p18.offset ~= 0 and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 10)
		})
	})
end
local function renderListItem(p20, p21) -- line: 403
	-- upvalues: React (copy), View (copy), renderInline (copy)
	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		key = tostring(p20.index),
		LayoutOrder = p20.index
	}, {
		InlineLayout = renderInline(p20, p21)
	})
end
local function renderStyledText(p22, p23) -- line: 413
	-- upvalues: Dash (copy), mergeContexts (copy)
	local v122 = if not p22.attributes or not p22.attributes.style then nil else p22.attributes.style
	local t11 = {}

	if v122 == "BOLD" or v122 == "BOLD_2" then
		t11.bold = true
	elseif v122 == "ITALIC" or v122 == "ITALIC_2" then
		t11.italic = true
	elseif v122 == "STRIKE" then
		t11.strike = true
	elseif v122 == "INLINE_CODE" then
		local codeStyles = p23.codeStyles

		t11 = Dash.joinDeep(codeStyles, {
			selectable = true
		})
	end

	return (p23.processChildren(p22, mergeContexts(p23, {
		textStyles = t11
	})))
end
local function renderText(p24, p25) -- line: 429
	-- upvalues: processSoftBreaks (copy), getBaseTextElementEngineTags (copy), BuilderSans (copy), SelectableTextElement (copy), TextElement (copy)
	local t12 = {
		LayoutOrder = p24.index,
		Text = processSoftBreaks(p24.text),
		EngineTags = getBaseTextElementEngineTags(p25.textStyles)
	}
	local t13 = {}
	local textStyles = p25.textStyles
	local v130 = BuilderSans

	t13.Font = if not textStyles.fontFace then if not textStyles.font then Font.fromEnum(v130) else Font.fromEnum(textStyles.font) else textStyles.fontFace
	t13.FontSize = p25.textStyles.textSize
	t12.fontStyle = t13
	t12.textStyle = {
		Color3 = if typeof(p25.textStyles.color) ~= "string" then p25.textStyles.color else Color3.fromHex(p25.textStyles.color),
		Transparency = p25.textStyles.transparency
	}
	t12.viewTags = p25.textStyles.viewTags

	if p25.textStyles.selectable then
		return SelectableTextElement.new(t12)
	end

	return TextElement.new(t12)
end
local function renderHardBreak() -- line: 453
	-- upvalues: HardBreakElement (copy)
	return HardBreakElement
end
local function renderLink(p26, p27) -- line: 457
	-- upvalues: mergeContexts (copy), Dash (copy), isInlineElement (copy), HardBreakElement (copy), LinkElement (copy)
	local v133 = p26.attributes and p26.attributes.url or (p26.url or "")
	local v134 = p27.processChildren(p26, mergeContexts(p27, {
		textStyles = {
			color = p27.linkStyles.linkColor
		}
	}))
	local v135 = Dash.filter(v134, function(p28) -- line: 467
		-- upvalues: isInlineElement (copy), HardBreakElement (copy)
		return isInlineElement(p28) and p28 ~= HardBreakElement
	end)

	return LinkElement.new(v135, {
		onActivated = function() -- line: 471
			-- upvalues: p27 (copy), v133 (copy)
			p27.linkCallback(v133)
		end
	})
end
local function renderThematicBreak(p29) -- line: 477
	-- upvalues: React (copy), View (copy), Divider (copy)
	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		key = tostring(p29.index),
		LayoutOrder = p29.index
	}, {
		UIPadding = p29.offset ~= 0 and React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 10)
		}),
		Divider = React.createElement(Divider)
	})
end
local function renderBlockquote(p30, p31) -- line: 492
	-- upvalues: React (copy), View (copy), renderInline (copy), mergeContexts (copy)
	return React.createElement(View, {
		tag = "size-full-0 auto-y padding-small",
		key = tostring(p30.index),
		LayoutOrder = p30.index,
		backgroundStyle = {
			Transparency = 1
		}
	}, {
		InlineLayoutWrapper = React.createElement(View, {
			tag = "size-full-0 auto-y",
			backgroundStyle = {
				Transparency = 0.9,
				Color3 = Color3.fromRGB(163, 162, 165)
			}
		}, {
			InlineLayout = renderInline(p30, mergeContexts(p31, {
				textStyles = {
					italic = true,
					transparency = 0.5
				}
			}))
		})
	})
end
local function renderImage(p32, p33) -- line: 516
	-- upvalues: ImageElement (copy)
	local v141 = p32.attributes and p32.attributes.url or (p32.url or nil)

	return ImageElement.new({
		LayoutOrder = p32.index,
		Image = v141,
		Size = p33.imageStyles.size,
		backgroundStyle = {
			Transparency = p33.imageStyles.backgroundTransparency,
			Color3 = p33.imageStyles.backgroundColor3
		},
		imageStyle = {
			Transparency = p33.imageStyles.transparency
		},
		ScaleType = p33.imageStyles.scaleType,
		ResampleMode = p33.imageStyles.resampleMode,
		tag = p33.imageStyles.tags
	})
end

t1.defaultRenderers = {
	ROOT = renderRoot,
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

function t1.render(p34, t14: {[any]: any}) -- line: 561
	-- upvalues: t1 (copy), Dash (copy), BuilderSans (copy), Code (copy), uDim2 (copy), v31 (copy), processChildren (copy), render (copy)
	t1.renderers = t14.userRenderers

	local v144 = table.clone(t14.markdownRendererProps or {})
	local v145 = Dash.joinDeep({
		isInline = false,
		textStyles = {
			textSize = 18,
			font = BuilderSans
		},
		codeStyles = {
			textSize = 18,
			lineHeight = 1.111,
			font = Code
		},
		headerStyles = {
			[1] = {
				textSize = 54,
				font = BuilderSans
			},
			[2] = {
				textSize = 45,
				font = BuilderSans
			},
			[3] = {
				textSize = 36,
				font = BuilderSans
			},
			[4] = {
				textSize = 27,
				font = BuilderSans
			}
		},
		imageStyles = {
			size = uDim2
		},
		linkStyles = {
			linkColor = `#{ t14.tokens.Color.Content.Link.Color3:ToHex() }`
		},
		linkCallback = t14.linkCallback or v31,
		colorScheme = t14.colorScheme,
		processChildren = processChildren
	}, v144)

	table.freeze(v145)

	return (render(p34, v145))
end

return t1
