local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)

local calculateMinMax = require(parent.util.calculateMinMax)

local function getVerts(p, isServer: boolean?, p2)
	local v, v2 = pcallDeferred(function()
		return UGCValidationService:GetEditableMeshVerts(p.editableMesh)
	end, p2)

	if v then
		return true, nil, v2
	end

	local v3 = "Failed to read mesh: " .. p.fullName

	if isServer then
		error(v3)
	end

	return false, { v3 }
end

local function getBoundsInfo(items, scale: Vector3?)
	local v = nil
	local v2 = nil

	for _, item in pairs(items) do
		if scale then
			item *= scale
		end

		v, v2 = calculateMinMax(v, v2, item, item)
	end

	return v, v2
end

local function getMeshMinMax(p, p2)
	local verts, v, v2 = getVerts(p, p2.isServer, p2)

	if not verts then
		return verts, v
	end

	if not v2 or #v2 == 0 then
		return false, { "Mesh: " .. p.fullName .. " contains no verts" }
	end

	local boundsInfo, v3 = getBoundsInfo(v2, p.scale)
	return true, nil, boundsInfo, v3
end

return getMeshMinMax
