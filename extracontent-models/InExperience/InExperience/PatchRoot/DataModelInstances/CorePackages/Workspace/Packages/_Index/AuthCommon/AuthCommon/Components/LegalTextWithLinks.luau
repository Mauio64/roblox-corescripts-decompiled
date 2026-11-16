local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local InlineRichText = require(parent.InlineRichText)

local createLegalLinkRenderer = require(AuthCommon.Utils.createLegalLinkRenderer)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local Renderer = InlineRichText.Renderer
local prepareRichTextCopy = InlineRichText.prepareRichTextCopy

local function LegalTextWithLinks(props)
	local v = useTokens()
	local onLinkActivated = props.onLinkActivated
	local renderers = React.useMemo(function()
		return {
			LINK = createLegalLinkRenderer(function(p: string)
				if onLinkActivated then
					onLinkActivated(p)
				end
			end)
		}
	end, { onLinkActivated })
	local text = React.useMemo(function()
		return prepareRichTextCopy(props.text)
	end, { props.text })

	return React.createElement(
		View,
		{ tag = "size-full-0 auto-y", LayoutOrder = props.LayoutOrder, testId = props.testId },
		{
			Text = React.createElement(Renderer, {
				text = text,
				renderers = renderers,
				textStyle = v.Color.Content.Muted,
				fontStyle = v.Typography.CaptionSmall,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				wrapperProps = { tag = "size-full-0 auto-y" }
			})
		}
	)
end

return LegalTextWithLinks
