local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Cryo = require(CorePackages.Packages.Cryo)
local modules = require("@luauforge/bundled/dtb").Modules

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies

local parseAndAddGameInfos = require("@luauforge/bundled/dCP").parseAndAddGameInfos
local gameInfoModel = require("@luauforge/deferred/gBJ").GameInfoModel
local topicContentsEntryModel = require("@luauforge/bundled/dCO").TopicContentsEntryModel
local gameDetailModel = require("@luauforge/bundled/dBl").GameDetails.GameDetailModel
local setGameVotes = require("@luauforge/bundled/dBR").GameVotes.SetGameVotes
local addGameDetailsV2 = require("@luauforge/bundled/dBl").GameDetails.AddGameDetailsV2
local setGameDetailError = require("@luauforge/bundled/dBl").GameDetails.SetGameDetailError

local ageRecommendationDetails = require("@luauforge/bundled/dBl").AgeRecommendations.AgeRecommendationDetails

local setAgeRecommendation = require("@luauforge/bundled/dBl").AgeRecommendations.SetAgeRecommendation

local setAgeRecommendationHeaders = require("@luauforge/bundled/dBl").AgeRecommendations.SetAgeRecommendationHeaders
local module = require("@luauforge/deferred/gBK")

local module2 = require("@luauforge/deferred/gBL")
local enumGameDetailErrorTypes = require("@luauforge/bundled/cBc").EnumGameDetailErrorTypes
local module3 = require("@luauforge/bundled/dSY")

local module4 = require("@luauforge/bundled/egs")
local module5 = require("@luauforge/deferred/gBM")

local getExperienceDetailsPage = require("@luauforge/bundled/dBl").ExperienceDetails.GetExperienceDetailsPage
local module6 = require("@luauforge/deferred/gBN")
local ageCheckUpsellRenderedData = require("@luauforge/bundled/dCK").AgeCheckUpsellRenderedData
local module7 = require("@luauforge/bundled/dDZ")

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable

local fFlagLuaAppExtendPlayWithRewardPeekView = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExtendPlayWithRewardPeekView

local fFlagLuaAppDataHydrationUpdateItem = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDataHydrationUpdateItem

local fFlagLuaAppEdpBackendV2AddUserVote = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2AddUserVote

local fFlagLuaAppDataHydrationConnectionsPlayedStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDataHydrationConnectionsPlayedStore

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGamePassesDataHydrationMigrationEnabled

local fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight

local success, result = pcall(function()
	return Enum.HttpError.InternalServerError
end)

local v5 = success and result or nil

local module8 = require("@luauforge/bundled/dCC")
local module9 = require("@luauforge/bundled/dCG")

local module10 = require("@luauforge/bundled/dBs")

local module11 = require("@luauforge/bundled/dBt")
local module12 = require("@luauforge/bundled/dBv")
local module13 = require("@luauforge/bundled/dBp")
local module14 = require("@luauforge/bundled/dBM")
local module15 = require("@luauforge/bundled/dBn")

local setExperienceCommunityLink = require("@luauforge/bundled/dEj").Actions.SetExperienceCommunityLink
local updateGameMedia = modules.LuaApp.Actions.Games.UpdateGameMedia
local module16 = require("@luauforge/bundled/dEi")

local gameMediaEntry = modules.LuaApp.Models.GamesApi.GameMediaEntry
local communityInfo = require("@luauforge/bundled/dEj").Models.CommunityInfo
local communityVisibility = require("@luauforge/bundled/dEj").Enums.CommunityVisibility

local module17 = require("@luauforge/bundled/gBO")
local module18 = require("@luauforge/deferred/gBQ")

local fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure

local fFlagLuaAppEdpBackendV2LogUniverseIdForEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogUniverseIdForEvents

local v6 = {}

function v6.KeyMapper(p2)
	return "luaapp.experience.details." .. p2
end

function v6.GetFetchingStatus(p2, p3)
	return performFetch.GetStatus(p2, "luaapp.experience.details." .. p3)
end

local function safeParseData(callback, p2, p3, p4)
	local success2, result2 = pcall(callback, p2)

	if success2 then
		return result2
	end

	if not p4 then
		return nil
	end

	local logParseFailure = module5.logParseFailure

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		p3 = nil
	end

	logParseFailure(p4, p3)

	return nil
end

local function parseGameDetails(experienceDetails, p2)
	local gameDetails = experienceDetails.gameDetails

	if gameDetails then
		local success2, result2 = pcall(gameDetailModel.fromJsonData, gameDetails)

		if not success2 then
			module5.logParseFailure(
				"gameDetails",
				if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then p2 else nil
			)
			result2 = nil
		end

		if result2 then
			return { [p2] = result2 }
		end
	else
		local logMissingData = module5.logMissingData

		if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
			p2 = nil
		end

		logMissingData("gameDetails", p2)
	end

	return nil
