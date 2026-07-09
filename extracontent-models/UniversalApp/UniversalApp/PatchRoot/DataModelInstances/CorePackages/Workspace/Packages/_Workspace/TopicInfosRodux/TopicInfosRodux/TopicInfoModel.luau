local Parent = script:FindFirstAncestor("TopicInfosRodux").Parent
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local FFlagSearchOmniAutocompletePage = require(Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppAddSubIdToHomeEvents = require(Parent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local t1 = {
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
local t2 = {}

t2.__index = t2

function t2.new() -- line: 38
	-- upvalues: DiscoveryTypes (copy), t2 (copy)
	local t3 = {
		dataSource = DiscoveryTypes.DataSourceType.Unknown
	}

	setmetatable(t3, t2)

	return t3
end
function t2.mockFromExploreJsonData(p1, p2, p3) -- line: 48
	-- upvalues: t2 (copy)
	return (t2.fromExploreJsonData({
		sortDisplayName = "",
		gameSetTargetId = 0,
		sortId = p1,
		gameSetTypeId = p3 or 0,
		topicLayoutData = {},
		treatmentType = p2
	}))
end
function t2.mockFromOmniApi(p4) -- line: 61
	-- upvalues: t2 (copy)
	return (t2.fromOmniApi({
		topic = "",
		treatmentType = "",
		topicId = p4
	}))
end
function t2.fromExploreJsonData(p5) -- line: 70
	-- upvalues: t2 (copy), DiscoveryTypes (copy), FFlagEnableTopSongsSort (copy), t1 (copy)
	local v14 = t2.new()

	v14.dataSource = DiscoveryTypes.DataSourceType.ExploreApi
	v14.displayName = p5.sortDisplayName
	v14.name = p5.sortId
	v14.subtitle = p5.subtitle
	v14.token = ""
	v14.gameSetTargetId = p5.gameSetTargetId
	v14.gameSetTypeId = tostring(p5.gameSetTypeId)
	v14.topicLayoutData = p5.topicLayoutData
	v14.treatmentType = p5.treatmentType
	v14.appliedFilters = p5.appliedFilters
	v14.subtitle = p5.subtitle

	if FFlagEnableTopSongsSort then
		v14.contentType = p5.contentType
	end

	if v14.name ~= nil then
		v14.displayIcon = t1[v14.name]
	end

	if v14.displayIcon == nil then
		v14.displayIcon = "LuaApp/category/filter_default"
	end

	v14.uniqueKey = v14.name
	v14.analyticsTypeId = v14.gameSetTypeId

	return v14
end
function t2.fromOmniApi(p6) -- line: 102
	-- upvalues: t2 (copy), DiscoveryTypes (copy), FFlagLuaAppAddSubIdToHomeEvents (copy)
	local v16 = t2.new()

	v16.dataSource = DiscoveryTypes.DataSourceType.DiscoveryApi
	v16.displayName = p6.topic
	v16.topicId = tostring(p6.topicId)
	v16.subtitle = p6.subtitle
	v16.sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else p6.sortSubId
	v16.analyticsData = p6.analyticsData
	v16.treatmentType = p6.treatmentType
	v16.uniqueKey = v16.topicId
	v16.analyticsTypeId = v16.topicId

	return v16
end

if FFlagSearchOmniAutocompletePage then
	function t2.fromOmniAutocompleteApi(p7) -- line: 119
		-- upvalues: t2 (copy), DiscoveryTypes (copy)
		local v18 = t2.new()

		v18.dataSource = DiscoveryTypes.DataSourceType.OmniAutocompleteApi
		v18.displayName = p7.sortDisplayName
		v18.name = p7.sortId
		v18.topicLayoutData = p7.topicLayoutData or {}
		v18.uniqueKey = v18.name
		v18.analyticsTypeId = v18.name
		v18.gameSetTypeId = v18.name

		return v18
	end
end

function t2.makeTopSearchTopicKey(p8, p9) -- line: 134
	return `{ p8 }_{ p9 }`
end
function t2.fromTopSearchApi(t4: {[any]: any}, s1: string) -- line: 138
	-- upvalues: t2 (copy), DiscoveryTypes (copy)
	local v23 = t2.new()

	v23.dataSource = DiscoveryTypes.DataSourceType.SearchApi
	v23.topicId = tostring(t4.topicId)
	v23.treatmentType = t4.treatmentType
	v23.topicLayoutData = t4.topicLayoutData or {}
	v23.searchUuid = s1
	v23.uniqueKey = t2.makeTopSearchTopicKey(v23.searchUuid, v23.topicId)
	v23.analyticsTypeId = v23.uniqueKey

	return v23
end
function t2.makeSearchTopicKey(p10, p11) -- line: 152
	-- upvalues: t2 (copy)
	return t2.makeTopSearchTopicKey(p10, p11)
end
function t2.fromSearchApi(p12, s2: string) -- line: 156
	-- upvalues: t2 (copy)
	return t2.fromTopSearchApi(p12, s2)
end
function t2.isOmni(p13) -- line: 160
	-- upvalues: DiscoveryTypes (copy)
	if p13.dataSource == DiscoveryTypes.DataSourceType.DiscoveryApi then
		return true
	end

	return false
end
function t2.isSponsored(p14) -- line: 168
	if p14.topicId == "400000000" then
		return true
	end

	if p14.gameSetTypeId == "27" then
		return true
	end

	return false
end

return t2
