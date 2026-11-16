local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicInfosRodux/DiscoveryTypes")
local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicInfosRodux/SharedFlags").FFlagEnableTopSongsSort

local v5 = {
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

local class = {}
class.__index = class

function class.new()
	local v6 = { dataSource = DiscoveryTypes.DataSourceType.Unknown }

	setmetatable(v6, class)

	return v6
end

function class.mockFromExploreJsonData(p2, p3, value)
	return (class.fromExploreJsonData({
		sortDisplayName = "",
		sortId = p2,
		gameSetTargetId = 0,
		gameSetTypeId = value or 0,
		topicLayoutData = {},
		treatmentType = p3
	}))
end

function class.mockFromOmniApi(p2)
	return (class.fromOmniApi({ topicId = p2, topic = "", treatmentType = "" }))
end

function class.fromExploreJsonData(data)
	local v6 = class.new()
	v6.dataSource = DiscoveryTypes.DataSourceType.ExploreApi
	v6.displayName = data.sortDisplayName
	v6.name = data.sortId
	v6.subtitle = data.subtitle
	v6.token = ""
	v6.gameSetTargetId = data.gameSetTargetId
	v6.gameSetTypeId = tostring(data.gameSetTypeId)
	v6.topicLayoutData = data.topicLayoutData
	v6.treatmentType = data.treatmentType
	v6.appliedFilters = data.appliedFilters
	v6.subtitle = data.subtitle

	if fFlagEnableTopSongsSort then
		v6.contentType = data.contentType
	end

	if v6.name ~= nil then
		v6.displayIcon = v5[v6.name]
	end

	if v6.displayIcon == nil then
		v6.displayIcon = "LuaApp/category/filter_default"
	end

	v6.uniqueKey = v6.name
	v6.analyticsTypeId = v6.gameSetTypeId

	return v6
end

function class.fromOmniApi(data)
	local v6 = class.new()
	v6.dataSource = DiscoveryTypes.DataSourceType.DiscoveryApi
	v6.displayName = data.topic
	v6.topicId = tostring(data.topicId)
	v6.subtitle = data.subtitle
	v6.sortSubId = data.sortSubId
	v6.analyticsData = data.analyticsData
	v6.treatmentType = data.treatmentType

	v6.uniqueKey = v6.topicId
	v6.analyticsTypeId = v6.topicId

	return v6
end

function class.fromOmniAutocompleteApi(data)
	local v6 = class.new()
	v6.dataSource = DiscoveryTypes.DataSourceType.OmniAutocompleteApi
	v6.displayName = data.sortDisplayName
	v6.name = data.sortId
	v6.topicLayoutData = data.topicLayoutData or {}

	v6.uniqueKey = v6.name
	v6.analyticsTypeId = v6.name
	v6.gameSetTypeId = v6.name

	return v6
end

function class.makeTopSearchTopicKey(p2, p3)
	return `{p2}_{p3}`
end

function class.fromTopSearchApi(data, searchUuid)
	local v6 = class.new()
	v6.dataSource = DiscoveryTypes.DataSourceType.SearchApi
	v6.topicId = tostring(data.topicId)
	v6.treatmentType = data.treatmentType
	v6.topicLayoutData = data.topicLayoutData or {}
	v6.searchUuid = searchUuid

	v6.uniqueKey = class.makeTopSearchTopicKey(v6.searchUuid, v6.topicId)
	v6.analyticsTypeId = v6.uniqueKey

	return v6
end

function class.makeSearchTopicKey(p2, p3)
	return class.makeTopSearchTopicKey(p2, p3)
end

function class.fromSearchApi(p2, p3)
	return class.fromTopSearchApi(p2, p3)
end

function class:isOmni(): boolean
	return self.dataSource == DiscoveryTypes.DataSourceType.DiscoveryApi
end

function class.isSponsored(p2): boolean
	if p2.topicId == "400000000" then
		return true
	end

	return p2.gameSetTypeId == "27"
end

return class
