local parent = script.Parent.Parent.Parent

require(script.Parent["ReactRobloxHostTypes.roblox"])

require(parent.ReactReconciler)

local Shared = require(parent.Shared)

local reactWorkTags = nil
local hostComponent = nil
local v = nil
local v2 = nil
local v3 = nil

local getParentSuspenseInstance = nil
local invariant = Shared.invariant

local v4 = {}

local v5 = {}
local v6 = {}

local v7 = string.sub(tostring(math.random()), 3)
local v8 = "__reactFiber$" .. v7
local v9 = "__reactContainer$" .. v7
local ReactRobloxComponentTree = {}

function ReactRobloxComponentTree.precacheFiberNode(p, p2)
	v5[p2] = p
end

function ReactRobloxComponentTree.uncacheFiberNode(p)
	v5[p] = nil
	v6[p] = nil
end

function ReactRobloxComponentTree.markContainerAsRoot(p, p2)
	v4[p2] = p
end

function ReactRobloxComponentTree.unmarkContainerAsRoot(p)
	v4[p] = nil
end

function ReactRobloxComponentTree.isContainerMarkedAsRoot(p)
	return v4[p] and true or false
end

function ReactRobloxComponentTree.getClosestInstanceFromNode(p)
	local v10 = v5[p]

	if v10 then
		return v10
	end

	local v11 = p.Parent

	while v11 do
		local v12 = v5[v11]

		if v12 then
			local alternate = v12.alternate

			if v12.child == nil and (alternate == nil or alternate.child == nil) then
				return v12
			end

			if getParentSuspenseInstance == nil then
				local ReactRobloxHostConfig = require(script.Parent.ReactRobloxHostConfig)
				getParentSuspenseInstance = ReactRobloxHostConfig.getParentSuspenseInstance
			end

			local parentSuspenseInstance = getParentSuspenseInstance(p)

			while parentSuspenseInstance ~= nil do
				local v13 = v5[parentSuspenseInstance]

				if v13 then
					return v13
				end

				parentSuspenseInstance = getParentSuspenseInstance(parentSuspenseInstance)
			end

			return v12
		end

		p = v11
		v11 = v11.Parent
	end

	return nil
end

function ReactRobloxComponentTree.getInstanceFromNode(p)
	if reactWorkTags == nil then
		local ReactReconcilerroblox = require(script.Parent.Parent["ReactReconciler.roblox"])
		reactWorkTags = ReactReconcilerroblox.ReactWorkTags

		hostComponent = reactWorkTags.HostComponent

		if Shared.ReactFeatureFlags.fixGetInstanceFromNode then
			v = reactWorkTags.HostText
			v2 = reactWorkTags.HostRoot
			v3 = reactWorkTags.SuspenseComponent
		else
			v = reactWorkTags.HostComponent
			v2 = reactWorkTags.HostComponent
			v3 = reactWorkTags.HostComponent
		end
	end

	local v10

	if Shared.ReactFeatureFlags.fixGetInstanceFromNode then
		v10 = v5[p] or v4[p]
	else
		v10 = p[v8] or p[v9]
	end

	if not v10 then
		return nil
	end

	if v10.tag == hostComponent or v10.tag == v or v10.tag == v3 or v10.tag == v2 then
		return v10
	end

	return nil
end

function ReactRobloxComponentTree.getNodeFromInstance(p)
	if p.tag == hostComponent or p.tag == v then
		return p.stateNode
	end

	invariant(false, "getNodeFromInstance: Invalid argument.")

	error("getNodeFromInstance: Invalid argument.")
end

function ReactRobloxComponentTree.getFiberCurrentPropsFromNode(p)
	return v6[p]
end

function ReactRobloxComponentTree.updateFiberProps(p, p2)
	v6[p] = p2
end

return ReactRobloxComponentTree
