local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local __DEV__ = ReactGlobals.__DEV__

require(script.Parent.ReactInternalTypes)

local Shared = require(parent.Shared)
local ReactSharedInternals = Shared.ReactSharedInternals
local ReactFiberComponentStack = require(script.Parent.ReactFiberComponentStack)
local getStackByFiberInDevAndProd = ReactFiberComponentStack.getStackByFiberInDevAndProd
local Shared2 = require(parent.Shared)
local getComponentName = Shared2.getComponentName

local ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame

local ReactCurrentFiber = { current = nil, isRendering = false }

function ReactCurrentFiber.getCurrentFiberOwnerNameInDevOrNull()
	if not (__DEV__ and ReactCurrentFiber.current ~= nil) then
		return nil
	end

	local debugOwner = ReactCurrentFiber.current._debugOwner

	if debugOwner then
		return getComponentName(debugOwner.type)
	end

	return nil
end

local function getCurrentFiberStackInDev()
	if not (__DEV__ and ReactCurrentFiber.current ~= nil) then
		return ""
	end

	return getStackByFiberInDevAndProd(ReactCurrentFiber.current)
end

function ReactCurrentFiber.resetCurrentFiber()
	if __DEV__ then
		ReactDebugCurrentFrame.getCurrentStack = nil
		ReactCurrentFiber.current = nil
		ReactCurrentFiber.isRendering = false
	end
end

function ReactCurrentFiber.setCurrentFiber(current)
	if __DEV__ then
		ReactDebugCurrentFrame.getCurrentStack = getCurrentFiberStackInDev
		ReactCurrentFiber.current = current
		ReactCurrentFiber.isRendering = false
	end
end

function ReactCurrentFiber.setIsRendering(isRendering: boolean)
	if __DEV__ then
		ReactCurrentFiber.isRendering = isRendering
	end
end

function ReactCurrentFiber.getIsRendering()
	return if __DEV__ then ReactCurrentFiber.isRendering else false
end

return ReactCurrentFiber