end

local function parseGameMedia(experienceDetails, value)
	local mediaGallery = experienceDetails.mediaGallery

	if mediaGallery and type(mediaGallery) == "table" then
		local result2 = {}

		for k, v7 in mediaGallery do
			if type(v7) == "table" then
				local v8 = {
					id = v7.id,
					assetTypeId = v7.assetTypeId,
					imageId = v7.imageId,
					videoId = v7.videoId,
					videoHash = v7.videoHash,
					videoTitle = v7.videoTitle,
					approved = true
				}
				local success2, result3 = pcall(gameMediaEntry.fromJsonData, v8)

				if not success2 then
					module5.logParseFailure(
						"gameMedia",
						if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
					)
					result3 = nil
				end

				if result3 then
					table.insert(result2, result3)
				end
			else
				module5.logInvalidData(
					"mediaEntry",
					if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
				)
			end
		end

		return result2
	else
		local logMissingData = module5.logMissingData

		if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
			value = nil
		end

		logMissingData("mediaGallery", value)

		return nil
	end
end

local function parseRecommendedGames(experienceDetails, p2, object, value)
	local relatedGames = experienceDetails.relatedGames

	if relatedGames and type(relatedGames) == "table" then
		local values = {}
		local function forEachGameInfo(p3, p4)
			if type(p3) == "table" then
				local fromGamesApiData = topicContentsEntryModel.fromGamesApiData
				local v7 = value
				local success2, result2 = pcall(fromGamesApiData, p3)

				if not success2 then
					local logParseFailure = module5.logParseFailure

					if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
						v7 = nil
					end

					logParseFailure("recommendedGame", v7)
					result2 = nil
				end

				if result2 then
					result2:match(function(p5)
						local joined = Cryo.Dictionary.join(p4, p5)
						table.insert(values, joined)
					end):matchError(function(p5)
						module5.logParseFailure(
							"recommendedGame",
							if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
						)
					end)
				end
			else
				module5.logInvalidData(
					"relatedGameData",
					if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
				)
			end
		end

		local function safeGameInfoModelFromGamesApi(p3)
			local success2, result2 = pcall(function()
				return gameInfoModel.fromGamesApi(p3)
			end)

			if success2 then
				return result2
			end

			module5.logParseFailure(
				"recommendedGame",
				if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
			)

			return nil
		end

		parseAndAddGameInfos(p2, object, relatedGames, safeGameInfoModelFromGamesApi, forEachGameInfo)
		return values
	else
		local logMissingData = module5.logMissingData

		if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
			value = nil
		end

		logMissingData("relatedGames", value)

		return nil
	end
end

local function parseGamePasses(experienceDetails, value)
	local gamePassProducts = experienceDetails.gamePassProducts

	if not gamePassProducts or type(gamePassProducts) ~= "table" then
		return nil
	end

	local ids = {}

	if #gamePassProducts > 0 then
		for k, gamePassProduct in gamePassProducts do
			if type(gamePassProduct) == "table" and gamePassProduct.id then
				table.insert(ids, gamePassProduct.id)
			else
				module5.logInvalidData(
					"gamePass",
					if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
				)
			end
		end
	end

	return { passes = gamePassProducts, passIds = ids }
end

local function parseFollowingStatus(experienceDetails, p2)
	local followingStatus = experienceDetails.followingStatus

	if followingStatus and type(followingStatus) == "table" then
		return {
			canFollow = followingStatus.canFollow,
			isFollowing = followingStatus.isFollowing,
			count = followingStatus.followingCountByType,
			limit = followingStatus.followingLimitByType
		}
	end

	local logMissingData = module5.logMissingData

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		p2 = nil
	end

	logMissingData("followingStatus", p2)

	return nil
end

local function parseCommunityLinks(p2, p3)
	local communityLinks = p2.communityLinks

	if not communityLinks then
		return nil
	end

	local success2, result2 = pcall(communityInfo.fromJsonData, communityLinks)

	if success2 then
		return result2
	end

	local logParseFailure = module5.logParseFailure

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		p3 = nil
	end

	logParseFailure("communityLinks", p3)

	return nil
end

