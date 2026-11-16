local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(InlineRichText.Types)

local InlineLayout = require(parent.InlineLayout)
local inlineLayout = InlineLayout.Components.InlineLayout

local NodeType = require(InlineRichText.Enums.NodeType)
local parseXml = require(InlineRichText.Parser.parseXml)
local processChildren = require(InlineRichText.Renderer.processChildren)
local TextSpanRenderer = require(InlineRichText.Renderer.NodeRenderers.TextSpanRenderer)
local LinkRenderer = require(InlineRichText.Renderer.NodeRenderers.LinkRenderer)
local IconRenderer = require(InlineRichText.Renderer.NodeRenderers.IconRenderer)
local HardbreakRenderer = require(InlineRichText.Renderer.NodeRenderers.HardbreakRenderer)
local useLinkerOnActivated = require(InlineRichText.Linker.useLinkerOnActivated)
local LinkType = require(InlineRichText.Enums.LinkType)
local LinkBehavior = require(InlineRichText.Enums.LinkBehavior)
local getLinkType = require(InlineRichText.Linker.getLinkType)

local function createDefaultRootNode(text: string)
	return {
		name = "ROOT",
		text = "",
		type = NodeType.Root,
		children = {
			{
				name = "TEXT",
				text = "",
				type = NodeType.InlineCustom,
				children = {
					{
						name = "PLAINTEXT",
						text = text,
						type = NodeType.Plaintext,
						children = {},
						attributes = {},
						index = 2
					}
				},
				attributes = {},
				index = 1
			}
		},
		attributes = {},
		index = 0
	}
end

local v2 = {
	["TEXT_SPAN"] = TextSpanRenderer,
	LINK = LinkRenderer,
	ICON = IconRenderer,
	BREAK = HardbreakRenderer
}

local v3 = {
	[LinkType.Http] = LinkBehavior.Webview,
	[LinkType.LinkingProtocolRegistered] = LinkBehavior.LinkingProtocol,
	[LinkType.Default] = LinkBehavior.ErrorToast
}

local v4 = {
	evaluateLinkBehavior = function(_: string, p)
		return v3[p] or LinkBehavior.ErrorToast
	end,
	errorToastText = nil,
	onActivatedSubscriber = nil
}

local function InlineRichTextRenderer(props)
	local ast = props.ast
	local text = props.text
	local v5 = React.useMemo(function()
		if ast then
			return ast
		end

		local v5, v6 = parseXml(text, props.parserOptions)

		if v5 then
			return v6
		end

		v:warning(`Error parsing XML input into AST: {v6}`)
		return createDefaultRootNode(text)
	end, { text, ast })

	local tokens = Foundation.Hooks.useTokens()
	local default = tokens.Color.Content.Default
	local v6 = {
		Font = Enum.Font.BuilderSans,
		FontSize = tokens.FontSize.FontSize_400,
		LineHeight = tokens.LineHeight.LineHeight_140
	}

	local union = Cryo.Dictionary.union(v4, props.linkerOptions or {})
	local v7 = useLinkerOnActivated({ errorToastTextOverride = union.errorToastText })

	local onActivated = React.useCallback(function(p)
		v7(p)

		if union.onActivatedSubscriber then
			local success, result = pcall(function(): boolean
				union.onActivatedSubscriber(p)
				return true
			end)

			if not success then
				v:warning(`Error notifying link activation subscriber: {tostring(result)}`)
			end
		end
	end, { union.onActivatedSubscriber, v7 })
	local evaluateLinkBehavior = React.useCallback(function(p: string)
		return union.evaluateLinkBehavior(p, getLinkType(p))
	end, { union.evaluateLinkBehavior })

	local v8 = React.useMemo(function()
		return {
			inlineCustomRenderers = Cryo.Dictionary.join(v2, props.renderers or {}),
			processChildren = processChildren,
			nodeProps = props.nodeProps or {},
			styles = {
				textStyle = Cryo.Dictionary.union(default, props.textStyle or {}),
				fontStyle = Cryo.Dictionary.union(v6, props.fontStyle or {})
			},
			tokens = tokens,
			linker = { onActivated = onActivated, evaluateLinkBehavior = evaluateLinkBehavior }
		}
	end, {
		props.renderers,
		props.nodeProps,
		props.textStyle,
		props.fontStyle,
		onActivated,
		evaluateLinkBehavior
	})

	local elements = React.useMemo(function()
		return processChildren(v5, v8)
	end, { v5 and v5.children, v8 })

	return React.createElement(Foundation.View, props.wrapperProps, {
		RichTextRoot = React.createElement(inlineLayout, {
			Elements = elements,
			HorizontalAlignment = props.HorizontalAlignment,
			VerticalPadding = UDim.new(0, v8.styles.fontStyle.FontSize * (v8.styles.fontStyle.LineHeight - 1) / 2)
		})
	})
end

return InlineRichTextRenderer
