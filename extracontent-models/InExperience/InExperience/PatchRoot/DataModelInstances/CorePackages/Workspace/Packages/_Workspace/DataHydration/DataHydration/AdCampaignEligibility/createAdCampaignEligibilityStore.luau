local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Players = game:GetService("Players")

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildAgentAdCampaignRefreshEligibility = SharedFlags.FFlagBuildAgentAdCampaignRefreshEligibility

local fetchAdCampaignEligibility = require(script.Parent.fetchAdCampaignEligibility)
require(script.Parent.AdCampaignEligibilityStoreTypes)

local function createAdCampaignEligibilityStore(p)
	local v = fetchAdCampaignEligibility

	if p and p.fetchEligibility then
		v = p.fetchEligibility
	end

	local fn
	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		ignoreResponsesAfterTimeout = FFlagBuildAgentAdCampaignRefreshEligibility,
		onClear = FFlagBuildAgentAdCampaignRefreshEligibility and function()
			fn()
		end or nil,
		fetchFn = function(p2: string, _)
			return v((tonumber(p2)))
		end
	})

	local v2 = {}
	local v3 = FFlagBuildAgentAdCampaignRefreshEligibility and {} or nil

	fn = function()
		if FFlagBuildAgentAdCampaignRefreshEligibility then
			for k, v4 in v3 do
				v3[k] = nil

				if v4.dispose ~= nil then
					v4.dispose()
				end
			end
		else
			for k, v4 in v2 do
				v2[k] = nil
				v4()
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
		getEligibility = function(p2)
			return dataResolver.getCachedItem((tostring(p2)))
		end,
		fetchEligibility = function(p2: number, callback)
			if FFlagBuildAgentAdCampaignRefreshEligibility then
				local v4 = tostring(p2)
				local requestInQueueOrInFlight = dataResolver.isRequestInQueueOrInFlight(v4)

				if not requestInQueueOrInFlight and callback == nil then
					return dataResolver.fetchItem(v4)
				end

				local cachedItem = dataResolver.getCachedItem(v4)
				local v5 = v3[v4]

				if v5 == nil then
					local v6 = {
						pending = requestInQueueOrInFlight,
						callbacks = {},
						nextCallbacks = {}
					}

					if callback ~= nil then
						local v7

						if requestInQueueOrInFlight then
							v7 = v6.nextCallbacks
						else
							v7 = v6.callbacks
						end

						table.insert(v7, callback)
					end

					v3[v4] = v6

					if not requestInQueueOrInFlight then
						dataResolver.fetchItem(v4)
					end

					v6.dispose = Signals.createEffect(function(p3)
						local data = cachedItem.data(p3)
						local status = cachedItem.status(p3)

						if status == "NotReady" or dataResolver.isRequestInQueueOrInFlight(v4) then
							return
						end

						local callbacks = v6.callbacks
						v6.callbacks = v6.nextCallbacks
						v6.nextCallbacks = {}

						if v6.pending then
							v6.pending = false
							dataResolver.fetchItem(v4)
						else
							v3[v4] = nil

							if v6.dispose ~= nil then
								v6.dispose()
							end
						end

						for _, callback2 in callbacks do
							local v7

							if status == "Ready" then
								v7 = data
							end

							callback2(v7)
						end
					end)
					return cachedItem
				end

				v5.pending = true

				if callback ~= nil then
					table.insert(v5.nextCallbacks, callback)
				end

				return cachedItem
			else
				local v4 = tostring(p2)

				if not dataResolver.isRequestInQueueOrInFlight(v4) then
					return dataResolver.fetchItem(v4)
				end

				local cachedItem = dataResolver.getCachedItem(v4)

				if v2[v4] == nil then
					v2[v4] = Signals.createEffect(function(p3)
						cachedItem.data(p3)
						cachedItem.status(p3)

						if dataResolver.isRequestInQueueOrInFlight(v4) then
							return
						end

						local v5 = v2[v4]
						v2[v4] = nil

						if v5 ~= nil then
							v5()
						end

						dataResolver.fetchItem(v4)
					end)
				end

				return cachedItem
			end
		end,
		getAndFetchEligibility = function(p2)
			return dataResolver.getAndFetchItem((tostring(p2)))
		end,
		clear = function()
			fn()
			dataResolver.clear()
		end,
		dispose = function()
			fn()

			if localPlayerChangedConnection ~= nil then
				localPlayerChangedConnection:Disconnect()
				localPlayerChangedConnection = nil
			end

			dataResolver.dispose()
		end
	}
end

return createAdCampaignEligibilityStore