local function parseAgeRecommendations(experienceDetails, value)
	local ageRecommendations = experienceDetails.ageRecommendations

	if ageRecommendations and type(ageRecommendations) == "table" then
		local ageRecommendationsDetails = ageRecommendations.ageRecommendationsDetails

		if ageRecommendationsDetails then
			local success2, result2 = pcall(
				ageRecommendationDetails.fromJsonData,
				ageRecommendationsDetails
			)

			if not success2 then
				module5.logParseFailure(
					"ageRecommendations",
					if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
				)
				result2 = nil
			end

			if not result2 then
				return nil
			end

			local unwrapped, v7 = result2:unwrap()

			if unwrapped ~= false then
				return {
					ageRecommendationDetailsData = v7,
					headerDisplayName = ageRecommendations.headerDisplayName,
					headerDisplayNameShort = ageRecommendations.headerDisplayNameShort
				}
			end

			local logParseFailure = module5.logParseFailure

			if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
				value = nil
			end

			logParseFailure("ageRecommendations", value)

			return nil
		end
	else
		local logMissingData = module5.logMissingData

		if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
			value = nil
		end

		logMissingData("ageRecommendations", value)
	end

	return nil
end

local function extractSduiFeedItems(responseBody, value)
	if
		responseBody
		and responseBody.sdui
		and responseBody.sdui.feed
		and responseBody.sdui.feed.props
		and responseBody.sdui.feed.props.feedItems
	then
		local result2 = {}
		local v7 = if fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then false else nil

		for k, feedItem in responseBody.sdui.feed.props.feedItems do
			if not (type(feedItem) == "table" and feedItem.feedItemKey) then
				continue
			end

			local v8 = {
				topicId = feedItem.topicId,
				sortIndex = feedItem.sortIndex,
				componentConfig = feedItem.componentConfig,
				analyticsData = feedItem.analyticsData
			}

			result2[feedItem.feedItemKey] = v8

			if
				fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight
				and feedItem.topicId == "age-check-upsell"
			then
				v7 = true
			end
		end

		if fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
			return result2, v7
		end

		return result2, nil
	else
		local v7 = nil

		if fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
			return v7, false
		end

		return v7, nil
	end
end

local function extractSduiTemplates(p2)
	if p2 and p2.sdui and p2.sdui.templates then
		return p2.sdui.templates
	end

	return nil
end

local function updateDataHydrationStores(value, responseBody)
	local experienceDetails

	if
		responseBody
		and responseBody.sdui
		and responseBody.sdui.feed
		and responseBody.sdui.feed.props
		and responseBody.sdui.feed.props.experienceDetails
	then
		experienceDetails = responseBody.sdui.feed.props.experienceDetails
	end

	if not experienceDetails then
		return
	end

	local votesStore = module3.Game.getVotesStore(false)
	local totalUpVotes = experienceDetails.totalUpVotes or 0
	local totalDownVotes = experienceDetails.totalDownVotes or 0

	votesStore.updateVoteItem(value, totalDownVotes, totalUpVotes)

	if fFlagLuaAppEdpBackendV2AddUserVote then
		local userVote = experienceDetails.userVote

		if userVote ~= nil then
			votesStore.updateUserVoteItem(value, userVote)
		end
	end

	local gameInfoStore = module3.Game.getGameInfoStore(false)
	local v7 = parseGameDetails(experienceDetails, value)
	local v8 = v7 and v7[value]

	if v8 then
		gameInfoStore.updateGameInfo(value, {
			rootPlaceId = v8.rootPlaceId,
			name = v8.name,
			description = v8.description,
			creator = v8.creator,
			universeId = value,
			playerCount = v8.playing
		})
	end

	local isFavorited = experienceDetails.isFavorited
	local favoritesStore = module3.Game.getFavoritesStore(false)

	if fFlagLuaAppDataHydrationConnectionsPlayedStore then
		local connectionsPlayed = experienceDetails.connectionsPlayed
		local connectionsPlayedStore = module3.Game.getConnectionsPlayedStore(false)

		if connectionsPlayed then
			connectionsPlayedStore.updateItems({ [value] = connectionsPlayed })
		end
	end

	favoritesStore.updateItem(value, { isFavorited = isFavorited })

	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId

	local v9 = userId and userId > 0 and parseFollowingStatus(experienceDetails, value)

	if v9 then
		local followingsStore = module3.Game.getFollowingsStore(false)
		followingsStore.updateItem(value, {
			userId = tostring(userId),
			universeId = value,
			isFollowing = v9.isFollowing,
			canFollow = v9.canFollow
		})

		followingsStore.updateUserFollowingLimits({
			followingCountByType = v9.count,
			followingLimitByType = v9.limit
		})
	end
end

