local invariant = require(script.Parent.invariant)
local invokeGuardedCallbackImpl = require(script.Parent.invokeGuardedCallbackImpl)

local fn

local flag = false
local v = nil

local flag2 = false
local v2 = nil
local v3 = {
	onError = function(p)
		flag = true
		v = p
	end
}

local ReactErrorUtils = {}

function ReactErrorUtils.invokeGuardedCallback(...)
	flag = false
	v = nil

	invokeGuardedCallbackImpl(v3, ...)
end

function ReactErrorUtils.invokeGuardedCallbackAndCatchFirstError(...)
	ReactErrorUtils.invokeGuardedCallback(...)

	if flag then
		local v4 = fn()

		if not flag2 then
			flag2 = true
			v2 = v4
		end
	end
end

function ReactErrorUtils.rethrowCaughtError()
	if flag2 then
		local v4 = v2
		flag2 = false
		v2 = nil
		error(v4)
	end
end

function ReactErrorUtils.hasCaughtError()
	return flag
end

fn = function()
	if not flag then
		invariant(
			false,
			"clearCaughtError was called but no error was captured. This error is likely caused by a bug in React. Please file an issue."
		)

		return nil
	end

	local v4 = v
	flag = false
	v = nil
	return v4
end

ReactErrorUtils.clearCaughtError = fn

return ReactErrorUtils
