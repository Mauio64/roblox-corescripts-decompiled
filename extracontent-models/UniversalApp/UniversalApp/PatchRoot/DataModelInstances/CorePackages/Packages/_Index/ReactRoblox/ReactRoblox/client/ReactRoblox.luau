local ParentParent = script.Parent.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)

require(ParentParent.Shared)
require(script.Parent["ReactRobloxHostTypes.roblox"])

local ReactRobloxRoot = require(script.Parent.ReactRobloxRoot)
local createRoot = ReactRobloxRoot.createRoot
local createBlockingRoot = ReactRobloxRoot.createBlockingRoot
local createLegacyRoot = ReactRobloxRoot.createLegacyRoot
local isValidContainer = ReactRobloxRoot.isValidContainer
local lib = require(script.Parent.Parent["ReactReconciler.roblox"])
local batchedUpdates = lib.batchedUpdates
local flushSync = lib.flushSync
local injectIntoDevTools = lib.injectIntoDevTools
local flushPassiveEffects = lib.flushPassiveEffects
local IsThisRendererActing = lib.IsThisRendererActing
local createPortal = lib.createPortal
local ReactVersion = require(ParentParent.Shared).ReactVersion
local invariant = require(ParentParent.Shared).invariant
local enableNewReconciler = require(ParentParent.Shared).ReactFeatureFlags.enableNewReconciler
local ReactRobloxComponentTree = require(script.Parent.ReactRobloxComponentTree)
local getInstanceFromNode = ReactRobloxComponentTree.getInstanceFromNode
local getNodeFromInstance = ReactRobloxComponentTree.getNodeFromInstance
local getFiberCurrentPropsFromNode = ReactRobloxComponentTree.getFiberCurrentPropsFromNode
local getClosestInstanceFromNode = ReactRobloxComponentTree.getClosestInstanceFromNode
local Event = require(ParentParent.Shared).Event
local Change = require(ParentParent.Shared).Change
local Tag = require(ParentParent.Shared).Tag
local t1 = {
	Events = {
		getInstanceFromNode = getInstanceFromNode,
		getNodeFromInstance = getNodeFromInstance,
		getFiberCurrentPropsFromNode = getFiberCurrentPropsFromNode,
		flushPassiveEffects = flushPassiveEffects,
		IsThisRendererActing = IsThisRendererActing
	}
}
local t2 = {
	createPortal = function(p1, p2, s1: string?) -- line: 135
		-- upvalues: invariant (copy), isValidContainer (copy), createPortal (copy)
		invariant(isValidContainer(p2), "Target container is not a Roblox Instance.")

		return createPortal(p1, p2, nil, s1)
	end,
	unstable_batchedUpdates = batchedUpdates,
	flushSync = flushSync,
	__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = t1,
	version = ReactVersion,
	createRoot = createRoot,
	createBlockingRoot = createBlockingRoot,
	createLegacyRoot = createLegacyRoot,
	Event = Event,
	Change = Change,
	Tag = Tag,
	unstable_isNewReconciler = enableNewReconciler,
	act = function(_: ((...any) -> ...any)) -- line: 276
		error("ReactRoblox.act is only available in testing environments, not production. Enable the `__ROACT_17_MOCK_SCHEDULER__` global in your test configuration in order to use `act`.")
	end
}

if ReactGlobals.__ROACT_17_MOCK_SCHEDULER__ then
	t2.act = lib.act
end

injectIntoDevTools({
	rendererPackageName = "ReactRoblox",
	findFiberByHostInstance = getClosestInstanceFromNode,
	bundleType = not ReactGlobals.__DEV__ and 0 or 1,
	version = ReactVersion
})

if not ReactGlobals.__DEV__ then
end

t2.robloxReactProfiling = lib.robloxReactProfiling
t2.schedulingProfiler = lib.schedulingProfiler

return t2
