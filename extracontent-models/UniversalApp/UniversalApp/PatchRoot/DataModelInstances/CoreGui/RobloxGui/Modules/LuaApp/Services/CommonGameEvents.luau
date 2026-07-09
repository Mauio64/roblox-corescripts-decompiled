local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local buttonClick = require(Modules.LuaApp.Analytics.Events.buttonClick)
local gamePlayIntent = require(Modules.LuaApp.Analytics.Events.Games.gamePlayIntent)
local joinGameInPlacesList = require(Modules.LuaApp.Analytics.Events.joinGameInPlacesList)
local peopleListInteractionV2 = require(Modules.LuaApp.Analytics.Events.peopleListInteractionV2)
local peopleListViewGameDetail = require(Modules.LuaApp.Analytics.Events.peopleListViewGameDetail)
local openModalFromGameTile = require(Modules.LuaApp.Analytics.Events.openModalFromGameTile)
local touchSwipe = require(Modules.LuaApp.Analytics.Events.touchSwipe)
local gameDetailReferral = require(Modules.LuaApp.Analytics.Events.Games.gameDetailReferral)
local AppPage = require(Modules.LuaApp.AppPage)
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local SetGamePlaySession = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SetGamePlaySession
local Constants = require(Modules.LuaApp.Constants)
local FFlagProfilePlatformFavoritesEnableGameDetailAnalytics = SharedFlags.FFlagProfilePlatformFavoritesEnableGameDetailAnalytics
local FFlagProfilePlatformImproveGameDetailsAnalytics = SharedFlags.FFlagProfilePlatformImproveGameDetailsAnalytics
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local FFlagLuaAppAddSubIdToHomeEvents = SharedFlags.FFlagLuaAppAddSubIdToHomeEvents
local v22 = game:DefineFastFlag("SduiChartsAnalyticsPage", false)

