local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local PublishStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/PublishStatus")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local GameConfigurationLabels = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationLabels")
local launchPlaytestWithLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/launchPlaytestWithLoadingState")
local getPrivatePlaytestersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PrivatePlaytesters").getPrivatePlaytestersStore
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local FFlagBuildExperiencePrivateInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePrivateInvites")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local FFlagEnableBuildAdPromotion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnableBuildAdPromotion")
local FFlagBuildExperienceMenuImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMenuImprovements")
local fFlagBuildExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceAnalytics
local FFlagBuildExperienceDisableNonPublicStats = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDisableNonPublicStats")
local privacyType = UniverseConfiguration.PrivacyType

local function isInApp(): boolean
	return game.GameId == 0
end

local function isInGame(): boolean
	return game.GameId ~= 0
end

local function isAssistantDisabled(p2): boolean
	return game.GameId == 0 or false
end

local function isPlaytestDisabled(data)
	return game.GameId ~= 0 or data.placeId == nil or data.isNewGameTarget and not data.hasPublishedTurn
end

local function isStatsDisabled(p2): boolean
	return p2.shareAudience ~= privacyType.Public
end

local function isVersionHistoryDisabled(p2): boolean
	return p2.placeId == nil
end

local function hasExistingRoster(p2): boolean
	local fetchInvitedPlayers = getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(p2.universeId)
	return fetchInvitedPlayers.status(false) == "Ready" and #fetchInvitedPlayers.players(false) > 0
end

local function isInviteToPlaytestDisabled(p2): boolean
	local fetchInvitedPlayers = getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(p2.universeId)
	local v5 = fetchInvitedPlayers.status(false) == "Ready" and #fetchInvitedPlayers.players(false) > 0

	if v5 then
		return false
	end

	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	return #privatePlaytestersStore.getAndFetchInvitedPlayers(p2.universeId).players(false) >= privatePlaytestersStore.MAX_INVITES
end

local function omitInviteToPlaytest(clone)
	local clone2 = table.clone(clone)

	for k, v5 in clone2 do
		local v6 = {}
		local flag = false

		for k2, item in v5.items do
			if item.id == "invite-to-playtest" then
				flag = true
			else
				table.insert(v6, item)
			end
		end

		if flag then
			clone2[k] = { items = v6 }
		end
	end

	return clone2
end

local function getPublishText(p2)
	if PublishStatus.isPublishLatest(p2.hasPublishedVersion, p2.hasPublishedTurn) then
		return LocalizationStrings.BUILD_MENU_PUBLISH_LATEST
	end

	return LocalizationStrings.BUILD_MENU_PUBLISH
end

local function getShareAudience(p2)
	local data = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(p2.universeId).data()
	return GameConfigurationLabels.getAudience(data)
end

local function isShareUnavailable(p2): boolean
	return p2.shareAudience == nil or p2.shareAudience == privacyType.Private
end

local function onShareActivated(data)
	if data.placeId == nil or (data.shareAudience == nil or data.shareAudience == privacyType.Private) then
		return nil
	end

	local data2 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(data.universeId).data()
	local audience = GameConfigurationLabels.getAudience(data2)

	if audience == privacyType.FriendsOnly then
		return { type = "confirmFriendsShare", placeId = data.placeId }
	end

	if audience == privacyType.Public then
		return { type = "share", placeId = data.placeId }
	end

	return nil
end

local function onAssistantActivated(p2)
	if game.GameId == 0 then
		return nil
	end

	return { type = "leaveExperience" }
end

local function onPlaytestActivated(data): nil
	if
		game.GameId ~= 0
		or data.placeId == nil
		or data.isNewGameTarget and not data.hasPublishedTurn
		or data.placeId == nil
	then
		return nil
	end

	sendBuildExperienceEvent(
		"PLAYTEST_CLICK",
		{
			universeId = data.universeId,
			placeId = data.placeId,
			conversationId = data.sessionId
		},
		{ context = "overflow_menu" }
	)
	launchPlaytestWithLoadingState(data.placeId, "BuildOverflowMenu", true)
	return nil
end

