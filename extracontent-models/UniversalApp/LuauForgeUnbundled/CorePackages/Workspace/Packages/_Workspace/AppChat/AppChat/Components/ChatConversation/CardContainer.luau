local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCards")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local useChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext").useChatPlacementContext

local cards = SocialCards.Cards

local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").LayoutMode
local userPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Enums.UserPresence

local useTokens = Foundation.Hooks.useTokens

local function CardContainer(props)
	local v5 = useLocalUserId()
	local v6 = tostring(v5) == props.senderTargetId
	local v7 = useTokens()
	local v8 = useChatPagePadding()
	local v9 = useChatPlacementContext()

	local v10 = React.useMemo(function()
		return Vector2.new(v7.Size.Size_700, v7.Size.Size_700)
	end, { v7 })

	local size_200 = v7.Size.Size_200
	local v11

	if props.senderTargetId then
		v11 = if v6 then Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Left
	else
		v11 = Enum.HorizontalAlignment.Center
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v12 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		testId = props.testId,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = v11,
			Padding = UDim.new(0, size_200),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		},
		padding = {
			left = UDim.new(0, v8.left),
			right = UDim.new(0, v8.right),
			top = UDim.new(0, v7.Padding.XSmall)
		}
	}

	local v14 = if props.senderTargetId and props.senderTargetId ~= v5 then React.createElement(Foundation.View, {
		Size = UDim2.new(0, v10.X, 0, v10.Y),
		LayoutOrder = v6 and 2 or 1
	}, { React.createElement(userTile, {
			userId = props.senderTargetId,
			layoutMode = layoutMode.compact,
			userPresenceType = userPresence.None
		}) }) else nil
	local v15

	if props.cards then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v16 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, not props.senderTargetId and 0 or -(v10.X + size_200), 0, 0),
			LayoutOrder = v6 and 1 or 2
		}

		local createElement3 = React.createElement
		local v18 = {
			analyticsInfo = { moduleLocation = v9.chatPlacement },
			anchorPoint = 0,
			position = 0,
			cards = 0
		}

		local v19 = if v6 then Vector2.new(1, 0) else Vector2.new(0, 0)
		v18.anchorPoint = v19
		local v20 = if v6 then UDim2.fromScale(1, 0) else UDim2.fromScale(0, 0)
		v18.position = v20
		v18.cards = props.cards
		v15 = createElement2(view2, v16, createElement3(cards, v18))
	end

	return createElement(view, v12, { Avatar = v14, Cards = v15 })
end

return CardContainer
