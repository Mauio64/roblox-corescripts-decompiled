local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local v3 = require(InlineRichText.Logger):new(script.Name)
local Cryo = require(InlineRichTextParent.Cryo)
local Foundation = require(InlineRichTextParent.Foundation)
local React = require(InlineRichTextParent.React)

require(InlineRichText.Types)

local InlineLayout = require(InlineRichTextParent.InlineLayout).Components.InlineLayout
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

local function createDefaultRootNode(s1: string) -- line: 49
	-- upvalues: NodeType (copy)
	return {
		name = "ROOT",
		text = "",
		index = 0,
		type = NodeType.Root,
		children = {{
			name = "TEXT",
			text = "",
			index = 1,
			type = NodeType.InlineCustom,
			children = {{
				name = "PLAINTEXT",
				index = 2,
				text = s1,
				type = NodeType.Plaintext,
				children = {},
				attributes = {}
			}},
			attributes = {}
		}},
		attributes = {}
	}
end

local t1 = {
	TEXT_SPAN = TextSpanRenderer,
	LINK = LinkRenderer,
	ICON = IconRenderer,
	BREAK = HardbreakRenderer
}
local t2 = {
	[LinkType.Http] = LinkBehavior.Webview,
	[LinkType.LinkingProtocolRegistered] = LinkBehavior.LinkingProtocol,
	[LinkType.Default] = LinkBehavior.ErrorToast
}
local t3 = {
	errorToastText = nil,
	evaluateLinkBehavior = function(_: string, p1) -- line: 90
		-- upvalues: t2 (copy), LinkBehavior (copy)
		return t2[p1] or LinkBehavior.ErrorToast
	end
}

local function InlineRichTextRenderer(p2) -- line: 96
	-- upvalues: React (copy), parseXml (copy), v3 (copy), createDefaultRootNode (copy), Foundation (copy), Cryo (copy), t3 (copy), useLinkerOnActivated (copy), getLinkType (copy), t1 (copy), processChildren (copy), InlineLayout (copy)
	local ast = p2.ast
	local text = p2.text
	local v30 = React.useMemo(function() -- line: 99
		-- upvalues: ast (copy), parseXml (copy), text (copy), p2 (copy), v3 (copy), createDefaultRootNode (copy)
		if ast then
			return ast
		end

		local v39, v40 = parseXml(text, p2.parserOptions)

		if not v39 then
			v3:warning(`Error parsing XML input into AST: { v40 }`)

			return (createDefaultRootNode(text))
		end

		return v40
	end, {
		text,
		ast
	})
	local v31 = Foundation.Hooks.useTokens()
	local Default = v31.Color.Content.Default
	local t4 = {
		Font = Enum.Font.BuilderSans,
		FontSize = v31.FontSize.FontSize_400,
		LineHeight = v31.LineHeight.LineHeight_140
	}
	local v34 = Cryo.Dictionary.union(t3, p2.linkerOptions or {})
	local v35 = useLinkerOnActivated({
		errorToastTextOverride = v34.errorToastText
	})
	local v36 = React.useCallback(function(s3: string) -- line: 123
		-- upvalues: v34 (copy), getLinkType (copy)
		return v34.evaluateLinkBehavior(s3, getLinkType(s3))
	end, { v34.evaluateLinkBehavior })
	local v37 = React.useMemo(function() -- line: 128
		-- upvalues: Cryo (copy), t1 (copy), p2 (copy), processChildren (copy), Default (copy), t4 (copy), v31 (copy), v35 (copy), v36 (copy)
		return {
			inlineCustomRenderers = Cryo.Dictionary.join(t1, p2.renderers or {}),
			processChildren = processChildren,
			nodeProps = p2.nodeProps or {},
			styles = {
				textStyle = Cryo.Dictionary.union(Default, p2.textStyle or {}),
				fontStyle = Cryo.Dictionary.union(t4, p2.fontStyle or {})
			},
			tokens = v31,
			linker = {
				onActivated = v35,
				evaluateLinkBehavior = v36
			}
		}
	end, {
		p2.renderers,
		p2.nodeProps,
		p2.textStyle,
		p2.fontStyle,
		v35,
		v36
	})
	local v38 = React.useMemo(function() -- line: 153
		-- upvalues: processChildren (copy), v30 (copy), v37 (copy)
		return processChildren(v30, v37)
	end, {
		v30 and v30.children,
		v37
	})

	return React.createElement(Foundation.View, p2.wrapperProps, {
		RichTextRoot = React.createElement(InlineLayout, {
			Elements = v38,
			HorizontalAlignment = p2.HorizontalAlignment,
			VerticalPadding = UDim.new(0, v37.styles.fontStyle.FontSize * (v37.styles.fontStyle.LineHeight - 1) / 2)
		})
	})
end

return InlineRichTextRenderer
