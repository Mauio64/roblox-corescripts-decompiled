local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local function createCreatorAgentResumeStore()
	local signal, v5 = Signals.createSignal(nil)

	local function useActiveTarget()
		return SignalsReact.useSignalState(signal)
	end

	return {
		getActiveTarget = signal,
		useActiveTarget = useActiveTarget,
		setActiveTarget = v5
	}
end

return Signals.createComputed(createCreatorAgentResumeStore)
