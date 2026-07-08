local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local pcallDeferred = require(ParentParent.util.pcallDeferred)

require(ParentParent.util.Types)

local getFStringUGCValidateBoundsInflationThreshold = require(ParentParent.flags.getFStringUGCValidateBoundsInflationThreshold)

local function calculateExtentsUnion(t1: {[any]: any}, t2: {[any]: any}) -- line: 30
	return {
		min = t1.min:Min(t2.min),
		max = t1.max:Max(t2.max)
	}
end
local function checkExtentsValid(t3: {[any]: any}) -- line: 37
	for _, v23 in {
		"X",
		"Y",
		"Z"
	} do
		if t3.max[v23] < t3.min[v23] then
			return false
		end
	end

	return true
end
local function validationSpaceToWorldSpace(vector3: Vector3, cFrame: CFrame, vector3_2: Vector3, cFrame2: CFrame, vector3_3: Vector3) -- line: 46
	return cFrame2 * (cFrame:Inverse() * vector3 / vector3_2 * vector3_3)
end
local function calculateAmountInflated(t4: {[any]: any}, t5: {[any]: any}) -- line: 59
	local t6 = {
		min = t4.min:Min(t5.min),
		max = t4.max:Max(t5.max)
	}
	local n1 = 0

	for _, v34 in {
		"X",
		"Y",
		"Z"
	} do
		local v35 = math.abs(t4.max[v34] - t4.min[v34])

		n1 = math.max(n1, (math.abs(math.abs(t6.max[v34] - t6.min[v34]) - v35)))
	end

	return n1
end
local function getPartNamesInAsset(p1, p2) -- line: 76
	local t7 = {}

	if p2 == Enum.AssetType.DynamicHead then
		table.insert(t7, p1.Name)

		return t7
	end

	for _, child in p1:GetChildren() do
		if child:IsA("MeshPart") then
			table.insert(t7, child.Name)
		end
	end

	return t7
end
local function calculateMeshScales(t8: {[any]: any}, p3, p4: ((...any) -> ...any)) -- line: 92
	-- upvalues: getExpectedPartSize (copy)
	local t9 = {}

	for _, v46 in t8 do
		local v47 = p4(v46)

		t9[v46] = getExpectedPartSize(v47, p3) / getExpectedPartSize(v47, p3, true)
	end

	return t9
end
local function checkInflatingGeo(t10: {[any]: any}, t11: {[any]: any}, n2: number, s1: string, p5, p6) -- line: 108
	-- upvalues: calculateAmountInflated (copy), getFStringUGCValidateBoundsInflationThreshold (copy)
	local t12 = {}

	for _, v56 in t11 do
		local v57 = calculateAmountInflated(t10, v56.extents)

		table.insert(t12, {
			extents = v56.extents,
			inflated = v57,
			worldSpacePosition = v56.worldSpacePosition
		})
	end

	table.sort(t12, function(p7, p8) -- line: 125
		return p7.inflated > p8.inflated
	end)

	local num = tonumber(getFStringUGCValidateBoundsInflationThreshold())
	local t13 = {}
	local n3 = 1

	while n3 <= #t12 and num < t12[n3].inflated and n2 > #t13 do
		table.insert(t13, t12[n3])
		n3 += 1
	end

	if #t13 > 0 then
		local s2 = ""

		for i = 1, #t13 do
			if i > 1 then
				s2 = if i ~= #t13 then s2 .. ", " else s2 .. ", and "
			end

			local worldSpacePosition = t13[i].worldSpacePosition

			s2 ..= string.format("{%.4f, %.4f, %.4f}", worldSpacePosition.X, worldSpacePosition.Y, worldSpacePosition.Z)
		end

		p6:updateReasons(false, { string.format("Detected %s centered around: %s that increases %s bounding box. Remove the geometry or increase its size so that it is more visible", s1, s2, p5.Name) })
	end
