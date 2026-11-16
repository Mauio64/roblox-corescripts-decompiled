local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local function createPlayButtonStore()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(nil)

	local signal3, v7 = Signals.createSignal(nil)

	local function useIsActive()
		return SignalsReact.useSignalState(signal)
	end

	local function useResumeTarget()
		return SignalsReact.useSignalState(signal2)
	end

	return {
		getIsActive = signal,
		useIsActive = useIsActive,
		setIsActive = v5,
		getResumeTarget = signal2,
		useResumeTarget = useResumeTarget,
		setResumeTarget = v6,
		getPendingResourceAttachment = signal3,
		setPendingResourceAttachment = v7
	}
end

return createPlayButtonStore
