local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game

local sduiChip = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiChip

local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage

local gameConnectionsPlayedChipClicked = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.gameConnectionsPlayedChipClicked

local avatarGroupType = Foundation.Enums.AvatarGroupType

local useLocalization = Localization.Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils").Hooks.RoactRodux.useDispatch

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local function ExperienceDetailsConnectionsPlayedChip(p2)
	local layoutOrder = p2.layoutOrder
	local universeId = p2.universeId

	local v5 = useDispatch()

	local v6 = SignalsReact.useSignalState(Game.getConnectionsPlayedStore(false).getConnectionsPlayed(universeId).data)

	local v7 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)

	local v8 = not v6 and {} or v6.userIds
	local v9 = not v6 and 0 or v6.totalCount

	local v10 = useLocalization({
		connectionsPlayed = {
			"Feature.Friends.Label.FriendsPlayed",
			numberOfConnections = v9
		},
		connectionsRecentlyPlayed = {
			"Feature.Friends.Label.FriendsRecentlyPlayed",
			numberOfConnections = v9
		},
		connectionRecentlyPlayed = { "Feature.Friends.Label.FriendRecentlyPlayed" }
	})

	local v11 = React.useCallback(function()
		local rootPlaceId = v7 and v7.rootPlaceId

		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameConnectionsPlayedChipClicked(
				{
					uid = tostring(userId),
					universeId = universeId,
					placeId = tostring(rootPlaceId),
					totalConnections = v9
				},
				"ExperienceDetailsConnectionsPlayedChip"
			)
		end

		local v12 = { name = appPage.SocialProofVerticalUserListSheet, extraProps = 0 }
		local v13 = { userIds = v8, title = 0 }

		local v14 = if v9 == 1 then v10.connectionRecentlyPlayed else v10.connectionsRecentlyPlayed
		v13.title = v14
		v12.extraProps = v13

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v12))
		else
			v5(navigateDown(v12))
		end
	end, { v5, universeId, v7, v9, v10, Players.LocalPlayer })

	if v9 == 0 then
		return nil
	end

	local connectionsPlayed = v10.connectionsPlayed

	local v12 = {}

	for i = 1, math.min(2, #v8) do
		table.insert(v12, v8[i])
	end

	return React.createElement(sduiChip, {
		text = connectionsPlayed,
		leading = {
			type = "AvatarGroup",
			props = { avatars = v12, type = avatarGroupType.Stacked, max = 2 }
		},
		onActivated = v11,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsConnectionsPlayedChip)
