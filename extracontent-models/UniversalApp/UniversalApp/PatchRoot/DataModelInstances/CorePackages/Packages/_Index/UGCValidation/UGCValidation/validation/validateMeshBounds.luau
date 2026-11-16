local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)
local getFFlagUGCValidateMeshMaxScale = require(parent.flags.getFFlagUGCValidateMeshMaxScale)

local getFIntUGCValidateMeshCenteringHundredsThreshold = require(parent.flags.getFIntUGCValidateMeshCenteringHundredsThreshold)
local getMeshMinMax = require(parent.util.getMeshMinMax)
local Analytics = require(parent.Analytics)

local defineFastInt = game:DefineFastInt("UGCValidationScaleMinimumThousandths", 10)
local defineFastInt2 = game:DefineFastInt("FIntUGCValidationScaleMaximumThousandths", 10000)

local function pointInBounds(p, cframe, size): boolean
	local pointToObjectSpace = cframe:PointToObjectSpace(p)
	return pointToObjectSpace.X >= -size.X / 2
		and pointToObjectSpace.X <= size.X / 2
		and pointToObjectSpace.Y >= -size.Y / 2
		and pointToObjectSpace.Y <= size.Y / 2
		and pointToObjectSpace.Z >= -size.Z / 2
		and pointToObjectSpace.Z <= size.Z / 2
end

local function isSizeWithinBounds(p, vector3: Vector3, cframe: CFrame): boolean
	local abs = (cframe * p.Size):Abs()
	return abs.X <= vector3.X and abs.Y <= vector3.Y and abs.Z <= vector3.Z
end

local function truncate(p: number) -- 3 equivalent calls inferred from this helper
	return math.floor(p * 100) / 100
end

local function getErrors(p: string, p2: string, size: Vector3)
	return { string.format(
			"%s has size larger than max allowed bounding size. The max size for type %s is [%.2f, %.2f, %.2f]",
			p,
			p2,
			truncate(size.X), -- inferred equivalent call
			truncate(size.Y), -- inferred equivalent call
			truncate(size.Z) -- inferred equivalent call
		) }
end

local function validateMeshBounds(instance, p, data, scale: Vector3, p2, p3: string, p4)
	local isServer = p4.isServer
	local size = p2.size
	local offset = p2.offset or Vector3.new(0, 0, 0)
	local v = instance.CFrame * p.CFrame * CFrame.new(offset)

	if
		instance.Position.X > 10000
		or instance.Position.X < -10000
		or instance.Position.Y > 10000
		or instance.Position.Y < -10000
		or instance.Position.Z > 10000
		or instance.Position.Z < -10000
	then
		return false, { "Position is outside of bounds" }
	end

	if
		v.Position.X > 10000
		or v.Position.X < -10000
		or v.Position.Y > 10000
		or v.Position.Y < -10000
		or v.Position.Z > 10000
		or v.Position.Z < -10000
	then
		return false, { "Position is outside of bounds" }
	end

	if scale.X < defineFastInt / 1000 or scale.Y < defineFastInt / 1000 or scale.Z < defineFastInt / 1000 then
		return false, { "Mesh scale is too small" }
	end

	local success, result, _, v2, _, v3, v4, v5, v6, _

	-- [DEDUP] synthesized from 2 duplicated terminal regions
	local function deduplicatedTail()
		local v7

		if not v3 then
			return false, v4
		end

		if p4.allowEditableInstances then
			return true
		end

		v7 = (v5 + v6) / 2

		if getFIntUGCValidateMeshCenteringHundredsThreshold() / 100 < v7.Magnitude then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_Shifted, nil, p4)

			return
				false,
				{ `{data.fullName}.{data.fieldName} has mesh data that is not centered. Please reimport this mesh with the roblox 3d importer, and ensure there is no loose geometry in the source file.` }
		end

		return true
	end

	-- [DEDUP] synthesized from 2 duplicated terminal regions
	local function deduplicatedTail2()
		local clone

		if not v2 then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_TooLarge, nil, p4)
			return false, getErrors(instance:GetFullName(), p3, size)
		end

		clone = table.clone(data)
		clone.scale = scale
		v3, v4, v5, v6 = getMeshMinMax(clone, p4)
		return deduplicatedTail()
	end

	-- [DEDUP] synthesized from 2 duplicated terminal regions
	local function deduplicatedTail3()
		local v7

		for _, v8 in pairs(result) do
			if not pointInBounds(instance.CFrame:PointToWorldSpace(v8 * scale), v, size) then
				Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_TooLarge, nil, p4)
				return false, getErrors(data.context, p3, size)
			end
		end

		v7 = (p.CFrame.Rotation * instance.Size):Abs()

		if v7.X <= size.X and v7.Y <= size.Y then
			v2 = v7.Z <= size.Z
		else
			v2 = false
		end

		return deduplicatedTail2()
	end

	if getFFlagUGCValidateMeshMaxScale() then
		local x = scale.X

		if not (defineFastInt2 / 1000 < x) then
			local y = scale.Y

			if not (defineFastInt2 / 1000 < y) then
				local z = scale.Z

				if not (defineFastInt2 / 1000 < z) then
					success, result = pcall(function()
						return UGCValidationService:GetEditableMeshVerts(data.editableMesh)
					end)

					if success then
						return deduplicatedTail3()
					end

					Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_FailedToLoadMesh, nil, p4)

					if isServer ~= nil and isServer then
						error(string.format(
							"Failed to load body part mesh %s. Make sure body part exists and try again.",
							data.fullName
						))
					end

					return
						false,
						{ string.format(
								"Failed to load body part mesh %s. Make sure body part exists and try again.",
								data.fullName
							) }
				end
			end
		end

		return false, { `{instance.Name} mesh scale is too large` }
	end

	success, result = pcall(function()
		return UGCValidationService:GetEditableMeshVerts(data.editableMesh)
	end)

	if success then
		return deduplicatedTail3()
	end

	Analytics.reportFailure(Analytics.ErrorType.validateMeshBounds_FailedToLoadMesh, nil, p4)

	if isServer ~= nil and isServer then
		error(string.format(
			"Failed to load body part mesh %s. Make sure body part exists and try again.",
			data.fullName
		))
	end

	return
		false,
		{ string.format("Failed to load body part mesh %s. Make sure body part exists and try again.", data.fullName) }
end

return validateMeshBounds
