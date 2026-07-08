local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console
local t1 = {}

require(ParentParent.Shared)
require(script.Parent.ReactInternalTypes)

local isPrimaryRenderer = require(script.Parent.ReactFiberHostConfig).isPrimaryRenderer
local t2 = {}
local t3 = nil

if ReactGlobals.__DEV__ then
	t3 = {}
end

function t1.markSourceAsDirty(p1) -- line: 39
	-- upvalues: t2 (copy)
	table.insert(t2, p1)
end
function t1.resetWorkInProgressVersions() -- line: 43
	-- upvalues: t2 (copy), isPrimaryRenderer (copy)
	for _, v10 in t2 do
		if isPrimaryRenderer then
			v10._workInProgressVersionPrimary = nil
		else
			v10._workInProgressVersionSecondary = nil
		end
	end

	table.clear(t2)
end
function t1.getWorkInProgressVersion(p2) -- line: 54
	-- upvalues: isPrimaryRenderer (copy)
	if isPrimaryRenderer then
		return p2._workInProgressVersionPrimary
	end

	return p2._workInProgressVersionSecondary
end
function t1.setWorkInProgressVersion(p3, p4) -- line: 64
	-- upvalues: isPrimaryRenderer (copy), t2 (copy)
	if isPrimaryRenderer then
		p3._workInProgressVersionPrimary = p4
	else
		p3._workInProgressVersionSecondary = p4
	end

	table.insert(t2, p3)
end
function t1.warnAboutMultipleRenderersDEV(p5) -- line: 76
	-- upvalues: ReactGlobals (copy), isPrimaryRenderer (copy), t3 (ref), console (copy)
	if ReactGlobals.__DEV__ then
		if isPrimaryRenderer then
			if p5._currentPrimaryRenderer == nil then
				p5._currentPrimaryRenderer = t3

				return
			end

			if p5._currentPrimaryRenderer ~= t3 then
				console.error("Detected multiple renderers concurrently rendering the same mutable source. This is currently unsupported.")

				return
			end
		else
			if p5._currentSecondaryRenderer == nil then
				p5._currentSecondaryRenderer = t3

				return
			end

			if p5._currentSecondaryRenderer ~= t3 then
				console.error("Detected multiple renderers concurrently rendering the same mutable source. This is currently unsupported.")
			end
		end
	end
end
function t1.registerMutableSourceForHydration(p6, p7) -- line: 104
	local v17 = p7._getVersion(p7._source)

	if p6.mutableSourceEagerHydrationData == nil then
		p6.mutableSourceEagerHydrationData = {
			p7,
			v17
		}

		return
	end
end

return t1
