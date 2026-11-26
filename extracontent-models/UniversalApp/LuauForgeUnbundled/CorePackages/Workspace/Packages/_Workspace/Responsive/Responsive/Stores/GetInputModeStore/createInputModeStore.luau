local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Signals")

local InputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/InputMode")

return function()
	local signal, v5 = Signals.createSignal(InputMode.last())
	local signal2, v6 = Signals.createSignal(InputMode.preferred())

	InputMode.connect(function()
		v5(InputMode.last())
		v6(InputMode.preferred())
	end)

	return { getLastInputType = signal, getPreferredInputType = signal2 }
end
