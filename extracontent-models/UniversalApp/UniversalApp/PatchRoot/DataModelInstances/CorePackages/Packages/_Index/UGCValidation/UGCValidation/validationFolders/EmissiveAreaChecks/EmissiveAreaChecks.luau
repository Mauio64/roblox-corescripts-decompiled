local parent = script.Parent.Parent.Parent

local AssetService = game:GetService("AssetService")

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateEmissiveAreaChecks = require(parent.flags.getFFlagUGCValidateEmissiveAreaChecks)
local getFIntUGCValidateMaxEmissivePercentageBody = require(parent.flags.getFIntUGCValidateMaxEmissivePercentageBody)

local getFIntUGCValidateMaxEmissivePercentageDynamicHead = require(parent.flags.getFIntUGCValidateMaxEmissivePercentageDynamicHead)

local getFIntUGCValidateMaxEmissiveAreaRigidAccessory = require(parent.flags.getFIntUGCValidateMaxEmissiveAreaRigidAccessory)

local getFIntUGCValidateMaxEmissiveAreaLayeredClothing = require(parent.flags.getFIntUGCValidateMaxEmissiveAreaLayeredClothing)

local getFIntUGCValidateEmissiveR15BlockyBoundingBoxVolume = require(parent.flags.getFIntUGCValidateEmissiveR15BlockyBoundingBoxVolume)

local getFIntUGCValidationMaxEmissiveStrengthForAreaChecks = require(parent.flags.getFIntUGCValidationMaxEmissiveStrengthForAreaChecks)
local getFFlagUGCValidateEmissiveFixAreaChecks = require(parent.flags.getFFlagUGCValidateEmissiveFixAreaChecks)

local getFFlagUGCValidateEmissiveAreaChecksFixedAlgo = require(parent.flags.getFFlagUGCValidateEmissiveAreaChecksFixedAlgo)

local EmissiveAreaChecks = {}
EmissiveAreaChecks.fflag = getFFlagUGCValidateEmissiveAreaChecks
EmissiveAreaChecks.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD,
	ValidationEnums.UploadCategory.LAYERED_CLOTHING,
	ValidationEnums.UploadCategory.EYEBROW_EYELASH,
	ValidationEnums.UploadCategory.RIGID_ACCESSORY
}

EmissiveAreaChecks.requiredData = {
	ValidationEnums.SharedDataMember.renderMeshesData,
	ValidationEnums.SharedDataMember.innerCagesData,
	ValidationEnums.SharedDataMember.meshTextures,
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.uploadCategory
}

EmissiveAreaChecks.expectedFailures = {}

local function getEmissiveStrength(p, childName: string) -- 3 equivalent calls inferred from this helper
	local v = p.rootInstance

	if v.Name ~= childName then
		v = p.rootInstance:FindFirstChild(childName, true)
	end

	if not v then
		return 0
	end

	local surfaceAppearance = v:FindFirstChildWhichIsA("SurfaceAppearance", true)

	if surfaceAppearance then
		return surfaceAppearance.EmissiveStrength
	end

	return 0
end

local function getWeightedAreaForTextures(p, editable, object)
	local editable2 = p.editable
	local size = editable.Size
	local pixelsBuffer = editable:ReadPixelsBuffer(Vector2.zero, size)
	local v

	if object then
		v = object:ReadPixelsBuffer(Vector2.zero, object.Size)
	end

	local total = 0
	local total2 = 0

	for _, v2 in editable2:GetFaces() do
		local faceVertices = editable2:GetFaceVertices(v2)
		local position = editable2:GetPosition(faceVertices[1])
		local v3 = ((editable2:GetPosition(faceVertices[2]) - position) * p.scale):Cross((editable2:GetPosition(faceVertices[3]) - position) * p.scale).Magnitude * 0.5

		if v3 == 0 then
			continue
		end

		total += v3

		local faceUVs = editable2:GetFaceUVs(v2)
		local uv = editable2:GetUV(faceUVs[1])
		local uv2 = editable2:GetUV(faceUVs[2])
		local uv3 = editable2:GetUV(faceUVs[3])

		if not (uv and uv2 and uv3) then
			continue
		end

		local v4 = (uv + uv2 + uv3) / 3
		local v5 = math.floor(v4.X % 1 * size.X)
		local v6 = buffer.readu8(pixelsBuffer, (math.floor(v4.Y % 1 * size.Y) * size.X + v5) * 4)
		local v7

		if object then
			local size2 = object.Size
			local v8 = math.floor(v4.X % 1 * size2.X)
			local v9 = (math.floor(v4.Y % 1 * size2.Y) * size2.X + v8) * 4
			local v10 = buffer.readu8(v, v9)
			local v11 = buffer.readu8(v, v9 + 1)
			local v12 = buffer.readu8(v, v9 + 2)
			v7 = (v10 + v11 + v12) / 765
		else
			v7 = 1
		end

		total2 += v3 * v6 * v7
	end

	return total2 / 255, total
