local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local parent = DiscoveryAnalytics.Parent

local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")

local Constants = require(DiscoveryAnalytics.Constants)
local Context = Constants.Context
local buttonClick = require(parent.Analytics.buttonClick)
local gameDetailReferral = require(DiscoveryAnalytics.Events.gameDetailReferral)
local gamePlayIntent = require(DiscoveryAnalytics.Events.gamePlayIntent)
local joinGameInPlacesList = require(DiscoveryAnalytics.Events.joinGameInPlacesList)
local openModalFromGameTile = require(DiscoveryAnalytics.Events.openModalFromGameTile)
local peopleListInteractionV2 = require(DiscoveryAnalytics.Events.peopleListInteractionV2)
local peopleListViewGameDetail = require(DiscoveryAnalytics.Events.peopleListViewGameDetail)
local touchSwipe = require(DiscoveryAnalytics.Events.touchSwipe)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession

local SharedFlags = require(parent.SharedFlags)

local FFlagProfilePlatformFavoritesEnableGameDetailAnalytics = SharedFlags.FFlagProfilePlatformFavoritesEnableGameDetailAnalytics
local FFlagProfilePlatformImproveGameDetailsAnalytics = SharedFlags.FFlagProfilePlatformImproveGameDetailsAnalytics
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local FFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport

