local parent = script.Parent.Parent
local React = require(parent.React)

local Signals = require(parent.Signals)
local createEffect = Signals.createEffect

local _, result = xpcall(function()
	return game:DefineFastFlag("SignalsReactUseMutableSource", false)
end, function(): boolean
	return true
end)

local function getSignalVersion(callback)
	local function dummyObserver()
		return callback
	end

	local v = nil

	local function scope(callback2)
		v = callback2
		return dummyObserver
	end

	callback(scope)

	v(dummyObserver, true)

	return v()
end

local function getSignalSnapshot(callback)
	return callback(false)
end

local function subscribeToSignal(callback, callback2)
	return createEffect(function(p)
		callback2(callback(p))
	end)
end

local function useSignalState(p)
	local v = React.useMemo(function()
		return React.createMutableSource(p, getSignalVersion)
	end, { p })

	return React.useMutableSource(v, getSignalSnapshot, subscribeToSignal)
end

local function useSignalState_old(callback)
	local state, setState = React.useState(function()
		return callback(false)
	end)

	React.useLayoutEffect(function()
		setState(callback(false))
		return createEffect(function(p)
			setState(callback(p))
		end)
	end, { callback })

	return state
end

return if result then useSignalState else useSignalState_old
