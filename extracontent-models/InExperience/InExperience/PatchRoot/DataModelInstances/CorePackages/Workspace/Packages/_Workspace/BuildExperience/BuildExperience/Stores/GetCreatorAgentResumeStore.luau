local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local function createCreatorAgentResumeStore()
	local signal, setActiveTarget = Signals.createSignal(nil)

	local function useActiveTarget()
		return SignalsReact.useSignalState(signal)
	end

	return {
		getActiveTarget = signal,
		useActiveTarget = useActiveTarget,
		setActiveTarget = setActiveTarget
	}
end

return Signals.createComputed(createCreatorAgentResumeStore)
