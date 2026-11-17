local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Players = game:GetService("Players")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameConnectionsPlayedChipClicked = DiscoveryAnalytics.Events.gameConnectionsPlayedChipClicked

local SduiSharedContent = require(parent.SduiSharedContent)
local SduiTextAccessoryRow = SduiSharedContent.SduiTextAccessoryRow

local AvatarGroupType = Foundation.Enums.AvatarGroupType
local InputSize = Foundation.Enums.InputSize
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Game = DataHydration.Game
local useTokens = Foundation.Hooks.useTokens

local useLocalization = Localization.Hooks.useLocalization
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType
local RobloxAppEnums2 = require(parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums2.DeviceType
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown

local SharedFlags = require(parent.SharedFlags)

local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function ExperienceDetailsConnectionsPlayedTextRow(props)
	local layoutOrder = props.layoutOrder
	local universeId = props.universeId
	local name = props.name

	local v = useTokens()
	local v2 = useDispatch()
	local v3 = useDeviceType() == DeviceType.Phone

	local connectionsPlayedStore = Game.getConnectionsPlayedStore(false)
	local v4 = SignalsReact.useSignalState(connectionsPlayedStore.getConnectionsPlayed(universeId).data)
	local v5 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)

	local userIds = not v4 and {} or v4.userIds
	local v6

	if v4 then
		v6 = v4.totalCount
	else
		v6 = #userIds
	end

	local v7 = useLocalization({
		connectionsRecentlyPlayed = {
			"Feature.Friends.Label.FriendsRecentlyPlayed",
			numberOfConnections = v6
		},
		connectionRecentlyPlayed = { "Feature.Friends.Label.FriendRecentlyPlayed" },
		playedByUserAndOthersPlural = {
			"Feature.Friends.Label.PlayedByUserAndOthers.FriendsRename",
			name = name or "",
			numOfOthers = v6 - 1
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
	local text

	if name and name ~= "" then
		if v6 == 1 then
			text = v7.playedByUser
		elseif v6 == 2 then
			text = v7.playedByUserAndOneOther
		else
			text = v7.playedByUserAndOthersPlural
		end
	elseif v6 == 1 then
		text = v7.connectionRecentlyPlayed
	else
		text = v7.connectionsRecentlyPlayed
	end

	local rootPlaceId = v5 and v5.rootPlaceId

	local onActivated = React.useCallback(function()
		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameConnectionsPlayedChipClicked(
				{
					uid = tostring(userId),
					universeId = universeId,
					placeId = tostring(rootPlaceId),
					totalConnections = v6
				},
				"ExperienceDetailsConnectionsPlayedChip"
			)
		end

		local v8 = { name = AppPage.SocialProofVerticalUserListSheet, extraProps = 0 }
		local extraProps = { userIds = userIds, title = 0 }
		local title

		if v6 == 1 then
			title = v7.connectionRecentlyPlayed
		else
			title = v7.connectionsRecentlyPlayed
		end

		extraProps.title = title
		v8.extraProps = extraProps

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v8))
		else
			v2(NavigateDown(v8))
		end
	end, { v2, universeId, rootPlaceId, userIds, v6, v7, Players.LocalPlayer })

	local avatars = React.useMemo(function()
		return { table.unpack(userIds, 1, (math.min(2, #userIds))) }
	end, { userIds })
	local backplateStyle

	if v3 then
		backplateStyle = v.Color.Surface.Surface_100
	else
		backplateStyle = v.Color.Surface.Surface_0
	end

	local leading = React.useMemo(function()
		return {
			type = "AvatarGroup",
			avatars = avatars,
			groupType = AvatarGroupType.Stacked,
			max = 2,
			size = InputSize.XSmall,
			backplateStyle = backplateStyle
		}
	end, { avatars, backplateStyle })

	local fontStyle = React.useMemo(function()
		return { FontSize = v.FontSize.FontSize_300 }
	end, { v })

	if v6 == 0 then
		return nil
	end

	return React.createElement(SduiTextAccessoryRow, {
		text = text,
		leading = leading,
		gap = v.Gap.Small,
		fontStyle = fontStyle,
		onActivated = onActivated,
		layoutOrder = layoutOrder,
		testId = "--experience-details-connections-played-text-row"
	})
end

return React.memo(ExperienceDetailsConnectionsPlayedTextRow)
