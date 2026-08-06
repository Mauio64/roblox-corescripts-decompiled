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
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local rehydrateGameMetadata = require(BuildExperience.utils.rehydrateGameMetadata)
local v14 = game:DefineFastInt("BuildExperienceSetAudiencesMaxRetries", 3)
local v15 = game:DefineFastInt("BuildExperienceSetAudiencesRetryDelayMs", 3000)
local v16 = game:DefineFastFlag("BuildExperienceSecondActivateAfterSetAudiences", false)
local FFlagBuildRehydrateOnPublish = require(BuildExperience.Flags.FFlagBuildRehydrateOnPublish)
local debug = CreatorAgentChat.debug
local v19 = UrlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/configure")
local v20 = UrlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/experience-questionnaire")

local function saveAndPublishPlace(p1) -- line: 38
	-- upvalues: debug (copy), CreatorAgentChat (copy), HttpClient (copy)
	debug.log("info", "GameConfigurationActions save_and_publish started", {
		placeId = p1.placeId
	})

	local v31 = CreatorAgentChat.getCreatorAgentChatStore().sessionSaveAndPublish(p1)

	return HttpClient.asPromise(v31)
end
local function updateAudienceSummary(n1: number, t1: {[any]: any}, p2) -- line: 98
	-- upvalues: UniverseConfiguration (copy)
	UniverseConfiguration.getUniverseConfigurationStore().updateSummary(n1, {
		isActive = true,
		privacyType = p2,
		audiences = t1
	})
end
local function buildPublicAudiences(t2: {[any]: any}) -- line: 110
	-- upvalues: UniverseActivation (copy)
	local t3 = {}

	for _, v42 in t2 do
		if v42 ~= UniverseActivation.Audience.Public and v42 ~= UniverseActivation.Audience.Friends then
			table.insert(t3, v42)
		end
	end

	table.insert(t3, UniverseActivation.Audience.Public)

	return t3
end
local function updateCachedAudience(n2: number, t4: {[any]: any}, b1: boolean?) -- line: 124
	-- upvalues: GameConfigurationLabels (copy), UniverseConfiguration (copy)
	local v46 = GameConfigurationLabels.getAudience({
		audiences = t4
	}) or UniverseConfiguration.PrivacyType.Private
	local v47 = UniverseConfiguration.getUniverseConfigurationStore()

	v47.updateConfiguration(n2, {
		privacyType = v46,
		audiences = t4
	})
	v47.updateSummary(n2, {
		isActive = b1,
		privacyType = v46,
		audiences = t4
	})
end
local function hasPublicAudience(t5: {[any]: any}?) -- line: 142
	-- upvalues: UniverseActivation (copy)
	return t5 ~= nil and table.find(t5, UniverseActivation.Audience.Public) ~= nil
end
local function audienceFailure(p3, p4) -- line: 148
	return {
		stage = "set_audience",
		errorMessage = if typeof(p3) ~= "table" or p3.errorMessage == nil then tostring(p3) else tostring(p3.errorMessage),
		publishResult = p4
	}
end
local function setAudiencesForPublish(p5, n3: number, t6: {[any]: any}) -- line: 158
	-- upvalues: FFlagBuildRehydrateOnPublish (copy), buildPublicAudiences (copy), Promise (copy), v14 (copy), v15 (copy), updateCachedAudience (copy), UniverseActivation (copy), debug (copy)
	local v54 = if not FFlagBuildRehydrateOnPublish then t6 else buildPublicAudiences(t6)

	return Promise.retryWithDelay(function() -- line: 164
		-- upvalues: p5 (copy), n3 (copy), v54 (copy)
		return p5.setAudiences(n3, v54)
	end, v14, v15 / 1000):andThen(function(p6) -- line: 167
		-- upvalues: FFlagBuildRehydrateOnPublish (copy), updateCachedAudience (copy), n3 (copy), UniverseActivation (copy), debug (copy), Promise (copy)
		if FFlagBuildRehydrateOnPublish then
			updateCachedAudience(n3, p6.audiences, true)

			local audiences = p6.audiences

			if audiences == nil or table.find(audiences, UniverseActivation.Audience.Public) == nil then
				debug.log("warn", "GameConfigurationActions set audience missing Public", {
					universeId = n3
				})

				return Promise.reject({
					errorMessage = "setAudiences did not return a Public audience"
				})
			end
		end

		return p6
	end)
