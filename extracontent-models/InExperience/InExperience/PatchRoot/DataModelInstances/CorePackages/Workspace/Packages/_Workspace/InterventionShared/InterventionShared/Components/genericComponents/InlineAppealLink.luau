local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local React = require(parent.React)

local Constants = require(InterventionShared.Utils.Constants)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local InlineLayout = require(parent.InlineLayout)
local inlineLayout = InlineLayout.Components.InlineLayout
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagUFRDialogContentCutoffFix = require(InterventionShared.Flags.FFlagUFRDialogContentCutoffFix)

local v = { name = "u", attributes = {} }

local function InlineAppealLink(p)
	local v2 = useTokens()
	local disclaimer = useLocalization({
		disclaimer = {
			Constants.localizationKeys.DisclaimerText,
			startLink = "<a>",
			endLink = "</a>"
		}
	}).disclaimer

	local bodyMedium = v2.Typography.BodyMedium
	local default = v2.Color.Content.Default

	local match, text, text2 = disclaimer:match("^(.*)<a>(.*)</a>(.*)$")
	local elements = {
		TextElement.new({ Text = match, fontStyle = bodyMedium, textStyle = default }),
		LinkElement.new({ TextElement.new({
				Text = text,
				EngineTags = { v },
				fontStyle = bodyMedium,
				testId = "inline-appeal-link-action-text",
				textStyle = default
			}) }, { key = "inline-appeal-link-action", onActivated = p.onActivated }),
		TextElement.new({ Text = text2, fontStyle = bodyMedium, textStyle = default })
	}

	if not FFlagUFRDialogContentCutoffFix then
		return React.createElement(
			View,
			{
				tag = "size-full-0 auto-y",
				testId = "inline-appeal-link",
				LayoutOrder = p.LayoutOrder
			},
			{
				Layout = React.createElement(inlineLayout, { Elements = elements })
			}
		)
	end

	local v3, v4 = React.useBinding(0)
	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		testId = "inline-appeal-link",
		LayoutOrder = p.LayoutOrder,
		sizeConstraint = {
			MinSize = v3:map(function(p2: number)
				return Vector2.new(0, p2)
			end)
		}
	}, {
		MeasuredLayout = React.createElement(View, {
			tag = "size-full-0 auto-y",
			onAbsoluteSizeChanged = function(p2)
				v4(p2.AbsoluteSize.Y)
			end
		}, {
			Layout = React.createElement(inlineLayout, { Elements = elements })
		})
	})
end

return React.memo(InlineAppealLink)
