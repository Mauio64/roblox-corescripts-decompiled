local parent = script:FindFirstAncestor("TopicInfosRodux").Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort

local v = {
	default = "LuaApp/category/filter_default",
	Featured = "LuaApp/category/filter_featured",
	FriendActivity = "LuaApp/category/filter_friendsplaying",
	MyFavorite = "LuaApp/category/filter_myfavorites",
	MyRecent = "LuaApp/category/filter_continueplaying",
	Popular = "LuaApp/category/filter_popular",
	PopularInCountry = "LuaApp/category/filter_popularnearyou",
	TopGrossing = "LuaApp/category/filter_topearning",
	TopRated = "LuaApp/category/filter_toprated",
	TopRetaining = "LuaApp/category/filter_recommended"
}

local TopicInfoModel = {}
TopicInfoModel.__index = TopicInfoModel

function TopicInfoModel.new()
	local v2 = { dataSource = DiscoveryTypes.DataSourceType.Unknown }

	setmetatable(v2, TopicInfoModel)

	return v2
end

function TopicInfoModel.mockFromExploreJsonData(sortId, treatmentType, value)
	return (TopicInfoModel.fromExploreJsonData({
		sortDisplayName = "",
		sortId = sortId,
		gameSetTargetId = 0,
		gameSetTypeId = value or 0,
		topicLayoutData = {},
		treatmentType = treatmentType
	}))
end

function TopicInfoModel.mockFromOmniApi(topicId)
	return (TopicInfoModel.fromOmniApi({ topicId = topicId, topic = "", treatmentType = "" }))
end

function TopicInfoModel.fromExploreJsonData(data)
	local v2 = TopicInfoModel.new()
	v2.dataSource = DiscoveryTypes.DataSourceType.ExploreApi
	v2.displayName = data.sortDisplayName
	v2.name = data.sortId
	v2.subtitle = data.subtitle
	v2.token = ""
	v2.gameSetTargetId = data.gameSetTargetId
	v2.gameSetTypeId = tostring(data.gameSetTypeId)
	v2.topicLayoutData = data.topicLayoutData
	v2.treatmentType = data.treatmentType
	v2.appliedFilters = data.appliedFilters
	v2.subtitle = data.subtitle

	if FFlagEnableTopSongsSort then
		v2.contentType = data.contentType
	end

	if v2.name ~= nil then
		v2.displayIcon = v[v2.name]
	end

	if v2.displayIcon == nil then
		v2.displayIcon = "LuaApp/category/filter_default"
	end

	v2.uniqueKey = v2.name
	v2.analyticsTypeId = v2.gameSetTypeId

	return v2
end

function TopicInfoModel.fromOmniApi(data)
	local v2 = TopicInfoModel.new()
	v2.dataSource = DiscoveryTypes.DataSourceType.DiscoveryApi
	v2.displayName = data.topic
	v2.topicId = tostring(data.topicId)
	v2.subtitle = data.subtitle
	v2.sortSubId = data.sortSubId
	v2.analyticsData = data.analyticsData
	v2.treatmentType = data.treatmentType

	v2.uniqueKey = v2.topicId
	v2.analyticsTypeId = v2.topicId

	return v2
end

function TopicInfoModel.fromOmniAutocompleteApi(data)
	local v2 = TopicInfoModel.new()
	v2.dataSource = DiscoveryTypes.DataSourceType.OmniAutocompleteApi
	v2.displayName = data.sortDisplayName
	v2.name = data.sortId
	v2.topicLayoutData = data.topicLayoutData or {}

	v2.uniqueKey = v2.name
	v2.analyticsTypeId = v2.name
	v2.gameSetTypeId = v2.name

	return v2
end

function TopicInfoModel.makeTopSearchTopicKey(p, p2)
	return `{p}_{p2}`
end

function TopicInfoModel.fromTopSearchApi(data, searchUuid: string)
	local v2 = TopicInfoModel.new()
	v2.dataSource = DiscoveryTypes.DataSourceType.SearchApi
	v2.topicId = tostring(data.topicId)
	v2.treatmentType = data.treatmentType
	v2.topicLayoutData = data.topicLayoutData or {}
	v2.searchUuid = searchUuid

	v2.uniqueKey = TopicInfoModel.makeTopSearchTopicKey(v2.searchUuid, v2.topicId)
	v2.analyticsTypeId = v2.uniqueKey

	return v2
end

function TopicInfoModel.makeSearchTopicKey(p, p2)
	return TopicInfoModel.makeTopSearchTopicKey(p, p2)
end

function TopicInfoModel.fromSearchApi(p, p2: string)
	return TopicInfoModel.fromTopSearchApi(p, p2)
end

function TopicInfoModel.isOmni(p): boolean
	return p.dataSource == DiscoveryTypes.DataSourceType.DiscoveryApi
end

function TopicInfoModel.isSponsored(p): boolean
	return p.topicId == "400000000" or p.gameSetTypeId == "27"
end

return TopicInfoModel
