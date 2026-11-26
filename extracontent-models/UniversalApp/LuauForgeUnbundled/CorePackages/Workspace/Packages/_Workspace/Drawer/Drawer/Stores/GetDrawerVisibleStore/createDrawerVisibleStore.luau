local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/SignalsReact")

local fFlagEnableDrawerAnimatingHook = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/SharedFlags").FFlagEnableDrawerAnimatingHook

local function createDrawerVisibleStore()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(false)

	local function useDrawerVisible()
		return SignalsReact.useSignalState(signal)
	end

	local function useDrawerShouldMount()
		return SignalsReact.useSignalState(signal2)
	end

	local function setDrawerVisible(p2)
		v5(p2)

		if p2 then
			v6(true)
		end
	end

	local v7, v8, fn

	if fFlagEnableDrawerAnimatingHook then
		local v9
		v9, v7 = Signals.createSignal(false)
		v8 = v9
		fn = function()
			return SignalsReact.useSignalState(v8)
		end
	else
		v8 = nil
	end

	return {
		getDrawerVisible = signal,
		getDrawerAnimating = v8,
		setDrawerVisible = setDrawerVisible,
		setDrawerShouldMount = v6,
		setDrawerAnimating = v7,
		useDrawerVisible = useDrawerVisible,
		useDrawerShouldMount = useDrawerShouldMount,
		useDrawerAnimating = fn
	}
end

return createDrawerVisibleStore
