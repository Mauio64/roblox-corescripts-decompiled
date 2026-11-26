local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals").createSignal

return function()
	local signal, v5 = createSignal(false)

	return { getInspectAndBuyOpen = signal, setInspectAndBuyOpen = v5 }
end
