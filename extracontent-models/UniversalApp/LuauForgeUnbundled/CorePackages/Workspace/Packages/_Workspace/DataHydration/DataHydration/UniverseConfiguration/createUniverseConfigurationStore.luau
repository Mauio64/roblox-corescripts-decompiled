local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local fetchUniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/fetchUniverseConfiguration")
local getPrivacyTypeForAudiences = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/getPrivacyTypeForAudiences")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/UniverseConfigurationStoreTypes")

local function createUniverseConfigurationStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }
	local count = 0
	local v7 = {}

	local v8 = createSingleEntityResolver(function(p2)
		count += 1
		local v9 = count
		return fetchUniverseConfiguration.fetchSummary(p2, v6):andThen(function(p3)
			local v10 = v7[p2]

			if v10 == nil then
				return p3
			end

			if v9 <= v10.generation then
				return Cryo.Dictionary.join(p3, v10.patch)
			end

			v7[p2] = nil
			return p3
		end)
	end)

	local v9 = createSingleEntityResolver(function(p2)
		return fetchUniverseConfiguration.fetchConfiguration(p2, v6)
	end)

	local v10 = createSingleEntityResolver(function(p2)
		return fetchUniverseConfiguration.fetchTeamCreate(p2, v6)
	end)

	local function getSummaryPatch(data)
		local v11 = {}

		if data.name ~= nil then
			v11.name = data.name
		end

		if data.description ~= nil then
			v11.description = data.description
		end

		if data.isArchived ~= nil then
			v11.isArchived = data.isArchived
		end

		if data.audiences ~= nil then
			v11.audiences = data.audiences
			v11.privacyType = getPrivacyTypeForAudiences(data.audiences)
		end

		if next(v11) == nil then
			return nil
		end

		return v11
	end

	local function patchConfiguration(p2, p3)
		return fetchUniverseConfiguration.patchConfiguration(p2, p3, v6):andThen(function(p4)
			v9.update(p2, p4)
			v9.update(p2, p3)

			local summaryPatch = getSummaryPatch(p3)

			if summaryPatch ~= nil and v8.get(p2).data(false) ~= nil then
				v7[p2] = { generation = count, patch = summaryPatch }

				local v11 = p2
				local data = v8.get(v11).data(false)

				if data ~= nil then
					local joined = Cryo.Dictionary.join(data, summaryPatch)
					v8.update(v11, joined)
				end
			end

			return v9.get(p2).data(false)
		end)
	end

	local function clear()
		count = 0
		v7 = {}
		v8.clear()
		v9.clear()
		v10.clear()
	end

	return {
		getSummary = v8.get,
		fetchSummary = v8.fetch,
		refreshSummary = function(p2)
			return fetchUniverseConfiguration.fetchSummary(p2, v6):andThen(function(p3)
				v8.cache.replaceItem(tostring(p2), p3)
				return p3
			end)
		end,
		getAndFetchSummary = v8.getAndFetch,
		updateSummary = function(p2, p3)
			local data = v8.get(p2).data(false)

			if data == nil then
				return
			end

			local joined = Cryo.Dictionary.join(data, p3)
			v8.update(p2, joined)
		end,
		getConfiguration = v9.get,
		fetchConfiguration = v9.fetch,
		refreshConfiguration = function(p2)
			return fetchUniverseConfiguration.fetchConfiguration(p2, v6):andThen(function(p3)
				v9.cache.replaceItem(tostring(p2), p3)
				return p3
			end)
		end,
		getAndFetchConfiguration = v9.getAndFetch,
		updateConfiguration = function(p2, p3)
			local data = v9.get(p2).data(false)

			if data == nil then
				return
			end

			local joined = Cryo.Dictionary.join(data, p3)
			v9.update(p2, joined)
		end,
		patchConfiguration = patchConfiguration,
		getTeamCreate = v10.get,
		fetchTeamCreate = v10.fetch,
		getAndFetchTeamCreate = v10.getAndFetch,
		setTeamCreate = function(p2, p3)
			return fetchUniverseConfiguration.setTeamCreate(p2, p3, v6):andThen(function(p4)
				v10.update(p2, p4)
				return p4
			end)
		end,
		clear = clear,
		dispose = function()
			v8.dispose()
			v9.dispose()
			v10.dispose()
		end
	}
end

return createUniverseConfigurationStore
