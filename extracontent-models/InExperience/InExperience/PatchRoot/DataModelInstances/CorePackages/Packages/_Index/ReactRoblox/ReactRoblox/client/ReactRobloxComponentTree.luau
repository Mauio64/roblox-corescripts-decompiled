local ParentParent = script.Parent.Parent.Parent

require(script.Parent["ReactRobloxHostTypes.roblox"])
require(ParentParent.ReactReconciler)

local Shared = require(ParentParent.Shared)
local ReactWorkTags = nil
local HostComponent = nil
local HostComponent2 = nil
local HostComponent3 = nil
local HostComponent4 = nil
local getParentSuspenseInstance = nil
local invariant = Shared.invariant
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local v14 = string.sub(tostring(math.random()), 3)
local v15 = "__reactFiber$" .. v14
local v16 = "__reactContainer$" .. v14

function t1.precacheFiberNode(p1, p2) -- line: 66
	-- upvalues: t3 (copy)
	t3[p2] = p1
end
function t1.uncacheFiberNode(p3) -- line: 73
	-- upvalues: t3 (copy), t4 (copy)
	t3[p3] = nil
	t4[p3] = nil
end
function t1.markContainerAsRoot(p4, p5) -- line: 80
	-- upvalues: t2 (copy)
	t2[p5] = p4
end
function t1.unmarkContainerAsRoot(p6) -- line: 86
	-- upvalues: t2 (copy)
	t2[p6] = nil
end
function t1.isContainerMarkedAsRoot(p7) -- line: 92
	-- upvalues: t2 (copy)
	return not not t2[p7]
end
function t1.getClosestInstanceFromNode(p8) -- line: 106
	-- upvalues: t3 (copy), getParentSuspenseInstance (ref)
	local v25 = t3[p8]

	if v25 then
		return v25
	end

	local p8Parent = p8.Parent

	while p8Parent do
		local v27 = t3[p8Parent]

		if v27 then
			local alternate = v27.alternate

			if v27.child ~= nil or alternate ~= nil and alternate.child ~= nil then
				if getParentSuspenseInstance == nil then
					getParentSuspenseInstance = require(script.Parent.ReactRobloxHostConfig).getParentSuspenseInstance
				end

				local v29 = getParentSuspenseInstance(p8)

				while v29 ~= nil do
					local v30 = t3[v29]

					if v30 then
						return v30
					end

					v29 = getParentSuspenseInstance(v29)
				end
			end

			return v27
		end

		p8 = p8Parent
		p8Parent = p8.Parent
	end

	return nil
end
function t1.getInstanceFromNode(p9) -- line: 190
	-- upvalues: ReactWorkTags (ref), HostComponent (ref), HostComponent2 (ref), HostComponent3 (ref), HostComponent4 (ref), v15 (copy), v16 (copy)
	if ReactWorkTags == nil then
		ReactWorkTags = require(script.Parent.Parent["ReactReconciler.roblox"]).ReactWorkTags
		HostComponent = ReactWorkTags.HostComponent
		HostComponent2 = ReactWorkTags.HostComponent
		HostComponent3 = ReactWorkTags.HostComponent
		HostComponent4 = ReactWorkTags.HostComponent
	end

	local v32 = p9[v15] or p9[v16]

	if v32 then
		if v32.tag == HostComponent or v32.tag == HostComponent2 or v32.tag == HostComponent4 or v32.tag == HostComponent3 then
			return v32
		end

		return nil
	end

	return nil
end
function t1.getNodeFromInstance(p10) -- line: 224
	-- upvalues: HostComponent (ref), HostComponent2 (ref), invariant (copy)
	if p10.tag == HostComponent or p10.tag == HostComponent2 then
		return p10.stateNode
	end

	invariant(false, "getNodeFromInstance: Invalid argument.")
	error("getNodeFromInstance: Invalid argument.")
end
function t1.getFiberCurrentPropsFromNode(p11) -- line: 238
	-- upvalues: t4 (copy)
	return t4[p11]
end
function t1.updateFiberProps(p12, p13) -- line: 244
	-- upvalues: t4 (copy)
	t4[p12] = p13
end

return t1
