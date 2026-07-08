local scriptParent = script.Parent

require(scriptParent.LuauPolyfill)

local ReactTypes = require(script.ReactTypes)

require(script["flowtypes.roblox"])
require(script.ReactElementType)

local ReactFiberHostConfig = require(script.ReactFiberHostConfig)
local ReactSharedInternals = require(script.ReactSharedInternals)
local lib = require(script["ErrorHandling.roblox"])

return {
	checkPropTypes = require(script.checkPropTypes),
	console = require(script.console),
	ConsolePatchingDev = require(script["ConsolePatchingDev.roblox"]),
	consoleWithStackDev = require(script.consoleWithStackDev),
	enqueueTask = require(script["enqueueTask.roblox"]),
	ExecutionEnvironment = require(script.ExecutionEnvironment),
	formatProdErrorMessage = require(script.formatProdErrorMessage),
	getComponentName = require(script.getComponentName),
	invariant = require(script.invariant),
	invokeGuardedCallbackImpl = require(script.invokeGuardedCallbackImpl),
	isValidElementType = require(script.isValidElementType),
	objectIs = require(script.objectIs),
	ReactComponentStackFrame = require(script.ReactComponentStackFrame),
	ReactElementType = require(script.ReactElementType),
	ReactErrorUtils = require(script.ReactErrorUtils),
	ReactFeatureFlags = require(script.ReactFeatureFlags),
	ReactInstanceMap = require(script.ReactInstanceMap),
	ReactSharedInternals = ReactSharedInternals,
	ReactFiberHostConfig = ReactFiberHostConfig,
	ReactSymbols = require(script.ReactSymbols),
	ReactVersion = require(script.ReactVersion),
	shallowEqual = require(script.shallowEqual),
	UninitializedState = require(script["UninitializedState.roblox"]),
	ReactTypes = ReactTypes,
	describeError = lib.describeError,
	errorToString = lib.errorToString,
	parseReactError = lib.parseReactError,
	Symbol = require(script["Symbol.roblox"]),
	Type = require(script["Type.roblox"]),
	Change = require(script.PropMarkers.Change),
	Event = require(script.PropMarkers.Event),
	Tag = require(script.PropMarkers.Tag)
}
