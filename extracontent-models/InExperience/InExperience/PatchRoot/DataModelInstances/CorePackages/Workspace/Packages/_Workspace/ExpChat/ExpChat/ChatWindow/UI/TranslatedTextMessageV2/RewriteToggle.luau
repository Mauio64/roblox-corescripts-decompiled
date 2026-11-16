local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Localization = require(ExpChat.Localization)

local FStringInExpChatRewriteLabelKey = require(ExpChat.Flags.FStringInExpChatRewriteLabelKey)

local mergeBindableScalar = require(ExpChat.ChatWindow.Helpers.mergeBindableScalar)

local function RewriteToggle(props)
	local v = Foundation.Hooks.useTokens()
	local v2 = Localization.useLocalization({
		rewrittenLabelText = FStringInExpChatRewriteLabelKey,
		defaultRewrittenLabelText = "CoreScripts.TextChat.ChatWindow.RewrittenLabel"
	})
	local v3

	if v2.rewrittenLabelText and v2.rewrittenLabelText ~= "" then
		v3 = v2.rewrittenLabelText
	else
		v3 = v2.defaultRewrittenLabelText
	end

	local mapped = props.textTransparency:map(function(p): boolean
		return p < 1
	end)

	local mapped2 = React.joinBindings({ mapped, props.isRewriteMenuOpen }):map(function(list)
		return list[1] and list[2]
	end)

	local mapped3 = React.joinBindings({ mapped, props.isRewriteMenuOpen }):map(function(list)
		return list[1] and not list[2]
	end)

	return React.createElement(
		Foundation.View,
		{
			tag = "row align-y-center gap-xsmall size-full-0 auto-y",
			LayoutOrder = props.LayoutOrder,
			Visible = props.Visible
		},
		{
			Label = React.createElement(Foundation.Text, {
				Text = "(" .. v3 .. ")",
				tag = "size-0-0 auto-xy text-caption-small text-align-x-left",
				LayoutOrder = 1,
				RichText = true,
				textStyle = {
					Color3 = v.Color.Content.Muted.Color3,
					Transparency = mergeBindableScalar(v.Color.Content.Muted.Transparency, props.textTransparency)
				},
				stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Transparency = mergeBindableScalar(0.5, props.textTransparency),
					Thickness = v.Stroke.Thin
				}
			}),
			IconButtonUp = React.createElement(Foundation.IconButton, {
				size = Foundation.Enums.InputSize.XSmall,
				icon = Foundation.Enums.IconName.ChevronLargeUp,
				variant = Foundation.Enums.ButtonVariant.Utility,
				isCircular = true,
				LayoutOrder = 2,
				Visible = mapped2,
				onActivated = props.onActivated
			}),
			IconButtonDown = React.createElement(Foundation.IconButton, {
				size = Foundation.Enums.InputSize.XSmall,
				icon = Foundation.Enums.IconName.ChevronLargeDown,
				variant = Foundation.Enums.ButtonVariant.Utility,
				isCircular = true,
				LayoutOrder = 3,
				Visible = mapped3,
				onActivated = props.onActivated
			})
		}
	)
end

return React.memo(RewriteToggle)
