local parent = script:FindFirstAncestor("SystemScrim").Parent
local Signals = require(parent.Signals)

local function createDefaultStates()
	local signal, setVisibility = Signals.createSignal(false)
	local signal2, setTransparency = Signals.createSignal(1)
	local signal3, setAutoDismiss = Signals.createSignal(true)

	return {
		visible = signal,
		setVisibility = setVisibility,
		transparency = signal2,
		setTransparency = setTransparency,
		autoDismiss = signal3,
		setAutoDismiss = setAutoDismiss,
		backgroundScrimActivated = Instance.new("BindableEvent")
	}
end

return Signals.createComputed(function(_)
	return createDefaultStates()
end)
