local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Cryo = require(parent.Cryo)
require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchUniverseConfiguration = require(script.Parent.fetchUniverseConfiguration)
local getPrivacyTypeForAudiences = require(script.Parent.getPrivacyTypeForAudiences)
require(script.Parent.UniverseConfigurationStoreTypes)

local function createUniverseConfigurationStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }
	local count = 0
	local v3 = {}

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		count += 1
		local v4 = count
		return fetchUniverseConfiguration.fetchSummary(p, v2):andThen(function(p2)
			local v5 = v3[p]

			if v5 == nil then
				return p2
			end

			if v4 <= v5.generation then
				return Cryo.Dictionary.join(p2, v5.patch)
			end

			v3[p] = nil
			return p2
		end)
	end)

	local singleEntityResolver2 = createSingleEntityResolver(function(p: number)
		return fetchUniverseConfiguration.fetchConfiguration(p, v2)
	end)

	local singleEntityResolver3 = createSingleEntityResolver(function(p: number)
		return fetchUniverseConfiguration.fetchTeamCreate(p, v2)
	end)

	local function getSummaryPatch(data)
		local v4 = {}

		if data.name ~= nil then
			v4.name = data.name
		end

		if data.description ~= nil then
			v4.description = data.description
		end

		if data.isArchived ~= nil then
			v4.isArchived = data.isArchived
		end

		if data.audiences ~= nil then
			v4.audiences = data.audiences
			v4.privacyType = getPrivacyTypeForAudiences(data.audiences)
		end

		return if next(v4) ~= nil then v4 else nil
	end

	local function updateSummary(p: number, summaryPatch) -- 1 equivalent call inferred from this helper
		local data = singleEntityResolver.get(p).data(false)

		if data == nil then
			return
		end

		local joined = Cryo.Dictionary.join(data, summaryPatch)
		singleEntityResolver.update(p, joined)
	end

	local function patchConfiguration(p: number, p2)
		return fetchUniverseConfiguration.patchConfiguration(p, p2, v2):andThen(function(p3)
			singleEntityResolver2.update(p, p3)
			singleEntityResolver2.update(p, p2)

			local summaryPatch = getSummaryPatch(p2)

			if summaryPatch ~= nil and singleEntityResolver.get(p).data(false) ~= nil then
				v3[p] = { generation = count, patch = summaryPatch }
				updateSummary(p, summaryPatch) -- inferred equivalent call
			end

			return (singleEntityResolver2.get(p).data(false))
		end)
	end

	local function clear()
		count = 0
		v3 = {}
		singleEntityResolver.clear()
		singleEntityResolver2.clear()
		singleEntityResolver3.clear()
	end

	return {
		getSummary = singleEntityResolver.get,
		fetchSummary = singleEntityResolver.fetch,
		refreshSummary = function(p: number)
			return fetchUniverseConfiguration.fetchSummary(p, v2):andThen(function(p2)
				singleEntityResolver.cache.replaceItem(tostring(p), p2)
				return p2
			end)
		end,
		getAndFetchSummary = singleEntityResolver.getAndFetch,
		updateSummary = updateSummary,
		getConfiguration = singleEntityResolver2.get,
		fetchConfiguration = singleEntityResolver2.fetch,
		refreshConfiguration = function(p: number)
			return fetchUniverseConfiguration.fetchConfiguration(p, v2):andThen(function(p2)
				singleEntityResolver2.cache.replaceItem(tostring(p), p2)
				return p2
			end)
		end,
		getAndFetchConfiguration = singleEntityResolver2.getAndFetch,
		updateConfiguration = function(p: number, p2)
			local data = singleEntityResolver2.get(p).data(false)

			if data == nil then
				return
			end

			local joined = Cryo.Dictionary.join(data, p2)
			singleEntityResolver2.update(p, joined)
		end,
		patchConfiguration = patchConfiguration,
		getTeamCreate = singleEntityResolver3.get,
		fetchTeamCreate = singleEntityResolver3.fetch,
		getAndFetchTeamCreate = singleEntityResolver3.getAndFetch,
		setTeamCreate = function(p: number, flag: boolean)
			return fetchUniverseConfiguration.setTeamCreate(p, flag, v2):andThen(function(p2)
				singleEntityResolver3.update(p, p2)
				return p2
			end)
		end,
		clear = clear,
		dispose = function()
			singleEntityResolver.dispose()
			singleEntityResolver2.dispose()
			singleEntityResolver3.dispose()
		end
	}
end

return createUniverseConfigurationStore
