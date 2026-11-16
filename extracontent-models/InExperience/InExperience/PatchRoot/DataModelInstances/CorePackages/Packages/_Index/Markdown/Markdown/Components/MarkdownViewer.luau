local parent = script:FindFirstAncestor("Components").Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Dash = require(parent2.Dash)
local Foundation = require(parent2.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local MarkdownCore = require(parent2.MarkdownCore)

local CommonMarkComplianceParser = require(parent.Parsers.CommonMarkComplianceParser)
local Flags = require(parent.Flags)
require(parent.Types)
local MarkdownRenderer = require(script.MarkdownRenderer)
local flags = MarkdownCore.Flags

local function profileParser(parserProfile: string?) -- 1 equivalent call inferred from this helper
	if parserProfile == "RobloxMarkdown" then
		return require(parent.Parsers.RobloxMarkdown.RendererParser)
	elseif parserProfile == "CommonMark" then
		return require(parent.Parsers.CommonMark.RendererParser)
	end

	return nil
end

local function MarkdownViewer(props)
	local tokens = useTokens()

	if not (flags.FFlagMarkdownAssistantParity or props.Markdown or props.Ast) then
		warn("MarkdownViewer requires either a Markdown string or an Ast in props")
		return nil
	end

	local useMemo = React.useMemo
	local function fn()
		return Dash.join(
			MarkdownRenderer.defaultRenderers,
			props.Renderers or {},
			props.AdditionalFeatureRenderers or {}
		)
	end

	local v

	if flags.FFlagMarkdownAssistantParity then
		v = { props.Renderers, props.AdditionalFeatureRenderers }
	else
		v = { props.Renderers }
	end

	local userRenderers = useMemo(fn, v)

	local v2 = (flags.FFlagMarkdownTables or flags.FFlagMarkdownTagFallbacks)
		and props.IsStreaming
		and { isStreaming = true }
		or nil
	local v3

	if flags.FFlagMarkdownTables or flags.FFlagMarkdownTagFallbacks then
		v3 = { props.Markdown, props.Ast, props.IsStreaming, props.ParserProfile }
	else
		v3 = { props.Markdown, props.Ast, props.ParserProfile }
	end

	local v4, v5 = React.useMemo(function()
		if props.Ast then
			return true, props.Ast
		end

		if not props.Markdown then
			return true, nil
		end

		local fFlagMarkdownDefaultRobloxProfile = Flags.FFlagMarkdownDefaultRobloxProfile
		local v4

		if Flags.FFlagMarkdownUseRobloxProfileParser or fFlagMarkdownDefaultRobloxProfile then
			v4 = profileParser(props.ParserProfile or fFlagMarkdownDefaultRobloxProfile and "RobloxMarkdown" or nil) -- inferred equivalent call
		end

		local selected, selected2

		if v4 == nil then
			selected, selected2 = CommonMarkComplianceParser.safeParse(props.Markdown, v2)
		else
			selected, selected2 = v4.safeParse(props.Markdown, v2)
		end

		if selected then
			return selected, selected2
		end

		if props.OnError then
			props.OnError(selected2)
			return selected, selected2
		end

		warn("MarkdownViewer: Error parsing markdown.", selected2)

		return selected, selected2
	end, v3)

	local useMemo2 = React.useMemo
	local function fn2()
		if v4 then
			return MarkdownRenderer.render(v5, {
				userRenderers = userRenderers,
				linkCallback = props.LinkCallback,
				markdownRendererProps = props.MarkdownRendererProps,
				colorScheme = props.ColorScheme,
				tokens = tokens
			})
		end

		return nil
	end

	local v6

	if flags.FFlagMarkdownAssistantParity then
		v6 = {
			v4,
			v5,
			props.LinkCallback,
			props.MarkdownRendererProps,
			props.ColorScheme,
			userRenderers,
			tokens
		}
	else
		v6 = {
			v4,
			v5,
			props.LinkCallback,
			props.MarkdownRendererProps,
			props.ColorScheme,
			userRenderers
		}
	end

	local v7 = useMemo2(fn2, v6)

	if flags.FFlagMarkdownAssistantParity and not (props.Markdown or props.Ast) then
		warn("MarkdownViewer requires either a Markdown string or an Ast in props")
		return nil
	end

	if v4 then
		return React.createElement(View, Dash.join({
			tag = "col size-full-0 auto-y",
			backgroundStyle = { Transparency = 1 },
			BorderSizePixel = 0
		}, props.WrapperProps or {}), v7)
	end

	return props.Fallback or React.createElement(View, Dash.join({
		tag = "size-full-0 auto-y",
		backgroundStyle = { Transparency = 1 }
	}, props.WrapperProps or {}), React.createElement(Text, {
		Text = "Failed to parse the provided markdown"
	}))
end

return MarkdownViewer
