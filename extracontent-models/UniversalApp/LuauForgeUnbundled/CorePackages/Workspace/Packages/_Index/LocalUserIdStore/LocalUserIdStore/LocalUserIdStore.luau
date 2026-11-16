local signal, v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/LocalUserIdStore/Signals").createSignal("")

return {
	getCurrentUserId = signal,
	setCurrentUserId = v5,
	reset = function()
		v5("")
	end
}
