local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBarStore/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBarStore/SignalsReact")

local function createShortcutBarStatusStore()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(0)

	local function useShortcutBarVisible()
		return SignalsReact.useSignalState(signal)
	end

	return {
		getShortcutBarVisible = signal,
		setShortcutBarVisible = v5,
		useShortcutBarVisible = useShortcutBarVisible,
		getShortcutBarReservedHeight = signal2,
		setShortcutBarReservedHeight = v6
	}
end

return createShortcutBarStatusStore
