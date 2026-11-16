local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)

local Analytics = require(parent.Analytics)

local function validateMeshVertexColors(p, flag: boolean, p2)
	local now = tick()

	local isServer = p2.isServer

	local v, v2 = pcallDeferred(function()
		return UGCValidationService:ValidateEditableMeshVertColors(p.editableMesh, flag)
	end, p2)

	if v then
		if v2 then
			Analytics.recordScriptTime(script.Name, now, p2)
			return true
		end

		Analytics.reportFailure(Analytics.ErrorType.validateMeshVertexColors_NonNeutralVertexColors, nil, p2)

		return
			false,
			{ string.format(
					"Invalid vertex color found in mesh model '%s'. You need to edit the color map to be all white %s and try again.",
					p.fullName,
					flag and "with no transarency" or ""
				) }
	else
		Analytics.reportFailure(Analytics.ErrorType.validateMeshVertexColors_FailedToLoadMesh, nil, p2)
		local v3 = string.format(
			"Failed to load vertex color map for model mesh %s. Make sure it exists and try again.",
			p.fullName
		)

		if isServer ~= nil and isServer then
			error(v3)
		end

		return false, { v3 }
	end
end

return validateMeshVertexColors
