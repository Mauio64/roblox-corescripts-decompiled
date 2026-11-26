local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local function createMyCreationsFilterStore()
	local signal, v5 = Signals.createSignal({ games = "MyGames" })

	local function useFilter()
		return SignalsReact.useSignalState(signal)
	end

	return { getFilter = signal, useFilter = useFilter, setFilter = v5 }
end

return createMyCreationsFilterStore
