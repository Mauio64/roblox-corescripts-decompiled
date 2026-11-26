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
local fFlagUserListActionsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagUserListActionsV2

game:DefineFastInt("ProfileCTAStoreProcessDelaySec", 1)

local defineFastInt = game:DefineFastInt("ProfileJoinUserActionsProcessDelaySec", 0)

local v6 = {
	{ component = "Actions", excludeContextualActions = true }
}

local v7 = {
	{
		component = "Actions",
		excludeContextualActions = true,
		isActionsV2Supported = true,
		supportedActions = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/UserListSupportedActions")
	}
}

local v8 = {
	{ component = "JoinUserActions" }
}

local function createProfileCTAStore(p2)
	local v9 = createDataCache()

	local v10 = if fFlagJoinabilityCTARefactor then createDataCache() else nil
	local v11

	if fFlagJoinabilityCTARefactor and p2 and p2.components then
		v11 = p2.components
	else
		v11 = if fFlagUserListActionsV2 then v7 else v6
	end

	local v12 = not (fFlagJoinabilityCTARefactor and v11[1]) and "Actions" or v11[1].component

	local function fetchComponent(p3, p4, p5, p6)
		local keys = Cryo.Dictionary.keys(p3)
		return Requests.GetUserProfileCTA(keys, p4):andThen(function(p7)
			local result = {}

			if p7.responseBody and p7.responseBody.profiles then
				for k, key in keys do
					local v13 = tostring(key)
					local profile = p7.responseBody.profiles[v13]
					result[v13] = profile and profile.components and profile.components[p5] or {}

					if FFlagProfileCTAHydratePresenceFromMetadata and p6 then
						hydratePresenceFromProfileMetadata(v13, profile and profile.metadata)
					end
				end
			end

			return result
		end)
	end

	local v13 = createDataResolver({
		cache = v9,
		queueProcessDelaySec = game:GetFastInt("ProfileCTAStoreProcessDelaySec"),
		requestBatchSize = 25,
		fetchFn = function(p3)
			if fFlagJoinabilityCTARefactor then
				return fetchComponent(p3, v11, v12, true)
			end

			local keys = Cryo.Dictionary.keys(p3)
			local getUserProfileCTA = Requests.GetUserProfileCTA
			local v14 = if fFlagUserListActionsV2 then v7 else nil
			return getUserProfileCTA(keys, v14):andThen(function(p4)
				local actions = {}

				if p4.responseBody and p4.responseBody.profiles then
					for k, key in keys do
						local v15 = tostring(key)
						local profile = p4.responseBody.profiles[v15]
						actions[v15] = profile and profile.components and profile.components.Actions or {}

						if FFlagProfileCTAHydratePresenceFromMetadata then
							hydratePresenceFromProfileMetadata(v15, profile and profile.metadata)
						end
					end
				end

				return actions
			end):catch(function(p4)
				return {}
			end)
		end
	})
	local v14

	if fFlagJoinabilityCTARefactor then
		v14 = createDataResolver({
			cache = v10,
			queueProcessDelaySec = defineFastInt,
			requestBatchSize = 25,
			replaceItems = true,
			logError = function(p3)
				v5:warning(`Failed to fetch JoinUserActions: {tostring(p3)}`)
			end,
			fetchFn = function(p3)
				local component = v8[1].component
				local keys = Cryo.Dictionary.keys(p3)
				local v16 = true
				local v17 = Requests.GetUserProfileCTA(keys, v8):andThen(function(p4)
					local result = {}

					if p4.responseBody and p4.responseBody.profiles then
						for k, key in keys do
							local v18 = tostring(key)
							local profile = p4.responseBody.profiles[v18]
							result[v18] = profile
								and profile.components
								and profile.components[component]
								or {}

							if FFlagProfileCTAHydratePresenceFromMetadata and v16 then
								hydratePresenceFromProfileMetadata(v18, profile and profile.metadata)
							end
						end
					end

					return result
				end)

				local JoinUserActionsTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/JoinUserActionsTelemetry")

				return v17:andThen(function(p4)
					JoinUserActionsTelemetry.logFetchResult("Success")
					return p4
				end):catch(function(p4)
					JoinUserActionsTelemetry.logFetchResult("Failed")
					return Promise.reject(p4)
				end)
			end
		})
	else
		v14 = nil
	end

	local function getCTA(p3, p4)
		local fn

		if p4 ~= nil then
			local v15 = p4 == true

			fn = function(p5)
				return v15
			end
		end

		return v13.getAndFetchItem(p3, fn)
	end

	local function getBatchCTAs(p3, p4)
		local fn

		if p4 then
			local count = 0
			fn = function(p5): boolean
				count += 1
				local v15 = p3[count]

				if v15 then
					return p4[v15] == true
				end

				return false
			end
		end

		return v13.getAndFetchItems(p3, fn)
	end

	local function clear()
		v9.clear()
		v13.clear()

		if fFlagJoinabilityCTARefactor then
			v10.clear()
			v14.clear()
		end
	end

	local function dispose()
		v13.dispose()

		if fFlagJoinabilityCTARefactor then
			v14.dispose()
		end
	end

	return {
		getCTA = getCTA,
		getBatchCTAs = getBatchCTAs,
		getJoinUserActions = fFlagJoinabilityCTARefactor and function(p3, p4)
			local fn

			if p4 ~= nil then
				local v15 = p4 == true

				fn = function(p5)
					return v15
				end
			end

			return v14.getAndFetchItem(p3, fn)
		end or nil,
		clear = clear,
		dispose = dispose
	}
end

return createProfileCTAStore
