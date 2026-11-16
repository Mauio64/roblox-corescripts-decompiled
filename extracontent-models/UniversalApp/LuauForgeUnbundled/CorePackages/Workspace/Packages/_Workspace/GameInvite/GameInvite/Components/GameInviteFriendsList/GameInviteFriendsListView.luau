local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation")
local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsMenu")
local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserList")
local FFlagGameInviteInExpJoinCta = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpJoinCta")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/useGameInviteJoinCard")

local verticalUserList = UserList.VerticalUserList.VerticalUserList
local friendsMenuShareGameInviteLink = FriendsMenu.FriendsMenuShareGameInviteLink

local v5 = {
	disableRowActivation = true,
	showTrustedFriendIndicator = false,
	disableVirtualization = true
}

local function GameInviteJoinCardPortal(p2)
	local v6 = Foundation.Hooks.useOverlay()
	local joinCard = p2.joinCard
	local cardComponent = joinCard.cardComponent

	if v6 == nil or cardComponent == nil then
		return nil
	end

	return ReactRoblox.createPortal({
		GameInviteJoinCard = React.createElement(cardComponent, {
			userId = joinCard.userId,
			onJoin = joinCard.join,
			onClose = joinCard.close
		})
	}, v6)
end

local function GameInviteFriendsListView(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		tag = "col",
		testId = "GameInviteFriendsListView",
		Size = props.size,
		LayoutOrder = props.layoutOrder
	}

	local v8 = if props.showShareGameInviteLink then React.createElement(friendsMenuShareGameInviteLink, {
		layoutOrder = 1
	}) else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local createElement3 = React.createElement
	local v12 = {
		entities = props.entities,
		isScrollEnabled = true,
		renderRow = props.renderRow,
		onRowSelected = props.onRowSelected,
		onEndReached = props.onEndReached,
		configs = v5,
		ctaConfig = 0
	}

	local v13 = if FFlagGameInviteInExpJoinCta then props.ctaConfig else nil
	v12.ctaConfig = v13
	local v7 = {
		ShareGameInviteLink = v8,
		Rows = createElement2(
			view2,
			{
				tag = "col fill size-full-0 padding-x-xxlarge",
				testId = "GameInviteFriendsListRows",
				LayoutOrder = 2
			},
			{
				List = createElement3(verticalUserList, v12)
			}
		),
		JoinCard = 0
	}

	local v14 = if FFlagGameInviteInExpJoinCta and props.joinCard and props.joinCard.userId then React.createElement(GameInviteJoinCardPortal, {
		joinCard = props.joinCard
	}) else nil
	v7.JoinCard = v14
	return createElement(view, v6, v7)
end

return GameInviteFriendsListView
