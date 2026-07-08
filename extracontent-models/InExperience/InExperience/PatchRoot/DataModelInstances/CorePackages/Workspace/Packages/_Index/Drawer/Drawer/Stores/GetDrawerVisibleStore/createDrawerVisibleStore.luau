local Parent = script:FindFirstAncestor("Drawer").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)

local function createDrawerVisibleStore() -- line: 14
	-- upvalues: Signals (copy), SignalsReact (copy)
	local v5, v6 = Signals.createSignal(false)
	local v7, v8 = Signals.createSignal(false)

	return {
		getDrawerVisible = v5,
		setDrawerVisible = function(b1: boolean) -- line: 26
			-- upvalues: v6 (copy), v8 (copy)
			v6(b1)

			if b1 then
				v8(true)
			end
		end,
		setDrawerShouldMount = v8,
		useDrawerVisible = function() -- line: 18
			-- upvalues: SignalsReact (copy), v5 (copy)
			return SignalsReact.useSignalState(v5)
		end,
		useDrawerShouldMount = function() -- line: 22
			-- upvalues: SignalsReact (copy), v7 (copy)
			return SignalsReact.useSignalState(v7)
		end
	}
end

return createDrawerVisibleStore
