local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local UniverseSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseSearch")
local UniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UrlBuilder").UrlBuilder
local GetBuildExperienceRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildExperienceRefreshStore")
local rehydrateGameMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/rehydrateGameMetadata")

local defineFastInt = game:DefineFastInt("BuildExperienceSetAudiencesMaxRetries", 3)
local defineFastInt2 = game:DefineFastInt("BuildExperienceSetAudiencesRetryDelayMs", 3000)

local defineFastFlag = game:DefineFastFlag("BuildExperienceSecondActivateAfterSetAudiences", false)

local Debug = CreatorAgentChat.debug

local v5 = urlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/configure")

local v6 = urlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/experience-questionnaire")

local function saveAndPublishPlace(p2)
	Debug.log("info", "GameConfigurationActions save_and_publish started", {
		placeId = p2.placeId
	})

	local sessionSaveAndPublish = CreatorAgentChat.getCreatorAgentChatStore().sessionSaveAndPublish(p2)
	return HttpClient.asPromise(sessionSaveAndPublish)
end

local function buildPublicAudiences(items)
	local publicAudiences = {}

	for k, item in items do
		if item ~= UniverseActivation.Audience.Public and item ~= UniverseActivation.Audience.Friends then
			table.insert(publicAudiences, item)
		end
	end

	table.insert(publicAudiences, UniverseActivation.Audience.Public)
	return publicAudiences
end

local function updateCachedAudience(p2, audiences, p3)
	local privacyTypeForAudiences = UniverseConfiguration.getPrivacyTypeForAudiences(audiences)
	local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()
	universeConfigurationStore.updateConfiguration(p2, {
		privacyType = privacyTypeForAudiences,
		audiences = audiences
	})

	universeConfigurationStore.updateSummary(p2, {
		isActive = p3,
		privacyType = privacyTypeForAudiences,
		audiences = audiences
	})
end

local function hasPublicAudience(list): boolean
	return list ~= nil and table.find(list, UniverseActivation.Audience.Public) ~= nil
end

local function audienceFailure(p2, publishResult)
	local v8 = if typeof(p2) == "table" and p2.errorMessage ~= nil then tostring(p2.errorMessage) else tostring(p2)
	return { stage = "set_audience", errorMessage = v8, publishResult = publishResult }
end

local function setAudiencesForPublish(universeActivationStore, universeId, audiences)
	local publicAudiences = buildPublicAudiences(audiences)
	return Promise.retryWithDelay(function()
		return universeActivationStore.setAudiences(universeId, publicAudiences)
	end, defineFastInt, defineFastInt2 / 1000):andThen(function(p2)
		updateCachedAudience(universeId, p2.audiences, true)
		local audiences2 = p2.audiences
		local v7 = not (audiences2 == nil) and table.find(audiences2, UniverseActivation.Audience.Public) ~= nil

		if v7 then
			return p2
		end

		Debug.log("warn", "GameConfigurationActions set audience missing Public", {
			universeId = universeId
		})

		return Promise.reject({
			errorMessage = "setAudiences did not return a Public audience"
		})
	end)
end

