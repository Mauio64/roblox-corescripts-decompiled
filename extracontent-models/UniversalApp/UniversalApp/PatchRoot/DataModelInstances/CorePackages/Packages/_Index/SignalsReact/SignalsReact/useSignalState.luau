local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local createEffect = require(ParentParent.Signals).createEffect
local _, result = xpcall(function() -- line: 8
	return game:DefineFastFlag("SignalsReactUseMutableSource", false)
end, function() -- line: 10
	return true
end)

local function getSignalVersion(p1) -- line: 14
	local function dummyObserver() -- line: 15
		-- upvalues: p1 (copy)
		return p1
	end

	local u13 = nil

	local function scope(p2: ((...any) -> ...any)) -- line: 25
		-- upvalues: u13 (ref), dummyObserver (copy)
		u13 = p2

		return dummyObserver
	end

	p1(scope)
	u13(dummyObserver, true)

	return u13()
end
local function getSignalSnapshot(p3) -- line: 37
	return p3(false)
end
local function subscribeToSignal(p4, p5: ((...any) -> ...any)) -- line: 41
	-- upvalues: createEffect (copy)
	return createEffect(function(p6) -- line: 42
		-- upvalues: p5 (copy), p4 (copy)
		p5(p4(p6))
	end)
end
local function useSignalState(p7) -- line: 47
	-- upvalues: React (copy), getSignalVersion (copy), getSignalSnapshot (copy), subscribeToSignal (copy)
	local v19 = React.useMemo(function() -- line: 48
		-- upvalues: React (copy), p7 (copy), getSignalVersion (copy)
		return React.createMutableSource(p7, getSignalVersion)
	end, { p7 })

	return React.useMutableSource(v19, getSignalSnapshot, subscribeToSignal)
end
local function useSignalState_old(p8) -- line: 55
	-- upvalues: React (copy), createEffect (copy)
	local v21, v22 = React.useState(function() -- line: 56
		-- upvalues: p8 (copy)
		return p8(false)
	end)

	React.useLayoutEffect(function() -- line: 60
		-- upvalues: v22 (copy), p8 (copy), createEffect (copy)
		v22(p8(false))

		return createEffect(function(p9) -- line: 62
			-- upvalues: v22 (copy), p8 (copy)
			v22(p8(p9))
		end)
	end, { p8 })

	return v21
end

if result then
	return useSignalState
end

return useSignalState_old
