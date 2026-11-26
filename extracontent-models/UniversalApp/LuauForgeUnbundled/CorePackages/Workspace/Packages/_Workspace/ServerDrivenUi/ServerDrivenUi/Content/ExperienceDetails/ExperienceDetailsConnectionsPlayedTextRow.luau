local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
local gameConnectionsPlayedChipClicked = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.gameConnectionsPlayedChipClicked

local sduiTextAccessoryRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiTextAccessoryRow

local avatarGroupType = Foundation.Enums.AvatarGroupType
local inputSize = Foundation.Enums.InputSize
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local Game = DataHydration.Game
local useTokens = Foundation.Hooks.useTokens

local useLocalization = Localization.Hooks.useLocalization
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppHooks").useDeviceType
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").DeviceType
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux").Thunks.NavigateDown

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local function ExperienceDetailsConnectionsPlayedTextRow(props)
	local layoutOrder = props.layoutOrder
	local universeId = props.universeId
	local name = props.name

	local v5 = useTokens()
	local v6 = useDispatch()
	local v7 = useDeviceType() == deviceType.Phone

	local connectionsPlayedStore = Game.getConnectionsPlayedStore(false)
	local v8 = SignalsReact.useSignalState(connectionsPlayedStore.getConnectionsPlayed(universeId).data)
	local v9 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)

	local v10 = not v8 and {} or v8.userIds
	local v11 = if v8 then v8.totalCount else #v10

	local v12 = useLocalization({
		connectionsRecentlyPlayed = {
			"Feature.Friends.Label.FriendsRecentlyPlayed",
			numberOfConnections = v11
		},
		connectionRecentlyPlayed = { "Feature.Friends.Label.FriendRecentlyPlayed" },
		playedByUserAndOthersPlural = {
			"Feature.Friends.Label.PlayedByUserAndOthers.FriendsRename",
			name = name or "",
			numOfOthers = v11 - 1
		},
		playedByUserAndOneOther = {
			"Feature.Friends.Label.PlayedByUserAndOneOther.FriendsRename",
			name = name or ""
		},
		playedByUser = {
			"Feature.Friends.Label.PlayedByUser",
			name = name or ""
		}
	})
	local v13

	if name and name ~= "" then
		if v11 == 1 then
			v13 = v12.playedByUser
		else
			v13 = if v11 == 2 then v12.playedByUserAndOneOther else v12.playedByUserAndOthersPlural
		end
	else
		v13 = if v11 == 1 then v12.connectionRecentlyPlayed else v12.connectionsRecentlyPlayed
	end

	local rootPlaceId = v9 and v9.rootPlaceId

	local v14 = React.useCallback(function()
		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameConnectionsPlayedChipClicked(
				{
					uid = tostring(userId),
					universeId = universeId,
					placeId = tostring(rootPlaceId),
					totalConnections = v11
				},
				"ExperienceDetailsConnectionsPlayedChip"
			)
		end

		local v15 = { name = appPage.SocialProofVerticalUserListSheet, extraProps = 0 }
		local v16 = { userIds = v10, title = 0 }

		local v17 = if v11 == 1 then v12.connectionRecentlyPlayed else v12.connectionsRecentlyPlayed
		v16.title = v17
		v15.extraProps = v16

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v15))
		else
			v6(navigateDown(v15))
		end
	end, { v6, universeId, rootPlaceId, v10, v11, v12, Players.LocalPlayer })

	local v15 = React.useMemo(function()
		return { table.unpack(v10, 1, (math.min(2, #v10))) }
	end, { v10 })

	local v16 = if v7 then v5.Color.Surface.Surface_100 else v5.Color.Surface.Surface_0

	local v17 = React.useMemo(function()
		return {
			type = "AvatarGroup",
			avatars = v15,
			groupType = avatarGroupType.Stacked,
			max = 2,
			size = inputSize.XSmall,
			backplateStyle = v16
		}
	end, { v15, v16 })

	local v18 = React.useMemo(function()
		return { FontSize = v5.FontSize.FontSize_300 }
	end, { v5 })

	if v11 == 0 then
		return nil
	end

	return React.createElement(sduiTextAccessoryRow, {
		text = v13,
		leading = v17,
		gap = v5.Gap.Small,
		fontStyle = v18,
		onActivated = v14,
		layoutOrder = layoutOrder,
		testId = "--experience-details-connections-played-text-row"
	})
end

return React.memo(ExperienceDetailsConnectionsPlayedTextRow)
