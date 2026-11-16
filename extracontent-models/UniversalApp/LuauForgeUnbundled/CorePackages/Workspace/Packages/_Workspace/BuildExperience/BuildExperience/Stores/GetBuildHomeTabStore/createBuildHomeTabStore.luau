local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local v5 = { Games = "Games", Previews = "Previews" }

return {
	BUILD_HOME_TAB = v5,
	createBuildHomeTabStore = function()
		local signal, v6 = Signals.createSignal(v5.Games)

		local function useTab()
			return SignalsReact.useSignalState(signal)
		end

		return { getTab = signal, useTab = useTab, setTab = v6 }
	end
}
