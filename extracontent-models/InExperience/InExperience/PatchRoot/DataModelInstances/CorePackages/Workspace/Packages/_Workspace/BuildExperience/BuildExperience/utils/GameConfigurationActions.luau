local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local HttpClient = require(BuildExperienceParent.HttpClient)
local Promise = require(BuildExperienceParent.Promise)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local UniverseSearch = require(BuildExperienceParent.DataHydration.UniverseSearch)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local UrlBuilder = require(BuildExperienceParent.UrlBuilder).UrlBuilder
local GetBuildExperienceRefreshStore = require(BuildExperience.Stores.GetBuildExperienceRefreshStore)
local v12 = game:DefineFastInt("BuildExperienceSetAudiencesMaxRetries", 3)
local v13 = game:DefineFastInt("BuildExperienceSetAudiencesRetryDelayMs", 3000)
local v14 = game:DefineFastFlag("BuildExperienceSecondActivateAfterSetAudiences", false)
local debug = CreatorAgentChat.debug
local v16 = UrlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/configure")
local v17 = UrlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/experience-questionnaire")

local function saveAndPublishPlace(p1) -- line: 33
	-- upvalues: debug (copy), CreatorAgentChat (copy), HttpClient (copy)
	debug.log("info", "GameConfigurationActions save_and_publish started", {
		placeId = p1.placeId
	})

	local v22 = CreatorAgentChat.getCreatorAgentChatStore().sessionSaveAndPublish(p1)

	return HttpClient.asPromise(v22)
end

return {
	getCreatorHubConfigureUrl = function(n1: number) -- line: 25
		-- upvalues: v16 (copy)
		return v16({
			universeId = n1
		})
	end,
	publishExperience = function(t1: {[any]: any}) -- line: 93
		-- upvalues: saveAndPublishPlace (copy), UniverseActivation (copy), debug (copy), Promise (copy), v12 (copy), v13 (copy), v14 (copy), UniverseConfiguration (copy)
		if t1.isActive then
			return saveAndPublishPlace({
				placeId = t1.placeId,
				title = t1.title,
				description = t1.description
			})
		end

		local v28 = UniverseActivation.getUniverseActivationStore()

		debug.log("info", "GameConfigurationActions publish activate-and-set-audience started", {
			universeId = t1.universeId,
			placeId = t1.placeId
		})

		return v28.activate(t1.universeId):andThen(function() -- line: 116
			-- upvalues: Promise (copy), v28 (copy), t1 (copy), v12 (copy), v13 (copy)
			return Promise.retryWithDelay(function() -- line: 117
				-- upvalues: v28 (copy), t1 (copy)
				return v28.setAudiences(t1.universeId, t1.audiences)
			end, v12, v13 / 1000)
		end):andThen(function() -- line: 121
			-- upvalues: v14 (copy), v28 (copy), t1 (copy), debug (copy)
			if v14 then
				return v28.activate(t1.universeId):catch(function(p2) -- line: 123
					-- upvalues: debug (copy), t1 (copy)
					debug.log("warn", "GameConfigurationActions second activate failed", {
						error = tostring(p2),
						universeId = t1.universeId
					})
				end)
			end

			return nil
		end):andThen(function() -- line: 132
			-- upvalues: UniverseConfiguration (copy), t1 (copy), saveAndPublishPlace (copy)
			UniverseConfiguration.getUniverseConfigurationStore().updateSummary(t1.universeId, {
				isActive = true,
				privacyType = UniverseConfiguration.PrivacyType.Public,
				audiences = t1.audiences
			})

			return saveAndPublishPlace({
				placeId = t1.placeId,
				title = t1.title,
				description = t1.description
			})
		end)
	end,
	getExperienceQuestionnaireUrl = function(n2: number) -- line: 29
		-- upvalues: v17 (copy)
		return v17({
			universeId = n2
		})
	end,
	saveAndPublishPlace = saveAndPublishPlace,
	archiveGame = function(n3: number) -- line: 41
		-- upvalues: debug (copy), UniverseConfiguration (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
		debug.log("info", "GameConfigurationActions archive started", {
			universeId = n3
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n3, {
			isArchived = true
		}):andThen(function() -- line: 47
			-- upvalues: debug (copy), n3 (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
			debug.log("info", "GameConfigurationActions archive succeeded", {
				universeId = n3
			})
			UniverseSearch.getUniverseSearchStore().invalidateAll()
			GetBuildExperienceRefreshStore().bumpRefreshTick()
		end):catch(function(p3) -- line: 54
			-- upvalues: debug (copy), n3 (copy)
			debug.log("warn", "GameConfigurationActions archive failed", {
				error = tostring(p3),
				universeId = n3
			})
		end)
	end,
	updateTitleDescription = function(n4: number, s1: string, s2: string) -- line: 62
		-- upvalues: debug (copy), UniverseConfiguration (copy), UniverseSearch (copy), DataHydration (copy)
		debug.log("info", "GameConfigurationActions title and description update started", {
			universeId = n4
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n4, {
			name = s1,
			description = s2
		}):andThen(function(p4) -- line: 72
			-- upvalues: UniverseSearch (copy), n4 (copy), s1 (copy), s2 (copy), DataHydration (copy), debug (copy)
			UniverseSearch.getUniverseSearchStore().updateSearchItem(n4, {
				name = s1,
				description = s2
			})

			local v31 = DataHydration.Game.getGameInfoStore(false)

			if v31.updateGameInfo == nil then
				debug.log("warn", "GameConfigurationActions updateGameInfo unavailable", {
					source = "updateTitleDescription",
					universeId = n4
				})

				return p4
			end

			v31.updateGameInfo(tostring(n4), {
				name = s1,
				description = s2
			})

			return p4
		end)
	end
}
