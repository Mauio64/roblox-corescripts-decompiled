local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Constants")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local InlineLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InlineLayout")
local inlineLayout = InlineLayout.Components.InlineLayout
local linkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local textElement = InlineLayout.Components.InlineLayoutElements.TextElement

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Localization").Hooks.useLocalization

local FFlagUFRDialogContentCutoffFix = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRDialogContentCutoffFix")

local v5 = { name = "u", attributes = {} }

local function InlineAppealLink(p2)
	local v6 = useTokens()
	local disclaimer = useLocalization({
		disclaimer = {
			Constants.localizationKeys.DisclaimerText,
			startLink = "<a>",
			endLink = "</a>"
		}
	}).disclaimer

	local bodyMedium = v6.Typography.BodyMedium
	local default = v6.Color.Content.Default

	local match, v7, v8 = disclaimer:match("^(.*)<a>(.*)</a>(.*)$")
	local v9 = {
		textElement.new({ Text = match, fontStyle = bodyMedium, textStyle = default }),
		linkElement.new({ textElement.new({
				Text = v7,
				EngineTags = { v5 },
				fontStyle = bodyMedium,
				testId = "inline-appeal-link-action-text",
				textStyle = default
			}) }, { key = "inline-appeal-link-action", onActivated = p2.onActivated }),
		textElement.new({ Text = v8, fontStyle = bodyMedium, textStyle = default })
	}

	if not FFlagUFRDialogContentCutoffFix then
		return React.createElement(
			view,
			{
				tag = "size-full-0 auto-y",
				testId = "inline-appeal-link",
				LayoutOrder = p2.LayoutOrder
			},
			{
				Layout = React.createElement(inlineLayout, { Elements = v9 })
			}
		)
	end

	local v10, v11 = React.useBinding(0)
	return React.createElement(view, {
		tag = "size-full-0 auto-y",
		testId = "inline-appeal-link",
		LayoutOrder = p2.LayoutOrder,
		sizeConstraint = {
			MinSize = v10:map(function(p3)
				return Vector2.new(0, p3)
			end)
		}
	}, {
		MeasuredLayout = React.createElement(view, {
			tag = "size-full-0 auto-y",
			onAbsoluteSizeChanged = function(p3)
				v11(p3.AbsoluteSize.Y)
			end
		}, {
			Layout = React.createElement(inlineLayout, { Elements = v9 })
		})
	})
end

return React.memo(InlineAppealLink)
