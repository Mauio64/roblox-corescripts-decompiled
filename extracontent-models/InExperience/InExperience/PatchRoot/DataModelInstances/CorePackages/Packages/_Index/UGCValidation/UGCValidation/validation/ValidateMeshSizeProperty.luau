local parent = script.Parent.Parent
local Constants = require(parent.Constants)

local Analytics = require(parent.Analytics)

local util = parent.util
local floatEquals = require(parent.util.floatEquals)
require(util.Types)
local pcallDeferred = require(util.pcallDeferred)
local getMeshSize = require(util.getMeshSize)
local getEditableMeshFromContext = require(util.getEditableMeshFromContext)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)

local function reportFailure(message: string, p: string, p2, flag: boolean)
	if flag and p2.isServer ~= nil and p2.isServer then
		error(message)
	end

	Analytics.reportFailure(p, nil, p2)
	return false, { message }
end

local function vector3Equals(meshSize: Vector3, vector3: Vector3) -- 1 equivalent call inferred from this helper
	return floatEquals(meshSize.X, vector3.X, 0.00001)
		and floatEquals(meshSize.Y, vector3.Y, 0.00001)
		and floatEquals(meshSize.Z, vector3.Z, 0.00001)
end

local function calculateMeshSize(instance, p)
	local v = {
		fullName = instance:GetFullName(),
		fieldName = "MeshId",
		contentId = instance.MeshId,
		context = instance.Name
	}

	local editableMeshFromContext, editableMesh = getEditableMeshFromContext(instance, "MeshId", p)

	if not editableMeshFromContext then
		return reportFailure(
			string.format("Mesh for '%s' failed to load. Make sure the mesh exists and try again.", instance.Name),
			Analytics.ErrorType.validateMeshSizeProperty_FailedToLoadMesh,
			p,
			false
		)
	end

	v.editableMesh = editableMesh

	local v2, v3 = pcallDeferred(function()
		return getMeshSize(v)
	end, p)

	if v2 then
		return true, nil, v3
	end

	return reportFailure(
		string.format("Mesh for '%s' failed to load. Make sure the mesh exists and try again.", instance.Name),
		Analytics.ErrorType.validateMeshSizeProperty_FailedToLoadMesh,
		p,
		true
	)
end

local function validateInternal(p, p2)
	local now = tick()

	local v, v2, v3 = calculateMeshSize(p, p2)

	if not (v and v3) then
		return v, v2
	end

	if vector3Equals(p.MeshSize, v3) then -- inferred equivalent call
		Analytics.recordScriptTime(script.Name, now, p2)
		return true
	end

	return reportFailure(
		string.format("Calculated mesh size for %s does not match MeshSize property value", p.Name),
		Analytics.ErrorType.validateMeshSizeProperty_Mismatch,
		p2,
		false
	)
end

local ValidateMeshSizeProperty = {}

function ValidateMeshSizeProperty.validateSingleMeshPart(p, p2)
	if p2.allowEditableInstances then
		return true
	end

	return validateInternal(p, p2)
end

function ValidateMeshSizeProperty.validateBodyAsset(instance, p)
	local now = tick()

	if p.allowEditableInstances then
		return true
	end

	local assetTypeEnum = p.assetTypeEnum

	if Enum.AssetType.DynamicHead == assetTypeEnum then
		local v, v2 = validateInternal(instance, p)
		Analytics.recordScriptTime(script.Name, now, p)
		return v, v2
	else
		local v = FailureReasonsAccumulator.new()

		for childName in Constants.ASSET_TYPE_INFO[assetTypeEnum].subParts do
			local child = instance:FindFirstChild(childName)
			assert(child)

			v:updateReasons(validateInternal(child, p))
		end

		Analytics.recordScriptTime(script.Name, now, p)
		return v:getFinalResults()
	end
end

return ValidateMeshSizeProperty
