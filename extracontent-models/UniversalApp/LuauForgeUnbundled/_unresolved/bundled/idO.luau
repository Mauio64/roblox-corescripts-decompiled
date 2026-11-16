local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local module2 = require("@luauforge/bundled/foD")
local module3 = require("@luauforge/bundled/hZg")
local module4 = require("@luauforge/bundled/idP")
local module5 = require("@luauforge/bundled/idQ")
local module6 = require("@luauforge/bundled/idR")
local module7 = require("@luauforge/bundled/idS")
local module8 = require("@luauforge/bundled/idT")
local module9 = require("@luauforge/bundled/hZz")
local module10 = require("@luauforge/bundled/dCp")
local sessionType = require("@luauforge/bundled/foF").SessionType
local setGamePlaySession = require("@luauforge/bundled/foF").SetGamePlaySession
local module11 = require("@luauforge/bundled/dwA")

local fFlagProfilePlatformFavoritesEnableGameDetailAnalytics = SharedFlags.FFlagProfilePlatformFavoritesEnableGameDetailAnalytics
local fFlagProfilePlatformImproveGameDetailsAnalytics = SharedFlags.FFlagProfilePlatformImproveGameDetailsAnalytics
local fFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local fFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport

return {
	get = function(p2, p3, object)
		local v5 = {
			[module10.Home] = "home",
			[module10.Games] = "games",
			[module10.SearchPage] = "gameSearch",
			[module10.GameDetail] = "gameDetails",
			[module10.Chat] = "chat",
			[module10.SongDetail] = fFlagEnableTopSongsSort and "songDetails" or nil,
			ChartsSortDetail = "games",
			HomeSortDetail = fFlagLuaAppSduiHomePageSupport and "home" or nil
		}

		local function getPageName(p4)
			local v6 = v5[p4]

			if v6 then
				return v6
			end

			return p4
		end

		local function startGameDetailSourceSession()
			setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)
		end

		local function startGamePlayFromFriendsListSession()
			setGamePlaySession(p2, sessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
		end

		local v6 = {}

		function v6.reportSeeAllWithId(p4, p5, p6)
			object:setRBXEventStream("SeeAll", "gamesPageInteraction", {
				aType = "touch",
				aValue = tostring(p4),
				gameSetTargetId = p5,
				pos = tonumber(p6)
			})
		end

		function v6.reportFilterChangeWithId(p4, p5, p6)
			object:setRBXEventStream("SFMenu", "gamesPageInteraction", {
				aType = "touch",
				aValue = tostring(p4),
				gameSetTargetId = p5,
				pos = tonumber(p6)
			})
		end

		local function reportGameDetailReferralWithId(p4, p5, p6, p7, p8, p9, p10, p11, value, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, value2)
			local robloxLocaleId = LocalizationService.RobloxLocaleId
			setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)

			module9(object, p4, {
				pg = p4,
				tis = p10,
				sortPos = p8,
				pid = p5,
				ad = p11 and "yes" or "no",
				isAd = p11,
				nativeAdData = value or "",
				universeId = p12,
				navigationUniverseId = p13,
				pos = p9,
				gameSetTypeId = p6,
				gameSetTargetId = p7,
				locale = robloxLocaleId,
				appliedFilters = p14,
				topicDataPosition = p15 or p9,
				isSdui = p16,
				positionInRow = p17,
				rowNumber = p18,
				rowOnPage = p19,
				heroUnitId = p20,
				loadSource = p21,
				tileType = p22,
				sortSubId = p23,
				analyticsData = p24,
				seeAllFlag = value2 or 0
			})
		end

		function v6.reportOpenGameDetailWithId(p4, p5, p6, p7, p8, p9, p10, value, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25)
			reportGameDetailReferralWithId(
				v5[p12] or p12,
				p4,
				p5,
				p6,
				p7,
				p8,
				p9,
				p10,
				value or "",
				p11,
				p13,
				p14,
				p15,
				p16,
				p17,
				p18,
				p19,
				p20,
				p21,
				p22,
				p23,
				p24,
				p25
			)
		end

		function v6.reportOpenGameDetailFromGameDetail(p4, p5, p6, p7, value, p8, p9, p10)
			local v7 = v5[p9] or p9

			module9(object, v7, {
				pg = v7,
				pos = p5,
				tis = p6,
				sortPos = 0,
				refId = p10,
				pid = p4,
				ad = p7 and "yes" or "no",
				nativeAdData = value or "",
				src = "recommended",
				universeId = p8
			})
		end

		if fFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
			function v6.reportOpenGameDetailFromProfile(pid, pos, tis, universeId, p4, sortPos, rowOnPage, friendId)
				local v7 = v5[p4] or p4

				setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)

				if not fFlagProfilePlatformImproveGameDetailsAnalytics then
					friendId = nil
				end

				module9(object, v7, {
					ad = "no",
					friendId = friendId,
					pg = v7,
					pid = pid,
					pos = pos,
					rowOnPage = rowOnPage,
					sortPos = sortPos,
					tis = tis,
					universeId = universeId
				})
			end
		end

		if fFlagProfilePlatformImproveGameDetailsAnalytics then
			function v6.reportOpenGameDetailFromProfileContext(p4, p5, p6, p7, p8)
				setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)
				module9(object, p8, {
					ad = "no",
					friendId = p7,
					pg = v5[p6] or p6,
					pid = p4,
					universeId = p5
				})
			end
		end

		function v6.reportOpenGameDetailFromSearch(p4, p5, p6, p7, value, p8, p9, p10, p11, p12, p13, p14, value2)
			local v7 = v5[p9] or p9

			setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)
			module9(object, v7, {
				pg = v5[p9] or p9,
				tis = p6,
				pid = p4,
				ad = p7 and "yes" or "no",
				nativeAdData = value or "",
				universeId = p8,
				pos = p5,
				sortPos = p10,
				gameSetTypeId = p11,
				rowOnPage = p12,
				topicDataPosition = p13 or p5,
				tileType = p14,
				seeAllFlag = value2 or 0
			})
		end

		function v6.reportOpenGameDetailFromPeopleList(p4, p5, p6, p7, p8, p9, p10)
			local home = module10.Home
			local v7 = v5[home] or home

			setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)

			module9(object, p10, {
				pg = v7,
				friendId = p4,
				position = p5,
				absolutePosition = p6,
				pid = p7,
				universeId = p8,
				fromWhere = p9
			})
		end

		function v6.reportOpenGameDetailFromChat(p4, p5, p6, p7)
			local chat = module10.Chat
			local v7 = v5[chat] or chat

			setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)

			module9(object, p7, {
				pg = v7,
				pid = p4,
				universeId = p6,
				conversationId = p5
			})
		end

		function v6.reportPeopleListInteraction(p4, p5, p6, p7, p8, p9)
			module5(p3.EventStream, p4, p5, p6, p8, p7, p9)
		end

		function v6.reportViewProfileFromPeopleList(p4, p5, p6, p7, p8)
			module6(p3.EventStream, p4, p5, p6, p7, p8)
		end

		function v6.reportPeopleListJoinGame(p4, p5, p6, p7, p8, p9, p10, p11, p12)
			setGamePlaySession(p2, sessionType.StructuralIdentifier.GamePlayFromFriendsList, true)

			object:setRBXEventStream("contactFriendFinder", "joinGameInPeopleList", {
				uid = tostring(Players.LocalPlayer.UserId),
				friendId = p4,
				position = p5,
				absolutePosition = p6,
				rootPlaceId = p8,
				gameInstanceId = p9,
				inGameFriendCount = p10,
				joinAttemptId = p11,
				source = p12
			})
			module3(object, module11.AnalyticsContext.PeopleListInHomePage, {
				placeId = p7,
				rootPlaceId = p8,
				joinAttemptId = p11,
				friendId = p4
			})
		end

		function v6.reportJoinGameInPlacesList(p4, p5, p6, p7, p8)
			module4(p3.EventStream, p4, p5, p6, p7, p8)
			module3(object, module11.AnalyticsContext.GamePlayIntentInPlacesList, {
				placeId = p5,
				rootPlaceId = p6,
				joinAttemptId = p8,
				friendId = p4
			})
		end

		if fFlagEnableTopSongsSort then
			function v6.reportOpenGameDetailFromSongDetail(p4, p5, p6, p7, value, p8, p9, p10)
				setGamePlaySession(p2, sessionType.StructuralIdentifier.GameDetailSource, false)
				local v7 = v5[p9] or p9

				module9(object, v7, {
					pg = v7,
					pos = p5,
					tis = p6,
					sortPos = 0,
					refSongId = p10,
					pid = p4,
					ad = p7 and "yes" or "no",
					nativeAdData = value or "",
					src = "songDetails",
					universeId = p8
				})
			end
		end

		function v6.reportOpenModalFromGameTileForPlacesList(p4)
			module7(p3.EventStream, p4)
		end

		function v6.reportButtonClicked(p4, p5)
			module2(p3.EventStream, p4, p5)
		end

		function v6.reportTouchSearchInsteadForPlayerNamed(p4, p5)
			module2(p3.EventStream, v5[p5] or p5, "searchInsteadForPlayerNamed", p4)
		end

		function v6.reportTouchSwipe(p4, p5, p6, p7)
			module8(p3.EventStream, p4, p5, p6, p7)
		end

		return v6
	end
}
