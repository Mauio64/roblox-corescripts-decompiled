local parent = script.Parent.Parent.Parent

local ReactGlobals = require(parent.ReactGlobals)
require(parent.Shared)

require(script.Parent["ReactRobloxHostTypes.roblox"])

local ReactRobloxRoot = require(script.Parent.ReactRobloxRoot)
local createRoot = ReactRobloxRoot.createRoot
local createBlockingRoot = ReactRobloxRoot.createBlockingRoot
local createLegacyRoot = ReactRobloxRoot.createLegacyRoot
local isValidContainer = ReactRobloxRoot.isValidContainer

local ReactReconcilerroblox = require(script.Parent.Parent["ReactReconciler.roblox"])

local batchedUpdates = ReactReconcilerroblox.batchedUpdates

local flushSync = ReactReconcilerroblox.flushSync

local injectIntoDevTools = ReactReconcilerroblox.injectIntoDevTools
local flushPassiveEffects = ReactReconcilerroblox.flushPassiveEffects
local IsThisRendererActing = ReactReconcilerroblox.IsThisRendererActing

local createPortal = ReactReconcilerroblox.createPortal

local Shared = require(parent.Shared)
local ReactVersion = Shared.ReactVersion
local Shared2 = require(parent.Shared)
local invariant = Shared2.invariant
local Shared3 = require(parent.Shared)
local enableNewReconciler = Shared3.ReactFeatureFlags.enableNewReconciler

local ReactRobloxComponentTree = require(script.Parent.ReactRobloxComponentTree)
local getInstanceFromNode = ReactRobloxComponentTree.getInstanceFromNode
local getNodeFromInstance = ReactRobloxComponentTree.getNodeFromInstance
local getFiberCurrentPropsFromNode = ReactRobloxComponentTree.getFiberCurrentPropsFromNode
local getClosestInstanceFromNode = ReactRobloxComponentTree.getClosestInstanceFromNode

local Shared4 = require(parent.Shared)
local Event = Shared4.Event
local Shared5 = require(parent.Shared)
local Change = Shared5.Change
local Shared6 = require(parent.Shared)
local ReactRoblox = {
	createPortal = function(p, p2, p3: string?)
		invariant(isValidContainer(p2), "Target container is not a Roblox Instance.")

		return createPortal(p, p2, nil, p3)
	end,
	unstable_batchedUpdates = batchedUpdates,
	flushSync = flushSync,
	__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = {
		Events = {
			getInstanceFromNode = getInstanceFromNode,
			getNodeFromInstance = getNodeFromInstance,
			getFiberCurrentPropsFromNode = getFiberCurrentPropsFromNode,
			flushPassiveEffects = flushPassiveEffects,
			IsThisRendererActing = IsThisRendererActing
		}
	},
	version = ReactVersion,
	createRoot = createRoot,
	createBlockingRoot = createBlockingRoot,
	createLegacyRoot = createLegacyRoot,
	Event = Event,
	Change = Change,
	Tag = Shared6.Tag,
	unstable_isNewReconciler = enableNewReconciler,
	act = function(_)
		error("ReactRoblox.act is only available in testing environments, not production. Enable the `__ROACT_17_MOCK_SCHEDULER__` global in your test configuration in order to use `act`.")
	end
}

if ReactGlobals.__ROACT_17_MOCK_SCHEDULER__ then
	ReactRoblox.act = ReactReconcilerroblox.act
end

injectIntoDevTools({
	findFiberByHostInstance = getClosestInstanceFromNode,
	bundleType = ReactGlobals.__DEV__ and 1 or 0,
	version = ReactVersion,
	rendererPackageName = "ReactRoblox"
})

local __DEV__ = ReactGlobals.__DEV__

ReactRoblox.robloxReactProfiling = ReactReconcilerroblox.robloxReactProfiling
ReactRoblox.schedulingProfiler = ReactReconcilerroblox.schedulingProfiler

return ReactRoblox
