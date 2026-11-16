local parent = script:FindFirstAncestor("StartupStore").Parent

local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus

local function isRetrievalStatus(p): boolean
	return p == RetrievalStatus.NotStarted
		or p == RetrievalStatus.Fetching
		or p == RetrievalStatus.Failed
		or p == RetrievalStatus.Done
end

local function joinRetrievalStatus(p: string?, p2: string?)
	if
		p ~= RetrievalStatus.NotStarted
		and p ~= RetrievalStatus.Fetching
		and p ~= RetrievalStatus.Failed
		and p ~= RetrievalStatus.Done
	then
		p = nil
	end

	if
		p2 ~= RetrievalStatus.NotStarted
		and p2 ~= RetrievalStatus.Fetching
		and p2 ~= RetrievalStatus.Failed
		and p2 ~= RetrievalStatus.Done
	then
		p2 = nil
	end

	if p == nil then
		return p2
	end

	if p2 == nil then
		return p
	end

	if p == RetrievalStatus.Failed or p2 == RetrievalStatus.Failed then
		return RetrievalStatus.Failed
	end

	if p == RetrievalStatus.NotStarted and p2 == RetrievalStatus.NotStarted then
		return RetrievalStatus.NotStarted
	end

	if p == RetrievalStatus.Done and p2 == RetrievalStatus.Done then
		return RetrievalStatus.Done
	end

	return RetrievalStatus.Fetching
end

local function defaultGamesPageDataStatus() -- 2 equivalent calls inferred from this helper
	return { status = RetrievalStatus.NotStarted, isRefreshFetch = false }
end

return Signals.createComputed(function()
	local signal, setPreloading = Signals.createSignal(true)

	local signal2, setHomePageDataStatus = Signals.createSignal(RetrievalStatus.NotStarted)

	local signal3, v = Signals.createSignal(defaultGamesPageDataStatus()) -- inferred equivalent call

	local signal4, setFetchHomePageDataStatusAll = Signals.createSignal(RetrievalStatus.NotStarted)

	return {
		getPreloading = signal,
		getHomePageDataStatus = signal2,
		getGamesPageDataStatus = signal3,
		getFetchHomePageDataStatusAll = signal4,
		getAppLoadingStarted = Signals.createComputed(function(p): boolean
			local status = signal3(p).status
			local v2 = signal2(p)
			local v3 = signal4(p)

			return joinRetrievalStatus(joinRetrievalStatus(status, v2), v3) ~= RetrievalStatus.NotStarted
		end),
		setPreloading = setPreloading,
		setHomePageDataStatus = setHomePageDataStatus,
		setGamesPageDataStatus = function(status: string, flag: boolean?)
			v({
				status = status,
				isRefreshFetch = flag or false
			})
		end,
		setFetchHomePageDataStatusAll = setFetchHomePageDataStatusAll,
		reset = function()
			SignalsExperimental.batch(function()
				setPreloading(true)
				setHomePageDataStatus(RetrievalStatus.NotStarted)
				v(defaultGamesPageDataStatus()) -- inferred equivalent call
				setFetchHomePageDataStatusAll(RetrievalStatus.NotStarted)
			end)
		end
	}
end)
