local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local Cryo = require(parent.Cryo)
local Promise = require(parent.Promise)
local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new(script.Name)

local Requests = require(DataHydration.Profile.Requests)
require(DataHydration.Profile.Enums.ProfileCTAEnums)
local hydratePresenceFromProfileMetadata = require(DataHydration.Profile.hydratePresenceFromProfileMetadata)

local FFlagProfileCTAHydratePresenceFromMetadata = require(DataHydration.Flags.FFlagProfileCTAHydratePresenceFromMetadata)

local SharedFlags = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListActionsV2 = SharedFlags2.FFlagUserListActionsV2

game:DefineFastInt("ProfileCTAStoreProcessDelaySec", 1)

local defineFastInt = game:DefineFastInt("ProfileJoinUserActionsProcessDelaySec", 0)

local v2 = {
	{ component = "Actions", excludeContextualActions = true }
}

local v3 = {
	{
		component = "Actions",
		excludeContextualActions = true,
		isActionsV2Supported = true,
		supportedActions = require(DataHydration.Profile.UserListSupportedActions)
	}
}

local v4 = {
	{ component = "JoinUserActions" }
}

local function fn() -- 1 equivalent call inferred from this helper
	return game:GetFastInt("ProfileCTAStoreProcessDelaySec")
end

local function createProfileCTAStore(p)
	local dataCache = createDataCache()
	local cache

	if FFlagJoinabilityCTARefactor then
		cache = createDataCache()
	else
		cache = nil
	end

	local v5

	if FFlagJoinabilityCTARefactor and p and p.components then
		v5 = p.components
	else
		v5 = if FFlagUserListActionsV2 then v3 else v2
	end

	local v6 = not (FFlagJoinabilityCTARefactor and v5[1]) and "Actions" or v5[1].component

	local function fetchComponent(p2, p3, p4: string, flag: boolean?) -- 1 equivalent call inferred from this helper
		local keys = Cryo.Dictionary.keys(p2)
		return Requests.GetUserProfileCTA(keys, p3):andThen(function(p5)
			local result = {}

			if p5.responseBody and p5.responseBody.profiles then
				for _, key in keys do
					local v7 = tostring(key)
					local profile = p5.responseBody.profiles[v7]
					result[v7] = profile and profile.components and profile.components[p4] or {}

					if FFlagProfileCTAHydratePresenceFromMetadata and flag then
						hydratePresenceFromProfileMetadata(v7, profile and profile.metadata)
					end
				end
			end

			return result
		end)
	end

	local dataResolver = createDataResolver({
		cache = dataCache,
		queueProcessDelaySec = fn(), -- inferred equivalent call
		requestBatchSize = 25,
		fetchFn = function(p2)
			if FFlagJoinabilityCTARefactor then
				return fetchComponent(p2, v5, v6, true)
			end

			local keys = Cryo.Dictionary.keys(p2)
			local getUserProfileCTA = Requests.GetUserProfileCTA
			local v7

			if FFlagUserListActionsV2 then
				v7 = v3
			end

			return getUserProfileCTA(keys, v7):andThen(function(p3)
				local actions = {}

				if p3.responseBody and p3.responseBody.profiles then
					for _, key in keys do
						local v8 = tostring(key)
						local profile = p3.responseBody.profiles[v8]
						actions[v8] = profile and profile.components and profile.components.Actions or {}

						if FFlagProfileCTAHydratePresenceFromMetadata then
							hydratePresenceFromProfileMetadata(v8, profile and profile.metadata)
						end
					end
				end

				return actions
			end):catch(function(_)
				return {}
			end)
		end
	})
	local v7

	if FFlagJoinabilityCTARefactor then
		v7 = createDataResolver({
			cache = cache,
			queueProcessDelaySec = defineFastInt,
			requestBatchSize = 25,
			replaceItems = true,
			logError = function(p2)
				v:warning(`Failed to fetch JoinUserActions: {tostring(p2)}`)
			end,
			fetchFn = function(p2)
				local component = fetchComponent(p2, v4, v4[1].component, true) -- inferred equivalent call

				local JoinUserActionsTelemetry = require(DataHydration.Profile.JoinUserActionsTelemetry)

				return component:andThen(function(p3)
					JoinUserActionsTelemetry.logFetchResult("Success")
					return p3
				end):catch(function(p3)
					JoinUserActionsTelemetry.logFetchResult("Failed")
					return Promise.reject(p3)
				end)
			end
		})
	else
		v7 = nil
	end

	local function getCTA(p2: string, flag: boolean?)
		local fn2

		if flag ~= nil then
			local v8 = flag == true

			fn2 = function(_)
				return v8
			end
		end

		return dataResolver.getAndFetchItem(p2, fn2)
	end

	local function getBatchCTAs(p2, p3)
		local fn2

		if p3 then
			local count = 0
			fn2 = function(_): boolean
				count += 1
				local v8 = p2[count]

				if v8 then
					return p3[v8] == true
				end

				return false
			end
		end

		return dataResolver.getAndFetchItems(p2, fn2)
	end

	local function clear()
		dataCache.clear()
		dataResolver.clear()

		if FFlagJoinabilityCTARefactor then
			cache.clear()
			v7.clear()
		end
	end

	local function dispose()
		dataResolver.dispose()

		if FFlagJoinabilityCTARefactor then
			v7.dispose()
		end
	end

	return {
		getCTA = getCTA,
		getBatchCTAs = getBatchCTAs,
		getJoinUserActions = FFlagJoinabilityCTARefactor and function(p2: string, flag: boolean?)
			local fn2

			if flag ~= nil then
				local v8 = flag == true

				fn2 = function(_)
					return v8
				end
			end

			return v7.getAndFetchItem(p2, fn2)
		end or nil,
		clear = clear,
		dispose = dispose
	}
end

return createProfileCTAStore
