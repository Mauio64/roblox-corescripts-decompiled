local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Signals")

local function createPlaytestLoadingStore()
	local loadingSignals = {}

	local function getLoadingSignal(p2)
		local loadingSignal = loadingSignals[p2]

		if loadingSignal ~= nil then
			return loadingSignal
		end

		local signal, v5 = Signals.createSignal("Idle")
		local signal2, v6 = Signals.createSignal("Idle")

		loadingSignal = {
			getAgentStatus = signal,
			setAgentStatus = v5,
			getPlaytestStatus = signal2,
			setPlaytestStatus = v6,
			getStatus = Signals.createComputed(function(p3): string
				if signal(p3) == "Loading" or signal2(p3) == "Loading" then
					return "Loading"
				end

				if signal(p3) == "Completed" or signal2(p3) == "Completed" then
					return "Completed"
				end

				return "Idle"
			end),
			getIsPlaytestLoading = Signals.createComputed(function(p3): boolean
				return signal2(p3) == "Loading"
			end)
		}

		loadingSignals[p2] = loadingSignal

		return loadingSignal
	end

	return {
		getAgentStatusForPlaceId = function(p2)
			return getLoadingSignal(p2).getAgentStatus
		end,
		getPlaytestStatusForPlaceId = function(p2)
			return getLoadingSignal(p2).getPlaytestStatus
		end,
		getStatusForPlaceId = function(p2)
			return getLoadingSignal(p2).getStatus
		end,
		getIsPlaytestLoadingForPlaceId = function(p2)
			return getLoadingSignal(p2).getIsPlaytestLoading
		end,
		setAgentStatusForPlaceId = function(p2, p3)
			getLoadingSignal(p2).setAgentStatus(p3)
		end,
		setPlaytestStatusForPlaceId = function(p2, p3)
			getLoadingSignal(p2).setPlaytestStatus(p3)
		end,
		clearCompletedStatusForPlaceId = function(p2)
			local loadingSignal = getLoadingSignal(p2)

			if loadingSignal.getStatus() ~= "Completed" then
				return
			end

			loadingSignal.setAgentStatus("Idle")
			loadingSignal.setPlaytestStatus("Idle")
		end
	}
end

return createPlaytestLoadingStore
