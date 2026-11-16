local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local v = { Games = "Games", Previews = "Previews" }

return {
	BUILD_HOME_TAB = v,
	createBuildHomeTabStore = function()
		local signal, setTab = Signals.createSignal(v.Games)

		local function useTab()
			return SignalsReact.useSignalState(signal)
		end

		return { getTab = signal, useTab = useTab, setTab = setTab }
	end
}
