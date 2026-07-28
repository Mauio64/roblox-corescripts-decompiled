local Drawer = script:FindFirstAncestor("Drawer")
local DrawerParent = Drawer.Parent
local Signals = require(DrawerParent.Signals)
local SignalsReact = require(DrawerParent.SignalsReact)
local FFlagEnableDrawerAnimatingHook = require(Drawer.Flags).FFlagEnableDrawerAnimatingHook

local function createDrawerVisibleStore() -- line: 18
	-- upvalues: Signals (copy), SignalsReact (copy), FFlagEnableDrawerAnimatingHook (copy)
	local v7, v8 = Signals.createSignal(false)
	local v9, v10 = Signals.createSignal(false)
	local v11 = nil
	local v12 = nil

	if FFlagEnableDrawerAnimatingHook then
		v11, v12 = Signals.createSignal(false)
	end

	return {
		getDrawerVisible = v7,
		getDrawerAnimating = v11,
		setDrawerVisible = function(b1: boolean) -- line: 30
			-- upvalues: v8 (copy), v10 (copy)
			v8(b1)

			if b1 then
				v10(true)
			end
		end,
		setDrawerShouldMount = v10,
		setDrawerAnimating = v12,
		useDrawerVisible = function() -- line: 22
			-- upvalues: SignalsReact (copy), v7 (copy)
			return SignalsReact.useSignalState(v7)
		end,
		useDrawerShouldMount = function() -- line: 26
			-- upvalues: SignalsReact (copy), v9 (copy)
			return SignalsReact.useSignalState(v9)
		end
	}
end

return createDrawerVisibleStore
