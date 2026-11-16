local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local PublishStatus = require(BuildExperience.Chat.PublishStatus)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local launchPlaytestWithLoadingState = require(parent.BuildExperiencePlaytestLaunch.launchPlaytestWithLoadingState)
local PrivatePlaytesters = require(parent.DataHydration.PrivatePlaytesters)
local getPrivatePlaytestersStore = PrivatePlaytesters.getPrivatePlaytestersStore
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagEnableBuildAdPromotion = require(BuildExperience.Flags.FFlagEnableBuildAdPromotion)
local FFlagBuildExperienceMenuImprovements = require(BuildExperience.Flags.FFlagBuildExperienceMenuImprovements)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local FFlagBuildExperienceDisableNonPublicStats = require(BuildExperience.Flags.FFlagBuildExperienceDisableNonPublicStats)
local PrivacyType = UniverseConfiguration.PrivacyType

local function isInApp(): boolean -- 4 equivalent calls inferred from this helper
	return game.GameId == 0
end

local function isInGame(): boolean
	return not isInApp() -- inferred equivalent call
end

local function isAssistantDisabled(_)
	return isInApp() and true or false -- inferred equivalent call
end

local function isPlaytestDisabled(data) -- 1 equivalent call inferred from this helper
	return not isInApp() or data.placeId == nil or data.isNewGameTarget and not data.hasPublishedTurn -- inferred equivalent call
end

local function isStatsDisabled(p): boolean -- 1 equivalent call inferred from this helper
	return p.shareAudience ~= PrivacyType.Public
end

local function isVersionHistoryDisabled(p): boolean -- 1 equivalent call inferred from this helper
	return p.placeId == nil
end

local function hasExistingRoster(p): boolean -- 2 equivalent calls inferred from this helper
	local fetchInvitedPlayers = getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(p.universeId)
	return fetchInvitedPlayers.status(false) == "Ready" and #fetchInvitedPlayers.players(false) > 0
end

local function isInviteToPlaytestDisabled(p): boolean
	if hasExistingRoster(p) then -- inferred equivalent call
		return false
	end

	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	return #privatePlaytestersStore.getAndFetchInvitedPlayers(p.universeId).players(false) >= privatePlaytestersStore.MAX_INVITES
end

local function omitInviteToPlaytest(clone)
	local clone2 = table.clone(clone)

	for k, v in clone2 do
		local items = {}
		local flag = false

		for _, item in v.items do
			if item.id == "invite-to-playtest" then
				flag = true
			else
				table.insert(items, item)
			end
		end

		if flag then
			clone2[k] = { items = items }
		end
	end

	return clone2
end

local function getPublishText(p)
	if PublishStatus.isPublishLatest(p.hasPublishedVersion, p.hasPublishedTurn) then
		return LocalizationStrings.BUILD_MENU_PUBLISH_LATEST
	end

	return LocalizationStrings.BUILD_MENU_PUBLISH
end

local function getShareAudience(p) -- 1 equivalent call inferred from this helper
	local data = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(p.universeId).data()
	return GameConfigurationLabels.getAudience(data)
end

local function isShareUnavailable(p): boolean -- 1 equivalent call inferred from this helper
	return p.shareAudience == nil or p.shareAudience == PrivacyType.Private
end

local function onShareActivated(p)
	if p.placeId == nil or isShareUnavailable(p) then -- inferred equivalent call
		return nil
	end

	local shareAudience = getShareAudience(p) -- inferred equivalent call

	if shareAudience == PrivacyType.FriendsOnly then
		return { type = "confirmFriendsShare", placeId = p.placeId }
	end

	if shareAudience == PrivacyType.Public then
		return { type = "share", placeId = p.placeId }
	end

	return nil
end

local function onAssistantActivated(_)
	if isInApp() then -- inferred equivalent call
		return nil
	end

	return { type = "leaveExperience" }
end

