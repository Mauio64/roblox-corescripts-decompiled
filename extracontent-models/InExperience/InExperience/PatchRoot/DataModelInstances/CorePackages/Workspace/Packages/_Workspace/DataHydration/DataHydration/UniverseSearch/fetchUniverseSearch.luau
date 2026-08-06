local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local UrlBuilder = require(Parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.UniverseSearchStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function fetchUniverseSearch(p1, t1: {[any]: any}?) -- line: 18
	-- upvalues: UrlBase (copy), fetch (copy), UrlBuilder (copy), asPromise (copy)
	local v10 = t1 or {}
	local v11 = v10.baseUrl or UrlBase.APIS
	local t2 = {}

	if p1.creatorType ~= nil then
		t2.CreatorType = p1.creatorType
	end

	if p1.creatorTargetId ~= nil then
		t2.CreatorTargetId = p1.creatorTargetId
	end

	if p1.surface ~= nil then
		t2.Surface = p1.surface
	end

	if p1.search ~= nil then
		t2.Search = p1.search
	end

	if p1.isArchived ~= nil then
		t2.IsArchived = tostring(p1.isArchived)
	end

	if p1.isPublic ~= nil then
		t2.IsPublic = tostring(p1.isPublic)
	end

	if p1.isShared ~= nil then
		t2.IsShared = tostring(p1.isShared)
	end

	if p1.isTeamCreateEnabled ~= nil then
		t2.IsTeamCreateEnabled = tostring(p1.isTeamCreateEnabled)
	end

	if p1.sortParam ~= nil then
		t2.SortParam = p1.sortParam
	end

	if p1.sortOrder ~= nil then
		t2.SortOrder = p1.sortOrder
	end

	if p1.needsAssetOptions ~= nil then
		t2.NeedsAssetOptions = tostring(p1.needsAssetOptions)
	end

	if p1.pageIndex ~= nil then
		t2.PageIndex = p1.pageIndex
	end

	if p1.pageSize ~= nil then
		t2.PageSize = p1.pageSize
	end

	local v13 = fetch({
		method = "GET",
		analyticsKey = "universes-search.search",
		network = v10.network,
		url = UrlBuilder.UrlBuilder.addQueryString(v11 .. "/universes/v1/search", t2),
		decode = function(p2) -- line: 72
			return p2
		end
	})

	return asPromise(v13)
end

return fetchUniverseSearch
