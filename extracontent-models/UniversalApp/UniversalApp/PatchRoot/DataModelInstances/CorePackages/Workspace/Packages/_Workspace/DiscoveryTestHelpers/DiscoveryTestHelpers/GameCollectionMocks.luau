local Parent = script:FindFirstAncestor("DiscoveryTestHelpers").Parent
local GameInfosReducer = require(Parent.GameInfosRodux).GameInfosReducer
local TopicInfosRodux = require(Parent.TopicInfosRodux)
local TopicInfosReducer = TopicInfosRodux.TopicInfosReducer
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local FetchStatusRodux = require(Parent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local TopicContentsReducer = require(Parent.TopicContentsRodux).TopicContentsReducer
local NextDataExpirationTimeRodux = require(Parent.NextDataExpirationTimeRodux)
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace

local function mockEntry(n1: number) -- line: 15
	return {
		ageRecommendationDisplayName = "",
		contentType = "Game",
		friendVisitedString = "",
		isSponsored = false,
		minimumAge = 0,
		under13 = false,
		under9 = false,
		contentId = `{ n1 }`,
		friendVisits = {},
		name = `name { n1 }`,
		placeId = `{ n1 }00`,
		playerCount = n1,
		totalDownVotes = n1,
		totalUpVotes = n1,
		universeId = `{ n1 }`,
		adId = `adId{ n1 }`
	}
end
local function mockTopicInfoFromOmni(p1, p2, p3) -- line: 36
	-- upvalues: TopicInfoModel (copy)
	local v20 = TopicInfoModel.mockFromOmniApi(p1)

	v20.displayName = p2
	v20.treatmentType = p3

	return v20
end
local function mockTopicContents(_: string, n2: number) -- line: 43
	-- upvalues: mockEntry (copy)
	local t1 = {}

	for i = 1, n2 do
		table.insert(t1, (mockEntry(i)))
	end

	return {
		hasMoreRows = false,
		nextPageExclusiveStartId = 0,
		nextPageToken = "",
		rowsRequested = 0,
		updatedTimestamp = 1718290975.274871,
		entries = t1
	}
end

return {
	mockEntry = mockEntry,
	mockTopicContents = mockTopicContents,
	mockGameSortForExploreApi = function(s2: string, s3: string, n3: number) -- line: 58
		-- upvalues: TopicInfoModel (copy)
		local v28 = TopicInfoModel.mockFromExploreJsonData(s2, "")

		v28.displayIcon = "test-display-icon"
		v28.displayName = "test-display-name"
		v28.gameSetTypeId = s3
		v28.gameSetTargetId = n3

		return v28
	end,
	mockStoreStateForOmniApi = function(s4: string, s5: string, _: number, n5: number, s6: string) -- line: 67
		-- upvalues: mockEntry (copy), GameInfosReducer (copy), TopicContentsReducer (copy), mockTopicContents (copy), TopicInfosReducer (copy), TopicInfoModel (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy)
		local t2 = {}
		local t3 = {}
		local t4 = {}
		local t5 = {}
		local t6 = {}

		for i = 1, n5 do
			table.insert(t2, {
				contentType = "Game",
				contentId = i
			})
			table.insert(t3, (mockEntry(i)))
			t4[`{ i }`] = mockEntry(i)
			t5[`{ i }`] = {
				PlayabilityStatus = "Playable"
			}
			t6[`{ i }`] = {
				summary = {
					ageRecommendation = {{
						ageRecommendationDisplayName = "",
						minimumAge = 0
					}}
				}
			}
		end

		local t7 = {
			LocalUserId = 2,
			AgeRecommendations = t6,
			GameIconsKey = {},
			GamesProductInfoKey = {},
			GameDetails = {},
			GameDetailsPeekView = {},
			PlayabilityStatus = t5,
			Users = {},
			InGameUsersByGame = {},
			UserGameVotes = {},
			ShowAgeVerificationOverlay = {},
			GameSorts = {},
			OmniRecommendations = {
				[s5] = {
					pageType = s5,
					metadata = {
						Games = t3
					},
					sorts = {
						{
							numberOfRows = 1,
							topic = "Friends",
							topicId = "600000000",
							treatmentType = "FriendCarousel",
							recommendations = {},
							topicLayoutData = {}
						},
						{
							numberOfRows = 1,
							topic = "Continue",
							treatmentType = "Carousel",
							recommendations = t2,
							topicId = s4,
							topicLayoutData = {}
						}
					}
				}
			}
		}
		local t8 = {
			[GameInfosReducer.key] = t4,
			[TopicContentsReducer.key] = {
				[s4] = mockTopicContents(s4, n5)
			}
		}
		local key = TopicInfosReducer.key
		local t9 = {}
		local v44 = TopicInfoModel.mockFromOmniApi(s4)

		v44.displayName = "Continue"
		v44.treatmentType = "Carousel"
		t9[s4] = v44
		t8[key] = t9
		t8[FetchStatusReducer.key] = {
			[FetchStatusNamespace.GameSorts] = {
				[s4] = s6
			},
			[FetchStatusNamespace.OmniRecommendations] = {
				[s5] = s6
			}
		}
		t8[NextDataExpirationTimeReducer.key] = {
			[ExpirationTimeNamespace.GameDetailPlayability] = {}
		}
		t7.Personalization = t8
		t7.BatchFetchingStatus = {}
		t7.FetchingStatus = {}
		t7.ScreenSize = Vector2.new(100, 100)
		t7.TopBar = {
			topBarHeight = 10
		}
		t7.GlobalGuiInset = {
			bottom = 10,
			top = 10,
			left = 0,
			right = 0
		}
		t7.Navigation = {}
		t7.CentralOverlay = {
			OverlayType = nil
		}

		return t7
	end,
	mockStoreStateForExploreApi = function(s7: string, n6: number, s8: string, s9: string, n7: number) -- line: 177
		-- upvalues: mockEntry (copy), GameInfosReducer (copy), TopicContentsReducer (copy), mockTopicContents (copy), TopicInfosReducer (copy), TopicInfoModel (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy)
		local t10 = {}
		local t11 = {}
		local t12 = {}

		for i = 1, n6 do
			t10[`{ i }`] = mockEntry(i)
			t11[`{ i }`] = {
				PlayabilityStatus = "Playable"
			}
			t12[`{ i }`] = {
				summary = {
					ageRecommendation = {{
						ageRecommendationDisplayName = "",
						minimumAge = 0
					}}
				}
			}
		end

		local t13 = {
			LocalUserId = 2,
			AgeRecommendations = t12,
			GameIconsKey = {},
			GamesProductInfoKey = {},
			GameDetails = {},
			GameDetailsPeekView = {},
			PlayabilityStatus = t11,
			Users = {},
			InGameUsersByGame = {},
			UserGameVotes = {},
			ShowAgeVerificationOverlay = {},
			GameSortGroups = {
				HomeGames = {
					pageId = ""
				}
			}
		}
		local t14 = {
			[GameInfosReducer.key] = t10,
			[TopicContentsReducer.key] = {
				[s7] = mockTopicContents(s7, n6)
			}
		}
		local key = TopicInfosReducer.key
		local t15 = {}
		local v58 = TopicInfoModel.mockFromExploreJsonData(s7, "")

		v58.displayIcon = "test-display-icon"
		v58.displayName = "test-display-name"
		v58.gameSetTypeId = s9
		v58.gameSetTargetId = n7
		t15[s7] = v58
		t14[key] = t15
		t14[FetchStatusReducer.key] = {
			[FetchStatusNamespace.GameSorts] = {
				[s7] = s8
			}
		}
		t14[NextDataExpirationTimeReducer.key] = {
			[ExpirationTimeNamespace.GameDetailPlayability] = {}
		}
		t13.Personalization = t14
		t13.BatchFetchingStatus = {}
		t13.FetchingStatus = {}
		t13.ScreenSize = Vector2.new(100, 100)
		t13.TopBar = {
			topBarHeight = 10
		}
		t13.GlobalGuiInset = {
			bottom = 10,
			top = 10,
			left = 0,
			right = 0
		}
		t13.Navigation = {}
		t13.CentralOverlay = {
			OverlayType = nil
		}

		return t13
	end
}
