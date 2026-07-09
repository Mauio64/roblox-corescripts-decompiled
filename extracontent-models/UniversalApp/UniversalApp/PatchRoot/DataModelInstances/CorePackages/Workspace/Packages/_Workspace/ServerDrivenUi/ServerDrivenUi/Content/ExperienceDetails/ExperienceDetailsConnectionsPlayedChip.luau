local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Players = game:GetService("Players")
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local SignalsReact = require(Parent.SignalsReact)
local Game = require(Parent.DataHydration).Game
local SduiChip = require(Parent.SduiSharedContent).SduiChip
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(Parent.RobloxAppEnums).AppPage
local gameConnectionsPlayedChipClicked = require(Parent.DiscoveryAnalytics).Events.gameConnectionsPlayedChipClicked
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local useLocalization = Localization.Hooks.useLocalization
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local SharedFlags = require(Parent.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

local function ExperienceDetailsConnectionsPlayedChip(t1: {[any]: any}) -- line: 40
	-- upvalues: useDispatch (copy), SignalsReact (copy), Game (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), React (copy), Players (copy), gameConnectionsPlayedChipClicked (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), NavigateDown (copy), SduiChip (copy), AvatarGroupType (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local v23 = useDispatch()
	local v24 = SignalsReact.useSignalState(Game.getConnectionsPlayedStore(false).getConnectionsPlayed(universeId).data)
	local v25 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v26 = if not v24 then {} else v24.userIds
	local v27 = not v24 and 0 or v24.totalCount
	local v28 = useLocalization({
		connectionsPlayed = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionsPlayed" or "Feature.Friends.Label.FriendsPlayed",
			numberOfConnections = v27
		},
		connectionsRecentlyPlayed = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionsRecentlyPlayed" or "Feature.Friends.Label.FriendsRecentlyPlayed",
			numberOfConnections = v27
		},
		connectionRecentlyPlayed = { not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionRecentlyPlayed" or "Feature.Friends.Label.FriendRecentlyPlayed" }
	})
	local v29 = React.useCallback(function() -- line: 74
		-- upvalues: v25 (copy), Players (copy), gameConnectionsPlayedChipClicked (copy), universeId (copy), v27 (copy), AppPage (copy), v26 (copy), v28 (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), v23 (copy), NavigateDown (copy)
		local v33 = v25 and v25.rootPlaceId

		if v33 then
			local v34 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameConnectionsPlayedChipClicked({
				uid = tostring(v34),
				universeId = universeId,
				placeId = tostring(v33),
				totalConnections = v27
			}, "ExperienceDetailsConnectionsPlayedChip")
		end

		local t2 = {
			name = AppPage.SocialProofVerticalUserListSheet,
			extraProps = {
				userIds = v26,
				title = if v27 ~= 1 then v28.connectionsRecentlyPlayed else v28.connectionRecentlyPlayed
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v18.down(v18.fromLegacyPage(t2))

			return
		end

		v23(NavigateDown(t2))
	end, {
		v23,
		universeId,
		v25,
		v27,
		v28,
		Players.LocalPlayer
	})

	if v27 == 0 then
		return nil
	end

	local connectionsPlayed = v28.connectionsPlayed
	local t3 = {}

	for i = 1, math.min(2, #v26) do
		table.insert(t3, v26[i])
	end

	return React.createElement(SduiChip, {
		text = connectionsPlayed,
		leading = {
			type = "AvatarGroup",
			props = {
				max = 2,
				avatars = t3,
				type = AvatarGroupType.Stacked
			}
		},
		onActivated = v29,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsConnectionsPlayedChip)
