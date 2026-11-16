local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local function createMyCreationsFilterStore()
	local signal, setFilter = Signals.createSignal({ games = "MyGames" })

	local function useFilter()
		return SignalsReact.useSignalState(signal)
	end

	return { getFilter = signal, useFilter = useFilter, setFilter = setFilter }
end

return createMyCreationsFilterStore
