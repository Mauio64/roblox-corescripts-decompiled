local parent = script.Parent.Parent
local Constants = require(parent.Constants)
require(parent.util.Types)
local getMeshInfo = require(parent.util.getMeshInfo)
local getMeshMinMax = require(parent.util.getMeshMinMax)
local getExpectedPartSize = require(parent.util.getExpectedPartSize)

local function getRenderMeshScale(p, p2)
	local meshInfo, v, v2 = getMeshInfo(p, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p2)

	if not meshInfo then
		return meshInfo, v
	end

	local meshMinMax, v3, v4, v5 = getMeshMinMax(v2, p2)

	if not meshMinMax then
		return meshMinMax, v3
	end

	local v6 = v5 - v4
	return true, nil, getExpectedPartSize(p, p2) / v6
end

return getRenderMeshScale
