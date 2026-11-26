local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")

return function()
	local signal, v5 = Signals.createSignal(false)

	return { getVisibility = signal, setVisibility = v5 }
end
