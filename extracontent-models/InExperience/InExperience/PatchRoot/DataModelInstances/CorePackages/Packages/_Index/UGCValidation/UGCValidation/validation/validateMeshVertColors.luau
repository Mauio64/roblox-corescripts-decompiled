local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)

local function validateMeshVertexColors(p1, b1: boolean, p2) -- line: 10
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	local timestamp = tick()
	local isServer = p2.isServer
	local v11, v12 = pcallDeferred(function() -- line: 19
		-- upvalues: UGCValidationService (copy), p1 (copy), b1 (copy)
		return UGCValidationService:ValidateEditableMeshVertColors(p1.editableMesh, b1)
	end, p2)

	if not v11 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshVertexColors_FailedToLoadMesh, nil, p2)

		local v13 = string.format("Failed to load vertex color map for model mesh %s. Make sure it exists and try again.", p1.fullName)

		if isServer ~= nil and isServer then
			error(v13)
		end

		return false, { v13 }
	end

	if not v12 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshVertexColors_NonNeutralVertexColors, nil, p2)

		return false, { string.format("Invalid vertex color found in mesh model '%s'. You need to edit the color map to be all white %s and try again.", p1.fullName, not b1 and "" or "with no transarency") }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return true
end

return validateMeshVertexColors
