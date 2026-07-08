local invariant = require(script.Parent.invariant)
local invokeGuardedCallbackImpl = require(script.Parent.invokeGuardedCallbackImpl)
local u3 = nil
local u4 = false
local u5 = nil
local u6 = false
local u7 = nil
local t1 = {
	onError = function(p1) -- line: 25
		-- upvalues: u4 (ref), u5 (ref)
		u4 = true
		u5 = p1
	end
}
local t2 = {
	invokeGuardedCallback = function(...) -- line: 45
		-- upvalues: u4 (ref), u5 (ref), invokeGuardedCallbackImpl (copy), t1 (copy)
		u4 = false
		u5 = nil
		invokeGuardedCallbackImpl(t1, ...)
	end
}

function t2.invokeGuardedCallbackAndCatchFirstError(...) -- line: 62
	-- upvalues: t2 (copy), u4 (ref), u3 (ref), u6 (ref), u7 (ref)
	t2.invokeGuardedCallback(...)

	if u4 then
		local v11 = u3()

		if not u6 then
			u6 = true
			u7 = v11
		end
	end
end
function t2.rethrowCaughtError() -- line: 80
	-- upvalues: u6 (ref), u7 (ref)
	if u6 then
		local v12 = u7

		u6 = false
		u7 = nil
		error(v12)
	end
end
function t2.hasCaughtError() -- line: 89
	-- upvalues: u4 (ref)
	return u4
end
function u3() -- line: 93
	-- upvalues: u4 (ref), u5 (ref), invariant (copy)
	if u4 then
		local v13 = u5

		u4 = false
		u5 = nil

		return v13
	end

	invariant(false, "clearCaughtError was called but no error was captured. This error is likely caused by a bug in React. Please file an issue.")

	return nil
end

t2.clearCaughtError = u3

return t2
