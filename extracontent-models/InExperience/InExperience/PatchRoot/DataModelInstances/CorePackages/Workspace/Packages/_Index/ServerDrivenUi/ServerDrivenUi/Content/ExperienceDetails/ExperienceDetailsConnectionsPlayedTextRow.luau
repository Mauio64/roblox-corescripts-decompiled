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
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v25 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

local function ExperienceDetailsConnectionsPlayedTextRow(t1: {[any]: any}) -- line: 54
	-- upvalues: useTokens (copy), useDispatch (copy), useDeviceType (copy), DeviceType (copy), Game (copy), SignalsReact (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), React (copy), Players (copy), gameConnectionsPlayedChipClicked (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), NavigateDown (copy), FFlagRenameDeprecatedUIBloxTokens (copy), AvatarGroupType (copy), InputSize (copy), SduiTextAccessoryRow (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local name = t1.name
	local v31 = useTokens()
	local v32 = useDispatch()
	local v33 = useDeviceType() == DeviceType.Phone
	local v34 = Game.getConnectionsPlayedStore(false)
	local v35 = SignalsReact.useSignalState(v34.getConnectionsPlayed(universeId).data)
	local v36 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v37 = if not v35 then {} else v35.userIds
	local v38 = if not v35 then #v37 else v35.totalCount
	local v39 = useLocalization({
		connectionsRecentlyPlayed = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionsRecentlyPlayed" or "Feature.Friends.Label.FriendsRecentlyPlayed",
			numberOfConnections = v38
		},
		connectionRecentlyPlayed = { not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionRecentlyPlayed" or "Feature.Friends.Label.FriendRecentlyPlayed" },
		playedByUserAndOthersPlural = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.PlayedByUserAndOthers" or "Feature.Friends.Label.PlayedByUserAndOthers.FriendsRename",
			name = name or "",
			numOfOthers = v38 - 1
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
	local v40 = if not name or name == "" then if v38 ~= 1 then v39.connectionsRecentlyPlayed else v39.connectionRecentlyPlayed else if v38 ~= 1 then if v38 ~= 2 then v39.playedByUserAndOthersPlural else v39.playedByUserAndOneOther else v39.playedByUser
	local v41 = v36 and v36.rootPlaceId
	local v42 = React.useCallback(function() -- line: 128
		-- upvalues: v41 (copy), Players (copy), gameConnectionsPlayedChipClicked (copy), universeId (copy), v38 (copy), AppPage (copy), v37 (copy), v39 (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), v32 (copy), NavigateDown (copy)
		if v41 then
			local v47 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameConnectionsPlayedChipClicked({
				uid = tostring(v47),
				universeId = universeId,
				placeId = tostring(v41),
				totalConnections = v38
			}, "ExperienceDetailsConnectionsPlayedChip")
		end

		local t2 = {
			name = AppPage.SocialProofVerticalUserListSheet,
			extraProps = {
				userIds = v37,
				title = if v38 ~= 1 then v39.connectionsRecentlyPlayed else v39.connectionRecentlyPlayed
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v25.down(v25.fromLegacyPage(t2))

			return
		end

		v32(NavigateDown(t2))
	end, {
		v32,
		universeId,
		v41,
		v37,
		v38,
		v39,
		Players.LocalPlayer
	})
	local v43 = React.useMemo(function() -- line: 157
		-- upvalues: v37 (copy)
		return { table.unpack(v37, 1, (math.min(2, #v37))) }
	end, { v37 })
	local v44 = if not v33 then if not FFlagRenameDeprecatedUIBloxTokens then v31.Semantic.Color.Background.Default else v31.Color.Surface.Surface_0 else if not FFlagRenameDeprecatedUIBloxTokens then v31.Semantic.Color.Background.Contrast else v31.Color.Surface.Surface_100
	local v45 = React.useMemo(function() -- line: 169
		-- upvalues: v43 (copy), AvatarGroupType (copy), InputSize (copy), v44 (copy)
		return {
			type = "AvatarGroup",
			max = 2,
			avatars = v43,
			groupType = AvatarGroupType.Stacked,
			size = InputSize.XSmall,
			backplateStyle = v44
		}
	end, {
		v43,
		v44
	})
	local v46 = React.useMemo(function() -- line: 180
		-- upvalues: v31 (copy)
		return {
			FontSize = v31.FontSize.FontSize_300
		}
	end, { v31 })

	if v38 == 0 then
		return nil
	end

	return React.createElement(SduiTextAccessoryRow, {
		testId = "--experience-details-connections-played-text-row",
		text = v40,
		leading = v45,
		gap = v31.Gap.Small,
		fontStyle = v46,
		onActivated = v42,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsConnectionsPlayedTextRow)
