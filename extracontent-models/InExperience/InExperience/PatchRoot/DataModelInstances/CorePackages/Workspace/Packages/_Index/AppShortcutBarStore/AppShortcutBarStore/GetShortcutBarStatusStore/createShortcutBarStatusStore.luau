local parent = script:FindFirstAncestor("AppShortcutBarStore").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local function createShortcutBarStatusStore()
	local signal, setShortcutBarVisible = Signals.createSignal(false)
	local signal2, setShortcutBarReservedHeight = Signals.createSignal(0)

	local function useShortcutBarVisible()
		return SignalsReact.useSignalState(signal)
	end

	return {
		getShortcutBarVisible = signal,
		setShortcutBarVisible = setShortcutBarVisible,
		useShortcutBarVisible = useShortcutBarVisible,
		getShortcutBarReservedHeight = signal2,
		setShortcutBarReservedHeight = setShortcutBarReservedHeight
	}
end

return createShortcutBarStatusStore