return {
	get = function(p, p2, object)
		local v = {
			[AppPage.Home] = "home",
			[AppPage.Games] = "games",
			[AppPage.SearchPage] = "gameSearch",
			[AppPage.GameDetail] = "gameDetails",
			[AppPage.Chat] = "chat",
			[AppPage.SongDetail] = FFlagEnableTopSongsSort and "songDetails" or nil,
			ChartsSortDetail = "games",
			HomeSortDetail = FFlagLuaAppSduiHomePageSupport and "home" or nil
		}

		local function getPageName(p3)
			return v[p3] or p3
		end

		local function startGameDetailSourceSession() -- 7 equivalent calls inferred from this helper
			SetGamePlaySession(p, SessionType.StructuralIdentifier.GameDetailSource, false)
		end

		local function startGamePlayFromFriendsListSession() -- 1 equivalent call inferred from this helper
			SetGamePlaySession(p, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
		end

		local v2 = {}

		function v2.reportSeeAllWithId(p3, gameSetTargetId, p4)
			object:setRBXEventStream("SeeAll", "gamesPageInteraction", {
				aType = "touch",
				aValue = tostring(p3),
				gameSetTargetId = gameSetTargetId,
				pos = tonumber(p4)
			})
		end

		function v2.reportFilterChangeWithId(p3, gameSetTargetId, p4)
			object:setRBXEventStream("SFMenu", "gamesPageInteraction", {
				aType = "touch",
				aValue = tostring(p3),
				gameSetTargetId = gameSetTargetId,
				pos = tonumber(p4)
			})
		end

		local function reportGameDetailReferralWithId(pg, pid, gameSetTypeId, gameSetTargetId, sortPos, pos, tis, isAd, value, universeId, navigationUniverseId, appliedFilters, p3, isSdui, positionInRow, rowNumber, rowOnPage, heroUnitId, loadSource, tileType, sortSubId, analyticsData, value2)
			local robloxLocaleId = LocalizationService.RobloxLocaleId
			startGameDetailSourceSession() -- inferred equivalent call
			gameDetailReferral(object, pg, {
				pg = pg,
				tis = tis,
				sortPos = sortPos,
				pid = pid,
				ad = isAd and "yes" or "no",
				isAd = isAd,
				nativeAdData = value or "",
				universeId = universeId,
				navigationUniverseId = navigationUniverseId,
				pos = pos,
				gameSetTypeId = gameSetTypeId,
				gameSetTargetId = gameSetTargetId,
				locale = robloxLocaleId,
				appliedFilters = appliedFilters,
				topicDataPosition = p3 or pos,
				isSdui = isSdui,
				positionInRow = positionInRow,
				rowNumber = rowNumber,
				rowOnPage = rowOnPage,
				heroUnitId = heroUnitId,
				loadSource = loadSource,
				tileType = tileType,
				sortSubId = sortSubId,
				analyticsData = analyticsData,
				seeAllFlag = value2 or 0
			})
		end

		function v2.reportOpenGameDetailWithId(pid, gameSetTypeId, gameSetTargetId, sortPos, pos, tis, isAd, value, universeId, p3, navigationUniverseId, appliedFilters, p4, isSdui, positionInRow, rowNumber, rowOnPage, heroUnitId, loadSource, tileType, sortSubId, analyticsData, p5)
			reportGameDetailReferralWithId(
				v[p3] or p3,
				pid,
				gameSetTypeId,
				gameSetTargetId,
				sortPos,
				pos,
				tis,
				isAd,
				value or "",
				universeId,
				navigationUniverseId,
				appliedFilters,
				p4,
				isSdui,
				positionInRow,
				rowNumber,
				rowOnPage,
				heroUnitId,
				loadSource,
				tileType,
				sortSubId,
				analyticsData,
				p5
			)
		end

		function v2.reportOpenGameDetailFromGameDetail(pid, pos, tis, p3, value, universeId, p4, refId)
			local pg = v[p4] or p4

			gameDetailReferral(object, pg, {
				pg = pg,
				pos = pos,
				tis = tis,
				sortPos = 0,
				refId = refId,
				pid = pid,
				ad = p3 and "yes" or "no",
				nativeAdData = value or "",
				src = "recommended",
				universeId = universeId
			})
		end

		if FFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
			function v2.reportOpenGameDetailFromProfile(pid, pos, tis, universeId, p3, sortPos, rowOnPage, friendId)
				local pg = v[p3] or p3
				startGameDetailSourceSession() -- inferred equivalent call

				if not FFlagProfilePlatformImproveGameDetailsAnalytics then
					friendId = nil
				end

				gameDetailReferral(object, pg, {
					ad = "no",
					friendId = friendId,
					pg = pg,
					pid = pid,
					pos = pos,
					rowOnPage = rowOnPage,
					sortPos = sortPos,
					tis = tis,
					universeId = universeId
				})
			end
		end

		if FFlagProfilePlatformImproveGameDetailsAnalytics then
			function v2.reportOpenGameDetailFromProfileContext(pid, universeId, p3, friendId, p4)
				startGameDetailSourceSession() -- inferred equivalent call
				gameDetailReferral(object, p4, {
					ad = "no",
					friendId = friendId,
					pg = v[p3] or p3,
					pid = pid,
					universeId = universeId
				})
			end
		end

		function v2.reportOpenGameDetailFromSearch(pid, pos, tis, p3, value, universeId, p4, sortPos, gameSetTypeId, rowOnPage, p5, tileType, value2)
			local v3 = v[p4] or p4
			startGameDetailSourceSession() -- inferred equivalent call
			gameDetailReferral(object, v3, {
				pg = v[p4] or p4,
				tis = tis,
				pid = pid,
				ad = p3 and "yes" or "no",
				nativeAdData = value or "",
				universeId = universeId,
				pos = pos,
				sortPos = sortPos,
				gameSetTypeId = gameSetTypeId,
				rowOnPage = rowOnPage,
				topicDataPosition = p5 or pos,
				tileType = tileType,
				seeAllFlag = value2 or 0
			})
		end

		function v2.reportOpenGameDetailFromPeopleList(friendId, position, absolutePosition, pid, universeId, fromWhere, p3)
			local home = AppPage.Home
			local pg = v[home] or home
			startGameDetailSourceSession() -- inferred equivalent call
			gameDetailReferral(object, p3, {
				pg = pg,
				friendId = friendId,
				position = position,
				absolutePosition = absolutePosition,
				pid = pid,
				universeId = universeId,
				fromWhere = fromWhere
			})
		end

		function v2.reportOpenGameDetailFromChat(pid, conversationId, universeId, p3)
			local chat = AppPage.Chat
			local pg = v[chat] or chat
			startGameDetailSourceSession() -- inferred equivalent call
			gameDetailReferral(object, p3, {
				pg = pg,
				pid = pid,
				universeId = universeId,
				conversationId = conversationId
			})
		end

		function v2.reportPeopleListInteraction(p3, p4, p5, p6, p7, p8)
			peopleListInteractionV2(p2.EventStream, p3, p4, p5, p7, p6, p8)
		end

		function v2.reportViewProfileFromPeopleList(p3, p4, p5, p6, p7)
			peopleListViewGameDetail(p2.EventStream, p3, p4, p5, p6, p7)
		end

		function v2.reportPeopleListJoinGame(friendId, position, absolutePosition, placeId, rootPlaceId, gameInstanceId, inGameFriendCount, joinAttemptId, source)
			startGamePlayFromFriendsListSession() -- inferred equivalent call
			object:setRBXEventStream("contactFriendFinder", "joinGameInPeopleList", {
				uid = tostring(Players.LocalPlayer.UserId),
				friendId = friendId,
				position = position,
				absolutePosition = absolutePosition,
				rootPlaceId = rootPlaceId,
				gameInstanceId = gameInstanceId,
				inGameFriendCount = inGameFriendCount,
				joinAttemptId = joinAttemptId,
				source = source
			})
			gamePlayIntent(object, Context.PeopleListInHomePage, {
				placeId = placeId,
				rootPlaceId = rootPlaceId,
				joinAttemptId = joinAttemptId,
				friendId = friendId
			})
		end

		function v2.reportJoinGameInPlacesList(friendId, placeId, rootPlaceId, p3, joinAttemptId)
			joinGameInPlacesList(p2.EventStream, friendId, placeId, rootPlaceId, p3, joinAttemptId)
			gamePlayIntent(object, Context.GamePlayIntentInPlacesList, {
				placeId = placeId,
				rootPlaceId = rootPlaceId,
				joinAttemptId = joinAttemptId,
				friendId = friendId
			})
		end

		if FFlagEnableTopSongsSort then
			function v2.reportOpenGameDetailFromSongDetail(pid, pos, tis, p3, value, universeId, p4, refSongId)
				startGameDetailSourceSession() -- inferred equivalent call
				local pg = v[p4] or p4

				gameDetailReferral(object, pg, {
					pg = pg,
					pos = pos,
					tis = tis,
					sortPos = 0,
					refSongId = refSongId,
					pid = pid,
					ad = p3 and "yes" or "no",
					nativeAdData = value or "",
					src = "songDetails",
					universeId = universeId
				})
			end
		end

		function v2.reportOpenModalFromGameTileForPlacesList(p3)
			openModalFromGameTile(p2.EventStream, p3)
		end

		function v2.reportButtonClicked(p3, p4)
			buttonClick(p2.EventStream, p3, p4)
		end

		function v2.reportTouchSearchInsteadForPlayerNamed(p3, p4)
			buttonClick(p2.EventStream, v[p4] or p4, "searchInsteadForPlayerNamed", p3)
		end

		function v2.reportTouchSwipe(p3, p4, p5, p6)
			touchSwipe(p2.EventStream, p3, p4, p5, p6)
		end

		return v2
	end
}
