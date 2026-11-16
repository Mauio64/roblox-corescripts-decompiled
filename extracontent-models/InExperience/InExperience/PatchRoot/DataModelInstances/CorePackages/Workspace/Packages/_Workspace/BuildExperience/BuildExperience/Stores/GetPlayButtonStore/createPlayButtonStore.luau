local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(BuildExperience.Chat.chatTypes)

local function createPlayButtonStore()
	local signal, setIsActive = Signals.createSignal(false)
	local signal2, setResumeTarget = Signals.createSignal(nil)

	local signal3, setPendingResourceAttachment = Signals.createSignal(nil)

	local function useIsActive()
		return SignalsReact.useSignalState(signal)
	end

	local function useResumeTarget()
		return SignalsReact.useSignalState(signal2)
	end

	return {
		getIsActive = signal,
		useIsActive = useIsActive,
		setIsActive = setIsActive,
		getResumeTarget = signal2,
		useResumeTarget = useResumeTarget,
		setResumeTarget = setResumeTarget,
		getPendingResourceAttachment = signal3,
		setPendingResourceAttachment = setPendingResourceAttachment
	}
end

return createPlayButtonStore
