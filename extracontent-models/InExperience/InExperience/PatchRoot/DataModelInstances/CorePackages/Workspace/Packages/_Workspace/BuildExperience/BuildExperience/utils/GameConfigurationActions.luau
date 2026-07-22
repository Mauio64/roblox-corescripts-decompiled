local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local HttpClient = require(BuildExperienceParent.HttpClient)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local UniverseSearch = require(BuildExperienceParent.DataHydration.UniverseSearch)
local GetBuildExperienceRefreshStore = require(BuildExperience.Stores.GetBuildExperienceRefreshStore)
local debug = CreatorAgentChat.debug

return {
	getCreatorHubConfigureUrl = function(n1: number) -- line: 13
		return `https://create.roblox.com/dashboard/creations/experiences/{ n1 }/configure`
	end,
	getExperienceQuestionnaireUrl = function(n2: number) -- line: 17
		return `https://create.roblox.com/dashboard/creations/experiences/{ n2 }/experience-questionnaire`
	end,
	saveAndPublishPlace = function(p1) -- line: 21
		-- upvalues: debug (copy), CreatorAgentChat (copy), HttpClient (copy)
		debug.log("info", "GameConfigurationActions save_and_publish started", {
			placeId = p1.placeId
		})

		local v13 = CreatorAgentChat.getCreatorAgentChatStore().sessionSaveAndPublish(p1)

		return HttpClient.asPromise(v13)
	end,
	archiveGame = function(n3: number) -- line: 29
		-- upvalues: debug (copy), UniverseConfiguration (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
		debug.log("info", "GameConfigurationActions archive started", {
			universeId = n3
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n3, {
			isArchived = true
		}):andThen(function() -- line: 35
			-- upvalues: debug (copy), n3 (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
			debug.log("info", "GameConfigurationActions archive succeeded", {
				universeId = n3
			})
			UniverseSearch.getUniverseSearchStore().invalidateAll()
			GetBuildExperienceRefreshStore().bumpRefreshTick()
		end):catch(function(p2) -- line: 42
			-- upvalues: debug (copy), n3 (copy)
			debug.log("warn", "GameConfigurationActions archive failed", {
				error = tostring(p2),
				universeId = n3
			})
		end)
	end,
	updateTitleDescription = function(n4: number, s1: string, s2: string) -- line: 50
		-- upvalues: debug (copy), UniverseConfiguration (copy), UniverseSearch (copy), DataHydration (copy)
		debug.log("info", "GameConfigurationActions title and description update started", {
			universeId = n4
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n4, {
			name = s1,
			description = s2
		}):andThen(function(p3) -- line: 60
			-- upvalues: UniverseSearch (copy), n4 (copy), s1 (copy), s2 (copy), DataHydration (copy), debug (copy)
			UniverseSearch.getUniverseSearchStore().updateSearchItem(n4, {
				name = s1,
				description = s2
			})

			local v20 = DataHydration.Game.getGameInfoStore(false)

			if v20.updateGameInfo == nil then
				debug.log("warn", "GameConfigurationActions updateGameInfo unavailable", {
					source = "updateTitleDescription",
					universeId = n4
				})

				return p3
			end

			v20.updateGameInfo(tostring(n4), {
				name = s1,
				description = s2
			})

			return p3
		end)
	end
}
