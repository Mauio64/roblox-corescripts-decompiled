local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)

require(AppChat.types)

local useTokens = Foundation.Hooks.useTokens
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local t1 = {
	actionText = "PLACEHOLDER Action",
	bodyText = "PLACEHOLDER Body",
	onActivated = function() -- line: 24
	end,
	onDismissed = function() -- line: 25
	end
}

local function ConversationBanner(t2: {[any]: any}) -- line: 28
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), useChatPagePadding (copy), React (copy), Foundation (copy)
	local v11 = Cryo.Dictionary.union(t1, t2)
	local Medium = useTokens().Padding.Medium
	local v13 = useChatPagePadding()

	return React.createElement(Foundation.View, {
		tag = "row gap-medium align-y-center size-full-0 auto-y bg-shift-200",
		padding = {
			left = UDim.new(0, v13.left),
			right = UDim.new(0, v13.right),
			top = UDim.new(0, Medium),
			bottom = UDim.new(0, Medium)
		},
		LayoutOrder = v11.layoutOrder
	}, {
		BodyText = React.createElement(Foundation.Text, {
			tag = "text-title-medium text-align-x-left text-truncate-end content-emphasis auto-y fill",
			LayoutOrder = 1,
			Text = v11.bodyText
		}),
		ActionContainer = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "row gap-small align-y-center auto-xy"
		}, {
			ActionButton = React.createElement(Foundation.Button, {
				LayoutOrder = 1,
				text = v11.actionText,
				onActivated = v11.onActivated,
				size = Foundation.Enums.InputSize.Small
			}),
			CloseButton = React.createElement(Foundation.View, {
				LayoutOrder = 2,
				tag = "auto-xy x-default-transparent radius-small padding-xsmall",
				onActivated = v11.onDismissed
			}, {
				Icon = React.createElement(Foundation.Icon, {
					size = Foundation.Enums.IconSize.Large,
					name = Foundation.Enums.IconName.X
				})
			})
		})
	})
end

return React.memo(ConversationBanner)
