local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)

local v = game:DefineFastInt("UGCValidateFacialBoundsScale", 120) / 100
local getExpectedPartSize = require(parent.util.getExpectedPartSize)
require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs = require(parent.flags.getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs)

local function validateFacialBounds(instance, p)
	local isServer = p.isServer

	local v2, v3 = pcallDeferred(function()
		local expectedPartSize = getExpectedPartSize(instance, p)

		local editableMeshFromContext, v2 = getEditableMeshFromContext(instance, "MeshId", p)

		if not editableMeshFromContext then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:ValidateEditableMeshFacialBounds(v2, v, expectedPartSize)
	end, p)

	if v2 then
		if v3 then
			return true
		end

		return
			false,
			{ string.format(
					"DynamicHead (%s) when emoting surpasses the expected bounding box",
					instance:GetFullName()
				) }
	else
		local v4 = string.format(
			"Failed to load mesh data for '%s'. Make sure the mesh exists and try again.",
			instance:GetFullName()
		)

		if isServer ~= nil and isServer then
			error(v4)
		end

		return false, { v4 }
	end
end

local function validateDynamicHeadData(p, p2)
	local now = tick()

	local v2 = FailureReasonsAccumulator.new()

	if not getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs() then
		v2:updateReasons(validateFacialBounds(p, p2))
	end

	Analytics.recordScriptTime(script.Name, now, p2)
	return v2:getFinalResults()
end

return validateDynamicHeadData
