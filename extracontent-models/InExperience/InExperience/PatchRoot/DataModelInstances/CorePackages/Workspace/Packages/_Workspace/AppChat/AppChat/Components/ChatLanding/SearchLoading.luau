local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)

local FFlagAppChatExtendConversationListRowDividers = require(AppChat.Flags.FFlagAppChatExtendConversationListRowDividers)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)

local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local udim = UDim2.fromOffset(94, 12)
local udim2 = UDim2.fromOffset(169, 12)

local function SearchLoading(p)
	local v = useChatPagePadding()
	local v2 = useTokens()

	local children = {}

	for i = 1, 3 do
		local formatted = `PlaceholderRow{i}`
		local createElement = React.createElement
		local v3 = {
			tag = "row align-y-center gap-small",
			Size = UDim2.new(1, 0, 0, p.entryHeight),
			LayoutOrder = i,
			padding = 0
		}

		local padding = { left = UDim.new(0, v.left), right = 0 }
		local right

		if not FFlagAppChatExtendConversationListRowDividers then
			right = UDim.new(0, v.right)
		end

		padding.right = right
		v3.padding = padding

		local children2 = {
			Avatar = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v2.Size.Size_1000, v2.Size.Size_1000),
				radius = Radius.Circle,
				LayoutOrder = 1
			}),
			Body = 0
		}

		local createElement2 = React.createElement

		local v4 = {
			Lines = React.createElement(View, {
				tag = "col align-y-center fill gap-small size-full-0",
				LayoutOrder = 1,
				padding = FFlagAppChatExtendConversationListRowDividers and {
					right = UDim.new(0, v.right)
				} or nil
			}, {
				Title = React.createElement(Skeleton, { Size = udim, LayoutOrder = 1 }),
				Subtitle = React.createElement(Skeleton, { Size = udim2, LayoutOrder = 2 })
			}),
			Divider = 0
		}
		local divider

		if i < 3 and not FFlagAppChatRemoveConversationListDivider then
			divider = React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = 2 }, {
				Line = React.createElement(Foundation.Divider)
			})
		end

		v4.Divider = divider
		children2.Body = createElement2(View, { tag = "col fill size-0-full", LayoutOrder = 2 }, v4)
		children[formatted] = createElement(View, v3, children2)
	end

	return React.createElement(View, {
		tag = "col size-full",
		padding = {
			top = UDim.new(0, p.topPadding or 0)
		}
	}, {
		ChatLoadingFrame = React.createElement(View, { tag = "col size-full-0 auto-y" }, children)
	})
end

return SearchLoading
