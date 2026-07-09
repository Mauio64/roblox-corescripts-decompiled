local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local SocialCards = require(AppChatParent.SocialCards)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local useChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).useChatPlacementContext
local Cards = SocialCards.Cards
local UserTile = require(AppChatParent.UserTile).UserTile
local LayoutMode = require(AppChatParent.UserTile).LayoutMode
local UserPresence = require(AppChatParent.Foundation).Enums.UserPresence
local useTokens = Foundation.Hooks.useTokens

local function CardContainer(t1: {[any]: any}) -- line: 28
	-- upvalues: useLocalUserId (copy), useTokens (copy), useChatPagePadding (copy), useChatPlacementContext (copy), React (copy), Foundation (copy), UserTile (copy), LayoutMode (copy), UserPresence (copy), Cards (copy)
	local v16 = useLocalUserId()
	local v17 = tostring(v16) == t1.senderTargetId
	local v18 = useTokens()
	local v19 = useChatPagePadding()
	local v20 = useChatPlacementContext()
	local v21 = React.useMemo(function() -- line: 35
		-- upvalues: v18 (copy)
		return Vector2.new(v18.Size.Size_700, v18.Size.Size_700)
	end, { v18 })
	local Size_200 = v18.Size.Size_200
	local v23 = if t1.senderTargetId then if not v17 then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Center

	return React.createElement(Foundation.View, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		testId = t1.testId,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = v23,
			Padding = UDim.new(0, Size_200),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		},
		padding = {
			left = UDim.new(0, v19.left),
			right = UDim.new(0, v19.right),
			top = UDim.new(0, v18.Padding.XSmall)
		}
	}, {
		Avatar = if not t1.senderTargetId or v16 == t1.senderTargetId then nil else React.createElement(Foundation.View, {
			Size = UDim2.new(0, v21.X, 0, v21.Y),
			LayoutOrder = not v17 and 1 or 2
		}, { React.createElement(UserTile, {
			userId = t1.senderTargetId,
			layoutMode = LayoutMode.compact,
			userPresenceType = UserPresence.None
		}) }),
		Cards = if not t1.cards then nil else React.createElement(Foundation.View, {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, not t1.senderTargetId and 0 or -(v21.X + Size_200), 0, 0),
			LayoutOrder = not v17 and 2 or 1
		}, React.createElement(Cards, {
			analyticsInfo = {
				moduleLocation = v20.chatPlacement
			},
			anchorPoint = if not v17 then Vector2.new(0, 0) else Vector2.new(1, 0),
			position = if not v17 then UDim2.fromScale(0, 0) else UDim2.fromScale(1, 0),
			cards = t1.cards
		}))
	})
end

return CardContainer