local function onPlaytestActivated(data): nil
	if isPlaytestDisabled(data) or data.placeId == nil then -- inferred equivalent call
		return nil
	end

	sendBuildExperienceEvent(
		"PLAYTEST_CLICK",
		{ universeId = data.universeId, placeId = data.placeId, conversationId = data.sessionId },
		{ context = "overflow_menu" }
	)
	launchPlaytestWithLoadingState(data.placeId, "BuildOverflowMenu", true)
	return nil
end

local function onVersionHistoryActivated(p)
	if isVersionHistoryDisabled(p) then -- inferred equivalent call
		return nil
	end

	return { type = "openVersionHistory" }
end

local v = {
	id = "get-users",
	text = LocalizationStrings.BUILD_MENU_GET_USERS,
	requiredPermission = "canAdvertise",
	isDisabled = function(p): boolean
		return p.getUsersUniverseEligible ~= true
	end,
	getTrailingText = function(p)
		if (p.getUsersFreeCreditsRemaining or 0) > 0 then
			return LocalizationStrings.BUILD_MENU_GET_USERS_FREE_TAG
		end

		return nil
	end,
	onActivated = function()
		return { type = "openGetUsers" }
	end
}

local function createBuildOverflowMenuStore()
	local v2 = {
		id = "settings",
		text = LocalizationStrings.BUILD_MENU_SETTINGS,
		requiredPermission = "canEdit",
		onActivated = function()
			return { type = "openPage", page = "settings" }
		end
	}

	local v3 = {
		id = "share",
		text = LocalizationStrings.BUILD_MENU_SHARE,
		isDisabled = 0,
		onActivated = 0
	}
	local isDisabled

	if not FFlagBuildExperiencePrivateInvites then
		isDisabled = isShareUnavailable
	end

	v3.isDisabled = isDisabled
	function v3.onActivated(p)
		if FFlagBuildExperiencePrivateInvites then
			return { type = "share" }
		end

		return onShareActivated(p)
	end

	local v4 = {
		id = "version-history",
		text = LocalizationStrings.BUILD_MENU_VERSIONS,
		isDisabled = isVersionHistoryDisabled,
		requiredPermission = "canEdit",
		onActivated = onVersionHistoryActivated
	}

	local v5 = {
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

			if hasExistingRoster(data) then -- inferred equivalent call
				return { type = "openInviteManagement" }
			end

			return { type = "openInvitePicker" }
		end
	}

	local v6 = {
		id = "stats",
		text = LocalizationStrings.BUILD_MENU_STATS,
		isDisabled = 0,
		requiredPermission = "canViewAnalytics",
		onActivated = 0
	}
	local isDisabled2

	if FFlagBuildExperienceDisableNonPublicStats then
		isDisabled2 = isStatsDisabled
	end

	v6.isDisabled = isDisabled2

	function v6.onActivated(p)
		if FFlagBuildExperienceDisableNonPublicStats and isStatsDisabled(p) then -- inferred equivalent call
			return nil
		end

		return { type = "openPage", page = "stats" }
	end

	local v7 = {
		id = "monetization",
		text = LocalizationStrings.BUILD_MENU_MONETIZATION,
		requiredPermission = "canMonetize",
		onActivated = function()
			return { type = "openPage", page = "monetization" }
		end
	}

	local v8 = nil
	local v9

	if FFlagBuildExperienceMenuImprovements then
		v9 = {
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
					v3,
					v4,
					v2
				}
			}
		}

		if FFlagBuildExperiencePrivateInvites then
			table.insert(v9[1].items, 3, v5)
		end
	else
		v9 = {
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
					v2,
					{
						id = "publish",
						text = LocalizationStrings.BUILD_MENU_PUBLISH,
						getText = getPublishText,
						requiredPermission = "canPublish",
						onActivated = function()
							return { type = "openPage", page = "publish" }
						end
					},
					v3,
					v4
				}
			}
		}

		if FFlagBuildExperiencePrivateInvites then
			table.insert(v9[2].items, 2, v5)
		end

		if FFlagBuildExperienceAnalytics then
			v8 = {
				items = { v6 }
			}

			table.insert(v9, v8)
		end
	end

	if FFlagBuildExperienceManageDevProduct and not FFlagBuildExperienceMenuImprovements then
		table.insert(v9, 1, {
			items = { v7 }
		})
	end

	local signal = Signals.createSignal(v9)

	local function useItems(data)
		local universeId

		if data == nil then
			universeId = nil
		else
			universeId = data.universeId
		end

		local v10 = React.useMemo(function()
			return Signals.createComputed(function(p)
				if not FFlagBuildExperiencePrivateInvites or universeId == nil then
					return nil
				end

				local data2 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(universeId).data(p)

				if data2 == nil then
					return nil
				end

				return data2.creatorType
			end)
		end, { universeId })
		local v11 = SignalsReact.useSignalState(v10) == "Group"

		local v12 = React.useMemo(function()
			return Signals.createComputed(function(p)
				if not FFlagBuildExperiencePrivateInvites or universeId == nil then
					return 0
				end

				local data2 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(universeId).data(p)

				if data2 == nil or data2.creatorType ~= "Group" then
					return #getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(universeId).players(p)
				end

				return 0
			end)
		end, { universeId })
		local v13 = SignalsReact.useSignalState(v12)
		local v14

		if FFlagBuildExperienceAnalytics then
			local v15 = React.useMemo(function()
				return Signals.createComputed(function(p)
					if universeId == nil then
						return nil
					end

					local data2 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(universeId).data(p)
					return GameConfigurationLabels.getAudience(data2)
				end)
			end, { universeId })

			v14 = SignalsReact.useSignalState(v15)
		else
			v14 = nil
		end

		local v15 = SignalsReact.useSignalState(signal)

		local v16 = FFlagEnableBuildAdPromotion

		if v16 then
			if data == nil or data.canOpenGetUsers ~= true then
				v16 = false
			else
				v16 = data.getUsersUserEligible == true
			end
		end

		local v17 = FFlagBuildExperiencePrivateInvites and v11

		local v18 = React.useMemo(function()
			if FFlagBuildExperienceMenuImprovements then
				local items = {}

				if
					FFlagBuildExperienceAnalytics
					and (FFlagBuildExperienceDisableNonPublicStats or v14 == PrivacyType.Public)
				then
					table.insert(items, v6)
				end

				if FFlagBuildExperienceManageDevProduct then
					table.insert(items, v7)
				end

				if v16 then
					table.insert(items, v)
				end

				if #items == 0 and not FFlagBuildExperiencePrivateInvites then
					return v15
				end

				local clone = table.clone(v15)

				if #items > 0 then
					table.insert(clone, 1, { items = items })
				end

				if v17 then
					clone = omitInviteToPlaytest(clone)
				end

				return clone
			else
				local v18 = FFlagBuildExperienceAnalytics
					and not FFlagBuildExperienceDisableNonPublicStats
					and v14 ~= PrivacyType.Public

				if not (FFlagBuildExperiencePrivateInvites or v18 or v16) then
					return v15
				end

				local clone = table.clone(v15)

				if v18 then
					local index = table.find(clone, v8)

					if index ~= nil then
						table.remove(clone, index)
					end
				end

				if v16 then
					local v19 = clone[1]

					if v19 ~= nil then
						local clone2 = table.clone(v19.items)
						table.insert(clone2, v)
						clone[1] = { items = clone2 }
					end
				end

				if v17 then
					clone = omitInviteToPlaytest(clone)
				end

				return clone
			end
		end, { v15, v13, v14, v16, v17 })

		if data == nil then
			return {}
		end

		return v18
	end

	return { getItems = signal, useItems = useItems }
end

return createBuildOverflowMenuStore
