local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console
require(parent.LuauPolyfill)

local New = {}

local function isCallable(value): boolean -- 3 equivalent calls inferred from this helper
	if typeof(value) == "function" then
		return true
	end

	if typeof(value) ~= "table" then
		return false
	end

	local metatable = getmetatable(value)

	if metatable and rawget(metatable, "__call") or value._isMockFunction then
		return true
	end

	return false
end

local Shared2 = require(parent.Shared)
local enableProfilerTimer = Shared2.ReactFeatureFlags.enableProfilerTimer

require(script.Parent.ReactInternalTypes)

require(parent.Shared)

local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local DidCapture = ReactFiberFlags.DidCapture

local v = nil
local v2 = nil
local v3 = false

function New.isDevToolsPresent(): boolean
	return ReactGlobals.__REACT_DEVTOOLS_GLOBAL_HOOK__ ~= nil
end

function New.injectInternals(p): boolean
	if ReactGlobals.__REACT_DEVTOOLS_GLOBAL_HOOK__ == nil then
		return false
	end

	local __REACT_DEVTOOLS_GLOBAL_HOOK__ = ReactGlobals.__REACT_DEVTOOLS_GLOBAL_HOOK__

	if __REACT_DEVTOOLS_GLOBAL_HOOK__.isDisabled then
		return true
	end

	if __REACT_DEVTOOLS_GLOBAL_HOOK__.supportsFiber then
		local success, result = pcall(function()
			v = __REACT_DEVTOOLS_GLOBAL_HOOK__.inject(p)

			v2 = __REACT_DEVTOOLS_GLOBAL_HOOK__
		end)

		if not success and ReactGlobals.__DEV__ then
			console.error("React instrumentation encountered an error: %s.", result)
		end

		return true
	end

	if ReactGlobals.__DEV__ then
		console.error("The installed version of React DevTools is too old and will not work with the current version of React. Please update React DevTools. https://reactjs.org/link/react-devtools")
	end

	return true
end

function New.onScheduleRoot(p, p2)
	if ReactGlobals.__DEV__ and v2 and isCallable(v2.onScheduleFiberRoot) then -- inferred equivalent call
		local success, result = pcall(v2.onScheduleFiberRoot, v, p, p2)

		if not success and ReactGlobals.__DEV__ and not v3 then
			v3 = true
			console.error("React instrumentation encountered an error: %s", result)
		end
	end
end

function New.onCommitRoot(p, p2)
	if v2 and isCallable(v2.onCommitFiberRoot) then -- inferred equivalent call
		local success, result = pcall(function()
			local v4 = bit32.band(p.current.flags, DidCapture) == DidCapture

			if enableProfilerTimer then
				v2.onCommitFiberRoot(v, p, p2, v4)
			else
				v2.onCommitFiberRoot(v, p, nil, v4)
			end
		end)

		if not success and ReactGlobals.__DEV__ and not v3 then
			v3 = true
			console.error("React instrumentation encountered an error: %s", result)
		end
	end
end

function New.onCommitUnmount(p)
	if v2 and isCallable(v2.onCommitFiberUnmount) then -- inferred equivalent call
		local success, result = pcall(v2.onCommitFiberUnmount, v, p)

		if not success and ReactGlobals.__DEV__ and not v3 then
			v3 = true
			console.error("React instrumentation encountered an error: %s", result)
		end
	end
end

return New