return {
	get = function(p1, p2, p3) -- line: 35
		-- upvalues: AppPage (copy), FFlagEnableTopSongsSort (copy), v22 (copy), SetGamePlaySession (copy), SessionType (copy), LocalizationService (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), gameDetailReferral (copy), FFlagProfilePlatformFavoritesEnableGameDetailAnalytics (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), peopleListInteractionV2 (copy), peopleListViewGameDetail (copy), Players (copy), Constants (copy), gamePlayIntent (copy), joinGameInPlacesList (copy), openModalFromGameTile (copy), buttonClick (copy), touchSwipe (copy)
		local t1 = {
			[AppPage.Home] = "home",
			[AppPage.Games] = "games",
			[AppPage.SearchPage] = "gameSearch",
			[AppPage.GameDetail] = "gameDetails",
			[AppPage.Chat] = "chat",
			[AppPage.SongDetail] = if not FFlagEnableTopSongsSort then nil else "songDetails",
			ChartsSortDetail = if not v22 then nil else "games"
		}

		local function getPageName(p4) -- line: 46
			-- upvalues: t1 (copy)
			local v33 = t1[p4]

			if v33 then
				return v33
			end

			return p4
		end
		local function startGameDetailSourceSession() -- line: 55
			-- upvalues: SetGamePlaySession (copy), p1 (copy), SessionType (copy)
			SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)
		end
		local function startGamePlayFromFriendsListSession() -- line: 59
			-- upvalues: SetGamePlaySession (copy), p1 (copy), SessionType (copy)
			SetGamePlaySession(p1, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
		end

		local t4 = {
			reportSeeAllWithId = function(p5, p6, p7) -- line: 65
				-- upvalues: p3 (copy)
				local t2 = {
					aType = "touch",
					aValue = tostring(p5),
					gameSetTargetId = p6,
					pos = tonumber(p7)
				}

				p3:setRBXEventStream("SeeAll", "gamesPageInteraction", t2)
			end,
			reportFilterChangeWithId = function(p8, p9, p10) -- line: 78
				-- upvalues: p3 (copy)
				local t3 = {
					aType = "touch",
					aValue = tostring(p8),
					gameSetTargetId = p9,
					pos = tonumber(p10)
				}

				p3:setRBXEventStream("SFMenu", "gamesPageInteraction", t3)
			end
		}

		local function reportGameDetailReferralWithId(p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32) -- line: 91
			-- upvalues: LocalizationService (copy), SetGamePlaySession (copy), p1 (copy), SessionType (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), gameDetailReferral (copy), p3 (copy)
			local RobloxLocaleId = LocalizationService.RobloxLocaleId
			local v65 = p19 or ""

			SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)

			local t5 = {
				pg = p11,
				tis = p17,
				sortPos = p15,
				pid = p12,
				ad = not p18 and "no" or "yes",
				isAd = p18,
				nativeAdData = v65,
				universeId = p20,
				navigationUniverseId = p21,
				pos = p16,
				gameSetTypeId = p13,
				gameSetTargetId = p14,
				locale = RobloxLocaleId,
				appliedFilters = p22,
				topicDataPosition = p23 or p16,
				isSdui = p24,
				positionInRow = p25,
				rowNumber = p26,
				rowOnPage = p27,
				heroUnitId = p28,
				loadSource = p29,
				tileType = p30,
				sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else p31,
				analyticsData = p32
			}

			gameDetailReferral(p3, p11, t5)
		end

		function t4.reportOpenGameDetailWithId(p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54) -- line: 149
			-- upvalues: reportGameDetailReferralWithId (copy), t1 (copy), FFlagLuaAppAddSubIdToHomeEvents (copy)
			reportGameDetailReferralWithId(t1[p42] or p42, p33, p34, p35, p36, p37, p38, p39, p40 or "", p41, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, if not FFlagLuaAppAddSubIdToHomeEvents then nil else p53, p54)
		end
		function t4.reportOpenGameDetailFromGameDetail(p55, p56, p57, p58, p59, p60, p61, p62) -- line: 199
			-- upvalues: t1 (copy), gameDetailReferral (copy), p3 (copy)
			local v97 = t1[p61] or p61
			local v98 = not p58 and "no" or "yes"
			local v99 = p59 or ""
			local t6 = {
				sortPos = 0,
				src = "recommended",
				pg = v97,
				pos = p56,
				tis = p57,
				refId = p62,
				pid = p55,
				ad = v98,
				nativeAdData = v99,
				universeId = p60
			}

			gameDetailReferral(p3, v97, t6)
		end

		if FFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
			function t4.reportOpenGameDetailFromProfile(p63, p64, p65, p66, p67, p68, p69, p70) -- line: 230
				-- upvalues: t1 (copy), SetGamePlaySession (copy), p1 (copy), SessionType (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), gameDetailReferral (copy), p3 (copy)
				local v109 = t1[p67] or p67

				SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)

				local t7 = {
					ad = "no",
					friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else p70,
					pg = v109,
					pid = p63,
					pos = p64,
					rowOnPage = p69,
					sortPos = p68,
					tis = p65,
					universeId = p66
				}

				gameDetailReferral(p3, v109, t7)
			end
		end

		if FFlagProfilePlatformImproveGameDetailsAnalytics then
			function t4.reportOpenGameDetailFromProfileContext(p71, p72, p73, p74, p75) -- line: 260
				-- upvalues: SetGamePlaySession (copy), p1 (copy), SessionType (copy), t1 (copy), gameDetailReferral (copy), p3 (copy)
				SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)

				local t8 = {
					ad = "no",
					friendId = p74,
					pg = t1[p73] or p73,
					pid = p71,
					universeId = p72
				}

				gameDetailReferral(p3, p75, t8)
			end
		end

		function t4.reportOpenGameDetailFromSearch(p76, p77, p78, p79, p80, p81, p82, p83, p84, p85, p86, p87) -- line: 275
			-- upvalues: t1 (copy), SetGamePlaySession (copy), p1 (copy), SessionType (copy), gameDetailReferral (copy), p3 (copy)
			local v129 = t1[p82] or p82
			local v130 = p80 or ""

			SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)

			local t9 = {
				pg = t1[p82] or p82,
				tis = p78,
				pid = p76,
				ad = not p79 and "no" or "yes",
				nativeAdData = v130,
				universeId = p81,
				pos = p77,
				sortPos = p83,
				gameSetTypeId = p84,
				rowOnPage = p85,
				topicDataPosition = p86 or p77,
				tileType = p87
			}

			gameDetailReferral(p3, v129, t9)
		end
		function t4.reportOpenGameDetailFromPeopleList(p88, p89, p90, p91, p92, p93, p94) -- line: 311
			-- upvalues: AppPage (copy), t1 (copy), SetGamePlaySession (copy), p1 (copy), SessionType (copy), gameDetailReferral (copy), p3 (copy)
			local Home = AppPage.Home
			local v140 = t1[Home] or Home

			SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)

			local t10 = {
				pg = v140,
				friendId = p88,
				position = p89,
				absolutePosition = p90,
				pid = p91,
				universeId = p92,
				fromWhere = p93
			}

			gameDetailReferral(p3, p94, t10)
		end
		function t4.reportOpenGameDetailFromChat(p95, p96, p97, p98) -- line: 336
			-- upvalues: AppPage (copy), t1 (copy), SetGamePlaySession (copy), p1 (copy), SessionType (copy), gameDetailReferral (copy), p3 (copy)
			local Chat = AppPage.Chat
			local v147 = t1[Chat] or Chat

			SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)

			local t11 = {
				pg = v147,
				pid = p95,
				universeId = p97,
				conversationId = p96
			}

			gameDetailReferral(p3, p98, t11)
		end
		function t4.reportPeopleListInteraction(p99, p100, p101, p102, p103, p104) -- line: 349
			-- upvalues: peopleListInteractionV2 (copy), p2 (copy)
			peopleListInteractionV2(p2.EventStream, p99, p100, p101, p103, p102, p104)
		end
		function t4.reportViewProfileFromPeopleList(p105, p106, p107, p108, p109) -- line: 361
			-- upvalues: peopleListViewGameDetail (copy), p2 (copy)
			peopleListViewGameDetail(p2.EventStream, p105, p106, p107, p108, p109)
		end
		function t4.reportPeopleListJoinGame(p110, p111, p112, p113, p114, p115, p116, p117, p118) -- line: 372
			-- upvalues: SetGamePlaySession (copy), p1 (copy), SessionType (copy), Players (copy), p3 (copy), Constants (copy), gamePlayIntent (copy)
			SetGamePlaySession(p1, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)

			local t12 = {
				uid = tostring(Players.LocalPlayer.UserId),
				friendId = p110,
				position = p111,
				absolutePosition = p112,
				rootPlaceId = p114,
				gameInstanceId = p115,
				inGameFriendCount = p116,
				joinAttemptId = p117,
				source = p118
			}

			p3:setRBXEventStream("contactFriendFinder", "joinGameInPeopleList", t12)

			local PeopleListInHomePage = Constants.AnalyticsContext.PeopleListInHomePage

			gamePlayIntent(p3, PeopleListInHomePage, {
				placeId = p113,
				rootPlaceId = p114,
				joinAttemptId = p117,
				friendId = p110
			})
		end
		function t4.reportJoinGameInPlacesList(p119, p120, p121, p122, p123) -- line: 407
			-- upvalues: joinGameInPlacesList (copy), p2 (copy), Constants (copy), gamePlayIntent (copy), p3 (copy)
			joinGameInPlacesList(p2.EventStream, p119, p120, p121, p122, p123)

			local GamePlayIntentInPlacesList = Constants.AnalyticsContext.GamePlayIntentInPlacesList

			gamePlayIntent(p3, GamePlayIntentInPlacesList, {
				placeId = p120,
				rootPlaceId = p121,
				joinAttemptId = p123,
				friendId = p119
			})
		end

		if FFlagEnableTopSongsSort then
			function t4.reportOpenGameDetailFromSongDetail(p124, p125, p126, p127, p128, p129, p130, p131) -- line: 419
				-- upvalues: SetGamePlaySession (copy), p1 (copy), SessionType (copy), t1 (copy), gameDetailReferral (copy), p3 (copy)
				SetGamePlaySession(p1, SessionType.StructuralIdentifier.GameDetailSource, false)

				local v185 = t1[p130] or p130
				local v186 = not p127 and "no" or "yes"
				local v187 = p128 or ""
				local t13 = {
					sortPos = 0,
					src = "songDetails",
					pg = v185,
					pos = p125,
					tis = p126,
					refSongId = p131,
					pid = p124,
					ad = v186,
					nativeAdData = v187,
					universeId = p129
				}

				gameDetailReferral(p3, v185, t13)
			end
		end

		function t4.reportOpenModalFromGameTileForPlacesList(p132) -- line: 451
			-- upvalues: openModalFromGameTile (copy), p2 (copy)
			openModalFromGameTile(p2.EventStream, p132)
		end
		function t4.reportButtonClicked(p133, p134) -- line: 455
			-- upvalues: buttonClick (copy), p2 (copy)
			buttonClick(p2.EventStream, p133, p134)
		end
		function t4.reportTouchSearchInsteadForPlayerNamed(p135, p136) -- line: 459
			-- upvalues: buttonClick (copy), p2 (copy), t1 (copy)
			buttonClick(p2.EventStream, t1[p136] or p136, "searchInsteadForPlayerNamed", p135)
		end
		function t4.reportTouchSwipe(p137, p138, p139, p140) -- line: 463
			-- upvalues: touchSwipe (copy), p2 (copy)
			touchSwipe(p2.EventStream, p137, p138, p139, p140)
		end

		return t4
	end
}
