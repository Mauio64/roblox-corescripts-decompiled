local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local SafeFlags = require(parent.SafeFlags)

local getFFlag = SafeFlags.createGetFFlag("ReactEnableSchedulingProfiler")

local getFFlag2 = SafeFlags.createGetFFlag("ReactCatchYieldingInDEV")

local getFFlag3 = SafeFlags.createGetFFlag("ReactFilterInternalStackFrames")

return {
	enableDebugTracing = false,
	enableSchedulingProfiler = getFFlag() or ReactGlobals.__PROFILE__ and ReactGlobals.__EXPERIMENTAL__,
	catchYieldingInDEV = ReactGlobals.__DEV__ and getFFlag2(),
	debugRenderPhaseSideEffectsForStrictMode = ReactGlobals.__DEV__,
	replayFailedUnitOfWorkWithInvokeGuardedCallback = ReactGlobals.__DEV__,
	warnAboutDeprecatedLifecycles = true,
	enableProfilerTimer = ReactGlobals.__PROFILE__,
	enableProfilerCommitHooks = ReactGlobals.__PROFILE__,
	enableSchedulerTracing = ReactGlobals.__PROFILE__,
	enableSuspenseServerRenderer = ReactGlobals.__EXPERIMENTAL__,
	enableBlocksAPI = ReactGlobals.__EXPERIMENTAL__,
	enableLazyElements = ReactGlobals.__EXPERIMENTAL__,
	enableSchedulerDebugging = false,
	enableFundamentalAPI = false,
	enableScopeAPI = false,
	enableCreateEventHandleAPI = false,
	warnAboutUnmockedScheduler = false,
	enableSuspenseCallback = false,
	warnAboutDefaultPropsOnFunctionComponents = false,
	warnAboutSpreadingKeyToJSX = true,
	enableComponentStackLocations = true,
	enableNewReconciler = true,
	skipUnmountedBoundaries = true,
	deletedTreeCleanUpLevel = SafeFlags.createGetFInt("ReactDeletedTreeCleanUpLevel", 1)(),
	enableNewTreeCleanupPath = SafeFlags.createGetFFlag("ReactEnableNewTreeCleanupPath", false)(),
	enableHookDoubleBuffering = SafeFlags.createGetFFlag("ReactEnableHookDoubleBuffering", false)(),
	filterInternalStackFrames = ReactGlobals.__DEV__ and getFFlag3(),
	warnAboutStringRefs = false,
	disableLegacyContext = false,
	disableModulePatternComponents = false,
	warnUnstableRenderSubtreeIntoContainer = false,
	deferRenderPhaseUpdateToNextBatch = false,
	decoupleUpdatePriorityFromScheduler = true,
	enableEagerRootListeners = false,
	enableDoubleInvokingEffects = false,
	enableAllocationTrims = SafeFlags.createGetFFlag("ReactEnableAllocationTrims", false)(),
	enableWorkLoopTrims = SafeFlags.createGetFFlag("ReactWorkLoopTrims", false)(),
	enableCommitTraversalTrims = SafeFlags.createGetFFlag("ReactCommitTraversalTrims", false)(),
	enableSkipHostSiblingLookup = SafeFlags.createGetFFlag("ReactSkipHostSiblingLookup", false)(),
	enableReentrantSafeSignals = SafeFlags.createGetFFlag("ReactReentrantSafeSignals", false)(),
	keepSyncQueueOnError = SafeFlags.createGetFFlag("ReactKeepSyncQueueOnError", false)(),
	fixGetInstanceFromNode = SafeFlags.createGetFFlag("ReactFixGetInstanceFromNode", false)(),
	fixEagerReducerError = SafeFlags.createGetFFlag("ReactFixEagerReducerError", false)()
}
