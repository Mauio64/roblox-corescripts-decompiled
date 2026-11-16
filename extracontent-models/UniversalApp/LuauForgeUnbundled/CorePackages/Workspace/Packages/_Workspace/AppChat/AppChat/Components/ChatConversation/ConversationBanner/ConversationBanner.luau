local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local useTokens = Foundation.Hooks.useTokens

local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")

local v5 = {
	actionText = "PLACEHOLDER Action",
	bodyText = "PLACEHOLDER Body",
	onActivated = function() end,
	onDismissed = function() end
}

local function ConversationBanner(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local medium = useTokens().Padding.Medium
	local v6 = useChatPagePadding()

	return React.createElement(Foundation.View, {
		padding = {
			left = UDim.new(0, v6.left),
			right = UDim.new(0, v6.right),
			top = UDim.new(0, medium),
			bottom = UDim.new(0, medium)
		},
		tag = "row gap-medium align-y-center size-full-0 auto-y bg-shift-200",
		LayoutOrder = union.layoutOrder
	}, {
		BodyText = React.createElement(Foundation.Text, {
			tag = "text-title-medium text-align-x-left text-truncate-end content-emphasis auto-y fill",
			LayoutOrder = 1,
			Text = union.bodyText
		}),
		ActionContainer = React.createElement(
			Foundation.View,
			{ LayoutOrder = 2, tag = "row gap-small align-y-center auto-xy" },
			{
				ActionButton = React.createElement(Foundation.Button, {
					text = union.actionText,
					onActivated = union.onActivated,
					size = Foundation.Enums.InputSize.Small,
					LayoutOrder = 1
				}),
				CloseButton = React.createElement(
					Foundation.View,
					{
						onActivated = union.onDismissed,
						LayoutOrder = 2,
						tag = "auto-xy x-default-transparent radius-small padding-xsmall"
					},
					{
						Icon = React.createElement(Foundation.Icon, {
							size = Foundation.Enums.IconSize.Large,
							name = Foundation.Enums.IconName.X
						})
					}
				)
			}
		)
	})
end

return React.memo(ConversationBanner)
