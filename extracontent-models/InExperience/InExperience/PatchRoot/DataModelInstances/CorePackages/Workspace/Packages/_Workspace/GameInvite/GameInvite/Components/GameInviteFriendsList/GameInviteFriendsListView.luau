local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local FriendsMenu = require(parent.FriendsMenu)
local UserList = require(parent.UserList)
local FFlagGameInviteInExpJoinCta = require(GameInvite.Flags.FFlagGameInviteInExpJoinCta)

require(script.Parent.useGameInviteJoinCard)

local VerticalUserList = UserList.VerticalUserList.VerticalUserList
local FriendsMenuShareGameInviteLink = FriendsMenu.FriendsMenuShareGameInviteLink

local configs = {
	disableRowActivation = true,
	showTrustedFriendIndicator = false,
	disableVirtualization = true
}

local function GameInviteJoinCardPortal(p)
	local v = Foundation.Hooks.useOverlay()
	local joinCard = p.joinCard
	local cardComponent = joinCard.cardComponent

	if v == nil or cardComponent == nil then
		return nil
	end

	return ReactRoblox.createPortal({
		GameInviteJoinCard = React.createElement(cardComponent, {
			userId = joinCard.userId,
			onJoin = joinCard.join,
			onClose = joinCard.close
		})
	}, v)
end

local function GameInviteFriendsListView(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = "col",
		testId = "GameInviteFriendsListView",
		Size = props.size,
		LayoutOrder = props.layoutOrder
	}
	local shareGameInviteLink

	if props.showShareGameInviteLink then
		shareGameInviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
			layoutOrder = 1
		})
	end

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local createElement3 = React.createElement
	local v2 = {
		entities = props.entities,
		isScrollEnabled = true,
		renderRow = props.renderRow,
		onRowSelected = props.onRowSelected,
		onEndReached = props.onEndReached,
		configs = configs,
		ctaConfig = 0
	}
	local ctaConfig

	if FFlagGameInviteInExpJoinCta then
		ctaConfig = props.ctaConfig
	end

	v2.ctaConfig = ctaConfig
	local v3 = {
		ShareGameInviteLink = shareGameInviteLink,
		Rows = createElement2(
			view2,
			{
				tag = "col fill size-full-0 padding-x-xxlarge",
				testId = "GameInviteFriendsListRows",
				LayoutOrder = 2
			},
			{
				List = createElement3(VerticalUserList, v2)
			}
		),
		JoinCard = 0
	}
	local joinCard

	if FFlagGameInviteInExpJoinCta and props.joinCard and props.joinCard.userId then
		joinCard = React.createElement(GameInviteJoinCardPortal, { joinCard = props.joinCard })
	end

	v3.JoinCard = joinCard
	return createElement(view, v, v3)
end

return GameInviteFriendsListView
