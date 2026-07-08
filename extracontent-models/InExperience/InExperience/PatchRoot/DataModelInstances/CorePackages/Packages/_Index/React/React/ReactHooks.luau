local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Array = require(ParentParent.LuauPolyfill).Array
local console = require(ParentParent.Shared).console

require(ParentParent.Shared)
require(ParentParent.Shared)

local ReactCurrentDispatcher = require(ParentParent.Shared).ReactSharedInternals.ReactCurrentDispatcher

local function resolveDispatcher() -- line: 46
	-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
	local current = ReactCurrentDispatcher.current

	if ReactGlobals.__DEV__ and current == nil then
		console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
	end

	return current
end

return {
	useContext = function(p1, p2, ...) -- line: 76
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy), Array (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		if ReactGlobals.__DEV__ then
			if p2 ~= nil then
				console.error("useContext() second argument is reserved for future use in React. Passing it is not supported. You passed: %s.%s", p2, (typeof(p2) ~= "number" or not Array.isArray({ ... })) and "" or "\n\nDid you call Array.map(useContext)? Calling Hooks inside a loop is not supported. Learn more at https://reactjs.org/link/rules-of-hooks")
			end

			if p1._context ~= nil then
				local _context = p1._context

				if p1 == _context.Consumer then
					console.error("Calling useContext(Context.Consumer) is not supported, may cause bugs, and will be removed in a future major release. Did you mean to call useContext(Context) instead?")
				elseif p1 == _context.Provider then
					console.error("Calling useContext(Context.Provider) is not supported. Did you mean to call useContext(Context) instead?")
				end
			end
		end

		return current.useContext(p1, p2)
	end,
	useState = function(p3, ...) -- line: 122
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useState(p3, ...)
	end,
	useReducer = function(p4: ((...any) -> ...any), p5, p6: ((...any) -> ...any)?) -- line: 141
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useReducer(p4, p5, p6)
	end,
	useRef = function(p7) -- line: 163
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useRef(p7)
	end,
	useBinding = function(p8) -- line: 175
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useBinding(p8)
	end,
	useEffect = function(p9: ((...any) -> ...any), p10) -- line: 195
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useEffect(p9, p10)
	end,
	useLayoutEffect = function(p11: ((...any) -> ...any), p12) -- line: 219
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useLayoutEffect(p11, p12)
	end,
	useCallback = function(p13, p14) -- line: 235
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useCallback(p13, p14)
	end,
	useMemo = function(p15: ((...any) -> ...any), p16) -- line: 246
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useMemo(p15, p16)
	end,
	useImperativeHandle = function(p17, p18: ((...any) -> ...any), p19) -- line: 261
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useImperativeHandle(p17, p18, p19)
	end,
	useDebugValue = function(p20, p21: ((...any) -> ...any)?) -- line: 279
		-- upvalues: ReactGlobals (copy), ReactCurrentDispatcher (copy), console (copy)
		if ReactGlobals.__DEV__ then
			local current = ReactCurrentDispatcher.current

			if ReactGlobals.__DEV__ and current == nil then
				console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
			end

			return current.useDebugValue(p20, p21)
		end

		return nil
	end,
	emptyObject = {},
	useOpaqueIdentifier = function() -- line: 304
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useOpaqueIdentifier()
	end,
	useMutableSource = function(p22, p23, p24) -- line: 309
		-- upvalues: ReactCurrentDispatcher (copy), ReactGlobals (copy), console (copy)
		local current = ReactCurrentDispatcher.current

		if ReactGlobals.__DEV__ and current == nil then
			console.error("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.")
		end

		return current.useMutableSource(p22, p23, p24)
	end
}
