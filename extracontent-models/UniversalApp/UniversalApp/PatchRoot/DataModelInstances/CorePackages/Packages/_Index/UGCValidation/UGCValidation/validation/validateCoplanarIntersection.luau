local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local getFIntMaxCoplanarIntersectionsPercentage = require(ParentParent.flags.getFIntMaxCoplanarIntersectionsPercentage)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)

local function getTriangleCount(p1, p2, b1: boolean?) -- line: 16
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	local v11, v12 = pcallDeferred(function() -- line: 21
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:GetEditableMeshTriCount(p1.editableMesh)
	end, p2)

	if not v11 then
		local v13 = string.format("Failed to load model mesh %s. Make sure the mesh exists and try again.", p1.fullName)

		Analytics.reportFailure(Analytics.ErrorType.validateCoplanarIntersection_FailedToExecute, nil, p2)

		if b1 ~= nil and b1 then
			error(v13)
		end

		return false, { v13 }
	end

	return true, nil, v12
end
local function validateCoplanarIntersection(p3, vector3: Vector3, p4) -- line: 44
	-- upvalues: getTriangleCount (copy), getFIntMaxCoplanarIntersectionsPercentage (copy), pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	local timestamp = tick()
	local isServer = p4.isServer
	local v19, v20, v21 = getTriangleCount(p3, p4, isServer)

	if not v19 then
		return false, v20
	end

	local v22 = math.floor(getFIntMaxCoplanarIntersectionsPercentage() / 100 * v21)
	local v23, v24 = pcallDeferred(function() -- line: 62
		-- upvalues: UGCValidationService (copy), p3 (copy), v22 (copy), vector3 (copy)
		return UGCValidationService:IsEditableMeshNumCoplanarIntersectionsOverLimit(p3.editableMesh, v22, vector3, true)
	end, p4)

	if not v23 then
		local v25 = string.format("Failed to execute coplanar triangle intersection check for '%s'. Make sure mesh exists and try again.", p3.fullName)

		if isServer ~= nil and isServer then
			error(v25)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateCoplanarIntersection_FailedToExecute, nil, p4)

		return false, { v25 }
	end

	if v24 then
		Analytics.reportFailure(Analytics.ErrorType.validateCoplanarIntersection_CoplanarIntersection, nil, p4)

		return false, { string.format("Detected too many coplanar triangles intersecting in model mesh '%s'. The maximum is %d intersections in a %d triangle mesh. Edit your mesh to reduce the number of coplanar triangle intersections.", p3.fullName, v22, v21) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p4)

	return true
end

return validateCoplanarIntersection
