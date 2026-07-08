local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getMeshSize = require(ParentParent.util.getMeshSize)
local pcallDeferred = require(ParentParent.util.pcallDeferred)

return function(p1, p2, b1: boolean?) -- line: 8
	-- upvalues: getEditableMeshFromContext (copy), pcallDeferred (copy), getMeshSize (copy)
	if not p2.bypassFlags or not p2.bypassFlags.skipPhysicsDataReset then
		if b1 then
			return p1.MeshSize
		end

		return p1.Size
	end

	if not p2.partSizes then
		p2.partSizes = {}
	end

	if p2.partSizes[p1] then
		return p2.partSizes[p1]
	end

	local t1 = {
		fieldName = "MeshId",
		fullName = p1:GetFullName(),
		contentId = p1.MeshId,
		context = p1.Name
	}
	local v9, v10 = getEditableMeshFromContext(p1, "MeshId", p2)

	if not v9 then
		if b1 then
			return p1.MeshSize
		end

		return p1.Size
	end

	t1.editableMesh = v10

	if p2.editableMeshes[p1].MeshId.created then
		if b1 then
			return p1.MeshSize
		end

		return p1.Size
	end

	local v11, v12 = pcallDeferred(function() -- line: 40
		-- upvalues: getMeshSize (copy), t1 (copy)
		return getMeshSize(t1)
	end, p2)

	if not v11 then
		if b1 then
			return p1.MeshSize
		end

		return p1.Size
	end

	p2.partSizes[p1] = v12

	return v12
end
