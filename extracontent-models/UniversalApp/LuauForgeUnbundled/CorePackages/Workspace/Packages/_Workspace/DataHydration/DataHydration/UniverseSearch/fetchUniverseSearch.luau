local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder")
local urlBase = UrlBuilder.UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
local fFlagBuildWithGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildWithGroups
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch/UniverseSearchStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function fetchUniverseSearch(data, options)
	local v5 = options or {}
	local baseUrl = v5.baseUrl or urlBase.APIS

	if fFlagBuildWithGroups and data.creators ~= nil then
		return asPromise((fetch({
			network = withCsrfRetry(v5.network or HttpClient.createRequestInternalNetwork()),
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
			decode = function(p2)
				return p2
			end
		})))
	end

	local v6 = {}

	if data.creatorType ~= nil then
		v6.CreatorType = data.creatorType
	end

	if data.creatorTargetId ~= nil then
		v6.CreatorTargetId = data.creatorTargetId
	end

	if data.surface ~= nil then
		v6.Surface = data.surface
	end

	if data.search ~= nil then
		v6.Search = data.search
	end

	if data.isArchived ~= nil then
		v6.IsArchived = tostring(data.isArchived)
	end

	if data.isPublic ~= nil then
		v6.IsPublic = tostring(data.isPublic)
	end

	if data.isShared ~= nil then
		v6.IsShared = tostring(data.isShared)
	end

	if data.isTeamCreateEnabled ~= nil then
		v6.IsTeamCreateEnabled = tostring(data.isTeamCreateEnabled)
	end

	if data.sortParam ~= nil then
		v6.SortParam = data.sortParam
	end

	if data.sortOrder ~= nil then
		v6.SortOrder = data.sortOrder
	end

	if data.needsAssetOptions ~= nil then
		v6.NeedsAssetOptions = tostring(data.needsAssetOptions)
	end

	if data.pageIndex ~= nil then
		v6.PageIndex = data.pageIndex
	end

	if data.pageSize ~= nil then
		v6.PageSize = data.pageSize
	end

	return asPromise((fetch({
		network = v5.network,
		method = "GET",
		url = UrlBuilder.UrlBuilder.addQueryString(baseUrl .. "/universes/v1/search", v6),
		analyticsKey = "universes-search.search",
		decode = function(p2)
			return p2
		end
	})))
end

return fetchUniverseSearch
