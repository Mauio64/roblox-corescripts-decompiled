local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local calculateMinMax = require(ParentParent.util.calculateMinMax)
local t1 = {}

function t1.combineBounds(p1, p2) -- line: 23
	-- upvalues: calculateMinMax (copy), t1 (copy)
	local t2 = {}
	local v7, v8 = calculateMinMax(p1.minMeshCorner, p1.maxMeshCorner, p2.minMeshCorner, p2.maxMeshCorner)

	t2.minMeshCorner = v7
	t2.maxMeshCorner = v8

	local v9, v10 = calculateMinMax(p1.minRigAttachment, p1.maxRigAttachment, p2.minRigAttachment, p2.maxRigAttachment)

	t2.minRigAttachment = v9
	t2.maxRigAttachment = v10
	t1.setOverallBounds(t2)

	return t2
end
function t1.expandMeshBounds(p3, vector3: Vector3) -- line: 36
	-- upvalues: calculateMinMax (copy)
	local v13, v14 = calculateMinMax(p3.minMeshCorner, p3.maxMeshCorner, vector3, vector3)

	p3.minMeshCorner = v13
	p3.maxMeshCorner = v14
end
function t1.expandRigAttachmentBounds(p4, vector3: Vector3) -- line: 41
	-- upvalues: calculateMinMax (copy)
	local v17, v18 = calculateMinMax(p4.minRigAttachment, p4.maxRigAttachment, vector3, vector3)

	p4.minRigAttachment = v17
	p4.maxRigAttachment = v18
end
function t1.setOverallBounds(p5) -- line: 46
	-- upvalues: calculateMinMax (copy)
	local v20, v21 = calculateMinMax(p5.minMeshCorner, p5.maxMeshCorner, p5.minRigAttachment, p5.maxRigAttachment)

	p5.minOverall = v20
	p5.maxOverall = v21
end
function t1.calculateBoundsCenters(p6) -- line: 52
	local v23 = if not p6.minMeshCorner or not p6.maxMeshCorner then nil else (p6.minMeshCorner + p6.maxMeshCorner) / 2
	local v24 = if not p6.minRigAttachment or not p6.maxRigAttachment then nil else (p6.minRigAttachment + p6.maxRigAttachment) / 2

	if p6.minOverall and p6.maxOverall then
		return v23, v24, (p6.minOverall + p6.maxOverall) / 2
	end

	return v23, v24, nil
end
function t1.calculateBoundsDimensions(p7) -- line: 66
	local v26 = if not p7.minMeshCorner or not p7.maxMeshCorner then nil else p7.maxMeshCorner - p7.minMeshCorner
	local v27 = if not p7.minRigAttachment or not p7.maxRigAttachment then nil else p7.maxRigAttachment - p7.minRigAttachment

	if p7.minOverall and p7.maxOverall then
		return v26, v27, p7.maxOverall - p7.minOverall
	end

	return v26, v27, nil
end

return t1
