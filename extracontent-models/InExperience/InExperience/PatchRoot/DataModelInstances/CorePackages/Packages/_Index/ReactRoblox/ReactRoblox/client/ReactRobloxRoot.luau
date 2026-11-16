local parent = script.Parent.Parent.Parent

require(script.Parent["ReactRobloxHostTypes.roblox"])

local ReactGlobals = require(parent.ReactGlobals)
require(parent.ReactReconciler)

require(parent.Shared)

require(parent.ReactReconciler)

local ReactRobloxComponentTree = require(script.Parent.ReactRobloxComponentTree)

local markContainerAsRoot = ReactRobloxComponentTree.markContainerAsRoot
local unmarkContainerAsRoot = ReactRobloxComponentTree.unmarkContainerAsRoot

local ReactReconcilerroblox = require(script.Parent.Parent["ReactReconciler.roblox"])
local createContainer = ReactReconcilerroblox.createContainer
local updateContainer = ReactReconcilerroblox.updateContainer

local Shared = require(parent.Shared)
local invariant = Shared.invariant

local Shared2 = require(parent.Shared)
local enableEagerRootListeners = Shared2.ReactFeatureFlags.enableEagerRootListeners

local flushSync = ReactReconcilerroblox.flushSync
local flushPassiveEffects = ReactReconcilerroblox.flushPassiveEffects

local BlockingRoot = ReactReconcilerroblox.ReactRootTags.BlockingRoot
local ConcurrentRoot = ReactReconcilerroblox.ReactRootTags.ConcurrentRoot
local LegacyRoot = ReactReconcilerroblox.ReactRootTags.LegacyRoot

local fn

local class = {}
class.__index = class

function class.new(p, p2)
	local self = setmetatable({}, class)
	self._internalRoot = fn(p, ConcurrentRoot, p2)

	return self
end

local function createBlockingRoot(p, p2, p3) -- 2 equivalent calls inferred from this helper
	local self = setmetatable({}, class)
	self._internalRoot = fn(p, p2, p3)

	return self
end

function class:render(p)
	updateContainer(p, self._internalRoot, nil)
end

function class:unmount()
	local internalRoot = self._internalRoot
	local containerInfo = internalRoot.containerInfo

	flushSync(function()
		updateContainer(nil, internalRoot, nil, function()
			unmarkContainerAsRoot(containerInfo)
		end)
	end)

	flushPassiveEffects()
end

fn = function(p, p2, p3)
	local v

	if p3 == nil then
		v = false
	else
		v = p3.hydrate == true
	end

	local hydrationOptions

	if p3 ~= nil then
		hydrationOptions = p3.hydrationOptions
	end

	local mutableSources

	if not (p3 == nil or p3.hydrationOptions == nil) then
		mutableSources = p3.hydrationOptions.mutableSources or nil
	end

	local container = createContainer(p, p2, v, hydrationOptions)
	markContainerAsRoot(container.current, p)

	return container
end

local function isValidContainer(instance): boolean -- 2 equivalent calls inferred from this helper
	return typeof(instance) == "Instance"
end

local ReactRobloxRoot = {
	["isValidContainer"] = isValidContainer,
	createRoot = function(instance, p)
		invariant(isValidContainer(instance), "createRoot(...): Target container is not a Roblox Instance.") -- inferred equivalent call

		warnIfReactDOMContainerInDEV(instance)
		return class.new(instance, p)
	end,
	createBlockingRoot = function(instance, p)
		invariant(isValidContainer(instance), "createRoot(...): Target container is not a Roblox Instance.") -- inferred equivalent call

		warnIfReactDOMContainerInDEV(instance)
		return createBlockingRoot(instance, BlockingRoot, p) -- inferred equivalent call
	end,
	createLegacyRoot = function(p, p2)
		return createBlockingRoot(p, LegacyRoot, p2) -- inferred equivalent call
	end
}

function warnIfReactDOMContainerInDEV(_)
	local ___DEV__ = ReactGlobals.__DEV__
end

return ReactRobloxRoot
