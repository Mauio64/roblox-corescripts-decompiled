local signal, v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/Signals").createSignal(0)

return {
	notifyProfileRefresh = function()
		v5(os.clock())
	end,
	getProfileRefreshSignal = signal
}
