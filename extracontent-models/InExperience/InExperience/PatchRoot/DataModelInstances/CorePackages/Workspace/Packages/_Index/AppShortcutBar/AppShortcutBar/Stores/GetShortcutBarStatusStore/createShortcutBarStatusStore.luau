local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)

local function createShortcutBarStatusStore() -- line: 13
	-- upvalues: Signals (copy), SignalsReact (copy)
	local v5, v6 = Signals.createSignal(false)

	return {
		getShortcutBarVisible = v5,
		setShortcutBarVisible = v6,
		useShortcutBarVisible = function() -- line: 16
			-- upvalues: SignalsReact (copy), v5 (copy)
			return SignalsReact.useSignalState(v5)
		end
	}
end

return createShortcutBarStatusStore
