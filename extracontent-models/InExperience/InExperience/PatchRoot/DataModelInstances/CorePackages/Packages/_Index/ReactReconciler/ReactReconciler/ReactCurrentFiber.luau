local ParentParent = script.Parent.Parent
local __DEV__ = require(ParentParent.ReactGlobals).__DEV__

require(script.Parent.ReactInternalTypes)

local ReactSharedInternals = require(ParentParent.Shared).ReactSharedInternals
local getStackByFiberInDevAndProd = require(script.Parent.ReactFiberComponentStack).getStackByFiberInDevAndProd
local getComponentName = require(ParentParent.Shared).getComponentName
local ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame
local t1 = {
	current = nil,
	isRendering = false
}

function t1.getCurrentFiberOwnerNameInDevOrNull() -- line: 39
	-- upvalues: __DEV__ (copy), t1 (copy), getComponentName (copy)
	if __DEV__ then
		if t1.current == nil then
			return nil
		end

		local _debugOwner = t1.current._debugOwner

		if _debugOwner then
			return getComponentName(_debugOwner.type)
		end
	end

	return nil
end

local function getCurrentFiberStackInDev() -- line: 53
	-- upvalues: __DEV__ (copy), t1 (copy), getStackByFiberInDevAndProd (copy)
	if __DEV__ then
		if t1.current == nil then
			return ""
		end

		return getStackByFiberInDevAndProd(t1.current)
	end

	return ""
end

function t1.resetCurrentFiber() -- line: 66
	-- upvalues: __DEV__ (copy), ReactDebugCurrentFrame (copy), t1 (copy)
	if __DEV__ then
		ReactDebugCurrentFrame.getCurrentStack = nil
		t1.current = nil
		t1.isRendering = false
	end
end
function t1.setCurrentFiber(p1) -- line: 75
	-- upvalues: __DEV__ (copy), ReactDebugCurrentFrame (copy), getCurrentFiberStackInDev (copy), t1 (copy)
	if __DEV__ then
		ReactDebugCurrentFrame.getCurrentStack = getCurrentFiberStackInDev
		t1.current = p1
		t1.isRendering = false
	end
end
function t1.setIsRendering(b1: boolean) -- line: 84
	-- upvalues: __DEV__ (copy), t1 (copy)
	if __DEV__ then
		t1.isRendering = b1
	end
end
function t1.getIsRendering() -- line: 90
	-- upvalues: __DEV__ (copy), t1 (copy)
	if __DEV__ then
		return t1.isRendering
	end

	return false
end

return t1