end

return {
	PublishFailureStage = {
		SetAudience = "set_audience"
	},
	getCreatorHubConfigureUrl = function(n4: number) -- line: 30
		-- upvalues: v19 (copy)
		return v19({
			universeId = n4
		})
	end,
	publishExperience = function(t7: {[any]: any}) -- line: 184
		-- upvalues: saveAndPublishPlace (copy), FFlagBuildRehydrateOnPublish (copy), UniverseActivation (copy), setAudiencesForPublish (copy), Promise (copy), debug (copy), v16 (copy), UniverseConfiguration (copy), rehydrateGameMetadata (copy)
		local function publishPlace() -- line: 194
			-- upvalues: saveAndPublishPlace (copy), t7 (copy)
			return saveAndPublishPlace({
				placeId = t7.placeId,
				title = t7.title,
				description = t7.description
			})
		end

		local u58

		if t7.isActive then
			if FFlagBuildRehydrateOnPublish then
				local v57 = UniverseActivation.getUniverseActivationStore()

				u58 = saveAndPublishPlace({
					placeId = t7.placeId,
					title = t7.title,
					description = t7.description
				}):andThen(function(p7) -- line: 207
					-- upvalues: setAudiencesForPublish (copy), v57 (copy), t7 (copy), Promise (copy)
					return setAudiencesForPublish(v57, t7.universeId, t7.audiences):andThen(function() -- line: 208
						-- upvalues: p7 (copy)
						return p7
					end, function(p8) -- line: 210
						-- upvalues: Promise (copy), p7 (copy)
						local reject = Promise.reject
						local v73 = p7

						return reject({
							stage = "set_audience",
							errorMessage = if typeof(p8) ~= "table" or p8.errorMessage == nil then tostring(p8) else tostring(p8.errorMessage),
							publishResult = v73
						})
					end)
				end)
			else
				u58 = saveAndPublishPlace({
					placeId = t7.placeId,
					title = t7.title,
					description = t7.description
				})
			end
		else
			local v59 = UniverseActivation.getUniverseActivationStore()

			debug.log("info", "GameConfigurationActions publish activate-and-set-audience started", {
				universeId = t7.universeId,
				placeId = t7.placeId
			})

			local function setPublicAudience() -- line: 223
				-- upvalues: setAudiencesForPublish (copy), v59 (copy), t7 (copy), v16 (copy), debug (copy)
				return setAudiencesForPublish(v59, t7.universeId, t7.audiences):andThen(function() -- line: 224
					-- upvalues: v16 (copy), v59 (copy), t7 (copy), debug (copy)
					if v16 then
						return v59.activate(t7.universeId):catch(function(p9) -- line: 226
							-- upvalues: debug (copy), t7 (copy)
							debug.log("warn", "GameConfigurationActions second activate failed", {
								error = tostring(p9),
								universeId = t7.universeId
							})
						end)
					end

					return nil
				end)
			end

			u58 = if not FFlagBuildRehydrateOnPublish then v59.activate(t7.universeId):andThen(function() -- line: 253
				-- upvalues: setPublicAudience (copy)
				return setPublicAudience()
			end):andThen(function() -- line: 256
				-- upvalues: t7 (copy), UniverseConfiguration (copy), publishPlace (copy)
				local universeId = t7.universeId
				local audiences = t7.audiences
				local Public = UniverseConfiguration.PrivacyType.Public

				UniverseConfiguration.getUniverseConfigurationStore().updateSummary(universeId, {
					isActive = true,
					privacyType = Public,
					audiences = audiences
				})

				return publishPlace()
			end) else v59.activate(t7.universeId):andThen(function() -- line: 240
				-- upvalues: publishPlace (copy)
				return publishPlace()
			end):andThen(function(p10) -- line: 243
				-- upvalues: setAudiencesForPublish (copy), v59 (copy), t7 (copy), v16 (copy), debug (copy), Promise (copy)
				return setAudiencesForPublish(v59, t7.universeId, t7.audiences):andThen(function() -- line: 224
					-- upvalues: v16 (copy), v59 (copy), t7 (copy), debug (copy)
					if v16 then
						return v59.activate(t7.universeId):catch(function(p11) -- line: 226
							-- upvalues: debug (copy), t7 (copy)
							debug.log("warn", "GameConfigurationActions second activate failed", {
								error = tostring(p11),
								universeId = t7.universeId
							})
						end)
					end

					return nil
				end):andThen(function() -- line: 244
					-- upvalues: p10 (copy)
					return p10
				end, function(p12) -- line: 246
					-- upvalues: Promise (copy), p10 (copy)
					local reject = Promise.reject
					local v76 = p10

					return reject({
						stage = "set_audience",
						errorMessage = if typeof(p12) ~= "table" or p12.errorMessage == nil then tostring(p12) else tostring(p12.errorMessage),
						publishResult = v76
					})
				end)
			end)
		end

		return u58:finally(function() -- line: 263
			-- upvalues: FFlagBuildRehydrateOnPublish (copy), rehydrateGameMetadata (copy), t7 (copy), u58 (ref)
			if FFlagBuildRehydrateOnPublish then
				rehydrateGameMetadata(t7.universeId)
			end

			return u58
		end)
	end,
	getExperienceQuestionnaireUrl = function(n5: number) -- line: 34
		-- upvalues: v20 (copy)
		return v20({
			universeId = n5
		})
	end,
	saveAndPublishPlace = saveAndPublishPlace,
	archiveGame = function(n6: number) -- line: 46
		-- upvalues: debug (copy), UniverseConfiguration (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
		debug.log("info", "GameConfigurationActions archive started", {
			universeId = n6
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n6, {
			isArchived = true
		}):andThen(function() -- line: 52
			-- upvalues: debug (copy), n6 (copy), UniverseSearch (copy), GetBuildExperienceRefreshStore (copy)
			debug.log("info", "GameConfigurationActions archive succeeded", {
				universeId = n6
			})
			UniverseSearch.getUniverseSearchStore().invalidateAll()
			GetBuildExperienceRefreshStore().bumpRefreshTick()
		end):catch(function(p13) -- line: 59
			-- upvalues: debug (copy), n6 (copy)
			debug.log("warn", "GameConfigurationActions archive failed", {
				error = tostring(p13),
				universeId = n6
			})
		end)
	end,
	updateCachedAudience = updateCachedAudience,
	updateTitleDescription = function(n7: number, s1: string, s2: string) -- line: 67
		-- upvalues: debug (copy), UniverseConfiguration (copy), UniverseSearch (copy), DataHydration (copy)
		debug.log("info", "GameConfigurationActions title and description update started", {
			universeId = n7
		})

		return UniverseConfiguration.getUniverseConfigurationStore().patchConfiguration(n7, {
			name = s1,
			description = s2
		}):andThen(function(p14) -- line: 77
			-- upvalues: UniverseSearch (copy), n7 (copy), s1 (copy), s2 (copy), DataHydration (copy), debug (copy)
			UniverseSearch.getUniverseSearchStore().updateSearchItem(n7, {
				name = s1,
				description = s2
			})

			local v63 = DataHydration.Game.getGameInfoStore(false)

			if v63.updateGameInfo == nil then
				debug.log("warn", "GameConfigurationActions updateGameInfo unavailable", {
					source = "updateTitleDescription",
					universeId = n7
				})

				return p14
			end

			v63.updateGameInfo(tostring(n7), {
				name = s1,
				description = s2
			})

			return p14
		end)
	end
}
