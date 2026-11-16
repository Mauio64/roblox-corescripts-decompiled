local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local console = LuauPolyfill.console
local function onlyInTestError(p: string)
	return function()
		console.error(p .. " is only available in tests, not in production")
	end
end

local ReactCurrentDispatcher = require(script.ReactCurrentDispatcher)

local ReactCurrentBatchConfig = require(script.ReactCurrentBatchConfig)
local ReactCurrentOwner = require(script.ReactCurrentOwner)
local ReactDebugCurrentFrame = require(script.ReactDebugCurrentFrame)
return {
	ReactCurrentDispatcher = ReactCurrentDispatcher,
	ReactCurrentBatchConfig = ReactCurrentBatchConfig,
	ReactCurrentOwner = ReactCurrentOwner,
	IsSomeRendererActing = require(script.IsSomeRendererActing),
	ReactDebugCurrentFrame = not ReactGlobals.__DEV__ and {
		setExtraStackFrame = function(_: string?) end
	} or ReactDebugCurrentFrame
}
