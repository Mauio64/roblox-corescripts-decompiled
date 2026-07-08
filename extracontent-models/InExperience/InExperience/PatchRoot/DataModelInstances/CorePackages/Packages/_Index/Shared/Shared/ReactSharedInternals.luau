local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.LuauPolyfill).console

local function onlyInTestError(s1: string) -- line: 28
	-- upvalues: console (copy)
	return function() -- line: 29
		-- upvalues: console (copy), s1 (copy)
		console.error(s1 .. " is only available in tests, not in production")
	end
end

local ReactCurrentDispatcher = require(script.ReactCurrentDispatcher)
local ReactCurrentBatchConfig = require(script.ReactCurrentBatchConfig)
local ReactCurrentOwner = require(script.ReactCurrentOwner)
local ReactDebugCurrentFrame = require(script.ReactDebugCurrentFrame)
local IsSomeRendererActing = require(script.IsSomeRendererActing)

return {
	ReactCurrentDispatcher = ReactCurrentDispatcher,
	ReactCurrentBatchConfig = ReactCurrentBatchConfig,
	ReactCurrentOwner = ReactCurrentOwner,
	IsSomeRendererActing = IsSomeRendererActing,
	ReactDebugCurrentFrame = if not ReactGlobals.__DEV__ then {
		setExtraStackFrame = function(_: string?) -- line: 52
		end
	} else ReactDebugCurrentFrame
}
