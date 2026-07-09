local Parent = script:FindFirstAncestor("SystemScrim").Parent
local Signals = require(Parent.Signals)

local function createDefaultStates() -- line: 17
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(false)
	local v6, v7 = Signals.createSignal(1)
	local v8, v9 = Signals.createSignal(true)
	local BindableEvent = Instance.new("BindableEvent")

	return {
		visible = v4,
		setVisibility = v5,
		transparency = v6,
		setTransparency = v7,
		autoDismiss = v8,
		setAutoDismiss = v9,
		backgroundScrimActivated = BindableEvent
	}
end

return Signals.createComputed(function(_) -- line: 35
	-- upvalues: createDefaultStates (copy)
	return (createDefaultStates())
end)
