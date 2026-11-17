local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SocialCards = require(parent.SocialCards)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext

local Cards = SocialCards.Cards

local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode
local Foundation2 = require(parent.Foundation)
local UserPresence = Foundation2.Enums.UserPresence

local useTokens = Foundation.Hooks.useTokens

local function CardContainer(props)
	local v = useLocalUserId()
	local v2 = tostring(v) == props.senderTargetId
	local v3 = useTokens()
	local v4 = useChatPagePadding()
	local v5 = useChatPlacementContext()

	local v6 = React.useMemo(function()
		return Vector2.new(v3.Size.Size_700, v3.Size.Size_700)
	end, { v3 })

	local size_200 = v3.Size.Size_200
	local horizontalAlignment

	if props.senderTargetId then
		if v2 then
			horizontalAlignment = Enum.HorizontalAlignment.Right
		else
			horizontalAlignment = Enum.HorizontalAlignment.Left
		end
	else
		horizontalAlignment = Enum.HorizontalAlignment.Center
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v7 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		testId = props.testId,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = horizontalAlignment,
			Padding = UDim.new(0, size_200),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		},
		padding = {
			left = UDim.new(0, v4.left),
			right = UDim.new(0, v4.right),
			top = UDim.new(0, v3.Padding.XSmall)
		}
	}
	local avatar

	if props.senderTargetId and props.senderTargetId ~= v then
		avatar = React.createElement(Foundation.View, {
			Size = UDim2.new(0, v6.X, 0, v6.Y),
			LayoutOrder = v2 and 2 or 1
		}, { React.createElement(userTile, {
				userId = props.senderTargetId,
				layoutMode = LayoutMode.compact,
				userPresenceType = UserPresence.None
			}) })
	end

	local cards

	if props.cards then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v8 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, not props.senderTargetId and 0 or -(v6.X + size_200), 0, 0),
			LayoutOrder = v2 and 1 or 2
		}

		local createElement3 = React.createElement
		local v9 = {
			analyticsInfo = { moduleLocation = v5.chatPlacement },
			anchorPoint = 0,
			position = 0,
			cards = 0,
			conversationId = 0
		}
		local anchorPoint

		if v2 then
			anchorPoint = Vector2.new(1, 0)
		else
			anchorPoint = Vector2.new(0, 0)
		end

		v9.anchorPoint = anchorPoint
		local position

		if v2 then
			position = UDim2.fromScale(1, 0)
		else
			position = UDim2.fromScale(0, 0)
		end

		v9.position = position
		v9.cards = props.cards
		v9.conversationId = props.conversationId
		cards = createElement2(view2, v8, createElement3(Cards, v9))
	end

	return createElement(view, v7, { Avatar = avatar, Cards = cards })
end

return CardContainer
