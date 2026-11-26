local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local InlineRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/InlineRichText")

local createLegalLinkRenderer = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/createLegalLinkRenderer")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local renderer = InlineRichText.Renderer
local prepareRichTextCopy = InlineRichText.prepareRichTextCopy

local function LegalTextWithLinks(props)
	local v5 = useTokens()
	local onLinkActivated = props.onLinkActivated
	local v6 = React.useMemo(function()
		return {
			LINK = createLegalLinkRenderer(function(p2)
				if onLinkActivated then
					onLinkActivated(p2)
				end
			end)
		}
	end, { onLinkActivated })
	local v7 = React.useMemo(function()
		return prepareRichTextCopy(props.text)
	end, { props.text })

	return React.createElement(
		view,
		{
			tag = "size-full-0 auto-y",
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		},
		{
			Text = React.createElement(renderer, {
				text = v7,
				renderers = v6,
				textStyle = v5.Color.Content.Muted,
				fontStyle = v5.Typography.CaptionSmall,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				wrapperProps = { tag = "size-full-0 auto-y" }
			})
		}
	)
end

return LegalTextWithLinks
