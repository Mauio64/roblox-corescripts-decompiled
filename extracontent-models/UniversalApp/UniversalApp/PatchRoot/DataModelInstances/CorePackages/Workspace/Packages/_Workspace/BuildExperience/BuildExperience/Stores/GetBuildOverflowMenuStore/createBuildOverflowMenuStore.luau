local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local launchPlaytestWithLoadingState = require(BuildExperience.utils.launchPlaytestWithLoadingState)

local function isInApp() -- line: 49
	return game.GameId == 0
end
local function isInGame() -- line: 53
	return game.GameId ~= 0
end
local function isAssistantDisabled(_: {[any]: any}) -- line: 57
	return game.GameId == 0
end
local function isPlaytestDisabled(t2: {[any]: any}) -- line: 61
	return game.GameId ~= 0 or (t2.placeId == nil or t2.isNewGameTarget and not t2.hasPublishedTurn)
end
local function isArchiveDisabled(t3: {[any]: any}) -- line: 65
	return t3.placeId == nil
end
local function isVersionHistoryDisabled(t4: {[any]: any}) -- line: 69
	return t4.placeId == nil
end
local function onAssistantActivated(_: {[any]: any}) -- line: 73
	if game.GameId == 0 then
		return nil
	end

	return {
		type = "leaveExperience"
	}
end
local function onPlaytestActivated(t6: {[any]: any}) -- line: 81
	-- upvalues: launchPlaytestWithLoadingState (copy)
	if game.GameId ~= 0 or (t6.placeId == nil or t6.isNewGameTarget and not t6.hasPublishedTurn) or t6.placeId == nil then
		return nil
	end

	launchPlaytestWithLoadingState(t6.placeId, "BuildOverflowMenu", true)

	return nil
end
local function onVersionHistoryActivated(t7: {[any]: any}) -- line: 90
	if t7.placeId == nil then
		return nil
	end

	return {
		type = "openVersionHistory"
	}
end
local function createBuildOverflowMenuStore() -- line: 100
	-- upvalues: UniverseConfiguration (copy), GameConfigurationLabels (copy), isAssistantDisabled (copy), onAssistantActivated (copy), isPlaytestDisabled (copy), onPlaytestActivated (copy), isVersionHistoryDisabled (copy), onVersionHistoryActivated (copy), isArchiveDisabled (copy), Signals (copy), SignalsReact (copy)
	local t8 = {}

	local function getConfigurationData(t9: {[any]: any}) -- line: 103
		-- upvalues: t8 (copy), UniverseConfiguration (copy)
		local v32 = t8[t9.universeId]

		if v32 ~= nil then
			return v32
		end

		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(t9.universeId).data()
	end
	local function isShareDisabled(t10: {[any]: any}) -- line: 112
		-- upvalues: GameConfigurationLabels (copy), getConfigurationData (copy)
		return GameConfigurationLabels.isPrivateAudience(getConfigurationData(t10))
	end
	local function onShareActivated(t11: {[any]: any}) -- line: 116
		-- upvalues: GameConfigurationLabels (copy), getConfigurationData (copy)
		if GameConfigurationLabels.isPrivateAudience(getConfigurationData(t11)) or t11.placeId == nil then
			return nil
		end

		return {
			type = "share",
			placeId = t11.placeId
		}
	end

	local t12 = {
		{
			items = {
				{
					id = "assistant",
					text = "Assistant",
					isDisabled = isAssistantDisabled,
					onActivated = onAssistantActivated
				},
				{
					id = "playtest",
					text = "Playtest",
					isDisabled = isPlaytestDisabled,
					onActivated = onPlaytestActivated
				}
			}
		},
		{
			items = {
				{
					id = "publish",
					text = "Publish",
					onActivated = function() -- line: 149
						return {
							type = "openPage",
							page = "publish"
						}
					end
				},
				{
					id = "settings",
					text = "Settings",
					onActivated = function() -- line: 159
						return {
							type = "openPage",
							page = "settings"
						}
					end
				},
				{
					id = "version-history",
					text = "Version History",
					isDisabled = isVersionHistoryDisabled,
					onActivated = onVersionHistoryActivated
				},
				{
					id = "share",
					text = "Share",
					isDisabled = isShareDisabled,
					onActivated = onShareActivated
				}
			}
		},
		{
			items = {{
				id = "archive-game",
				text = "Archive game",
				isDisabled = isArchiveDisabled,
				onActivated = function() -- line: 186
					return {
						type = "archive"
					}
				end
			}}
		}
	}
	local v30 = Signals.createSignal(t12)

	return {
		getItems = v30,
		useItems = function(t13: {[any]: any}) -- line: 195
			-- upvalues: SignalsReact (copy), UniverseConfiguration (copy), t8 (copy), v30 (copy)
			local v36 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
			local v37 = SignalsReact.useSignalState(v36.getAndFetchConfiguration(t13.universeId).data)

			t8[t13.universeId] = v37

			return SignalsReact.useSignalState(v30)
		end
	}
end

return createBuildOverflowMenuStore
