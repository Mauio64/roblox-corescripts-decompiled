local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Cryo = require(CorePackages.Packages.Cryo)
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local parseAndAddGameInfos = require(CorePackages.Workspace.Packages.GameInfosRodux).parseAndAddGameInfos
local GameInfoModel = require(CorePackages.Workspace.Packages.GameModels).GameInfoModel
local TopicContentsEntryModel = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsEntryModel
local GameDetailModel = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.GameDetailModel
local SetGameVotes = require(CorePackages.Workspace.Packages.GameVotesRodux).GameVotes.SetGameVotes
local AddGameDetailsV2 = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.AddGameDetailsV2
local SetGameDetailError = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.SetGameDetailError
local AgeRecommendationDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.AgeRecommendationDetails
local SetAgeRecommendation = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.SetAgeRecommendation
local SetAgeRecommendationHeaders = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.SetAgeRecommendationHeaders
local getEdpServerIxpVariablesStore = require(Modules.LuaApp.Components.ExperienceDetails.getEdpServerIxpVariablesStore)
local getEdpPerUniverseVisibilityVariablesStore = require(Modules.LuaApp.Components.ExperienceDetails.getEdpPerUniverseVisibilityVariablesStore)
local EnumGameDetailErrorTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).EnumGameDetailErrorTypes
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local Promise = require(Modules.LuaApp.Promise)
local ApiFetchExperienceDetailsPageCounters = require(Modules.LuaApp.Thunks.ApiFetchExperienceDetailsPageCounters)
local GetExperienceDetailsPage = require(CorePackages.Workspace.Packages.GameDetailRodux).ExperienceDetails.GetExperienceDetailsPage
local EdpSduiUtils = require(script.Parent.Parent.Parent.Components.ExperienceDetails.EdpSduiUtils)
local AgeCheckUpsellRenderedData = require(CorePackages.Workspace.Packages.GameDetail).AgeCheckUpsellRenderedData
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
local FFlagLuaAppExtendPlayWithRewardPeekView = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExtendPlayWithRewardPeekView
local FFlagLuaAppDataHydrationUpdateItem = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDataHydrationUpdateItem
local FFlagSduiFavoritesHydrationStructured = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiFavoritesHydrationStructured
local FFlagLuaAppEdpBackendV2AddUserVote = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2AddUserVote
local v37 = game:DefineFastFlag("LuaAppEdpBackendV2LogFetchFailureErrorCodeAndMessage2", false)
local FFlagLuaAppDataHydrationConnectionsPlayedStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDataHydrationConnectionsPlayedStore
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight
local SetGameFavorite = require(Modules.LuaApp.Actions.Games.SetGameFavorite)
local SetRecommendedGameEntries = require(Modules.LuaApp.Actions.Games.SetRecommendedGameEntries)
local SetExperienceNotificationsEnabledCount = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledCount)
local SetExperienceNotificationsEnabledLimit = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledLimit)
local SetGamePasses = require(Modules.LuaApp.Actions.Games.SetGamePasses)
local SetGameFollowingStatus = require(Modules.LuaApp.Actions.SetGameFollowingStatus)
local SetGameBadges = require(Modules.LuaApp.Actions.SetGameBadges)
local SetGameSocialLinks = require(Modules.LuaApp.Actions.Games.SetGameSocialLinks)
local SetExperienceCommunityLink = require(CorePackages.Workspace.Packages.CommunityLinks).Actions.SetExperienceCommunityLink
local UpdateGameMedia = Modules2.LuaApp.Actions.Games.UpdateGameMedia
local SetAssetTextFilterSettings = require(Modules.LuaApp.Actions.SetAssetTextFilterSettings)
local GameMediaEntry = Modules2.LuaApp.Models.GamesApi.GameMediaEntry
local CommunityInfo = require(CorePackages.Workspace.Packages.CommunityLinks).Models.CommunityInfo
local CommunityVisibility = require(CorePackages.Workspace.Packages.CommunityLinks).Enums.CommunityVisibility
local ApiFetchPassesThumbnails = require(Modules.LuaApp.Thunks.ApiFetchPassesThumbnails)
local ProcessGameSocialLinks = require(Modules.LuaApp.Thunks.Games.ProcessGameSocialLinks)
local FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure
local FFlagLuaAppEdpBackendV2LogUniverseIdForEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2LogUniverseIdForEvents
local t1 = {
	KeyMapper = function(p1) -- line: 102
		return "luaapp.experience.details." .. p1
	end,
	GetFetchingStatus = function(p2, p3) -- line: 108
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p2, "luaapp.experience.details." .. p3)
	end
}

