local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Logger = require(BuildExperienceParent.Loggers).Logger
local DataHydration = require(BuildExperienceParent.DataHydration)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
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
	archiveGame = function(n3: number) -- line: 21
		-- upvalues: Logger (copy), UniverseConfiguration (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
		Logger:info("GameConfigurationActions: archiving universe {}", n3)

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n3, {
			isArchived = true
		}):andThen(function() -- line: 25
			-- upvalues: Logger (copy), n3 (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
			Logger:info("GameConfigurationActions: archived universe {}", n3)
			UniverseSearch.getUniverseSearchStore().invalidateAll()
			GetBuildExperienceRefreshStore().bumpRefreshTick()
		end):catch(function(p1) -- line: 30
			-- upvalues: Logger (copy), n3 (copy)
			Logger:warning("GameConfigurationActions: failed to archive universe {}: {}", n3, (tostring(p1)))
		end)
	end,
	updateTitleDescription = function(n4: number, s1: string, s2: string) -- line: 35
		-- upvalues: Logger (copy), UniverseConfiguration (copy), UniverseSearch (copy), DataHydration (copy), debug (copy)
		Logger:info("GameConfigurationActions: updating title and description for universe {}", n4)

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n4, {
			name = s1,
			description = s2
		}):andThen(function(p2) -- line: 43
			-- upvalues: UniverseSearch (copy), n4 (copy), s1 (copy), s2 (copy), DataHydration (copy), debug (copy)
			UniverseSearch.getUniverseSearchStore().updateSearchItem(n4, {
				name = s1,
				description = s2
			})

			local v18 = DataHydration.Game.getGameInfoStore(false)

			if v18.updateGameInfo == nil then
				debug.log("warn", "GameConfigurationActions updateGameInfo unavailable", {
					source = "updateTitleDescription",
					universeId = n4
				})

				return p2
			end

			v18.updateGameInfo(tostring(n4), {
				name = s1,
				description = s2
			})

			return p2
		end)
	end
}