local function parseEdpServerIxpVariables(responseBody, value)
	if not (responseBody and responseBody.sdui and responseBody.sdui.feed and responseBody.sdui.feed.props and responseBody.sdui.feed.props.visibilityVariables) then
		return nil
	end

	local visibilityVariables = responseBody.sdui.feed.props.visibilityVariables

	local v7 = {
		hideNotifyButton = visibilityVariables.hideNotifyButton,
		hideGameRatings = visibilityVariables.hideGameRatings,
		hideFavoritesInContextMenu = visibilityVariables.hideFavoritesInContextMenu,
		hideNotifyInContextMenu = visibilityVariables.hideNotifyInContextMenu,
		showVisitsInInfoList = visibilityVariables.showVisitsInInfoList,
		showAgeMaturityInHeader = visibilityVariables.showAgeMaturityInHeader,
		showContentDescriptorsInInfoList = visibilityVariables.showContentDescriptorsInInfoList,
		hideStatsCarousel = visibilityVariables.hideStatsCarousel
	}

	local v8 = {}

	for k, v9 in v7 do
		if v9 ~= nil then
			table.insert(v8, tostring(k) .. ":" .. tostring(v9))
		end
	end

	local joined = table.concat(v8, ",")
	module5.logVisibilityVariables(joined)

	return v7
end

local function parseEdpServerVariables(responseBody, value)
	if not (responseBody and responseBody.sdui and responseBody.sdui.feed and responseBody.sdui.feed.props and responseBody.sdui.feed.props.visibilityVariables) then
		return nil, nil
	end

	local visibilityVariables = responseBody.sdui.feed.props.visibilityVariables

	local v7 = {
		hideNotifyButton = visibilityVariables.hideNotifyButton,
		hideGameRatings = visibilityVariables.hideGameRatings,
		hideFavoritesInContextMenu = visibilityVariables.hideFavoritesInContextMenu,
		hideNotifyInContextMenu = visibilityVariables.hideNotifyInContextMenu,
		showVisitsInInfoList = visibilityVariables.showVisitsInInfoList,
		showAgeMaturityInHeader = visibilityVariables.showAgeMaturityInHeader,
		showContentDescriptorsInInfoList = visibilityVariables.showContentDescriptorsInInfoList,
		hideStatsCarousel = visibilityVariables.hideStatsCarousel
	}

	local v8 = {}

	for k, v9 in v7 do
		if v9 ~= nil then
			table.insert(v8, tostring(k) .. ":" .. tostring(v9))
		end
	end

	local joined = table.concat(v8, ",")
	module5.logVisibilityVariables(joined)

	local v9 = {
		hidePlayWithReward = visibilityVariables.hidePlayWithReward,
		extendPlayWithRewardPeekViewOffset = 0
	}

	local v10 = if fFlagLuaAppExtendPlayWithRewardPeekView then visibilityVariables.extendPlayWithRewardPeekViewOffset else nil
	v9.extendPlayWithRewardPeekViewOffset = v10

	return v7, v9
end

