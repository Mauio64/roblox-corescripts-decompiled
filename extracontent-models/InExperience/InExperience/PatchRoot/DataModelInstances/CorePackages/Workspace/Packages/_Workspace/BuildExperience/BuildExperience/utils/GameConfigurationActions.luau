local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local DataHydration = require(parent.DataHydration)
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local UniverseSearch = require(parent.DataHydration.UniverseSearch)
local UniverseActivation = require(parent.DataHydration.UniverseActivation)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local GetBuildExperienceRefreshStore = require(BuildExperience.Stores.GetBuildExperienceRefreshStore)
local rehydrateGameMetadata = require(BuildExperience.utils.rehydrateGameMetadata)
local FFlagBuildExperienceActionOutcomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceActionOutcomeTelemetry)

local defineFastInt = game:DefineFastInt("BuildExperienceSetAudiencesMaxRetries", 3)
local defineFastInt2 = game:DefineFastInt("BuildExperienceSetAudiencesRetryDelayMs", 3000)

local defineFastFlag = game:DefineFastFlag("BuildExperienceSecondActivateAfterSetAudiences", false)

local Debug = CreatorAgentChat.debug

local v = urlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/configure")

local v2 = urlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/experience-questionnaire")

local function saveAndPublishPlace(p)
	Debug.log("info", "GameConfigurationActions save_and_publish started", { placeId = p.placeId })

	local sessionSaveAndPublish = CreatorAgentChat.getCreatorAgentChatStore().sessionSaveAndPublish(p)
	return HttpClient.asPromise(sessionSaveAndPublish)
end

local function buildPublicAudiences(items)
	local publicAudiences = {}

	for _, item in items do
		if item ~= UniverseActivation.Audience.Public and item ~= UniverseActivation.Audience.Friends then
			table.insert(publicAudiences, item)
		end
	end

	table.insert(publicAudiences, UniverseActivation.Audience.Public)
	return publicAudiences
end

local function updateCachedAudience(p: number, audiences, isActive: boolean?)
	local privacyTypeForAudiences = UniverseConfiguration.getPrivacyTypeForAudiences(audiences)
	local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()
	universeConfigurationStore.updateConfiguration(p, {
		privacyType = privacyTypeForAudiences,
		audiences = audiences
	})

	universeConfigurationStore.updateSummary(p, {
		isActive = isActive,
		privacyType = privacyTypeForAudiences,
		audiences = audiences
	})
end

local function hasPublicAudience(audiences): boolean -- 1 equivalent call inferred from this helper
	return audiences ~= nil and table.find(audiences, UniverseActivation.Audience.Public) ~= nil
end

local function audienceFailure(cause, publishResult)
	local errorMessage

	if typeof(cause) == "table" and cause.errorMessage ~= nil then
		errorMessage = tostring(cause.errorMessage)
	else
		errorMessage = tostring(cause)
	end

	if not FFlagBuildExperienceActionOutcomeTelemetry then
		cause = nil
	end

	return {
		stage = "set_audience",
		errorMessage = errorMessage,
		publishResult = publishResult,
		cause = cause
	}
end

local function setAudiencesForPublish(universeActivationStore, universeId: number, audiences)
	local publicAudiences = buildPublicAudiences(audiences)
	return Promise.retryWithDelay(function()
		return universeActivationStore.setAudiences(universeId, publicAudiences)
	end, defineFastInt, defineFastInt2 / 1000):andThen(function(p)
		updateCachedAudience(universeId, p.audiences, true)

		if hasPublicAudience(p.audiences) then -- inferred equivalent call
			return p
		end

		Debug.log("warn", "GameConfigurationActions set audience missing Public", {
			universeId = universeId
		})

		return Promise.reject({ errorMessage = "setAudiences did not return a Public audience" })
	end)
end

local GameConfigurationActions = {}
GameConfigurationActions.PublishFailureStage = { SetAudience = "set_audience" }

function GameConfigurationActions.getCreatorHubConfigureUrl(universeId: number)
	return v({ universeId = universeId })
end

