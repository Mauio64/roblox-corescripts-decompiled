local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/StartupStore/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/StartupStore/SignalsExperimental")

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/StartupStore/Http").Enum.RetrievalStatus

local function isRetrievalStatus(p2): boolean
	return p2 == retrievalStatus.NotStarted
		or p2 == retrievalStatus.Fetching
		or p2 == retrievalStatus.Failed
		or p2 == retrievalStatus.Done
end

local function joinRetrievalStatus(p2, p3)
	if
		p2 ~= retrievalStatus.NotStarted
		and p2 ~= retrievalStatus.Fetching
		and p2 ~= retrievalStatus.Failed
		and p2 ~= retrievalStatus.Done
	then
		p2 = nil
	end

	if
		p3 ~= retrievalStatus.NotStarted
		and p3 ~= retrievalStatus.Fetching
		and p3 ~= retrievalStatus.Failed
		and p3 ~= retrievalStatus.Done
	then
		p3 = nil
	end

	if p2 == nil then
		return p3
	end

	if p3 == nil then
		return p2
	end

	if p2 == retrievalStatus.Failed or p3 == retrievalStatus.Failed then
		return retrievalStatus.Failed
	end

	if p2 == retrievalStatus.NotStarted and p3 == retrievalStatus.NotStarted then
		return retrievalStatus.NotStarted
	end

	if p2 == retrievalStatus.Done and p3 == retrievalStatus.Done then
		return retrievalStatus.Done
	end

	return retrievalStatus.Fetching
end

local function defaultGamesPageDataStatus()
	return { status = retrievalStatus.NotStarted, isRefreshFetch = false }
end

return Signals.createComputed(function()
	local signal, v5 = Signals.createSignal(true)

	local signal2, v6 = Signals.createSignal(retrievalStatus.NotStarted)
	local signal3, v7 = Signals.createSignal({
		status = retrievalStatus.NotStarted,
		isRefreshFetch = false
	})

	local signal4, v8 = Signals.createSignal(retrievalStatus.NotStarted)

	return {
		getPreloading = signal,
		getHomePageDataStatus = signal2,
		getGamesPageDataStatus = signal3,
		getFetchHomePageDataStatusAll = signal4,
		getAppLoadingStarted = Signals.createComputed(function(p2): boolean
			local status = signal3(p2).status
			local v9 = signal2(p2)
			local v10 = signal4(p2)

			return joinRetrievalStatus(joinRetrievalStatus(status, v9), v10) ~= retrievalStatus.NotStarted
		end),
		setPreloading = v5,
		setHomePageDataStatus = v6,
		setGamesPageDataStatus = function(p2, p3)
			v7({
				status = p2,
				isRefreshFetch = p3 or false
			})
		end,
		setFetchHomePageDataStatusAll = v8,
		reset = function()
			SignalsExperimental.batch(function()
				v5(true)
				v6(retrievalStatus.NotStarted)
				v7({ status = retrievalStatus.NotStarted, isRefreshFetch = false })
				v8(retrievalStatus.NotStarted)
			end)
		end
	}
end)
