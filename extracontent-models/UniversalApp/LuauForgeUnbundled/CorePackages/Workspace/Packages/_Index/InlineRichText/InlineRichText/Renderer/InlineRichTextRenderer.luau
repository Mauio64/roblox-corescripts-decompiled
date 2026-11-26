local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("InlineRichTextRenderer")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/React")
require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

local inlineLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/InlineLayout").Components.InlineLayout

local NodeType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/NodeType")
local parseXml = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Parser/parseXml")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/processChildren")
local TextSpanRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/TextSpanRenderer")
local LinkRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/LinkRenderer")
local IconRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/IconRenderer")
local HardbreakRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/HardbreakRenderer")
local useLinkerOnActivated = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Linker/useLinkerOnActivated")
local LinkType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/LinkType")
local LinkBehavior = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/LinkBehavior")
local getLinkType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Linker/getLinkType")

local function createDefaultRootNode(text)
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

local v6 = { ["TEXT_SPAN"] = TextSpanRenderer, LINK = LinkRenderer, ICON = IconRenderer, BREAK = HardbreakRenderer }

local v7 = {
	[LinkType.Http] = LinkBehavior.Webview,
	[LinkType.LinkingProtocolRegistered] = LinkBehavior.LinkingProtocol,
	[LinkType.Default] = LinkBehavior.ErrorToast
}

local v8 = {
	evaluateLinkBehavior = function(p2, p3)
		return v7[p3] or LinkBehavior.ErrorToast
	end,
	errorToastText = nil,
	onActivatedSubscriber = nil
}

local function InlineRichTextRenderer(props)
	local ast = props.ast
	local text = props.text
	local v9 = React.useMemo(function()
		if ast then
			return ast
		end

		local v10, v11 = parseXml(text, props.parserOptions)

		if v10 then
			return v11
		end

		v5:warning(`Error parsing XML input into AST: {v11}`)
		return createDefaultRootNode(text)
	end, { text, ast })

	local v10 = Foundation.Hooks.useTokens()
	local default = v10.Color.Content.Default
	local v11 = {
		Font = Enum.Font.BuilderSans,
		FontSize = v10.FontSize.FontSize_400,
		LineHeight = v10.LineHeight.LineHeight_140
	}

	local union = Cryo.Dictionary.union(v8, props.linkerOptions or {})
	local v12 = useLinkerOnActivated({ errorToastTextOverride = union.errorToastText })

	local v13 = React.useCallback(function(p2)
		v12(p2)

		if union.onActivatedSubscriber then
			local success, result = pcall(function(): boolean
				union.onActivatedSubscriber(p2)
				return true
			end)

			if not success then
				v5:warning(`Error notifying link activation subscriber: {tostring(result)}`)
			end
		end
	end, { union.onActivatedSubscriber, v12 })
	local v14 = React.useCallback(function(p2)
		return union.evaluateLinkBehavior(p2, getLinkType(p2))
	end, { union.evaluateLinkBehavior })

	local v15 = React.useMemo(function()
		return {
			inlineCustomRenderers = Cryo.Dictionary.join(v6, props.renderers or {}),
			processChildren = module6,
			nodeProps = props.nodeProps or {},
			styles = {
				textStyle = Cryo.Dictionary.union(default, props.textStyle or {}),
				fontStyle = Cryo.Dictionary.union(v11, props.fontStyle or {})
			},
			tokens = v10,
			linker = { onActivated = v13, evaluateLinkBehavior = v14 }
		}
	end, {
		props.renderers,
		props.nodeProps,
		props.textStyle,
		props.fontStyle,
		v13,
		v14
	})

	local v16 = React.useMemo(function()
		return module6(v9, v15)
	end, { v9 and v9.children, v15 })

	return React.createElement(Foundation.View, props.wrapperProps, {
		RichTextRoot = React.createElement(inlineLayout, {
			Elements = v16,
			HorizontalAlignment = props.HorizontalAlignment,
			VerticalPadding = UDim.new(
				0,
				v15.styles.fontStyle.FontSize * (v15.styles.fontStyle.LineHeight - 1) / 2
			)
		})
	})
end

return InlineRichTextRenderer