local function safeParseData(p4, p5, p6, p7) -- line: 112
	-- upvalues: ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	local ok, result = pcall(p4, p5)

	if not ok then
		if p7 then
			ApiFetchExperienceDetailsPageCounters.logParseFailure(p7, if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p6)
		end

		return nil
	end

	return result
end
local function parseGameDetails(p8, p9) -- line: 126
	-- upvalues: GameDetailModel (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	local gameDetails = p8.gameDetails

	if gameDetails then
		local fromJsonData = GameDetailModel.fromJsonData
		local ok, result = pcall(fromJsonData, gameDetails)

		if not ok then
			ApiFetchExperienceDetailsPageCounters.logParseFailure("gameDetails", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p9)
			result = nil
		end

		if result then
			return {
				[p9] = result
			}
		end
	else
		ApiFetchExperienceDetailsPageCounters.logMissingData("gameDetails", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p9)
	end

	return nil
end
local function parseGameMedia(p10, p11) -- line: 142
	-- upvalues: GameMediaEntry (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	local mediaGallery = p10.mediaGallery

	if mediaGallery and type(mediaGallery) == "table" then
		local t2 = {}

		for _, v93 in mediaGallery do
			if type(v93) == "table" then
				local t3 = {
					approved = true,
					id = v93.id,
					assetTypeId = v93.assetTypeId,
					imageId = v93.imageId,
					videoId = v93.videoId,
					videoHash = v93.videoHash,
					videoTitle = v93.videoTitle
				}
				local fromJsonData = GameMediaEntry.fromJsonData
				local ok, result = pcall(fromJsonData, t3)

				if not ok then
					ApiFetchExperienceDetailsPageCounters.logParseFailure("gameMedia", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p11)
					result = nil
				end

				if result then
					table.insert(t2, result)
				end
			else
				ApiFetchExperienceDetailsPageCounters.logInvalidData("mediaEntry", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p11)
			end
		end

		return t2
	end

	ApiFetchExperienceDetailsPageCounters.logMissingData("mediaGallery", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p11)

	return nil
end
local function parseRecommendedGames(p12, p13, p14, p15) -- line: 178
	-- upvalues: TopicContentsEntryModel (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), Cryo (copy), GameInfoModel (copy), parseAndAddGameInfos (copy)
	local relatedGames = p12.relatedGames

	if relatedGames and type(relatedGames) == "table" then
		local t4 = {}

		local function forEachGameInfo(p16, p17) -- line: 182
			-- upvalues: TopicContentsEntryModel (copy), p15 (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), Cryo (copy), t4 (copy)
			if type(p16) == "table" then
				local fromGamesApiData = TopicContentsEntryModel.fromGamesApiData
				local v185 = p15
				local ok, result = pcall(fromGamesApiData, p16)

				if not ok then
					ApiFetchExperienceDetailsPageCounters.logParseFailure("recommendedGame", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else v185)
					result = nil
				end

				if result then
					result:match(function(p18) -- line: 189
						-- upvalues: Cryo (copy), p17 (copy), t4 (copy)
						local v193 = Cryo.Dictionary.join(p17, p18)

						table.insert(t4, v193)
					end):matchError(function(_) -- line: 193
						-- upvalues: ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), p15 (copy)
						ApiFetchExperienceDetailsPageCounters.logParseFailure("recommendedGame", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p15)
					end)

					return
				end
			else
				ApiFetchExperienceDetailsPageCounters.logInvalidData("relatedGameData", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p15)
			end
		end
		local function safeGameInfoModelFromGamesApi(p20) -- line: 208
			-- upvalues: GameInfoModel (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), p15 (copy)
			local ok, result = pcall(function() -- line: 209
				-- upvalues: GameInfoModel (copy), p20 (copy)
				return GameInfoModel.fromGamesApi(p20)
			end)

			if ok then
				return result
			end

			ApiFetchExperienceDetailsPageCounters.logParseFailure("recommendedGame", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p15)

			return nil
		end

		parseAndAddGameInfos(p13, p14, relatedGames, safeGameInfoModelFromGamesApi, forEachGameInfo)

		return t4
	end

	ApiFetchExperienceDetailsPageCounters.logMissingData("relatedGames", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p15)

	return nil
end
local function parseGamePasses(p21, p22) -- line: 234
	-- upvalues: ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	local gamePassProducts = p21.gamePassProducts

	if gamePassProducts and type(gamePassProducts) == "table" then
		local t5 = {}

		if #gamePassProducts > 0 then
			for _, v111 in gamePassProducts do
				if type(v111) == "table" and v111.id then
					table.insert(t5, v111.id)
				else
					ApiFetchExperienceDetailsPageCounters.logInvalidData("gamePass", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p22)
				end
			end
		end

		return {
			passes = gamePassProducts,
			passIds = t5
		}
	end

	return nil
end
local function parseFollowingStatus(p23, p24) -- line: 258
	-- upvalues: ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	local followingStatus = p23.followingStatus

	if followingStatus and type(followingStatus) == "table" then
		local canFollow = followingStatus.canFollow
		local isFollowing = followingStatus.isFollowing
		local followingCountByType = followingStatus.followingCountByType
		local followingLimitByType = followingStatus.followingLimitByType

		return {
			canFollow = canFollow,
			isFollowing = isFollowing,
			count = followingCountByType,
			limit = followingLimitByType
		}
	end

	ApiFetchExperienceDetailsPageCounters.logMissingData("followingStatus", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p24)

	return nil
end
local function parseCommunityLinks(p25, p26) -- line: 281
	-- upvalues: CommunityInfo (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	local communityLinks = p25.communityLinks

	if communityLinks then
		local fromJsonData = CommunityInfo.fromJsonData
		local ok, result = pcall(fromJsonData, communityLinks)

		if not ok then
			ApiFetchExperienceDetailsPageCounters.logParseFailure("communityLinks", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p26)

			return nil
		end

		return result
	end

	return nil
end
local function parseAgeRecommendations(p27, p28) -- line: 291
	-- upvalues: AgeRecommendationDetails (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	local ageRecommendations = p27.ageRecommendations

	if ageRecommendations and type(ageRecommendations) == "table" then
		local ageRecommendationsDetails = ageRecommendations.ageRecommendationsDetails

		if ageRecommendationsDetails then
			local fromJsonData = AgeRecommendationDetails.fromJsonData
			local ok, result = pcall(fromJsonData, ageRecommendationsDetails)

			if not ok then
				ApiFetchExperienceDetailsPageCounters.logParseFailure("ageRecommendations", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p28)
				result = nil
			end

			if not result then
				return nil
			end

			local v132, v133 = result:unwrap()

			if v132 == false then
				ApiFetchExperienceDetailsPageCounters.logParseFailure("ageRecommendations", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p28)

				return nil
			end

			local headerDisplayName = ageRecommendations.headerDisplayName
			local headerDisplayNameShort = ageRecommendations.headerDisplayNameShort

			return {
				ageRecommendationDetailsData = v133,
				headerDisplayName = headerDisplayName,
				headerDisplayNameShort = headerDisplayNameShort
			}
		end
	else
		ApiFetchExperienceDetailsPageCounters.logMissingData("ageRecommendations", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p28)
	end

	return nil
end
local function extractSduiFeedItems(p29, _) -- line: 335
	-- upvalues: FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight (copy)
	if p29 and (p29.sdui and p29.sdui.feed and p29.sdui.feed.props and p29.sdui.feed.props.feedItems) then
		local t6 = {}
		local v139 = not FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight and nil

		for _, v141 in p29.sdui.feed.props.feedItems do
			if type(v141) == "table" and v141.feedItemKey then
				local t7 = {
					topicId = v141.topicId,
					sortIndex = v141.sortIndex,
					componentConfig = v141.componentConfig,
					analyticsData = v141.analyticsData
				}

				t6[v141.feedItemKey] = t7

				if FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight and v141.topicId == "age-check-upsell" then
					v139 = true
				end
			end
		end

		if FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
			return t6, v139
		end

		return t6, nil
	end

	local v143 = nil

	if FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
		return v143, false
	end

	return v143, nil
end
local function extractSduiTemplates(p31) -- line: 364
	if not p31 or (not p31.sdui or not p31.sdui.templates) then
		return nil
	end

	return p31.sdui.templates
end
local function updateDataHydrationStores(p32, p33) -- line: 372
	-- upvalues: DataHydration (copy), FFlagLuaAppEdpBackendV2AddUserVote (copy), parseGameDetails (copy), FFlagLuaAppDataHydrationConnectionsPlayedStore (copy), FFlagSduiFavoritesHydrationStructured (copy), Players (copy), parseFollowingStatus (copy)
	local v147 = if not p33 or (not p33.sdui or (not p33.sdui.feed or (not p33.sdui.feed.props or not p33.sdui.feed.props.experienceDetails))) then nil else p33.sdui.feed.props.experienceDetails

	if not v147 then
		return
	end

	local v148 = DataHydration.Game.getVotesStore(false)
	local v149 = v147.totalUpVotes or 0
	local v150 = v147.totalDownVotes or 0

	v148.updateVoteItem(p32, v150, v149)

	if FFlagLuaAppEdpBackendV2AddUserVote then
		local userVote = v147.userVote

		if userVote ~= nil then
			v148.updateUserVoteItem(p32, userVote)
		end
	end

	local v152 = DataHydration.Game.getGameInfoStore(false)
	local v153 = parseGameDetails(v147, p32)
	local v154 = v153 and v153[p32]

	if v154 then
		v152.updateGameInfo(p32, {
			rootPlaceId = v154.rootPlaceId,
			name = v154.name,
			description = v154.description,
			creator = v154.creator,
			universeId = p32,
			playerCount = v154.playing
		})
	end

	local isFavorited = v147.isFavorited
	local v156 = DataHydration.Game.getFavoritesStore(false)

	if FFlagLuaAppDataHydrationConnectionsPlayedStore then
		local connectionsPlayed = v147.connectionsPlayed
		local v158 = DataHydration.Game.getConnectionsPlayedStore(false)

		if connectionsPlayed then
			v158.updateItems({
				[p32] = connectionsPlayed
			})
		end
	end

	if FFlagSduiFavoritesHydrationStructured then
		v156.updateItem(p32, {
			isFavorited = isFavorited
		})
	else
		v156.updateItem(p32, isFavorited)
	end

	local v159 = Players.LocalPlayer and Players.LocalPlayer.UserId

	if v159 and v159 > 0 then
		local v160 = parseFollowingStatus(v147, p32)

		if v160 then
			local v161 = DataHydration.Game.getFollowingsStore(false)

			v161.updateItem(p32, {
				userId = tostring(v159),
				universeId = p32,
				isFollowing = v160.isFollowing,
				canFollow = v160.canFollow
			})
			v161.updateUserFollowingLimits({
				followingCountByType = v160.count,
				followingLimitByType = v160.limit
			})
		end
	end
end
local function parseEdpServerIxpVariables(p34, _) -- line: 447
	-- upvalues: ApiFetchExperienceDetailsPageCounters (copy)
	if not p34 or (not p34.sdui or not p34.sdui.feed or not p34.sdui.feed.props or not p34.sdui.feed.props.visibilityVariables) then
		return nil
	end

	local visibilityVariables = p34.sdui.feed.props.visibilityVariables
	local t8 = {
		hideNotifyButton = visibilityVariables.hideNotifyButton,
		hideGameRatings = visibilityVariables.hideGameRatings,
		hideFavoritesInContextMenu = visibilityVariables.hideFavoritesInContextMenu,
		hideNotifyInContextMenu = visibilityVariables.hideNotifyInContextMenu,
		showVisitsInInfoList = visibilityVariables.showVisitsInInfoList,
		showAgeMaturityInHeader = visibilityVariables.showAgeMaturityInHeader,
		showContentDescriptorsInInfoList = visibilityVariables.showContentDescriptorsInInfoList,
		hideStatsCarousel = visibilityVariables.hideStatsCarousel
	}
	local t9 = {}

	for v167, v168 in t8 do
		if v168 ~= nil then
			table.insert(t9, tostring(v167) .. ":" .. tostring(v168))
		end
	end

	local v169 = table.concat(t9, ",")

	ApiFetchExperienceDetailsPageCounters.logVisibilityVariables(v169)

	return t8
end
local function parseEdpServerVariables(p36, _) -- line: 483
	-- upvalues: ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppExtendPlayWithRewardPeekView (copy)
	if not p36 or (not p36.sdui or not p36.sdui.feed or not p36.sdui.feed.props or not p36.sdui.feed.props.visibilityVariables) then
		return nil, nil
	end

	local visibilityVariables = p36.sdui.feed.props.visibilityVariables
	local t10 = {
		hideNotifyButton = visibilityVariables.hideNotifyButton,
		hideGameRatings = visibilityVariables.hideGameRatings,
		hideFavoritesInContextMenu = visibilityVariables.hideFavoritesInContextMenu,
		hideNotifyInContextMenu = visibilityVariables.hideNotifyInContextMenu,
		showVisitsInInfoList = visibilityVariables.showVisitsInInfoList,
		showAgeMaturityInHeader = visibilityVariables.showAgeMaturityInHeader,
		showContentDescriptorsInInfoList = visibilityVariables.showContentDescriptorsInInfoList,
		hideStatsCarousel = visibilityVariables.hideStatsCarousel
	}
	local t11 = {}

	for v175, v176 in t10 do
		if v176 ~= nil then
			table.insert(t11, tostring(v175) .. ":" .. tostring(v176))
		end
	end

	local v177 = table.concat(t11, ",")

	ApiFetchExperienceDetailsPageCounters.logVisibilityVariables(v177)

	return t10, {
		hidePlayWithReward = visibilityVariables.hidePlayWithReward,
		extendPlayWithRewardPeekViewOffset = if not FFlagLuaAppExtendPlayWithRewardPeekView then nil else visibilityVariables.extendPlayWithRewardPeekViewOffset
	}
end

function t1.Fetch(p38, p39, p40, p41) -- line: 526
	-- upvalues: PerformFetch (copy), GetExperienceDetailsPage (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), extractSduiFeedItems (copy), FFlagLuaAppDataHydrationUpdateItem (copy), updateDataHydrationStores (copy), EdpSduiUtils (copy), ServerDrivenUi (copy), FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight (copy), AgeCheckUpsellRenderedData (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), parseEdpServerVariables (copy), getEdpServerIxpVariablesStore (copy), getEdpPerUniverseVisibilityVariablesStore (copy), parseEdpServerIxpVariables (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), Promise (copy), parseGameDetails (copy), AddGameDetailsV2 (copy), parseGameMedia (copy), UpdateGameMedia (copy), SetGameFavorite (copy), SetGameVotes (copy), SetAssetTextFilterSettings (copy), parseRecommendedGames (copy), SetRecommendedGameEntries (copy), parseGamePasses (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), SetGamePasses (copy), ApiFetchPassesThumbnails (copy), parseFollowingStatus (copy), SetGameFollowingStatus (copy), SetExperienceNotificationsEnabledCount (copy), SetExperienceNotificationsEnabledLimit (copy), SetGameBadges (copy), ProcessGameSocialLinks (copy), SetGameSocialLinks (copy), getAppFeaturePolicies (copy), CommunityInfo (copy), CommunityVisibility (copy), SetExperienceCommunityLink (copy), parseAgeRecommendations (copy), SetAgeRecommendation (copy), SetAgeRecommendationHeaders (copy), FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure (copy), SetGameDetailError (copy), EnumGameDetailErrorTypes (copy), v37 (copy)
	if type(p39) ~= "string" then
		error("ApiFetchExperienceDetailsPage thunk expects universeId to be a string")
	end

	return PerformFetch.Single("luaapp.experience.details." .. p39, function(p42) -- line: 531
		-- upvalues: GetExperienceDetailsPage (copy), p38 (copy), p39 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), p41 (copy), extractSduiFeedItems (copy), FFlagLuaAppDataHydrationUpdateItem (copy), updateDataHydrationStores (copy), EdpSduiUtils (copy), ServerDrivenUi (copy), FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight (copy), AgeCheckUpsellRenderedData (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), parseEdpServerVariables (copy), getEdpServerIxpVariablesStore (copy), getEdpPerUniverseVisibilityVariablesStore (copy), parseEdpServerIxpVariables (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p40 (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), Promise (copy), parseGameDetails (copy), AddGameDetailsV2 (copy), parseGameMedia (copy), UpdateGameMedia (copy), SetGameFavorite (copy), SetGameVotes (copy), SetAssetTextFilterSettings (copy), parseRecommendedGames (copy), SetRecommendedGameEntries (copy), parseGamePasses (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), SetGamePasses (copy), ApiFetchPassesThumbnails (copy), parseFollowingStatus (copy), SetGameFollowingStatus (copy), SetExperienceNotificationsEnabledCount (copy), SetExperienceNotificationsEnabledLimit (copy), SetGameBadges (copy), ProcessGameSocialLinks (copy), SetGameSocialLinks (copy), getAppFeaturePolicies (copy), CommunityInfo (copy), CommunityVisibility (copy), SetExperienceCommunityLink (copy), parseAgeRecommendations (copy), SetAgeRecommendation (copy), SetAgeRecommendationHeaders (copy), FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure (copy), SetGameDetailError (copy), EnumGameDetailErrorTypes (copy), v37 (copy)
		return GetExperienceDetailsPage(p38, p39):andThen(function(p43) -- line: 532
			-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), p41 (copy), extractSduiFeedItems (copy), p39 (copy), FFlagLuaAppDataHydrationUpdateItem (copy), updateDataHydrationStores (copy), EdpSduiUtils (copy), ServerDrivenUi (copy), FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight (copy), AgeCheckUpsellRenderedData (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), parseEdpServerVariables (copy), getEdpServerIxpVariablesStore (copy), getEdpPerUniverseVisibilityVariablesStore (copy), parseEdpServerIxpVariables (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p40 (copy), ApiFetchExperienceDetailsPageCounters (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), Promise (copy), parseGameDetails (copy), p42 (copy), AddGameDetailsV2 (copy), parseGameMedia (copy), UpdateGameMedia (copy), SetGameFavorite (copy), SetGameVotes (copy), SetAssetTextFilterSettings (copy), parseRecommendedGames (copy), p38 (copy), SetRecommendedGameEntries (copy), parseGamePasses (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), SetGamePasses (copy), ApiFetchPassesThumbnails (copy), parseFollowingStatus (copy), SetGameFollowingStatus (copy), SetExperienceNotificationsEnabledCount (copy), SetExperienceNotificationsEnabledLimit (copy), SetGameBadges (copy), ProcessGameSocialLinks (copy), SetGameSocialLinks (copy), getAppFeaturePolicies (copy), CommunityInfo (copy), CommunityVisibility (copy), SetExperienceCommunityLink (copy), parseAgeRecommendations (copy), SetAgeRecommendation (copy), SetAgeRecommendationHeaders (copy), FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure (copy)
			local responseBody = p43.responseBody

			if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p41 then
				local v197, v198 = extractSduiFeedItems(responseBody, p39)
				local v199 = if not not responseBody and (not not responseBody.sdui and responseBody.sdui.templates) then responseBody.sdui.templates else nil

				if v197 and next(v197) then
					if FFlagLuaAppDataHydrationUpdateItem then
						updateDataHydrationStores(p39, responseBody)
					end

					local v200 = os.time() * 1000
					local v201 = EdpSduiUtils.getUnprocessedEdpStoreKey((tostring(p39)))

					ServerDrivenUi.getSduiFeedStore(v201).updateData({
						itemCollections = v197,
						templates = v199,
						dataUpdatedTimestamp = v200
					})
				end

				if FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
					AgeCheckUpsellRenderedData.setAgeCheckUpsellRendered(tostring(p39), v198)
				end

				if FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
					local v202, v203 = parseEdpServerVariables(responseBody, p39)

					if v202 then
						getEdpServerIxpVariablesStore().setEdpServerIxpVariables(v202)
					end

					if v203 then
						getEdpPerUniverseVisibilityVariablesStore(p39).setVisibilityVariables(v203)
					end
				else
					local v204 = parseEdpServerIxpVariables(responseBody, p39)

					if v204 then
						getEdpServerIxpVariablesStore().setEdpServerIxpVariables(v204)
					end
				end
			end

			if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p40 then
				local experienceDetails = nil

				if responseBody and responseBody.sdui and responseBody.sdui.feed and responseBody.sdui.feed.props and responseBody.sdui.feed.props.experienceDetails then
					experienceDetails = responseBody.sdui.feed.props.experienceDetails
				end

				if experienceDetails == nil then
					ApiFetchExperienceDetailsPageCounters.logMissingData("experienceDetailsProps", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p39)

					return Promise.reject({
						HttpError = Enum.HttpError.InternalServerError
					})
				end

				local v206 = parseGameDetails(experienceDetails, p39)

				if v206 then
					p42:dispatch(AddGameDetailsV2(v206))
				end

				local v207 = parseGameMedia(experienceDetails, p39)

				if v207 then
					p42:dispatch(UpdateGameMedia(p39, v207))
				end

				local isFavorited = experienceDetails.isFavorited

				if isFavorited ~= nil then
					p42:dispatch(SetGameFavorite(p39, isFavorited))
				end

				local totalUpVotes = experienceDetails.totalUpVotes
				local totalDownVotes = experienceDetails.totalDownVotes

				if totalUpVotes ~= nil and totalDownVotes ~= nil then
					local v211 = if not (totalUpVotes < 0) then totalUpVotes else 0
					local v212 = if not (totalDownVotes < 0) then totalDownVotes else 0

					p42:dispatch(SetGameVotes(p39, v211, v212))
				end

				local textFilterProfanity = experienceDetails.textFilterProfanity

				if textFilterProfanity ~= nil then
					p42:dispatch(SetAssetTextFilterSettings(p39, textFilterProfanity))
				else
					p42:dispatch(SetAssetTextFilterSettings(p39, false))
				end

				local v214 = parseRecommendedGames(experienceDetails, p38, p42, p39)

				if v214 then
					p42:dispatch(SetRecommendedGameEntries(p39, v214))
				end

				local v215 = parseGamePasses(experienceDetails, p39)

				if v215 and v215.passes then
					if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
						if v215.passes then
							local t12 = {}
							local t13 = {}

							for _, v219 in v215.passes do
								if v219.id then
									local str = tostring(v219.id)

									t12[str] = v219
									table.insert(t13, str)
								end
							end

							local v221 = DataHydration.Game.getGamePassStore(false)

							v221.updateGamePassInfos(t12)
							v221.updateUniversePasses({
								[p39] = t13
							})
						end
					else
						p42:dispatch(SetGamePasses(p39, v215.passes))

						if v215 and v215.passIds then
							p42:dispatch(ApiFetchPassesThumbnails(p38, v215.passIds))
						end
					end
				end

				local v222 = parseFollowingStatus(experienceDetails, p39)

				if v222 and v222.canFollow ~= nil and v222.isFollowing ~= nil then
					p42:dispatch(SetGameFollowingStatus(p39, v222.canFollow, v222.isFollowing))
				end

				if v222 and v222.count ~= nil then
					p42:dispatch(SetExperienceNotificationsEnabledCount(v222.count))
				end

				if v222 and v222.limit ~= nil then
					p42:dispatch(SetExperienceNotificationsEnabledLimit(v222.limit))
				end

				local badges = experienceDetails.badges

				if badges then
					p42:dispatch(SetGameBadges(p39, badges))
				end

				local socialLinks = experienceDetails.socialLinks

				if socialLinks then
					local v225 = ProcessGameSocialLinks(socialLinks, p39)

					if v225 then
						p42:dispatch(SetGameSocialLinks(p39, v225))
					end
				end

				if getAppFeaturePolicies().getCommunityLinksEnabled() then
					local v226 = p39
					local communityLinks = experienceDetails.communityLinks
					local result

					if communityLinks then
						local fromJsonData = CommunityInfo.fromJsonData
						local ok

						ok, result = pcall(fromJsonData, communityLinks)

						if not ok then
							ApiFetchExperienceDetailsPageCounters.logParseFailure("communityLinks", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else v226)
							result = nil
						end
					else
						result = nil
					end

					if result and result.visibility == CommunityVisibility.Public then
						p42:dispatch(SetExperienceCommunityLink(p39, result))
					end
				end

				local v231 = parseAgeRecommendations(experienceDetails, p39)

				if v231 then
					p42:dispatch(SetAgeRecommendation(p39, v231.ageRecommendationDetailsData))
					p42:dispatch(SetAgeRecommendationHeaders(v231.headerDisplayName, v231.headerDisplayNameShort))
				end
			end

			if FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
				ApiFetchExperienceDetailsPageCounters.logFetchSuccess(if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p39)
			end

			return responseBody
		end):catch(function(p44) -- line: 722
			-- upvalues: p42 (copy), SetGameDetailError (copy), p39 (copy), EnumGameDetailErrorTypes (copy), FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure (copy), ApiFetchExperienceDetailsPageCounters (copy), v37 (copy), Promise (copy)
			if p44 and p44.StatusCode == 404 then
				p42:dispatch(SetGameDetailError(p39, EnumGameDetailErrorTypes.ExperienceUnavailable))
			end

			if FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
				ApiFetchExperienceDetailsPageCounters.logFetchFailure(p39, if not v37 or not p44 then nil else p44.StatusCode, if not v37 or not p44 then nil else p44.StatusMessage)
			end

			return Promise.reject(p44)
		end)
	end)
end

return t1
