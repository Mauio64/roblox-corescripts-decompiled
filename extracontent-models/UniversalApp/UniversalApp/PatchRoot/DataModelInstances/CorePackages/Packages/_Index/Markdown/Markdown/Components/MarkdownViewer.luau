local Parent = script:FindFirstAncestor("Components").Parent
local ParentParent = Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)
local Foundation = require(ParentParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

require(ParentParent.MarkdownCore)

local CommonMarkComplianceParser = require(Parent.Parsers.CommonMarkComplianceParser)

require(Parent.Types)

local MarkdownRenderer = require(script.MarkdownRenderer)

local function MarkdownViewer(t1: {[any]: any}) -- line: 46
	-- upvalues: useTokens (copy), React (copy), Dash (copy), MarkdownRenderer (copy), CommonMarkComplianceParser (copy), View (copy), FoundationText (copy)
	local v13 = useTokens()

	if not t1.Markdown and not t1.Ast then
		warn("MarkdownViewer requires either a Markdown string or an Ast in props")

		return nil
	end

	local v14 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), MarkdownRenderer (copy), t1 (copy)
		return Dash.join(MarkdownRenderer.defaultRenderers, t1.Renderers or {}, t1.AdditionalFeatureRenderers or {})
	end, { t1.Renderers })
	local v15, v16 = React.useMemo(function() -- line: 62
		-- upvalues: t1 (copy), CommonMarkComplianceParser (copy)
		if t1.Ast then
			return true, t1.Ast
		end

		if t1.Markdown then
			local v18, v19 = CommonMarkComplianceParser.safeParse(t1.Markdown)

			if not v18 then
				if t1.OnError then
					t1.OnError(v19)

					return v18, v19
				end

				warn("MarkdownViewer: Error parsing markdown.", v19)
			end

			return v18, v19
		end

		return true, nil
	end, {
		t1.Markdown,
		t1.Ast
	})
	local v17 = React.useMemo(function() -- line: 82
		-- upvalues: v15 (copy), MarkdownRenderer (copy), v16 (copy), v14 (copy), t1 (copy), v13 (copy)
		if not v15 then
			return nil
		end

		return MarkdownRenderer.render(v16, {
			userRenderers = v14,
			linkCallback = t1.LinkCallback,
			markdownRendererProps = t1.MarkdownRendererProps,
			colorScheme = t1.ColorScheme,
			tokens = v13
		})
	end, {
		v15,
		v16,
		t1.LinkCallback,
		t1.MarkdownRendererProps,
		t1.ColorScheme,
		v14
	})

	if not v15 then
		return t1.Fallback or React.createElement(View, Dash.join({
			tag = "size-full-0 auto-y",
			backgroundStyle = {
				Transparency = 1
			}
		}, t1.WrapperProps or {}), React.createElement(FoundationText, {
			Text = "Failed to parse the provided markdown"
		}))
	end

	return React.createElement(View, Dash.join({
		tag = "col size-full-0 auto-y",
		BorderSizePixel = 0,
		backgroundStyle = {
			Transparency = 1
		}
	}, t1.WrapperProps or {}), v17)
end

return MarkdownViewer