end

local function getTotalEmissiveSurfaceArea(p, object)
	local editable = p.editable
	local size = object.Size
	local pixelsBuffer = object:ReadPixelsBuffer(Vector2.zero, size)
	local total = 0
	local total2 = 0

	for _, v in editable:GetFaces() do
		local faceVertices = editable:GetFaceVertices(v)
		local position = editable:GetPosition(faceVertices[1])
		local v2 = ((editable:GetPosition(faceVertices[2]) - position) * p.scale):Cross((editable:GetPosition(faceVertices[3]) - position) * p.scale).Magnitude * 0.5

		if v2 == 0 then
			continue
		end

		local faceUVs = editable:GetFaceUVs(v)
		local uv = editable:GetUV(faceUVs[1])
		local uv2 = editable:GetUV(faceUVs[2])
		local uv3 = editable:GetUV(faceUVs[3])

		if not (uv and uv2 and uv3) then
			continue
		end

		local v3 = (uv + uv2 + uv3) / 3
		local v4 = math.floor(v3.X % 1 * size.X)
		local v5 = buffer.readu8(pixelsBuffer, (math.floor(v3.Y % 1 * size.Y) * size.X + v4) * 4)

		total += v2
		total2 += v2 * v5
	end

	return total2 / 255, total
end

local function getEmissiveFraction(p, editable, data, childName: string) -- 1 equivalent call inferred from this helper
	local totalEmissiveSurfaceArea, v = getTotalEmissiveSurfaceArea(p, editable)

	if not (v > 0) then
		return 0
	end

	return totalEmissiveSurfaceArea / v * getEmissiveStrength(data, childName) / getFIntUGCValidationMaxEmissiveStrengthForAreaChecks() -- inferred equivalent call
end

local function getTotalEmissiveArea(p, emissiveMask, data, k: string) -- 1 equivalent call inferred from this helper
	local editable = emissiveMask.editable
	local colorMap = data.meshTextures[k].ColorMap
	local v

	if colorMap then
		v = colorMap.editable
	end

	return getWeightedAreaForTextures(p, editable, v)
end

local function runEmissiveAreaChecks(object, data)
	for k, v in data.renderMeshesData do
		local meshTexture = data.meshTextures[k]
		local emissiveMask

		if meshTexture then
			emissiveMask = meshTexture.EmissiveMask
		end

		if not emissiveMask then
			continue
		end

		local name = data.uploadEnum.assetType.Name
		local totalEmissiveArea, v2 = getTotalEmissiveArea(v, emissiveMask, data, k) -- inferred equivalent call

		local emissiveStrength = meshTexture.EmissiveStrength
		local emissiveTint = meshTexture.EmissiveTint
		local v3 = (emissiveTint.R + emissiveTint.G + emissiveTint.B) / 3
		local v4 = emissiveStrength / getFIntUGCValidationMaxEmissiveStrengthForAreaChecks()
		local v5 = totalEmissiveArea * v3 * v4

		if data.uploadCategory == ValidationEnums.UploadCategory.RIGID_ACCESSORY then
			if getFIntUGCValidateMaxEmissiveAreaRigidAccessory() < v5 then
				object:fail(ErrorSourceStrings.Keys.EmissiveArea_SurfaceAreaExceededNew, {
					assetTypeName = name,
					emissiveArea = string.format("%.2f", v5),
					maxEmissiveArea = tostring(getFIntUGCValidateMaxEmissiveAreaRigidAccessory())
				})
			end
		elseif
			data.uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS
			or data.uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD
		then
			local v6 = v5 / v2
			local v7 = getFIntUGCValidateMaxEmissivePercentageBody()

			if data.uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD then
				v7 = getFIntUGCValidateMaxEmissivePercentageDynamicHead()
			end

			if v7 / 100 < v6 then
				object:fail(ErrorSourceStrings.Keys.EmissiveArea_AboveThresholdNew, {
					meshName = k,
					emissivePercentage = string.format("%.2f", v6 * 100),
					maxEmissivePercentage = tostring(v7)
				})
			end
		else
			local v6 = data.innerCagesData[k]
			local model = Instance.new("Model")
			local createMeshPartAsync = AssetService:CreateMeshPartAsync(Content.fromObject(v6.editable))
			createMeshPartAsync.Parent = model
			local _, v7 = model:GetBoundingBox()
			local v8 = v7.X * v7.Y * v7.Z
			local v9 = v5 * (getFIntUGCValidateEmissiveR15BlockyBoundingBoxVolume() / v8) ^ (2 / 3)

			if getFIntUGCValidateMaxEmissiveAreaLayeredClothing() < v9 then
				object:fail(ErrorSourceStrings.Keys.EmissiveArea_SurfaceAreaExceededNew, {
					assetTypeName = name,
					emissiveArea = string.format("%.2f", v9),
					maxEmissiveArea = tostring(getFIntUGCValidateMaxEmissiveAreaLayeredClothing())
				})
			end
		end
	end
