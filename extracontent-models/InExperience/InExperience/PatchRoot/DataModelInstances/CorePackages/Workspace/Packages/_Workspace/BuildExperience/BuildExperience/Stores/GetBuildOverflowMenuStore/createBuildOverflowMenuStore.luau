local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local PublishStatus = require(BuildExperience.Chat.PublishStatus)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local launchPlaytestWithLoadingState = require(BuildExperience.utils.launchPlaytestWithLoadingState)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local PrivacyType = UniverseConfiguration.PrivacyType

local function isInApp() -- line: 59
	return game.GameId == 0
end
local function isInGame() -- line: 63
	return game.GameId ~= 0
end
local function isAssistantDisabled(_: {[any]: any}) -- line: 67
	return game.GameId == 0
end
local function isPlaytestDisabled(t2: {[any]: any}) -- line: 71
	return game.GameId ~= 0 or (t2.placeId == nil or t2.isNewGameTarget and not t2.hasPublishedTurn)
end
local function isArchiveDisabled(t3: {[any]: any}) -- line: 75
	return t3.placeId == nil
end
local function isVersionHistoryDisabled(t4: {[any]: any}) -- line: 79
	return t4.placeId == nil
end
local function getPublishText(t5: {[any]: any}) -- line: 83
	-- upvalues: PublishStatus (copy), LocalizationStrings (copy)
	if PublishStatus.isPublishLatest(t5.hasPublishedVersion, t5.hasPublishedTurn) then
		return LocalizationStrings.BUILD_MENU_PUBLISH_LATEST
	end

	return LocalizationStrings.BUILD_MENU_PUBLISH
end
local function onAssistantActivated(_: {[any]: any}) -- line: 89
	if game.GameId == 0 then
		return nil
	end

	return {
		type = "leaveExperience"
	}
end
local function onPlaytestActivated(t7: {[any]: any}) -- line: 97
	-- upvalues: sendBuildExperienceEvent (copy), launchPlaytestWithLoadingState (copy)
	if game.GameId ~= 0 or (t7.placeId == nil or t7.isNewGameTarget and not t7.hasPublishedTurn) or t7.placeId == nil then
		return nil
	end

	sendBuildExperienceEvent("PLAYTEST_CLICK", {
		universeId = t7.universeId,
		placeId = t7.placeId,
		conversationId = t7.sessionId
	}, {
		context = "overflow_menu"
	})
	launchPlaytestWithLoadingState(t7.placeId, "BuildOverflowMenu", true)

	return nil
end
local function onVersionHistoryActivated(t8: {[any]: any}) -- line: 111
	if t8.placeId == nil then
		return nil
	end

	return {
		type = "openVersionHistory"
	}
end
local function createBuildOverflowMenuStore() -- line: 121
	-- upvalues: Signals (copy), UniverseConfiguration (copy), GameConfigurationLabels (copy), PrivacyType (copy), LocalizationStrings (copy), isAssistantDisabled (copy), onAssistantActivated (copy), isPlaytestDisabled (copy), onPlaytestActivated (copy), getPublishText (copy), isVersionHistoryDisabled (copy), onVersionHistoryActivated (copy), isArchiveDisabled (copy), SignalsReact (copy)
	local t9 = {}
	local v32 = Signals.createSignal(nil)

	local function getConfigurationData(t10: {[any]: any}) -- line: 125
		-- upvalues: t9 (copy), UniverseConfiguration (copy)
		local v38 = t9[t10.universeId]

		if v38 ~= nil then
			return v38
		end

		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(t10.universeId).data()
	end
	local function onShareActivated(t11: {[any]: any}) -- line: 134
		-- upvalues: GameConfigurationLabels (copy), getConfigurationData (copy), PrivacyType (copy)
		if t11.placeId == nil then
			return nil
		end

		local v40 = GameConfigurationLabels.getAudience(getConfigurationData(t11))

		if v40 == PrivacyType.Private then
			return {
				type = "showPrivateShareTooltip"
			}
		end

		if v40 == PrivacyType.FriendsOnly then
			return {
				type = "confirmFriendsShare",
				placeId = t11.placeId
			}
		end

		if v40 == PrivacyType.Public then
			return {
				type = "share",
				placeId = t11.placeId
			}
		end

		return nil
	end

	local t12 = {
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
					onActivated = onPlaytestActivated
				}
			}
		},
		{
			items = {
				{
					id = "publish",
					text = LocalizationStrings.BUILD_MENU_PUBLISH,
					getText = getPublishText,
					onActivated = function() -- line: 180
						return {
							type = "openPage",
							page = "publish"
						}
					end
				},
				{
					id = "settings",
					text = LocalizationStrings.BUILD_MENU_SETTINGS,
					onActivated = function() -- line: 190
						return {
							type = "openPage",
							page = "settings"
						}
					end
				},
				{
					id = "version-history",
					text = LocalizationStrings.BUILD_MENU_VERSION_HISTORY,
					isDisabled = isVersionHistoryDisabled,
					onActivated = onVersionHistoryActivated
				},
				{
					id = "share",
					text = LocalizationStrings.BUILD_MENU_SHARE,
					onActivated = onShareActivated
				}
			}
		},
		{
			items = {{
				id = "archive-game",
				text = LocalizationStrings.BUILD_MENU_ARCHIVE_GAME,
				isDisabled = isArchiveDisabled,
				onActivated = function() -- line: 216
					return {
						type = "archive"
					}
				end
			}}
		}
	}
	local v36 = Signals.createSignal(t12)

	return {
		getItems = v36,
		useItems = function(t13: {[any]: any}?) -- line: 225
			-- upvalues: SignalsReact (copy), UniverseConfiguration (copy), v32 (copy), t9 (copy), v36 (copy)
			local v42 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
			local v43 = if t13 == nil then v32 else v42.getAndFetchConfiguration(t13.universeId).data
			local v44 = SignalsReact.useSignalState(v43)

			if t13 ~= nil then
				t9[t13.universeId] = v44
			end

			local v45 = SignalsReact.useSignalState(v36)

			if t13 == nil then
				return {}
			end

			return v45
		end
	}
end

return createBuildOverflowMenuStore
