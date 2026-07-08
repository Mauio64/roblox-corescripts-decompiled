local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local calculateMinMax = require(ParentParent.util.calculateMinMax)

local function getVerts(p1, b1: boolean?, p2) -- line: 14
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy)
	local v11, v12 = pcallDeferred(function() -- line: 19
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:GetEditableMeshVerts(p1.editableMesh)
	end, p2)

	if not v11 then
		local v13 = "Failed to read mesh: " .. p1.fullName

		if b1 then
			error(v13)
		end

		return false, { v13 }
	end

	return true, nil, v12
end
local function getBoundsInfo(p3, vector3: Vector3?) -- line: 36
	-- upvalues: calculateMinMax (copy)
	local v16 = nil
	local v17 = nil

	for _, v in pairs(p3) do
		local v20 = if not vector3 then v else v * vector3

		v16, v17 = calculateMinMax(v16, v17, v20, v20)
	end

	return v16, v17
end
local function getMeshMinMax(p4, p5) -- line: 47
	-- upvalues: getVerts (copy), getBoundsInfo (copy)
	local isServer = p5.isServer
	local v24, v25, v26 = getVerts(p4, isServer, p5)

	if not v24 then
		return v24, v25
	end

	if not v26 or #v26 == 0 then
		return false, { "Mesh: " .. p4.fullName .. " contains no verts" }
	end

	local v27, v28 = getBoundsInfo(v26, p4.scale)

	return true, nil, v27, v28
end

return getMeshMinMax
