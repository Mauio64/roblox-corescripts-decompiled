local parent = script:FindFirstAncestor("Drawer").Parent
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableDrawerAnimatingHook = SharedFlags.FFlagEnableDrawerAnimatingHook

local function createDrawerVisibleStore()
	local signal, v = Signals.createSignal(false)
	local signal2, setDrawerShouldMount = Signals.createSignal(false)

	local function useDrawerVisible()
		return SignalsReact.useSignalState(signal)
	end

	local function useDrawerShouldMount()
		return SignalsReact.useSignalState(signal2)
	end

	local function setDrawerVisible(flag: boolean)
		v(flag)

		if flag then
			setDrawerShouldMount(true)
		end
	end

	local setDrawerAnimating, getDrawerAnimating, fn

	if FFlagEnableDrawerAnimatingHook then
		local v2
		v2, setDrawerAnimating = Signals.createSignal(false)
		getDrawerAnimating = v2
		fn = function()
			return SignalsReact.useSignalState(getDrawerAnimating)
		end
	else
		getDrawerAnimating = nil
	end

	return {
		getDrawerVisible = signal,
		getDrawerAnimating = getDrawerAnimating,
		setDrawerVisible = setDrawerVisible,
		setDrawerShouldMount = setDrawerShouldMount,
		setDrawerAnimating = setDrawerAnimating,
		useDrawerVisible = useDrawerVisible,
		useDrawerShouldMount = useDrawerShouldMount,
		useDrawerAnimating = fn
	}
end

return createDrawerVisibleStore
