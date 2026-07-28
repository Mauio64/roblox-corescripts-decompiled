local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Players = game:GetService("Players")
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local DataHydration = require(Parent.DataHydration)
local SignalsReact = require(Parent.SignalsReact)
local RoactUtils = require(Parent.RoactUtils)
local gameConnectionsPlayedChipClicked = require(Parent.DiscoveryAnalytics).Events.gameConnectionsPlayedChipClicked
local SduiTextAccessoryRow = require(Parent.SduiSharedContent).SduiTextAccessoryRow
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local InputSize = Foundation.Enums.InputSize
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Game = DataHydration.Game
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useDeviceType = require(Parent.RobloxAppHooks).useDeviceType
local DeviceType = require(Parent.RobloxAppEnums).DeviceType
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local SharedFlags = require(Parent.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v24 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

local function ExperienceDetailsConnectionsPlayedTextRow(t1: {[any]: any}) -- line: 53
	-- upvalues: useTokens (copy), useDispatch (copy), useDeviceType (copy), DeviceType (copy), Game (copy), SignalsReact (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), React (copy), Players (copy), gameConnectionsPlayedChipClicked (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v24 (copy), NavigateDown (copy), AvatarGroupType (copy), InputSize (copy), SduiTextAccessoryRow (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local name = t1.name
	local v30 = useTokens()
	local v31 = useDispatch()
	local v32 = useDeviceType() == DeviceType.Phone
	local v33 = Game.getConnectionsPlayedStore(false)
	local v34 = SignalsReact.useSignalState(v33.getConnectionsPlayed(universeId).data)
	local v35 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v36 = if not v34 then {} else v34.userIds
	local v37 = if not v34 then #v36 else v34.totalCount
	local v38 = useLocalization({
		connectionsRecentlyPlayed = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionsRecentlyPlayed" or "Feature.Friends.Label.FriendsRecentlyPlayed",
			numberOfConnections = v37
		},
		connectionRecentlyPlayed = { not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionRecentlyPlayed" or "Feature.Friends.Label.FriendRecentlyPlayed" },
		playedByUserAndOthersPlural = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.PlayedByUserAndOthers" or "Feature.Friends.Label.PlayedByUserAndOthers.FriendsRename",
			name = name or "",
			numOfOthers = v37 - 1
		},
		playedByUserAndOneOther = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.PlayedByUserAndOneOther" or "Feature.Friends.Label.PlayedByUserAndOneOther.FriendsRename",
			name = name or ""
		},
		playedByUser = {
			"Feature.Friends.Label.PlayedByUser",
			name = name or ""
		}
	})
	local v39 = if not name or name == "" then if v37 ~= 1 then v38.connectionsRecentlyPlayed else v38.connectionRecentlyPlayed else if v37 ~= 1 then if v37 ~= 2 then v38.playedByUserAndOthersPlural else v38.playedByUserAndOneOther else v38.playedByUser
	local v40 = v35 and v35.rootPlaceId
	local v41 = React.useCallback(function() -- line: 127
		-- upvalues: v40 (copy), Players (copy), gameConnectionsPlayedChipClicked (copy), universeId (copy), v37 (copy), AppPage (copy), v36 (copy), v38 (copy), FFlagSignalsNavP3Dispatch (copy), v24 (copy), v31 (copy), NavigateDown (copy)
		if v40 then
			local v46 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameConnectionsPlayedChipClicked({
				uid = tostring(v46),
				universeId = universeId,
				placeId = tostring(v40),
				totalConnections = v37
			}, "ExperienceDetailsConnectionsPlayedChip")
		end

		local t2 = {
			name = AppPage.SocialProofVerticalUserListSheet,
			extraProps = {
				userIds = v36,
				title = if v37 ~= 1 then v38.connectionsRecentlyPlayed else v38.connectionRecentlyPlayed
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v24.down(v24.fromLegacyPage(t2))

			return
		end

		v31(NavigateDown(t2))
	end, {
		v31,
		universeId,
		v40,
		v36,
		v37,
		v38,
		Players.LocalPlayer
	})
	local v42 = React.useMemo(function() -- line: 156
		-- upvalues: v36 (copy)
		return { table.unpack(v36, 1, (math.min(2, #v36))) }
	end, { v36 })
	local v43 = if not v32 then v30.Color.Surface.Surface_0 else v30.Color.Surface.Surface_100
	local v44 = React.useMemo(function() -- line: 162
		-- upvalues: v42 (copy), AvatarGroupType (copy), InputSize (copy), v43 (copy)
		return {
			type = "AvatarGroup",
			max = 2,
			avatars = v42,
			groupType = AvatarGroupType.Stacked,
			size = InputSize.XSmall,
			backplateStyle = v43
		}
	end, {
		v42,
		v43
	})
	local v45 = React.useMemo(function() -- line: 173
		-- upvalues: v30 (copy)
		return {
			FontSize = v30.FontSize.FontSize_300
		}
	end, { v30 })

	if v37 == 0 then
		return nil
	end

	return React.createElement(SduiTextAccessoryRow, {
		testId = "--experience-details-connections-played-text-row",
		text = v39,
		leading = v44,
		gap = v30.Gap.Small,
		fontStyle = v45,
		onActivated = v41,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsConnectionsPlayedTextRow)
