local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local getFFlagUGCValidateMeshMaxScale = require(ParentParent.flags.getFFlagUGCValidateMeshMaxScale)
local getFIntUGCValidateMeshCenteringHundredsThreshold = require(ParentParent.flags.getFIntUGCValidateMeshCenteringHundredsThreshold)
local getMeshMinMax = require(ParentParent.util.getMeshMinMax)
local Analytics = require(ParentParent.Analytics)
local v7 = game:DefineFastInt("UGCValidationScaleMinimumThousandths", 10)
local v8 = game:DefineFastInt("FIntUGCValidationScaleMaximumThousandths", 10000)
local v9 = game:DefineFastFlag("RenderBoundsCheckAttachmentOrientation", false)

local function pointInBounds(p1, p2, p3) -- line: 19
	local v19 = p2:PointToObjectSpace(p1)

	return v19.X >= -p3.X / 2 and (v19.X <= p3.X / 2 and (v19.Y >= -p3.Y / 2 and (v19.Y <= p3.Y / 2 and (v19.Z >= -p3.Z / 2 and v19.Z <= p3.Z / 2))))
end
local function isSizeWithinBounds_deprecated(p4, p5) -- line: 29
	return p4.Size.X <= p5.X and (p4.Size.Y <= p5.Y and p4.Size.Z <= p5.Z)
end
local function isSizeWithinBounds(p6, vector3: Vector3, cFrame: CFrame) -- line: 33
	local v25 = (cFrame * p6.Size):Abs()

	return v25.X <= vector3.X and (v25.Y <= vector3.Y and v25.Z <= vector3.Z)
end
local function truncate(n1: number) -- line: 40
	return math.floor(n1 * 100) / 100
end
local function getErrors(s1: string, s2: string, vector3: Vector3) -- line: 44
	return { string.format("%s has size larger than max allowed bounding size. The max size for type %s is [%.2f, %.2f, %.2f]", s1, s2, math.floor(vector3.X * 100) / 100, math.floor(vector3.Y * 100) / 100, math.floor(vector3.Z * 100) / 100) }
end
local function validateMeshBounds(p7, p8, p9, vector3: Vector3, p10, s3: string, p11) -- line: 57
	-- upvalues: v7 (copy), getFFlagUGCValidateMeshMaxScale (copy), v8 (copy), UGCValidationService (copy), Analytics (copy), pointInBounds (copy), getErrors (copy), v9 (copy), getMeshMinMax (copy), getFIntUGCValidateMeshCenteringHundredsThreshold (copy)
	local isServer = p11.isServer
	local size = p10.size
	local v39 = p10.offset or Vector3.new(0, 0, 0)
	local v40 = p7.CFrame * p8.CFrame * CFrame.new(v39)

	if p7.Position.X > 10000 or (p7.Position.X < -10000 or p7.Position.Y > 10000 or p7.Position.Y < -10000 or p7.Position.Z > 10000 or p7.Position.Z < -10000) then
		return false, { "Position is outside of bounds" }
	end

	if v40.Position.X > 10000 or v40.Position.X < -10000 or v40.Position.Y > 10000 or v40.Position.Y < -10000 or v40.Position.Z > 10000 or v40.Position.Z < -10000 then
		return false, { "Position is outside of bounds" }
	end

	if vector3.X < v7 / 1000 or vector3.Y < v7 / 1000 or vector3.Z < v7 / 1000 then
		return false, { "Mesh scale is too small" }
	end

	if getFFlagUGCValidateMeshMaxScale() and (vector3.X > v8 / 1000 or vector3.Y > v8 / 1000 or vector3.Z > v8 / 1000) then
		return false, { `{ p7.Name } mesh scale is too large` }
	end

	local ok, result = pcall(function() -- line: 110
		-- upvalues: UGCValidationService (copy), p9 (copy)
		return UGCValidationService:GetEditableMeshVerts(p9.editableMesh)
	end)

	if not ok then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_FailedToLoadMesh, nil, p11)

		if isServer ~= nil and isServer then
			error(string.format("Failed to load body part mesh %s. Make sure body part exists and try again.", p9.fullName))
		end

		return false, { string.format("Failed to load body part mesh %s. Make sure body part exists and try again.", p9.fullName) }
	end

	for _, v in pairs(result) do
		local v45 = p7.CFrame:PointToWorldSpace(v * vector3)

		if not pointInBounds(v45, v40, size) then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_TooLarge, nil, p11)

			return false, (getErrors(p9.context, s3, size))
		end
	end

	if v9 then
		local v46 = (p8.CFrame.Rotation * p7.Size):Abs()

		if not (v46.X <= size.X) or (not (v46.Y <= size.Y) or not (v46.Z <= size.Z)) then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_TooLarge, nil, p11)

			return false, (getErrors(p7:GetFullName(), s3, size))
		end
	elseif not (p7.Size.X <= size.X) or (not (p7.Size.Y <= size.Y) or not (p7.Size.Z <= size.Z)) then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_TooLarge, nil, p11)

		return false, (getErrors(p7:GetFullName(), s3, size))
	end

	local v47 = table.clone(p9)

	v47.scale = vector3

	local v48, v49, v50, v51 = getMeshMinMax(v47, p11)

	if not v48 then
		return false, v49
	end

	if not p11.allowEditableInstances then
		local v52 = (v50 + v51) / 2

		if getFIntUGCValidateMeshCenteringHundredsThreshold() / 100 < v52.Magnitude then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_Shifted, nil, p11)

			return false, { `{ p9.fullName }.{ p9.fieldName } has mesh data that is not centered. Please reimport this mesh with the roblox 3d importer, and ensure there is no loose geometry in the source file.` }
		end
	end

	return true
end

return validateMeshBounds
