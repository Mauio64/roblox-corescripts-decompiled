local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local getFIntMaxCoplanarIntersectionsPercentage = require(parent.flags.getFIntMaxCoplanarIntersectionsPercentage)

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)

local Analytics = require(parent.Analytics)

local function getTriangleCount(p, p2, isServer: boolean?)
	local v, v2 = pcallDeferred(function()
		return UGCValidationService:GetEditableMeshTriCount(p.editableMesh)
	end, p2)

	if v then
		return true, nil, v2
	end

	local v3 = string.format("Failed to load model mesh %s. Make sure the mesh exists and try again.", p.fullName)
	Analytics.reportFailure(Analytics.ErrorType.validateCoplanarIntersection_FailedToExecute, nil, p2)

	if isServer ~= nil and isServer then
		error(v3)
	end

	return false, { v3 }
end

local function validateCoplanarIntersection(p, vector3: Vector3, p2)
	local now = tick()

	local isServer = p2.isServer

	local triangleCount, v, v2 = getTriangleCount(p, p2, isServer)

	if not triangleCount then
		return false, v
	end

	local v3 = math.floor(getFIntMaxCoplanarIntersectionsPercentage() / 100 * v2)

	local v4, v5 = pcallDeferred(function()
		return UGCValidationService:IsEditableMeshNumCoplanarIntersectionsOverLimit(p.editableMesh, v3, vector3, true)
	end, p2)

	if v4 then
		if v5 then
			Analytics.reportFailure(Analytics.ErrorType.validateCoplanarIntersection_CoplanarIntersection, nil, p2)

			return
				false,
				{ string.format(
						"Detected too many coplanar triangles intersecting in model mesh '%s'. The maximum is %d intersections in a %d triangle mesh. Edit your mesh to reduce the number of coplanar triangle intersections.",
						p.fullName,
						v3,
						v2
					) }
		end

		Analytics.recordScriptTime(script.Name, now, p2)
		return true
	else
		local v6 = string.format(
			"Failed to execute coplanar triangle intersection check for '%s'. Make sure mesh exists and try again.",
			p.fullName
		)

		if isServer ~= nil and isServer then
			error(v6)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateCoplanarIntersection_FailedToExecute, nil, p2)

		return false, { v6 }
	end
end

return validateCoplanarIntersection