function GameConfigurationActions.getCreatorHubAnalyticsUrl(universeId: number, p: string, rangeType: string?)
	local creatorHubAnalyticsUrl = urlBuilder.fromString(`create:dashboard/creations/experiences/\{universeId}/{p}`)({
		universeId = universeId
	})

	if rangeType ~= nil then
		creatorHubAnalyticsUrl = urlBuilder.addQueryString(creatorHubAnalyticsUrl, {
			rangeType = rangeType
		})
	end

	return creatorHubAnalyticsUrl
end

function GameConfigurationActions.publishExperience(data)
	local function publishPlace() -- 1 equivalent call inferred from this helper
		return saveAndPublishPlace({
			placeId = data.placeId,
			title = data.title,
			description = data.description
		})
	end

	local v3

	if data.isActive then
		local universeActivationStore = UniverseActivation.getUniverseActivationStore()

		v3 = publishPlace():andThen(function(publishResult) -- inferred equivalent call
			return setAudiencesForPublish(universeActivationStore, data.universeId, data.audiences):andThen(function()
				return publishResult
			end, function(p)
				return Promise.reject(audienceFailure(p, publishResult))
			end)
		end)
	else
		local universeActivationStore = UniverseActivation.getUniverseActivationStore()
		Debug.log("info", "GameConfigurationActions publish activate-and-set-audience started", {
			universeId = data.universeId,
			placeId = data.placeId
		})

		local function setPublicAudience() -- 1 equivalent call inferred from this helper
			return setAudiencesForPublish(universeActivationStore, data.universeId, data.audiences):andThen(function()
				if defineFastFlag then
					return universeActivationStore.activate(data.universeId):catch(function(p)
						Debug.log("warn", "GameConfigurationActions second activate failed", {
							error = tostring(p),
							universeId = data.universeId
						})
					end)
				end

				return nil
			end)
		end

		v3 = universeActivationStore.activate(data.universeId):andThen(function()
			return publishPlace()
		end):andThen(function(publishResult)
			return setPublicAudience():andThen(function() -- inferred equivalent call
				return publishResult
			end, function(p)
				return Promise.reject(audienceFailure(p, publishResult))
			end)
		end)
	end

	return v3:finally(function()
		rehydrateGameMetadata(data.universeId)
		return v3
	end)
end

function GameConfigurationActions.getExperienceQuestionnaireUrl(universeId: number)
	return v2({ universeId = universeId })
end

GameConfigurationActions.saveAndPublishPlace = saveAndPublishPlace

function GameConfigurationActions.archiveGame(universeId: number)
	Debug.log("info", "GameConfigurationActions archive started", { universeId = universeId })

	return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(universeId, {
		isArchived = true
	}):andThen(function()
		Debug.log("info", "GameConfigurationActions archive succeeded", { universeId = universeId })

		UniverseSearch.getUniverseSearchStore().invalidateAll()
		GetBuildExperienceRefreshStore().bumpRefreshTick()
	end):catch(function(p)
		Debug.log("warn", "GameConfigurationActions archive failed", {
			error = tostring(p),
			universeId = universeId
		})

		if FFlagBuildExperienceActionOutcomeTelemetry then
			return Promise.reject(p)
		end
	end)
end

GameConfigurationActions.updateCachedAudience = updateCachedAudience

function GameConfigurationActions.updateTitleDescription(universeId: number, name: string, description: string)
	Debug.log("info", "GameConfigurationActions title and description update started", {
		universeId = universeId
	})

	return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(universeId, {
		name = name,
		description = description
	}):andThen(function(p)
		UniverseSearch.getUniverseSearchStore().updateSearchItem(universeId, {
			name = name,
			description = description
		})

		local gameInfoStore = DataHydration.Game.getGameInfoStore(false)

		if gameInfoStore.updateGameInfo == nil then
			Debug.log("warn", "GameConfigurationActions updateGameInfo unavailable", {
				universeId = universeId,
				source = "updateTitleDescription"
			})
			return p
		end

		gameInfoStore.updateGameInfo(tostring(universeId), {
			name = name,
			description = description
		})

		return p
	end)
end

return GameConfigurationActions
