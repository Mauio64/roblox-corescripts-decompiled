local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Result = require(Parent.Result)
local Cryo = require(Parent.Cryo)
local GameInfoModel = require(Parent.GameModels).GameInfoModel
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local OmniRecommendationsPageType = require(Parent.DiscoveryUtils).OmniRecommendationsPageType
local AppPage = require(Parent.RobloxAppEnums).AppPage
local FFlagLuaAppAddSubIdToHomeEvents = require(Parent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagEnableSduiV2HomeInterleave = require(Parent.SharedFlags).FFlagEnableSduiV2HomeInterleave
local t1 = {
	new = function() -- line: 49
		return {}
	end
}

function t1.mock() -- line: 55
	-- upvalues: t1 (copy), AppPage (copy), GameInfoModel (copy), OmniRecommendationsContentType (copy), OmniFeedTypes (copy)
	local v13 = t1.new()

	v13.pageType = AppPage.Home
	v13.nextPageToken = "eyJzdGFydCI6MTAsImNvdW50IjoxMCwiZW5kT2ZQYWdlIjpmYWxzZX0="
	v13.isSessionExpired = false

	local v14 = GameInfoModel.mock()

	v13.sorts = {{
		topic = "topic1",
		topicId = "100000003",
		numberOfRows = -1,
		recommendations = {{
			contentType = OmniRecommendationsContentType.Game,
			contentId = v14.universeId
		}},
		treatmentType = OmniFeedTypes.Carousel
	}}
	v13.recommendationsId = "3d14d9e6-cea3-4eec-bcdc-cfdc906f61cb"
	v13.omniSessionId = "d3240862-f901-419c-8780-5160e05d8473"

	return v13
end
function t1.mockEndpointResponse(s1: string?) -- line: 84
	-- upvalues: OmniRecommendationsContentType (copy), OmniFeedTypes (copy), OmniRecommendationsPageType (copy)
	local t2 = {
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
		friendVisitedString = "1 Friend visited",
		primaryWideAssetId = "12046435434",
		friendVisits = {{
			userId = "1894536079"
		}},
		defaultLayoutData = {
			footer = {
				type = "TextLabel",
				textLiteral = "This is footer text"
			}
		},
		layoutDataBySort = {
			["500000000"] = {
				footer = {
					type = "TextLabel",
					textLiteral = "This is a sort-level footer text"
				}
			}
		}
	}

	return {
		requestId = "123avcd3-1431-35bd-24db-452abcde65abf35",
		nextPageToken = "eyJzdGFydCI6MTAsImNvdW50IjoxMCwiZW5kT2ZQYWdlIjpmYWxzZX0=",
		isSessionExpired = false,
		contentMetadata = {
			[OmniRecommendationsContentType.Game] = {
				[t2.universeId] = t2
			}
		},
		sorts = {
			{
				topic = "Friends",
				topicId = 600000000,
				recommendationList = {},
				treatmentType = OmniFeedTypes.FriendCarousel
			},
			{
				topicId = 100000003,
				topic = s1 or "topic123",
				recommendationList = {{
					contentType = OmniRecommendationsContentType.Game,
					contentId = t2.universeId
				}},
				treatmentType = OmniFeedTypes.Carousel
			}
		},
		pageType = OmniRecommendationsPageType.OmniRecommendationsPageType.PAGE_TYPE_HOME
	}
end
function t1.fromJsonData(p1, s2: string?) -- line: 147
	-- upvalues: OmniRecommendationsPageType (copy), Result (copy), Cryo (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), FFlagEnableSduiV2HomeInterleave (copy)
	local t3 = {}
	local v20 = OmniRecommendationsPageType.toAppPage(p1.pageType)

	if not v20 then
		return Result.error(`pageType { v20 } for OmniRecommedations is not supported.`)
	end

	assert(v20, "always exists for linter")
	t3.pageType = v20

	if p1.sortsRefreshInterval and p1.sortsRefreshInterval > 0 then
		t3.sortsExpirationTime = tick() + p1.sortsRefreshInterval
	end

	t3.nextPageToken = p1.nextPageToken
	t3.isSessionExpired = p1.isSessionExpired
	t3.recommendationsId = p1.requestId
	t3.omniSessionId = s2 or "Invalid_OmniSessionId"
	t3.sorts = Cryo.List.map(p1.sorts, function(p2) -- line: 165
		-- upvalues: FFlagLuaAppAddSubIdToHomeEvents (copy), Cryo (copy)
		local v22 = if not p2.topicId then nil else tostring(p2.topicId)

		return {
			topic = p2.topic,
			topicId = v22,
			subtitle = p2.subtitle,
			sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else p2.subId,
			analyticsData = p2.analyticsData,
			recommendations = if not p2.recommendationList then nil else Cryo.List.map(p2.recommendationList, function(p3) -- line: 175
				return {
					contentType = p3.contentType,
					contentId = p3.contentId,
					contentStringId = p3.contentStringId,
					contentMetadata = p3.contentMetadata,
					analyticsData = p3.analyticsData
				}
			end),
			treatmentType = p2.treatmentType,
			numberOfRows = p2.numberOfRows and p2.numberOfRows or -1,
			topicLayoutData = p2.topicLayoutData,
			feedItemKey = p2.feedItemKey
		}
	end)
	t3.globalLayoutData = p1.globalLayoutData or {}
	t3.sdui = p1.sdui
	t3.sduiv2 = if not FFlagEnableSduiV2HomeInterleave then nil else p1.sduiv2

	return Result.success(t3)
end

return t1
