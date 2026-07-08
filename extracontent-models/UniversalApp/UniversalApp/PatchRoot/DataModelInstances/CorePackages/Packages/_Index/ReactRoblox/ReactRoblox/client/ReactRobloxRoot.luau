local ParentParent = script.Parent.Parent.Parent

require(script.Parent["ReactRobloxHostTypes.roblox"])

local ReactGlobals = require(ParentParent.ReactGlobals)

require(ParentParent.ReactReconciler)
require(ParentParent.Shared)
require(ParentParent.ReactReconciler)

local ReactRobloxComponentTree = require(script.Parent.ReactRobloxComponentTree)
local markContainerAsRoot = ReactRobloxComponentTree.markContainerAsRoot
local unmarkContainerAsRoot = ReactRobloxComponentTree.unmarkContainerAsRoot
local lib = require(script.Parent.Parent["ReactReconciler.roblox"])
local createContainer = lib.createContainer
local updateContainer = lib.updateContainer
local invariant = require(ParentParent.Shared).invariant
local enableEagerRootListeners = require(ParentParent.Shared).ReactFeatureFlags.enableEagerRootListeners
local flushSync = lib.flushSync
local flushPassiveEffects = lib.flushPassiveEffects
local BlockingRoot = lib.ReactRootTags.BlockingRoot
local ConcurrentRoot = lib.ReactRootTags.ConcurrentRoot
local LegacyRoot = lib.ReactRootTags.LegacyRoot
local u16 = nil
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 66
	-- upvalues: t1 (copy), u16 (ref), ConcurrentRoot (copy)
	local self = setmetatable({}, t1)

	self._internalRoot = u16(p1, ConcurrentRoot, p2)

	return self
end

local function createBlockingRoot(p3, p4, p5) -- line: 73
	-- upvalues: t1 (copy), u16 (ref)
	local self = setmetatable({}, t1)

	self._internalRoot = u16(p3, p4, p5)

	return self
end

function t1.render(p6, p7) -- line: 85
	-- upvalues: updateContainer (copy)
	local _internalRoot = p6._internalRoot

	updateContainer(p7, _internalRoot, nil)
end
function t1.unmount(p8) -- line: 113
	-- upvalues: flushSync (copy), updateContainer (copy), unmarkContainerAsRoot (copy), flushPassiveEffects (copy)
	local _internalRoot = p8._internalRoot
	local containerInfo = _internalRoot.containerInfo

	flushSync(function() -- line: 126
		-- upvalues: updateContainer (copy), _internalRoot (copy), unmarkContainerAsRoot (copy), containerInfo (copy)
		updateContainer(nil, _internalRoot, nil, function() -- line: 127
			-- upvalues: unmarkContainerAsRoot (copy), containerInfo (copy)
			unmarkContainerAsRoot(containerInfo)
		end)
	end)
	flushPassiveEffects()
end
function u16(p9, p10, p11) -- line: 141
	-- upvalues: createContainer (copy), markContainerAsRoot (copy), enableEagerRootListeners (copy)
	local v36 = p11 ~= nil and p11.hydrate == true
	local v37 = if p11 == nil then nil else p11.hydrationOptions
	local v38 = p11 ~= nil and (p11.hydrationOptions ~= nil and p11.hydrationOptions.mutableSources) or nil
	local v39 = createContainer(p9, p10, v36, v37)

	markContainerAsRoot(v39.current, p9)

	if not enableEagerRootListeners then
	end

	if not v38 then
	end

	return v39
end

local t2 = {
	isValidContainer = function(p12) -- line: 189
		return typeof(p12) == "Instance"
	end,
	createRoot = function(p13, p14) -- line: 212
		-- upvalues: invariant (copy), t1 (copy)
		invariant(typeof(p13) == "Instance", "createRoot(...): Target container is not a Roblox Instance.")
		warnIfReactDOMContainerInDEV(p13)

		return t1.new(p13, p14)
	end,
	createBlockingRoot = function(p15, p16) -- line: 222
		-- upvalues: invariant (copy), BlockingRoot (copy), t1 (copy), u16 (ref)
		invariant(typeof(p15) == "Instance", "createRoot(...): Target container is not a Roblox Instance.")
		warnIfReactDOMContainerInDEV(p15)

		local v45 = BlockingRoot
		local self = setmetatable({}, t1)

		self._internalRoot = u16(p15, v45, p16)

		return self
	end,
	createLegacyRoot = function(p17, p18) -- line: 235
		-- upvalues: LegacyRoot (copy), t1 (copy), u16 (ref)
		local v49 = LegacyRoot
		local self = setmetatable({}, t1)

		self._internalRoot = u16(p17, v49, p18)

		return self
	end
}

function warnIfReactDOMContainerInDEV(_) -- line: 239
	-- upvalues: ReactGlobals (copy)
	if not ReactGlobals.__DEV__ then
	end
end

return t2
