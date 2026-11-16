local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildWithGroups = SharedFlags.FFlagBuildWithGroups
require(script.Parent.UniverseSearchStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function fetchUniverseSearch(data, options)
	local v = options or {}
	local baseUrl = v.baseUrl or UrlBase.APIS

	if FFlagBuildWithGroups and data.creators ~= nil then
		return asPromise((fetch({
			network = withCsrfRetry(v.network or HttpClient.createRequestInternalNetwork()),
			method = "POST",
			url = baseUrl .. "/universes/v1/search",
			body = {
				creators = data.creators,
				surface = data.surface,
				search = data.search,
				isArchived = data.isArchived,
				isPublic = data.isPublic,
				isShared = data.isShared,
				isTeamCreateEnabled = data.isTeamCreateEnabled,
				sortParam = data.sortParam,
				sortOrder = data.sortOrder,
				needsAssetOptions = data.needsAssetOptions,
				limit = data.pageSize,
				cursor = data.cursor
			},
			analyticsKey = "universes-search.multi-creator-search",
			decode = function(p)
				return p
			end
		})))
	end

	local v2 = {}

	if data.creatorType ~= nil then
		v2.CreatorType = data.creatorType
	end

	if data.creatorTargetId ~= nil then
		v2.CreatorTargetId = data.creatorTargetId
	end

	if data.surface ~= nil then
		v2.Surface = data.surface
	end

	if data.search ~= nil then
		v2.Search = data.search
	end

	if data.isArchived ~= nil then
		v2.IsArchived = tostring(data.isArchived)
	end

	if data.isPublic ~= nil then
		v2.IsPublic = tostring(data.isPublic)
	end

	if data.isShared ~= nil then
		v2.IsShared = tostring(data.isShared)
	end

	if data.isTeamCreateEnabled ~= nil then
		v2.IsTeamCreateEnabled = tostring(data.isTeamCreateEnabled)
	end

	if data.sortParam ~= nil then
		v2.SortParam = data.sortParam
	end

	if data.sortOrder ~= nil then
		v2.SortOrder = data.sortOrder
	end

	if data.needsAssetOptions ~= nil then
		v2.NeedsAssetOptions = tostring(data.needsAssetOptions)
	end

	if data.pageIndex ~= nil then
		v2.PageIndex = data.pageIndex
	end

	if data.pageSize ~= nil then
		v2.PageSize = data.pageSize
	end

	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = UrlBuilder.UrlBuilder.addQueryString(baseUrl .. "/universes/v1/search", v2),
		analyticsKey = "universes-search.search",
		decode = function(p)
			return p
		end
	})))
end

return fetchUniverseSearch
