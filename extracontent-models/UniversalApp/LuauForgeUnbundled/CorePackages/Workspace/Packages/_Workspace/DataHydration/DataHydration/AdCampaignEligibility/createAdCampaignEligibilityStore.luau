local Players = game:GetService("Players")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local fFlagBuildAgentAdCampaignRefreshEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildAgentAdCampaignRefreshEligibility

local fetchAdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignEligibility/fetchAdCampaignEligibility")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignEligibility/AdCampaignEligibilityStoreTypes")

local function createAdCampaignEligibilityStore(p2)
	local v5 = fetchAdCampaignEligibility

	if p2 and p2.fetchEligibility then
		v5 = p2.fetchEligibility
	end

	local fn
	local v7 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		ignoreResponsesAfterTimeout = fFlagBuildAgentAdCampaignRefreshEligibility,
		onClear = fFlagBuildAgentAdCampaignRefreshEligibility and function()
			fn()
		end or nil,
		fetchFn = function(p3, p4)
			return v5((tonumber(p3)))
		end
	})

	local v8 = {}
	local v9 = fFlagBuildAgentAdCampaignRefreshEligibility and {} or nil

	fn = function()
		if fFlagBuildAgentAdCampaignRefreshEligibility then
			for k, v10 in v9 do
				v9[k] = nil

				if v10.dispose ~= nil then
					v10.dispose()
				end
			end
		else
			for k, v10 in v8 do
				v8[k] = nil
				v10()
			end
		end
	end
	local localPlayer = Players.LocalPlayer
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		if Players.LocalPlayer ~= localPlayer then
			localPlayer = Players.LocalPlayer
			fn()
		end
	end)
	return {
		getEligibility = function(p3)
			return v7.getCachedItem((tostring(p3)))
		end,
		fetchEligibility = function(p3, p4)
			if fFlagBuildAgentAdCampaignRefreshEligibility then
				local v10 = tostring(p3)
				local requestInQueueOrInFlight = v7.isRequestInQueueOrInFlight(v10)

				if not requestInQueueOrInFlight and p4 == nil then
					return v7.fetchItem(v10)
				end

				local cachedItem = v7.getCachedItem(v10)
				local v11 = v9[v10]

				if v11 == nil then
					local v12 = {
						pending = requestInQueueOrInFlight,
						callbacks = {},
						nextCallbacks = {}
					}

					if p4 ~= nil then
						local v13 = if requestInQueueOrInFlight then v12.nextCallbacks else v12.callbacks
						table.insert(v13, p4)
					end

					v9[v10] = v12

					if not requestInQueueOrInFlight then
						v7.fetchItem(v10)
					end

					v12.dispose = Signals.createEffect(function(p5)
						local data = cachedItem.data(p5)
						local status = cachedItem.status(p5)

						if status == "NotReady" or v7.isRequestInQueueOrInFlight(v10) then
							return
						end

						local callbacks = v12.callbacks
						v12.callbacks = v12.nextCallbacks
						v12.nextCallbacks = {}

						if v12.pending then
							v12.pending = false
							v7.fetchItem(v10)
						else
							v9[v10] = nil

							if v12.dispose ~= nil then
								v12.dispose()
							end
						end

						for k, callback in callbacks do
							local v13 = if status == "Ready" then data else nil
							callback(v13)
						end
					end)
					return cachedItem
				end

				v11.pending = true

				if p4 ~= nil then
					table.insert(v11.nextCallbacks, p4)
				end

				return cachedItem
			else
				local v10 = tostring(p3)

				if not v7.isRequestInQueueOrInFlight(v10) then
					return v7.fetchItem(v10)
				end

				local cachedItem = v7.getCachedItem(v10)

				if v8[v10] == nil then
					v8[v10] = Signals.createEffect(function(p5)
						cachedItem.data(p5)
						cachedItem.status(p5)

						if v7.isRequestInQueueOrInFlight(v10) then
							return
						end

						local v11 = v8[v10]
						v8[v10] = nil

						if v11 ~= nil then
							v11()
						end

						v7.fetchItem(v10)
					end)
				end

				return cachedItem
			end
		end,
		getAndFetchEligibility = function(p3)
			return v7.getAndFetchItem((tostring(p3)))
		end,
		clear = function()
			fn()
			v7.clear()
		end,
		dispose = function()
			fn()

			if localPlayerChangedConnection ~= nil then
				localPlayerChangedConnection:Disconnect()
				localPlayerChangedConnection = nil
			end

			v7.dispose()
		end
	}
end

return createAdCampaignEligibilityStore