function v6.Fetch(p2, value, p3, p4)
	if type(value) ~= "string" then
		error("ApiFetchExperienceDetailsPage thunk expects universeId to be a string")
	end

	return performFetch.Single("luaapp.experience.details." .. value, function(object)
		return getExperienceDetailsPage(p2, value):andThen(function(p5)
			local responseBody = p5.responseBody

			if
				fFlagLuaAppEdpBackendV2SduiInterleaveDefault
				or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p4
			then
				local v7, v8 = extractSduiFeedItems(responseBody, value)
				local templates

				if responseBody and responseBody.sdui and responseBody.sdui.templates then
					templates = responseBody.sdui.templates
				end

				if v7 and next(v7) then
					if fFlagLuaAppDataHydrationUpdateItem then
						updateDataHydrationStores(value, responseBody)
					end

					local v9 = os.time() * 1000

					local unprocessedEdpStoreKey = module6.getUnprocessedEdpStoreKey((tostring(value)))
					module7.getSduiFeedStore(unprocessedEdpStoreKey).updateData({
						itemCollections = v7,
						templates = templates,
						dataUpdatedTimestamp = v9
					})
				end

				if fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
					ageCheckUpsellRenderedData.setAgeCheckUpsellRendered(tostring(value), v8)
				end

				if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
					local v9, v10 = parseEdpServerVariables(responseBody, value)

					if v9 then
						module().setEdpServerIxpVariables(v9)
					end

					if v10 then
						module2(value).setVisibilityVariables(v10)
					end
				else
					local v9 = parseEdpServerIxpVariables(responseBody, value)

					if v9 then
						module().setEdpServerIxpVariables(v9)
					end
				end
			end

			local experienceDetails

			if
				responseBody
				and responseBody.sdui
				and responseBody.sdui.feed
				and responseBody.sdui.feed.props
				and responseBody.sdui.feed.props.experienceDetails
			then
				experienceDetails = responseBody.sdui.feed.props.experienceDetails
			end

			if experienceDetails == nil then
				module5.logMissingData(
					"experienceDetailsProps",
					if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil
				)

				return module4.reject({
					HttpError = v5 or Enum.HttpError.ConnectFail
				})
			else
				local v7 = parseGameDetails(experienceDetails, value)

				if v7 then
					object:dispatch(addGameDetailsV2(v7))
				end

				local v8 = parseGameMedia(experienceDetails, value)

				if v8 then
					object:dispatch(updateGameMedia(value, v8))
				end

				local isFavorited = experienceDetails.isFavorited

				if isFavorited ~= nil then
					object:dispatch(module8(value, isFavorited))
				end

				local totalUpVotes = experienceDetails.totalUpVotes
				local totalDownVotes = experienceDetails.totalDownVotes

				if totalUpVotes ~= nil and totalDownVotes ~= nil then
					object:dispatch(setGameVotes(
						value,
						totalUpVotes < 0 and 0 or totalUpVotes,
						totalDownVotes < 0 and 0 or totalDownVotes
					))
				end

				local textFilterProfanity = experienceDetails.textFilterProfanity

				if textFilterProfanity == nil then
					object:dispatch(module16(value, false))
				else
					object:dispatch(module16(value, textFilterProfanity))
				end

				local v9 = parseRecommendedGames(experienceDetails, p2, object, value)

				if v9 then
					object:dispatch(module9(value, v9))
				end

				local v10 = parseGamePasses(experienceDetails, value)

				if v10 and v10.passes then
					if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
						if v10.passes then
							local passesById = {}
							local ids = {}

							for k, pass in v10.passes do
								if not pass.id then
									continue
								end

								local id = tostring(pass.id)
								passesById[id] = pass
								table.insert(ids, id)
							end

							local gamePassStore = module3.Game.getGamePassStore(false)
							gamePassStore.updateGamePassInfos(passesById)
							gamePassStore.updateUniversePasses({ [value] = ids })
						end
					else
						object:dispatch(module12(value, v10.passes))

						if v10 and v10.passIds then
							object:dispatch(module17(p2, v10.passIds))
						end
					end
				end

				local v11 = parseFollowingStatus(experienceDetails, value)

				if v11 and v11.canFollow ~= nil and v11.isFollowing ~= nil then
					object:dispatch(module13(value, v11.canFollow, v11.isFollowing))
				end

				if v11 and v11.count ~= nil then
					object:dispatch(module10(v11.count))
				end

				if v11 and v11.limit ~= nil then
					object:dispatch(module11(v11.limit))
				end

				local badges = experienceDetails.badges

				if badges then
					object:dispatch(module14(value, badges))
				end

				local socialLinks = experienceDetails.socialLinks

				local v12 = socialLinks and module18(socialLinks, value)

				if v12 then
					object:dispatch(module15(value, v12))
				end

				if getAppFeaturePolicies().getCommunityLinksEnabled() then
					local v13 = value
					local communityLinks = experienceDetails.communityLinks
					local result2

					if communityLinks then
						local success2
						success2, result2 = pcall(communityInfo.fromJsonData, communityLinks)

						if not success2 then
							local logParseFailure = module5.logParseFailure

							if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
								v13 = nil
							end

							logParseFailure("communityLinks", v13)
							result2 = nil
						end
					end

					if result2 and result2.visibility == communityVisibility.Public then
						object:dispatch(setExperienceCommunityLink(value, result2))
					end
				end

				local v13 = parseAgeRecommendations(experienceDetails, value)

				if v13 then
					object:dispatch(setAgeRecommendation(value, v13.ageRecommendationDetailsData))
					object:dispatch(setAgeRecommendationHeaders(
						v13.headerDisplayName,
						v13.headerDisplayNameShort
					))
				end

				if not fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
					return responseBody
				end

				module5.logFetchSuccess(if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then value else nil)

				return responseBody
			end
		end):catch(function(p5)
			if p5 and p5.StatusCode == 404 then
				object:dispatch(setGameDetailError(value, enumGameDetailErrorTypes.ExperienceUnavailable))
			end

			if fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
				local logFetchFailure = module5.logFetchFailure

				local statusCode = if p5 then p5.StatusCode else nil
				local v8 = if p5 then p5.StatusMessage else nil
				logFetchFailure(value, statusCode, v8)
			end

			return module4.reject(p5)
		end)
	end)
end

return v6