end
local function getWorldPositions(p9, t14: {[any]: any}, t15: {[any]: any}, s3: string, t16: {[any]: any}, p10: ((...any) -> ...any)) -- line: 167
	local t17 = {}

	for _, v72 in t16 do
		local v73 = p10(v72)
		local CFrame = v73.CFrame
		local v75 = v73.Size / v73.MeshSize

		for _, v77 in p9[v72][s3] do
			local v78 = (v77.min + v77.max) / 2
			local v79 = t14[v72]
			local v80 = t15[v72]
			local v81 = CFrame * (v79:Inverse() * v78 / v80 * v75)

			table.insert(t17, {
				extents = v77,
				worldSpacePosition = v81
			})
		end
	end

	return t17
end
local function validateAccurateBoundingBox(p11, p12) -- line: 202
	-- upvalues: getPartNamesInAsset (copy), AssetCalculator (copy), calculateMeshScales (copy), getEditableMeshFromContext (copy), pcallDeferred (copy), UGCValidationService (copy), checkExtentsValid (copy), getWorldPositions (copy), FailureReasonsAccumulator (copy), checkInflatingGeo (copy), Analytics (copy)
	local assetTypeEnum = p12.assetTypeEnum

	assert(assetTypeEnum)

	local v85 = getPartNamesInAsset(p11, assetTypeEnum)
	local v86 = AssetCalculator.calculateAllTransformsForAsset(assetTypeEnum, p11)

	local function findMeshHandle(s4: string) -- line: 213
		-- upvalues: assetTypeEnum (copy), p11 (copy)
		if assetTypeEnum == Enum.AssetType.DynamicHead then
			return p11
		end

		return (p11:FindFirstChild(s4))
	end

	if assetTypeEnum ~= Enum.AssetType.DynamicHead and assetTypeEnum ~= Enum.AssetType.Torso then
		for v88, v89 in (AssetCalculator.calculateStraightenedLimb(assetTypeEnum, v86, findMeshHandle)) do
			v86[v88] = v89
		end
	end

	local v90 = calculateMeshScales(v85, p12, findMeshHandle)
	local t18 = {}

	for _, v93 in v85 do
		local v94 = if assetTypeEnum ~= Enum.AssetType.DynamicHead then p11:FindFirstChild(v93) else p11
		local v95, v96 = getEditableMeshFromContext(v94, "MeshId", p12)

		if not v95 then
			return false, { string.format("Failed to load mesh for '%s'. Make sure mesh exists and try again.", v94.Name) }
		end

		t18[v93] = v96
	end

	local t19 = {}
	local t20 = {}
	local t21 = {}

	for _, v101 in v85 do
		table.insert(t19, t18[v101])
		table.insert(t20, v86[v101])
		table.insert(t21, v90[v101])
	end

	local v102, v103 = pcallDeferred(function() -- line: 254
		-- upvalues: UGCValidationService (copy), t19 (copy), t20 (copy), t21 (copy)
		return UGCValidationService:GetBoundingBoxManipulationData(t19, t20, t21)
	end, p12)

	if not v102 then
		local v104 = string.format("Could not get bounding box manipulation metrics for %s", assetTypeEnum.Name)

		if not p12.isServer then
			return false, { v104 }
		end

		error(v104)
	end

	local t22 = {
		min = v103.minValidExtents,
		max = v103.maxValidExtents
	}

	if not checkExtentsValid(t22) then
		return false, { string.format("%s mesh is too small or made of disconnected pieces that are too small", assetTypeEnum.Name) }
	end

	local t23 = {}

	for v107, v108 in v103.partsProblemGeos do
		t23[v85[v107]] = v108
	end

	local v109 = getWorldPositions(t23, v86, v90, "smallIslands", v85, findMeshHandle)
	local v110 = getWorldPositions(t23, v86, v90, "skinnyTris", v85, findMeshHandle)
	local v111 = FailureReasonsAccumulator.new()

	checkInflatingGeo(t22, v109, 3, "small geometry", assetTypeEnum, v111)
	checkInflatingGeo(t22, v110, 3, "skinny triangle(s)", assetTypeEnum, v111)

	if not v111:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validateAccurateBoundingBox, nil, p12)
	end

	return v111:getFinalResults()
end

return validateAccurateBoundingBox
