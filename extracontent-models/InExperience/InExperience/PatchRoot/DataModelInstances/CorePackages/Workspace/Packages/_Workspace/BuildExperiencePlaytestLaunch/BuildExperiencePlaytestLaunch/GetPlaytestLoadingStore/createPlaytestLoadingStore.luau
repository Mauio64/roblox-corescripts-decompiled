local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent

local Signals = require(parent.Signals)

local function createPlaytestLoadingStore()
	local loadingSignals = {}

	local function getLoadingSignal(p: number)
		local loadingSignal = loadingSignals[p]

		if loadingSignal ~= nil then
			return loadingSignal
		end

		local signal, setAgentStatus = Signals.createSignal("Idle")
		local signal2, setPlaytestStatus = Signals.createSignal("Idle")

		loadingSignal = {
			getAgentStatus = signal,
			setAgentStatus = setAgentStatus,
			getPlaytestStatus = signal2,
			setPlaytestStatus = setPlaytestStatus,
			getStatus = Signals.createComputed(function(p2): string
				if signal(p2) == "Loading" or signal2(p2) == "Loading" then
					return "Loading"
				end

				if signal(p2) == "Completed" or signal2(p2) == "Completed" then
					return "Completed"
				end

				return "Idle"
			end),
			getIsPlaytestLoading = Signals.createComputed(function(p2): boolean
				return signal2(p2) == "Loading"
			end)
		}

		loadingSignals[p] = loadingSignal

		return loadingSignal
	end

	return {
		getAgentStatusForPlaceId = function(p: number)
			return getLoadingSignal(p).getAgentStatus
		end,
		getPlaytestStatusForPlaceId = function(p: number)
			return getLoadingSignal(p).getPlaytestStatus
		end,
		getStatusForPlaceId = function(p: number)
			return getLoadingSignal(p).getStatus
		end,
		getIsPlaytestLoadingForPlaceId = function(p: number)
			return getLoadingSignal(p).getIsPlaytestLoading
		end,
		setAgentStatusForPlaceId = function(p: number, p2: string)
			getLoadingSignal(p).setAgentStatus(p2)
		end,
		setPlaytestStatusForPlaceId = function(p: number, p2: string)
			getLoadingSignal(p).setPlaytestStatus(p2)
		end,
		clearCompletedStatusForPlaceId = function(p: number)
			local loadingSignal = getLoadingSignal(p)

			if loadingSignal.getStatus() ~= "Completed" then
				return
			end

			loadingSignal.setAgentStatus("Idle")
			loadingSignal.setPlaytestStatus("Idle")
		end
	}
end

return createPlaytestLoadingStore
