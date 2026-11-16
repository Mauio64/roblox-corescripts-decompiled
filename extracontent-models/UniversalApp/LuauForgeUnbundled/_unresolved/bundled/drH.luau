local module = require("@luauforge/bundled/dqz")
local module2 = require("@luauforge/bundled/dqd")
local gameInfoModel = require("@luauforge/bundled/dqf").GameInfoModel
local module3 = require("@luauforge/bundled/dqn")
local omniRecommendationsContentType = module3.OmniRecommendationsContentType
local omniFeedTypes = module3.OmniFeedTypes
local omniRecommendationsPageType = require("@luauforge/bundled/dqK").OmniRecommendationsPageType
local appPage = require("@luauforge/bundled/drn").AppPage

local v5 = {}

function v5.new()
	return {}
end

function v5.mock()
	local v6 = v5.new()

	v6.pageType = appPage.Home
	v6.nextPageToken = "eyJzdGFydCI6MTAsImNvdW50IjoxMCwiZW5kT2ZQYWdlIjpmYWxzZX0="
	v6.isSessionExpired = false
	local mock = gameInfoModel.mock()
	v6.sorts = {
		{
			topic = "topic1",
			topicId = "100000003",
			recommendations = {
				{
					contentType = omniRecommendationsContentType.Game,
					contentId = mock.universeId
				}
			},
			treatmentType = omniFeedTypes.Carousel,
			numberOfRows = -1
		}
	}

	v6.recommendationsId = "3d14d9e6-cea3-4eec-bcdc-cfdc906f61cb"
	v6.omniSessionId = "d3240862-f901-419c-8780-5160e05d8473"

	return v6
end

function v5.mockEndpointResponse(value)
	local v6 = {
		rootPlaceId = "10395446",
		universeId = "149757",
		name = "test",
		totalUpVotes = 10970,
		totalDownVotes = 2564,
		playerCount = 5,
		under9 = true,
		under13 = false,
		friendActivityTitle = "Friend Activity",
		minimumAge = 0,
		ageRecommendationDisplayName = "All Ages",
		friendVisits = {
			{ userId = "1894536079" }
		},
		friendVisitedString = "1 Friend visited",
		defaultLayoutData = {
			footer = { type = "TextLabel", textLiteral = "This is footer text" }
		},
		layoutDataBySort = {
			["500000000"] = {
				footer = {
					type = "TextLabel",
					textLiteral = "This is a sort-level footer text"
				}
			}
		},
		primaryWideAssetId = "12046435434"
	}

	return {
		contentMetadata = {
			[omniRecommendationsContentType.Game] = { [v6.universeId] = v6 }
		},
		sorts = {
			{
				topic = "Friends",
				topicId = 600000000,
				recommendationList = {},
				treatmentType = omniFeedTypes.FriendCarousel
			},
			{
				topic = value or "topic123",
				topicId = 100000003,
				recommendationList = {
					{
						contentType = omniRecommendationsContentType.Game,
						contentId = v6.universeId
					}
				},
				treatmentType = omniFeedTypes.Carousel
			}
		},
		pageType = omniRecommendationsPageType.OmniRecommendationsPageType.PAGE_TYPE_HOME,
		requestId = "123avcd3-1431-35bd-24db-452abcde65abf35",
		nextPageToken = "eyJzdGFydCI6MTAsImNvdW50IjoxMCwiZW5kT2ZQYWdlIjpmYWxzZX0=",
		isSessionExpired = false
	}
end

function v5.fromJsonData(data, value)
	local v6 = {}
	local appPage2 = omniRecommendationsPageType.toAppPage(data.pageType)

	if not appPage2 then
		return module.error(`pageType {appPage2} for OmniRecommedations is not supported.`)
	end

	assert(appPage2, "always exists for linter")
	v6.pageType = appPage2

	if data.sortsRefreshInterval and data.sortsRefreshInterval > 0 then
		v6.sortsExpirationTime = tick() + data.sortsRefreshInterval
	end

	v6.nextPageToken = data.nextPageToken
	v6.isSessionExpired = data.isSessionExpired
	v6.recommendationsId = data.requestId
	v6.omniSessionId = value or "Invalid_OmniSessionId"
	v6.sorts = module2.List.map(data.sorts, function(data2)
		local v7 = if data2.topicId then tostring(data2.topicId) else nil

		local v8 = {
			topic = data2.topic,
			topicId = v7,
			subtitle = data2.subtitle,
			sortSubId = data2.subId,
			analyticsData = data2.analyticsData,
			recommendations = 0,
			treatmentType = 0,
			numberOfRows = 0,
			topicLayoutData = 0,
			feedItemKey = 0
		}
		local v9

		if data2.recommendationList then
			v9 = module2.List.map(data2.recommendationList, function(data3)
				return {
					contentType = data3.contentType,
					contentId = data3.contentId,
					contentStringId = data3.contentStringId,
					contentMetadata = data3.contentMetadata,
					analyticsData = data3.analyticsData
				}
			end)
		end

		v8.recommendations = v9

		v8.treatmentType = data2.treatmentType
		v8.numberOfRows = data2.numberOfRows and data2.numberOfRows or -1
		v8.topicLayoutData = data2.topicLayoutData

		v8.feedItemKey = data2.feedItemKey
		return v8
	end)

	v6.globalLayoutData = data.globalLayoutData or {}
	v6.sdui = data.sdui
	v6.sduiv2 = data.sduiv2

	return module.success(v6)
end

return v5