local function onVersionHistoryActivated(p2)
	if p2.placeId == nil then
		return nil
	end

	return { type = "openVersionHistory" }
end

local v5 = {
	id = "get-users",
	text = LocalizationStrings.BUILD_MENU_GET_USERS,
	requiredPermission = "canAdvertise",
	isDisabled = function(p2): boolean
		return p2.getUsersUniverseEligible ~= true
	end,
	getTrailingText = function(p2)
		if (p2.getUsersFreeCreditsRemaining or 0) > 0 then
			return LocalizationStrings.BUILD_MENU_GET_USERS_FREE_TAG
		end

		return nil
	end,
	onActivated = function()
		return { type = "openGetUsers" }
	end
}

local function createBuildOverflowMenuStore()
	local v6 = {
		id = "settings",
		text = LocalizationStrings.BUILD_MENU_SETTINGS,
		requiredPermission = "canEdit",
		onActivated = function()
			return { type = "openPage", page = "settings" }
		end
	}

	local v7 = {
		id = "share",
		text = LocalizationStrings.BUILD_MENU_SHARE,
		isDisabled = if not FFlagBuildExperiencePrivateInvites then isShareUnavailable else nil,
		onActivated = function(p2)
			if FFlagBuildExperiencePrivateInvites then
				return { type = "share" }
			end

			return onShareActivated(p2)
		end
	}

	local v9 = {
		id = "version-history",
		text = LocalizationStrings.BUILD_MENU_VERSIONS,
		isDisabled = isVersionHistoryDisabled,
		requiredPermission = "canEdit",
		onActivated = onVersionHistoryActivated
	}

	local v10 = {
		id = "invite-to-playtest",
		text = LocalizationStrings.BUILD_MENU_INVITE_TO_PLAYTEST,
		isDisabled = isInviteToPlaytestDisabled,
		requiredPermission = "canEdit",
		onActivated = function(data)
			sendBuildExperienceEvent(
				"ADD_TO_PLAYTEST_CLICK",
				{
					universeId = data.universeId,
					placeId = data.placeId,
					conversationId = data.sessionId
				},
				{ source = "overflow_menu" }
			)
			local fetchInvitedPlayers = getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(data.universeId)
			local v11 = fetchInvitedPlayers.status(false) == "Ready"
				and #fetchInvitedPlayers.players(false) > 0

			if v11 then
				return { type = "openInviteManagement" }
			end

			return { type = "openInvitePicker" }
		end
	}

	local v11 = {
		id = "stats",
		text = LocalizationStrings.BUILD_MENU_STATS,
		isDisabled = if FFlagBuildExperienceDisableNonPublicStats then isStatsDisabled else nil,
		requiredPermission = "canViewAnalytics",
		onActivated = function(p2)
			if FFlagBuildExperienceDisableNonPublicStats and p2.shareAudience ~= privacyType.Public then
				return nil
			end

			return { type = "openPage", page = "stats" }
		end
	}

	local v13 = {
		id = "monetization",
		text = LocalizationStrings.BUILD_MENU_MONETIZATION,
		requiredPermission = "canMonetize",
		onActivated = function()
			return { type = "openPage", page = "monetization" }
		end
	}

	local v14 = nil
	local v15

	if FFlagBuildExperienceMenuImprovements then
		v15 = {
			{
				items = {
					{
						id = "publish",
						text = LocalizationStrings.BUILD_MENU_PUBLISH,
						requiredPermission = "canPublish",
						onActivated = function()
							return { type = "openPage", page = "publish" }
						end
					},
					v7,
					v9,
					v6
				}
			}
		}

		if FFlagBuildExperiencePrivateInvites then
			table.insert(v15[1].items, 3, v10)
		end
	else
		v15 = {
			{
				items = {
					{
						id = "assistant",
						text = LocalizationStrings.BUILD_MENU_BACK_TO_BUILD,
						isDisabled = isAssistantDisabled,
						onActivated = onAssistantActivated
					},
					{
						id = "playtest",
						text = LocalizationStrings.BUILD_MENU_PLAYTEST,
						isDisabled = isPlaytestDisabled,
						requiredPermission = "canEdit",
						onActivated = onPlaytestActivated
					}
				}
			},
			{
				items = {
					v6,
					{
						id = "publish",
						text = LocalizationStrings.BUILD_MENU_PUBLISH,
						getText = getPublishText,
						requiredPermission = "canPublish",
						onActivated = function()
							return { type = "openPage", page = "publish" }
						end
					},
					v7,
					v9
				}
			}
		}

		if FFlagBuildExperiencePrivateInvites then
			table.insert(v15[2].items, 2, v10)
		end

		if fFlagBuildExperienceAnalytics then
			v14 = {
				items = { v11 }
			}

			table.insert(v15, v14)
		end
	end

	if FFlagBuildExperienceManageDevProduct and not FFlagBuildExperienceMenuImprovements then
		table.insert(v15, 1, {
			items = { v13 }
		})
	end

	local signal = Signals.createSignal(v15)

	local function useItems(data)
		local universeId = if data ~= nil then data.universeId else nil
		local v16 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				if not FFlagBuildExperiencePrivateInvites or universeId == nil then
					return nil
				end

				local data2 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(universeId).data(p2)

				if data2 == nil then
					return nil
				end

				return data2.creatorType
			end)
		end, { universeId })
		local v17 = SignalsReact.useSignalState(v16) == "Group"

		local v18 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				if not FFlagBuildExperiencePrivateInvites or universeId == nil then
					return 0
				end

				local data2 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(universeId).data(p2)

				if data2 == nil or data2.creatorType ~= "Group" then
					return #getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(universeId).players(p2)
				end

				return 0
			end)
		end, { universeId })
		local v19 = SignalsReact.useSignalState(v18)
		local v20

		if fFlagBuildExperienceAnalytics then
			local v21 = React.useMemo(function()
				return Signals.createComputed(function(p2)
					if universeId == nil then
						return nil
					end

					local data2 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(universeId).data(p2)
					return GameConfigurationLabels.getAudience(data2)
				end)
			end, { universeId })

			v20 = SignalsReact.useSignalState(v21)
		else
			v20 = nil
		end

		local v21 = SignalsReact.useSignalState(signal)

		local v22 = FFlagEnableBuildAdPromotion

		if v22 then
			v22 = not (data == nil or data.canOpenGetUsers ~= true) and data.getUsersUserEligible == true
		end

		local v23 = FFlagBuildExperiencePrivateInvites and v17

		local v24 = React.useMemo(function()
			if FFlagBuildExperienceMenuImprovements then
				local v25 = {}

				if fFlagBuildExperienceAnalytics and (FFlagBuildExperienceDisableNonPublicStats or v20 == privacyType.Public) then
					table.insert(v25, v11)
				end

				if FFlagBuildExperienceManageDevProduct then
					table.insert(v25, v13)
				end

				if v22 then
					table.insert(v25, v5)
				end

				if #v25 == 0 and not FFlagBuildExperiencePrivateInvites then
					return v21
				end

				local clone = table.clone(v21)

				if #v25 > 0 then
					table.insert(clone, 1, { items = v25 })
				end

				if v23 then
					clone = omitInviteToPlaytest(clone)
				end

				return clone
			else
				local v25 = fFlagBuildExperienceAnalytics and not FFlagBuildExperienceDisableNonPublicStats and v20 ~= privacyType.Public

				if not (FFlagBuildExperiencePrivateInvites or v25 or v22) then
					return v21
				end

				local clone = table.clone(v21)

				if v25 then
					local index = table.find(clone, v14)

					if index ~= nil then
						table.remove(clone, index)
					end
				end

				if v22 then
					local v26 = clone[1]

					if v26 ~= nil then
						local clone2 = table.clone(v26.items)
						table.insert(clone2, v5)
						clone[1] = { items = clone2 }
					end
				end

				if v23 then
					clone = omitInviteToPlaytest(clone)
				end

				return clone
			end
		end, { v21, v19, v20, v22, v23 })

		if data == nil then
			return {}
		end

		return v24
	end

	return { getItems = signal, useItems = useItems }
end

return createBuildOverflowMenuStore
