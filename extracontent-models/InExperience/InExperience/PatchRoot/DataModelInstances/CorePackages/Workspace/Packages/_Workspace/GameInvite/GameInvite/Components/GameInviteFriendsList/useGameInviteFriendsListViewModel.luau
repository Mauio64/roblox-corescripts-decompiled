local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent
local React = require(parent.React)
local FriendsMenu = require(parent.FriendsMenu)
local UserList = require(parent.UserList)
local DataHydration = require(parent.DataHydration)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local GameInviteConstants = require(GameInvite.GameInviteConstants)
require(GameInvite.gameInviteModalType)
local GameDetailsContext = require(GameInvite.Context.GameDetailsContext)
local GameInviteFriendRow = require(script.Parent.GameInviteFriendRow)
require(script.Parent.GameInviteFriendsListView)
local canShareGameInviteLink = require(script.Parent.canShareGameInviteLink)
local useGameInviteJoinCard = require(script.Parent.useGameInviteJoinCard)
local isInThisServer = require(GameInvite.utils.isInThisServer)
local isJoinExpected = require(GameInvite.utils.isJoinExpected)
local shouldShowJoinCta = require(GameInvite.utils.shouldShowJoinCta)
local FFlagGameInviteInExpJoinCta = require(GameInvite.Flags.FFlagGameInviteInExpJoinCta)
local FFlagGameInviteInExpLivePresence = require(GameInvite.Flags.FFlagGameInviteInExpLivePresence)
local FFlagGameInviteInExpRefetchOnPresenceEvent = require(GameInvite.Flags.FFlagGameInviteInExpRefetchOnPresenceEvent)
local useRefetchOnlineFriendsOnPresenceEvent

if FFlagGameInviteInExpRefetchOnPresenceEvent then
	useRefetchOnlineFriendsOnPresenceEvent = require(script.Parent.useRefetchOnlineFriendsOnPresenceEvent)
else
	useRefetchOnlineFriendsOnPresenceEvent = nil
end

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListHideNotJoinableJoin = SharedFlags.FFlagUserListHideNotJoinableJoin
local isPioneerLaunch

if FFlagUserListHideNotJoinableJoin then
	local PioneerUtils = require(parent.PioneerUtils)
	isPioneerLaunch = PioneerUtils.isPioneerLaunch
else
	isPioneerLaunch = nil
end

local User = UserList.Enums.EntityType.User

local function ignoreRowSelection() end

local function isJoinVisible(p): boolean
	return not isInThisServer(p, game.JobId)
end

local function createJoinCtaConfig(p, onActivated)
	return {
		supportedActions = { "JoinExperience" },
		primaryCtaMinWidth = GameInviteConstants.Layout.JoinCtaMinWidth,
		primaryCtaMaxWidth = GameInviteConstants.Layout.JoinCtaMaxWidth,
		enableJoinabilityCheck = FFlagUserListHideNotJoinableJoin and isPioneerLaunch() and true or nil,
		join = {
			onActivated = onActivated,
			isVisible = isJoinVisible,
			isJoinExpected = function(p2: string, p3)
				return isJoinExpected(p3, p[p2], game.JobId)
			end
		}
	}
end

local function useJoinCtaConfig(friendsById, p, open)
	local v = shouldShowJoinCta(p)
	return React.useMemo(function()
		if v then
			return createJoinCtaConfig(friendsById, open)
		end

		return nil
	end, { v, friendsById, open })
end

local function useGameInviteFriendsListViewModel(p)
	local v = React.useContext(FriendsMenu.FriendsListContext)
	local friends = v.friends
	local v2 = React.useContext(GameDetailsContext)
	local v3 = useAppPolicy(function(p2)
		return p2.getExperienceInviteShareLinkEnabled()
	end)

	if FFlagGameInviteInExpLivePresence then
		React.useEffect(function()
			DataHydration.Friends.FriendsStore.get().RefetchOnlineFriends()
		end, {})
	end

	local v4 = React.useMemo(function()
		local friendsById = {}
		local entities = {}

		for _, friend in friends do
			if friend.isLoadingPlaceholder or friendsById[friend.id] ~= nil then
				continue
			end

			table.insert(entities, { id = friend.id, type = User })
			friendsById[friend.id] = friend
		end

		return { entities = entities, friendsById = friendsById }
	end, { friends })

	local friendsById = v4.friendsById

	if FFlagGameInviteInExpRefetchOnPresenceEvent then
		useRefetchOnlineFriendsOnPresenceEvent(friendsById)
	end

	local joinCard

	if FFlagGameInviteInExpJoinCta then
		joinCard = useGameInviteJoinCard(tostring(game.GameId), game.JobId)
	end

	local v5

	if FFlagGameInviteInExpJoinCta then
		v5 = useJoinCtaConfig(friendsById, v2, joinCard.open)
	end

	local renderRow = React.useCallback(function(createRow, p2, rowNumber: number)
		local friend = friendsById[p2.id]

		if friend == nil then
			return nil
		end

		return React.createElement(GameInviteFriendRow, {
			createRow = createRow,
			friend = friend,
			rowNumber = rowNumber
		})
	end, { friendsById })

	local fetchMoreFriends = v.fetchMoreFriends
	local onEndReached = React.useCallback(function()
		fetchMoreFriends()
	end, { fetchMoreFriends })

	local v6 = {
		layoutOrder = p.layoutOrder,
		size = p.size,
		entities = v4.entities,
		renderRow = renderRow,
		onRowSelected = ignoreRowSelection,
		onEndReached = 0,
		showShareGameInviteLink = 0,
		ctaConfig = 0,
		joinCard = 0
	}

	if not fetchMoreFriends or v.searchFriendsString ~= "" then
		onEndReached = nil
	end

	v6.onEndReached = onEndReached
	v6.showShareGameInviteLink = canShareGameInviteLink(game.GameId, v2, v3)
	local ctaConfig

	if FFlagGameInviteInExpJoinCta then
		ctaConfig = v5
	end

	v6.ctaConfig = ctaConfig

	if not FFlagGameInviteInExpJoinCta or v5 == nil then
		joinCard = nil
	end

	v6.joinCard = joinCard
	return v6
end

return useGameInviteFriendsListViewModel