end

function EmissiveAreaChecks.run(object, data)
	if getFFlagUGCValidateEmissiveAreaChecksFixedAlgo() then
		runEmissiveAreaChecks(object, data)
		return
	end

	for k, v in data.renderMeshesData do
		local meshTexture = data.meshTextures[k]
		local emissiveMask

		if meshTexture then
			emissiveMask = meshTexture.EmissiveMask
		end

		if not emissiveMask then
			continue
		end

		if data.uploadCategory == ValidationEnums.UploadCategory.RIGID_ACCESSORY then
			local v2 = getTotalEmissiveSurfaceArea(v, emissiveMask.editable)

			if getFFlagUGCValidateEmissiveFixAreaChecks() then
				v2 = v2 * getEmissiveStrength(data, k) / getFIntUGCValidationMaxEmissiveStrengthForAreaChecks() -- inferred equivalent call
			end

			if getFIntUGCValidateMaxEmissiveAreaRigidAccessory() < v2 then
				object:fail(ErrorSourceStrings.Keys.EmissiveArea_SurfaceAreaExceeded, {
					meshName = k,
					emissiveArea = string.format("%.2f", v2),
					maxEmissiveArea = tostring(getFIntUGCValidateMaxEmissiveAreaRigidAccessory())
				})
			end
		elseif
			data.uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS
			or data.uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD
		then
			local emissiveFraction = getEmissiveFraction(v, emissiveMask.editable, data, k) -- inferred equivalent call
			local v2 = getFIntUGCValidateMaxEmissivePercentageBody()

			if data.uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD then
				v2 = getFIntUGCValidateMaxEmissivePercentageDynamicHead()
			end

			if v2 / 100 < emissiveFraction then
				object:fail(ErrorSourceStrings.Keys.EmissiveArea_AboveThreshold, {
					meshName = k,
					emissivePercentage = string.format("%.2f", emissiveFraction * 100),
					maxEmissivePercentage = tostring(v2)
				})
			end
		else
			local v2 = data.innerCagesData[k]
			local model = Instance.new("Model")
			local createMeshPartAsync = AssetService:CreateMeshPartAsync(Content.fromObject(v2.editable))
			createMeshPartAsync.Parent = model
			local _, v3 = model:GetBoundingBox()
			local v4 = v3.X * v3.Y * v3.Z
			local v5 = ((getFIntUGCValidateEmissiveR15BlockyBoundingBoxVolume() / v4) ^ (1 / 3)) ^ 2
			local v6 = getTotalEmissiveSurfaceArea(v, emissiveMask.editable)

			if getFFlagUGCValidateEmissiveFixAreaChecks() then
				v6 = v6 * getEmissiveStrength(data, k) / getFIntUGCValidationMaxEmissiveStrengthForAreaChecks() -- inferred equivalent call
			end

			local v7 = v6 * v5

			if getFIntUGCValidateMaxEmissiveAreaLayeredClothing() < v7 then
				object:fail(ErrorSourceStrings.Keys.EmissiveArea_SurfaceAreaExceeded, {
					meshName = k,
					emissiveArea = string.format("%.2f", v7),
					maxEmissiveArea = tostring(getFIntUGCValidateMaxEmissiveAreaLayeredClothing())
				})
			end
		end
	end
end

return EmissiveAreaChecks
