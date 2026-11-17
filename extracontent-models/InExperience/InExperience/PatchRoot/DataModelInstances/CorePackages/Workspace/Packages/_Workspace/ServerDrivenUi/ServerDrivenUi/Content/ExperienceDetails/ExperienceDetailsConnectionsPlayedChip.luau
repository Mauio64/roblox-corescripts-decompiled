local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Players = game:GetService("Players")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game

local SduiSharedContent = require(parent.SduiSharedContent)
local SduiChip = SduiSharedContent.SduiChip

local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameConnectionsPlayedChipClicked = DiscoveryAnalytics.Events.gameConnectionsPlayedChipClicked

local AvatarGroupType = Foundation.Enums.AvatarGroupType

local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function ExperienceDetailsConnectionsPlayedChip(p)
	local layoutOrder = p.layoutOrder
	local universeId = p.universeId

	local v = useDispatch()

	local v2 = SignalsReact.useSignalState(Game.getConnectionsPlayedStore(false).getConnectionsPlayed(universeId).data)

	local v3 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)

	local userIds = not v2 and {} or v2.userIds
	local v4 = not v2 and 0 or v2.totalCount

	local v5 = useLocalization({
		connectionsPlayed = {
			"Feature.Friends.Label.FriendsPlayed",
			numberOfConnections = v4
		},
		connectionsRecentlyPlayed = {
			"Feature.Friends.Label.FriendsRecentlyPlayed",
			numberOfConnections = v4
		},
		connectionRecentlyPlayed = { "Feature.Friends.Label.FriendRecentlyPlayed" }
	})

	local onActivated = React.useCallback(function()
		local rootPlaceId = v3 and v3.rootPlaceId

		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameConnectionsPlayedChipClicked(
				{
					uid = tostring(userId),
					universeId = universeId,
					placeId = tostring(rootPlaceId),
					totalConnections = v4
				},
				"ExperienceDetailsConnectionsPlayedChip"
			)
		end

		local v6 = { name = AppPage.SocialProofVerticalUserListSheet, extraProps = 0 }
		local extraProps = { userIds = userIds, title = 0 }
		local title

		if v4 == 1 then
			title = v5.connectionRecentlyPlayed
		else
			title = v5.connectionsRecentlyPlayed
		end

		extraProps.title = title
		v6.extraProps = extraProps

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v(NavigateDown(v6))
		end
	end, { v, universeId, v3, v4, v5, Players.LocalPlayer })

	if v4 == 0 then
		return nil
	end

	local connectionsPlayed = v5.connectionsPlayed

	local avatars = {}

	for i = 1, math.min(2, #userIds) do
		table.insert(avatars, userIds[i])
	end

	return React.createElement(SduiChip, {
		text = connectionsPlayed,
		leading = {
			type = "AvatarGroup",
			props = { avatars = avatars, type = AvatarGroupType.Stacked, max = 2 }
		},
		onActivated = onActivated,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsConnectionsPlayedChip)
