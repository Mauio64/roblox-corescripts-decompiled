local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local getMeshInfo = require(ParentParent.util.getMeshInfo)
local getMeshMinMax = require(ParentParent.util.getMeshMinMax)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)

local function getRenderMeshScale(p1, p2) -- line: 12
	-- upvalues: getMeshInfo (copy), Constants (copy), getMeshMinMax (copy), getExpectedPartSize (copy)
	local v9, v10, v11 = getMeshInfo(p1, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p2)

	if not v9 then
		return v9, v10
	end

	local v12, v13, v14, v15 = getMeshMinMax(v11, p2)

	if not v12 then
		return v12, v13
	end

	local v16 = v15 - v14

	return true, nil, getExpectedPartSize(p1, p2) / v16
end

return getRenderMeshScale
