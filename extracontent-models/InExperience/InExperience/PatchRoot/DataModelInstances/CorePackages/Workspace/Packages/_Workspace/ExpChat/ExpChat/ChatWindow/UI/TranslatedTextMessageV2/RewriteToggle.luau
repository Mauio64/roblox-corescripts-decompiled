local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local Localization = require(ExpChat.Localization)
local FStringInExpChatRewriteLabelKey = require(ExpChat.Flags.FStringInExpChatRewriteLabelKey)
local mergeBindableScalar = require(ExpChat.ChatWindow.Helpers.mergeBindableScalar)

local function RewriteToggle(t1: {[any]: any}) -- line: 21
	-- upvalues: Foundation (copy), Localization (copy), FStringInExpChatRewriteLabelKey (copy), React (copy), mergeBindableScalar (copy)
	local v10 = Foundation.Hooks.useTokens()
	local v11 = Localization.useLocalization({
		defaultRewrittenLabelText = "CoreScripts.TextChat.ChatWindow.RewrittenLabel",
		rewrittenLabelText = FStringInExpChatRewriteLabelKey
	})
	local v12 = if not v11.rewrittenLabelText or v11.rewrittenLabelText == "" then v11.defaultRewrittenLabelText else v11.rewrittenLabelText
	local v13 = t1.textTransparency:map(function(p1) -- line: 32
		return p1 < 1
	end)
	local v14 = React.joinBindings({
		v13,
		t1.isRewriteMenuOpen
	}):map(function(p2) -- line: 36
		return p2[1] and p2[2]
	end)
	local v15 = React.joinBindings({
		v13,
		t1.isRewriteMenuOpen
	}):map(function(p3) -- line: 41
		return p3[1] and not p3[2]
	end)

	return React.createElement(Foundation.View, {
		tag = "row align-y-center gap-xsmall size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder,
		Visible = t1.Visible
	}, {
		Label = React.createElement(Foundation.Text, {
			tag = "size-0-0 auto-xy text-caption-small text-align-x-left",
			LayoutOrder = 1,
			RichText = true,
			Text = "(" .. v12 .. ")",
			textStyle = {
				Color3 = v10.Color.Content.Muted.Color3,
				Transparency = mergeBindableScalar(v10.Color.Content.Muted.Transparency, t1.textTransparency)
			},
			stroke = {
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = mergeBindableScalar(0.5, t1.textTransparency),
				Thickness = v10.Stroke.Thin
			}
		}),
		IconButtonUp = React.createElement(Foundation.IconButton, {
			isCircular = true,
			LayoutOrder = 2,
			size = Foundation.Enums.InputSize.XSmall,
			icon = Foundation.Enums.IconName.ChevronLargeUp,
			variant = Foundation.Enums.ButtonVariant.Utility,
			Visible = v14,
			onActivated = t1.onActivated
		}),
		IconButtonDown = React.createElement(Foundation.IconButton, {
			isCircular = true,
			LayoutOrder = 3,
			size = Foundation.Enums.InputSize.XSmall,
			icon = Foundation.Enums.IconName.ChevronLargeDown,
			variant = Foundation.Enums.ButtonVariant.Utility,
			Visible = v15,
			onActivated = t1.onActivated
		})
	})
end

return React.memo(RewriteToggle)
