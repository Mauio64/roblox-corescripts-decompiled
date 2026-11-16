local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local function validateMeshTriangles(p, p2: number?, p3)
	local isServer = p3.isServer

	local v, v2 = pcallDeferred(function()
		return UGCValidationService:GetEditableMeshTriCount(p.editableMesh)
	end, p3)

	if p2 == nil then
		p2 = Constants.MAX_HAT_TRIANGLES
	end

	if v then
		if p2 < v2 then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshTriangles_TooManyTriangles, nil, p3)

			return
				false,
				{ string.format(
						"Model mesh %s resolution of %d is higher than max support value of %d. You need to retopologize your model and try again.",
						p.fullName,
						v2,
						p2
					) }
		end

		return true
	end

	Analytics.reportFailure(Analytics.ErrorType.validateMeshTriangles_FailedToLoadMesh, nil, p3)

	if isServer ~= nil and isServer then
		error(string.format("Failed to load model mesh %s. Make sure the mesh exists and try again.", p.fullName))
	end

	return
		false,
		{ string.format("Failed to load model mesh %s. Make sure the mesh exists and try again.", p.fullName) }
end

return validateMeshTriangles