return {
	PublishFailureStage = { SetAudience = "set_audience" },
	getCreatorHubConfigureUrl = function(p2)
		return v5({ universeId = p2 })
	end,
	getCreatorHubAnalyticsUrl = function(p2, p3, p4)
		local creatorHubAnalyticsUrl = urlBuilder.fromString(`create:dashboard/creations/experiences/\{universeId}/{p3}`)({
			universeId = p2
		})

		if p4 ~= nil then
			creatorHubAnalyticsUrl = urlBuilder.addQueryString(creatorHubAnalyticsUrl, {
				rangeType = p4
			})
		end

		return creatorHubAnalyticsUrl
	end,
	publishExperience = function(data)
		local function publishPlace()
			return saveAndPublishPlace({
				placeId = data.placeId,
				title = data.title,
				description = data.description
			})
		end

		local v7

		if data.isActive then
			local universeActivationStore = UniverseActivation.getUniverseActivationStore()
			v7 = saveAndPublishPlace({
				placeId = data.placeId,
				title = data.title,
				description = data.description
			}):andThen(function(p2)
				return setAudiencesForPublish(universeActivationStore, data.universeId, data.audiences):andThen(
					function()
						return p2
					end,
					function(p3)
						local reject = Promise.reject
						local v10 = if typeof(p3) == "table" and p3.errorMessage ~= nil then tostring(p3.errorMessage) else tostring(p3)
						return reject({
							stage = "set_audience",
							errorMessage = v10,
							publishResult = p2
						})
					end
				)
			end)
		else
			local universeActivationStore = UniverseActivation.getUniverseActivationStore()
			Debug.log("info", "GameConfigurationActions publish activate-and-set-audience started", {
				universeId = data.universeId,
				placeId = data.placeId
			})

			local function setPublicAudience()
				return setAudiencesForPublish(universeActivationStore, data.universeId, data.audiences):andThen(function()
					if defineFastFlag then
						return universeActivationStore.activate(data.universeId):catch(function(p2)
							Debug.log("warn", "GameConfigurationActions second activate failed", {
								error = tostring(p2),
								universeId = data.universeId
							})
						end)
					end

					return nil
				end)
			end

			v7 = universeActivationStore.activate(data.universeId):andThen(function()
				return publishPlace()
			end):andThen(function(p2)
				return setAudiencesForPublish(universeActivationStore, data.universeId, data.audiences):andThen(function()
					if defineFastFlag then
						return universeActivationStore.activate(data.universeId):catch(function(p3)
							Debug.log("warn", "GameConfigurationActions second activate failed", {
								error = tostring(p3),
								universeId = data.universeId
							})
						end)
					end

					return nil
				end):andThen(
					function()
						return p2
					end,
					function(p3)
						local reject = Promise.reject
						local v10 = if typeof(p3) == "table" and p3.errorMessage ~= nil then tostring(p3.errorMessage) else tostring(p3)
						return reject({
							stage = "set_audience",
							errorMessage = v10,
							publishResult = p2
						})
					end
				)
			end)
		end

		return v7:finally(function()
			rehydrateGameMetadata(data.universeId)
			return v7
		end)
	end,
	getExperienceQuestionnaireUrl = function(p2)
		return v6({ universeId = p2 })
	end,
	saveAndPublishPlace = saveAndPublishPlace,
	archiveGame = function(p2)
		Debug.log("info", "GameConfigurationActions archive started", {
			universeId = p2
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(p2, {
			isArchived = true
		}):andThen(function()
			Debug.log("info", "GameConfigurationActions archive succeeded", {
				universeId = p2
			})

			UniverseSearch.getUniverseSearchStore().invalidateAll()
			GetBuildExperienceRefreshStore().bumpRefreshTick()
		end):catch(function(p3)
			Debug.log("warn", "GameConfigurationActions archive failed", {
				error = tostring(p3),
				universeId = p2
			})
		end)
	end,
	updateCachedAudience = updateCachedAudience,
	updateTitleDescription = function(p2, p3, p4)
		Debug.log("info", "GameConfigurationActions title and description update started", {
			universeId = p2
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(p2, {
			name = p3,
			description = p4
		}):andThen(function(p5)
			UniverseSearch.getUniverseSearchStore().updateSearchItem(p2, {
				name = p3,
				description = p4
			})

			local gameInfoStore = DataHydration.Game.getGameInfoStore(false)

			if gameInfoStore.updateGameInfo == nil then
				Debug.log("warn", "GameConfigurationActions updateGameInfo unavailable", {
					universeId = p2,
					source = "updateTitleDescription"
				})
				return p5
			end

			gameInfoStore.updateGameInfo(tostring(p2), { name = p3, description = p4 })

			return p5
		end)
	end
}
