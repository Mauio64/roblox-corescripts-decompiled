local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Loggers").Logger:new("createProfileCTAStore")

local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/Requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/Enums/ProfileCTAEnums")
local hydratePresenceFromProfileMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/hydratePresenceFromProfileMetadata")

local FFlagProfileCTAHydratePresenceFromMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagProfileCTAHydratePresenceFromMetadata")

local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagJoinabilityCTARefactor

game:DefineFastInt("ProfileCTAStoreProcessDelaySec", 1)

local defineFastInt = game:DefineFastInt("ProfileJoinUserActionsProcessDelaySec", 0)

local v6 = {
	{ component = "Actions", excludeContextualActions = true }
}

local v7 = {
	{ component = "JoinUserActions" }
}

local function createProfileCTAStore(p2)
	local v8 = createDataCache()

	local v9 = if fFlagJoinabilityCTARefactor then createDataCache() else nil

	local v10 = if fFlagJoinabilityCTARefactor and p2 and p2.components then p2.components else v6

	local v11 = not (fFlagJoinabilityCTARefactor and v10[1]) and "Actions" or v10[1].component

	local function fetchComponent(p3, p4, p5, p6)
		local keys = Cryo.Dictionary.keys(p3)
		return Requests.GetUserProfileCTA(keys, p4):andThen(function(p7)
			local result = {}

			if p7.responseBody and p7.responseBody.profiles then
				for k, key in keys do
					local v12 = tostring(key)
					local profile = p7.responseBody.profiles[v12]
					result[v12] = profile and profile.components and profile.components[p5] or {}

					if FFlagProfileCTAHydratePresenceFromMetadata and p6 then
						hydratePresenceFromProfileMetadata(v12, profile and profile.metadata)
					end
				end
			end

			return result
		end)
	end

	local v12 = createDataResolver({
		cache = v8,
		queueProcessDelaySec = game:GetFastInt("ProfileCTAStoreProcessDelaySec"),
		requestBatchSize = 25,
		fetchFn = function(p3)
			if fFlagJoinabilityCTARefactor then
				return fetchComponent(p3, v10, v11, true)
			end

			local keys = Cryo.Dictionary.keys(p3)
			return Requests.GetUserProfileCTA(keys):andThen(function(p4)
				local actions = {}

				if p4.responseBody and p4.responseBody.profiles then
					for k, key in keys do
						local v13 = tostring(key)
						local profile = p4.responseBody.profiles[v13]
						actions[v13] = profile and profile.components and profile.components.Actions or {}

						if FFlagProfileCTAHydratePresenceFromMetadata then
							hydratePresenceFromProfileMetadata(v13, profile and profile.metadata)
						end
					end
				end

				return actions
			end):catch(function(p4)
				return {}
			end)
		end
	})
	local v13

	if fFlagJoinabilityCTARefactor then
		v13 = createDataResolver({
			cache = v9,
			queueProcessDelaySec = defineFastInt,
			requestBatchSize = 25,
			replaceItems = true,
			logError = function(p3)
				v5:warning(`Failed to fetch JoinUserActions: {tostring(p3)}`)
			end,
			fetchFn = function(p3)
				local component = v7[1].component
				local keys = Cryo.Dictionary.keys(p3)
				local v15 = true
				local v16 = Requests.GetUserProfileCTA(keys, v7):andThen(function(p4)
					local result = {}

					if p4.responseBody and p4.responseBody.profiles then
						for k, key in keys do
							local v17 = tostring(key)
							local profile = p4.responseBody.profiles[v17]
							result[v17] = profile
								and profile.components
								and profile.components[component]
								or {}

							if FFlagProfileCTAHydratePresenceFromMetadata and v15 then
								hydratePresenceFromProfileMetadata(v17, profile and profile.metadata)
							end
						end
					end

					return result
				end)

				local JoinUserActionsTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/JoinUserActionsTelemetry")

				return v16:andThen(function(p4)
					JoinUserActionsTelemetry.logFetchResult("Success")
					return p4
				end):catch(function(p4)
					JoinUserActionsTelemetry.logFetchResult("Failed")
					return Promise.reject(p4)
				end)
			end
		})
	else
		v13 = nil
	end

	local function getCTA(p3, p4)
		local fn

		if p4 ~= nil then
			local v14 = p4 == true

			fn = function(p5)
				return v14
			end
		end

		return v12.getAndFetchItem(p3, fn)
	end

	local function getBatchCTAs(p3, p4)
		local fn

		if p4 then
			local count = 0
			fn = function(p5): boolean
				count += 1
				local v14 = p3[count]

				if v14 then
					return p4[v14] == true
				end

				return false
			end
		end

		return v12.getAndFetchItems(p3, fn)
	end

	local function clear()
		v8.clear()
		v12.clear()

		if fFlagJoinabilityCTARefactor then
			v9.clear()
			v13.clear()
		end
	end

	local function dispose()
		v12.dispose()

		if fFlagJoinabilityCTARefactor then
			v13.dispose()
		end
	end

	return {
		getCTA = getCTA,
		getBatchCTAs = getBatchCTAs,
		getJoinUserActions = fFlagJoinabilityCTARefactor and function(p3, p4)
			local fn

			if p4 ~= nil then
				local v14 = p4 == true

				fn = function(p5)
					return v14
				end
			end

			return v13.getAndFetchItem(p3, fn)
		end or nil,
		clear = clear,
		dispose = dispose
	}
end

return createProfileCTAStore
