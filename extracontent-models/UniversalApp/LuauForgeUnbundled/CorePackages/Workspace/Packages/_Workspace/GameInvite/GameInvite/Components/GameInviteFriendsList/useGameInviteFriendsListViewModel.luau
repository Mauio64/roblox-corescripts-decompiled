local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsMenu")
local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserList")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UniversalAppPolicy").useAppPolicy

local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")
local GameDetailsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameDetailsContext")
local GameInviteFriendRow = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/GameInviteFriendRow")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/GameInviteFriendsListView")
local canShareGameInviteLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/canShareGameInviteLink")
local useGameInviteJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/useGameInviteJoinCard")
local isInThisServer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/isInThisServer")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/isJoinExpected")
local shouldShowJoinCta = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/shouldShowJoinCta")
local FFlagGameInviteInExpJoinCta = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpJoinCta")
local FFlagGameInviteInExpLivePresence = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpLivePresence")
local FFlagGameInviteInExpRefetchOnPresenceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpRefetchOnPresenceEvent")

local v5 = if FFlagGameInviteInExpRefetchOnPresenceEvent then require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/useRefetchOnlineFriendsOnPresenceEvent") else nil

local fFlagUserListHideNotJoinableJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagUserListHideNotJoinableJoin

local isPioneerLaunch = if fFlagUserListHideNotJoinableJoin then require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/PioneerUtils").isPioneerLaunch else nil

local user = UserList.Enums.EntityType.User

local function ignoreRowSelection() end

local function isJoinVisible(p2): boolean
	return not isInThisServer(p2, game.JobId)
end

local function createJoinCtaConfig(p2, onActivated)
	return {
		supportedActions = { "JoinExperience" },
		primaryCtaMinWidth = GameInviteConstants.Layout.JoinCtaMinWidth,
		primaryCtaMaxWidth = GameInviteConstants.Layout.JoinCtaMaxWidth,
		enableJoinabilityCheck = fFlagUserListHideNotJoinableJoin and isPioneerLaunch() and true or nil,
		join = {
			onActivated = onActivated,
			isVisible = isJoinVisible,
			isJoinExpected = function(p3, p4)
				return module11(p4, p2[p3], game.JobId)
			end
		}
	}
end

local function useJoinCtaConfig(friendsById, p2, open)
	local v6 = shouldShowJoinCta(p2)
	return React.useMemo(function()
		if v6 then
			return createJoinCtaConfig(friendsById, open)
		end

		return nil
	end, { v6, friendsById, open })
end

local function useGameInviteFriendsListViewModel(p2)
	local v6 = React.useContext(FriendsMenu.FriendsListContext)
	local friends = v6.friends
	local v7 = React.useContext(GameDetailsContext)
	local v8 = useAppPolicy(function(p3)
		return p3.getExperienceInviteShareLinkEnabled()
	end)

	if FFlagGameInviteInExpLivePresence then
		React.useEffect(function()
			DataHydration.Friends.FriendsStore.get().RefetchOnlineFriends()
		end, {})
	end

	local v9 = React.useMemo(function()
		local friendsById = {}
		local v10 = {}

		for k, friend in friends do
			if friend.isLoadingPlaceholder or friendsById[friend.id] ~= nil then
				continue
			end

			table.insert(v10, { id = friend.id, type = user })
			friendsById[friend.id] = friend
		end

		return { entities = v10, friendsById = friendsById }
	end, { friends })

	local friendsById = v9.friendsById

	if FFlagGameInviteInExpRefetchOnPresenceEvent then
		v5(friendsById)
	end

	local v10 = if FFlagGameInviteInExpJoinCta then useGameInviteJoinCard(tostring(game.GameId), game.JobId) else nil

	local v11 = if FFlagGameInviteInExpJoinCta then useJoinCtaConfig(friendsById, v7, v10.open) else nil

	local v12 = React.useCallback(function(p3, p4, p5)
		local friend = friendsById[p4.id]

		if friend == nil then
			return nil
		end

		return React.createElement(GameInviteFriendRow, {
			createRow = p3,
			friend = friend,
			rowNumber = p5
		})
	end, { friendsById })

	local fetchMoreFriends = v6.fetchMoreFriends
	local v13 = React.useCallback(function()
		fetchMoreFriends()
	end, { fetchMoreFriends })

	local v14 = {
		layoutOrder = p2.layoutOrder,
		size = p2.size,
		entities = v9.entities,
		renderRow = v12,
		onRowSelected = ignoreRowSelection,
		onEndReached = 0,
		showShareGameInviteLink = 0,
		ctaConfig = 0,
		joinCard = 0
	}

	if not fetchMoreFriends or v6.searchFriendsString ~= "" then
		v13 = nil
	end

	v14.onEndReached = v13
	v14.showShareGameInviteLink = canShareGameInviteLink(game.GameId, v7, v8)
	v14.ctaConfig = if FFlagGameInviteInExpJoinCta then v11 else nil

	if not FFlagGameInviteInExpJoinCta or v11 == nil then
		v10 = nil
	end

	v14.joinCard = v10
	return v14
end

return useGameInviteFriendsListViewModel
