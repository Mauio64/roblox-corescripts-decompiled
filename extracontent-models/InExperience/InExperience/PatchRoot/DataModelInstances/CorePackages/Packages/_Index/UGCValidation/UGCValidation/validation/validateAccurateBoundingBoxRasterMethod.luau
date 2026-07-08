local AssetService = game:GetService("AssetService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local bodyAssetMasksRenderer = require(ParentParent.util.bodyAssetMasksRenderer)
local nelderMead = require(ParentParent.util.nelderMead)
local SummedAreaTable = require(ParentParent.util.SummedAreaTable)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getMeshVerts = require(ParentParent.util.getMeshVerts)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)

require(ParentParent.util.Types)

local FloatVector = require(ParentParent.util.FloatVector)
local Extents = require(ParentParent.util.Extents)
local tryYield = require(ParentParent.util.tryYield)
local validateAccurateBoundingBoxFlags = require(ParentParent.flags.validateAccurateBoundingBoxFlags)
local getFFlagUGCValidateTinyTrianglesIntersectFix = require(ParentParent.flags.getFFlagUGCValidateTinyTrianglesIntersectFix)

local function getHeadNeckAttachmentMeshLocalPosition(p1) -- line: 39
	-- upvalues: getAttachmentCFrameInPartSpace (copy)
	local NeckRigAttachment = p1:FindFirstChild("NeckRigAttachment", true)

	if not NeckRigAttachment then
		return nil
	end

	local v35 = getAttachmentCFrameInPartSpace(NeckRigAttachment)
	local v36 = p1.Size / p1.MeshSize

	return v35.Position / v36
end
local function projectMeshLocalPointToImageRow(vector3: Vector3, p2) -- line: 53
	local v39 = p2.view:Inverse() * vector3
	local viewSpaceBounds = p2.viewSpaceBounds
	local v41 = (viewSpaceBounds.max.Y + viewSpaceBounds.min.Y) / 2
	local v42 = (viewSpaceBounds.max.Y - viewSpaceBounds.min.Y) / 2
	local v43 = (v39.Y - v41) / v42
	local maskSize = p2.mask.Size

	return (v43 * -0.5 + 0.5) * (maskSize.Y - 1)
end
local function cloneMaskZeroedBelowRow(p3, n1: number) -- line: 69
	-- upvalues: AssetService (copy)
	local p3Size = p3.Size
	local p3SizeX = p3Size.X
	local p3SizeY = p3Size.Y
	local v50 = p3:ReadPixelsBuffer(Vector2.zero, p3Size)
	local v51 = math.max(0, (math.min(p3SizeY, math.floor(n1) + 1)))

	if v51 < p3SizeY then
		local v52 = v51 * p3SizeX * 4
		local v53 = (p3SizeY - v51) * p3SizeX * 4

		buffer.fill(v50, v52, 0, v53)
	end

	local v54 = AssetService:CreateEditableImage({
		Size = p3Size
	})

	v54:WritePixelsBuffer(Vector2.zero, p3Size, v50)

	return v54
end
local function sampleAreaTable(p4, p5, p6, p7, p8) -- line: 89
	local vector2 = Vector2.new(p5, p7)
	local vector2_2 = Vector2.new(p6, p8)
	local v62 = vector2 * p4.size

	return (p4:GetAreaDensityContinuous(v62, vector2_2 * p4.size - v62))
end
local function shrinkBounds(p9, p10: ((...any) -> ...any), vector2: Vector2) -- line: 101
	-- upvalues: FloatVector (copy)
	for i = 1, 4 do
		local v67 = p9[if i % 2 ~= 0 then i + 1 else i - 1]
		local v68 = 1 / vector2[not (i < 3) and "Y" or "X"]
		local v69 = FloatVector.new(p9)
		local v70 = p10(p9)
		local v71 = p9[i]

		while v68 <= math.abs(v71 - v67) do
			local v72 = (v71 + v67) / 2

			v69[i] = v72

			local v73 = p10(v69)

			if v73 < v70 then
				v69[i] = v72 + (v67 - v72) * 0.01

				if p10(v69) - v73 > 0 then
					v67 = v71
				end

				v71 = v72
				v70 = v73
			else
				v67 = v72
			end
		end

		p9[i] = v71
	end
end
local function createSimplex(p11, n2: number) -- line: 146
	-- upvalues: FloatVector (copy)
	local t1 = {}

	table.insert(t1, p11)
	table.insert(t1, p11 + FloatVector.new(n2, 0, 0, 0))
	table.insert(t1, p11 + FloatVector.new(0, n2, 0, 0))
	table.insert(t1, p11 + FloatVector.new(0, 0, n2, 0))
	table.insert(t1, p11 + FloatVector.new(0, 0, 0, n2))

	return t1
end
local function calculateMinimumBoundsForView(p12, p13) -- line: 156
	-- upvalues: FloatVector (copy), createSimplex (copy), SummedAreaTable (copy), validateAccurateBoundingBoxFlags (copy), nelderMead (copy), tryYield (copy), shrinkBounds (copy)
	local v79 = FloatVector.new(0, 1, 0, 1)
	local v80 = createSimplex(v79, 0.9)
	local mask = p12.mask
	local maskSize = mask.Size
	local v83 = SummedAreaTable.new(maskSize, function(p14) -- line: 165
		if p14.R > 0 or (p14.G > 0 or p14.B > 0) then
			return 1
		end

		return 0
	end)

	v83:BuildSummedAreaTable(mask)

	local AreaDensity = v83:GetAreaDensity(Vector2.zero, maskSize)

	if AreaDensity <= 0 then
		return false, { string.format("%s asset not visible from the %s, cannot determine quality of asset bounding box", p13.assetTypeEnum.Name, p12.viewId) }
	end

	local v85 = validateAccurateBoundingBoxFlags.targetPercentage()
	local v86 = validateAccurateBoundingBoxFlags.percentageWeight()

	local function v87(p15) -- line: 189
		-- upvalues: v83 (copy), AreaDensity (copy), v85 (copy), v86 (copy)
		assert(p15:getSize() == 4)

		local n3 = 0

		if p15[1] <= p15[2] and p15[3] <= p15[4] then
			local v217 = v83
			local v218 = p15[1]
			local v219 = p15[2]
			local v220 = p15[3]
			local v221 = p15[4]
			local vector2 = Vector2.new(v218, v220)
			local vector2_3 = Vector2.new(v219, v221)
			local v224 = vector2 * v217.size

			n3 = v217:GetAreaDensityContinuous(v224, vector2_3 * v217.size - v224)
		end

		local v225 = math.abs(n3 / AreaDensity * 100 - v85) * v86
		local vector2 = Vector2.new(p15[2] - p15[1], p15[4] - p15[3])

		return v225 + (vector2.X + vector2.Y)
	end

	local v88 = validateAccurateBoundingBoxFlags.maxIterations()
	local vector2 = Vector2.new(1 / maskSize.X, 1 / maskSize.Y)
	local v90 = validateAccurateBoundingBoxFlags.convergedLength()
	local v91 = vector2.Magnitude * v90
	local v92 = nelderMead.new(v80, v87, function(t2: {[any]: any}, n4: number) -- line: 209
		-- upvalues: v88 (copy), nelderMead (copy), v91 (copy), tryYield (copy), p13 (copy)
		if n4 >= v88 then
			return true
		end

		if nelderMead.calculateMaxLengthBetweenVertices(t2) <= v91 then
			return true
		end

		tryYield(p13)

		return false
	end)

	v92:evaluate()

	local v93 = v92.simplex[1]

	shrinkBounds(v93, v87, maskSize)

	return true, (FloatVector.new(math.clamp(v93[1], 0, 1), math.clamp(v93[2], 0, 1), math.clamp(v93[3], 0, 1), (math.clamp(v93[4], 0, 1))))
end
local function transformIsAlignedWithAxis(cFrame: CFrame, vector3: Vector3) -- line: 242
	if vector3:FuzzyEq(cFrame.XVector:Abs()) then
		return true
	end

	if vector3:FuzzyEq(cFrame.YVector:Abs()) then
		return true
	end

	return false
end
local function alignedExtentsFromReprojectedPoint(vector3: Vector3, cFrame: CFrame) -- line: 252
	-- upvalues: Extents (copy)
	local t3 = {
		X = -1e999,
		Y = -1e999,
		Z = -1e999
	}
	local t4 = {
		X = 1e999,
		Y = 1e999,
		Z = 1e999
	}

	if not not Vector3.new(1, 0, 0):FuzzyEq(cFrame.XVector:Abs()) or not not Vector3.new(1, 0, 0):FuzzyEq(cFrame.YVector:Abs()) then
		t3.X = math.max(t3.X, vector3.X)
		t4.X = math.min(t4.X, vector3.X)
	end

	if not not Vector3.new(0, 1, 0):FuzzyEq(cFrame.XVector:Abs()) or not not Vector3.new(0, 1, 0):FuzzyEq(cFrame.YVector:Abs()) then
		t3.Y = math.max(t3.Y, vector3.Y)
		t4.Y = math.min(t4.Y, vector3.Y)
	end

	if not not Vector3.new(0, 0, 1):FuzzyEq(cFrame.XVector:Abs()) or not not Vector3.new(0, 0, 1):FuzzyEq(cFrame.YVector:Abs()) then
		t3.Z = math.max(t3.Z, vector3.Z)
		t4.Z = math.min(t4.Z, vector3.Z)
	end

	return Extents.fromMinMax(Vector3.new(t4.X, t4.Y, t4.Z), (Vector3.new(t3.X, t3.Y, t3.Z)))
end
local function calculateValidBounds(t5: {[any]: any}, p16) -- line: 279
	-- upvalues: Extents (copy), getFFlagUGCValidateTinyTrianglesIntersectFix (copy), calculateMinimumBoundsForView (copy), bodyAssetMasksRenderer (copy), alignedExtentsFromReprojectedPoint (copy)
	local v102 = Extents.new()
	local v103 = if not getFFlagUGCValidateTinyTrianglesIntersectFix() then nil else {}

	for v104, v105 in t5 do
		local v106, v107 = calculateMinimumBoundsForView(v105, p16)

		if not v106 then
			return false, v107
		end

		local vector2 = Vector2.new(v107[2], v107[3])
		local vector2_4 = Vector2.new(v107[1], v107[4])
		local v110 = bodyAssetMasksRenderer.getViewSpacePositionFromNormalized(vector2, v105.viewSpaceBounds)
		local v111 = v105.view * v110
		local v112 = bodyAssetMasksRenderer.getViewSpacePositionFromNormalized(vector2_4, v105.viewSpaceBounds)
		local v113 = v105.view * v112
		local v114 = alignedExtentsFromReprojectedPoint(v111, v105.view)
		local v115 = alignedExtentsFromReprojectedPoint(v113, v105.view)

		if getFFlagUGCValidateTinyTrianglesIntersectFix() then
			local v116 = Extents.new():unionExtents(v114):unionExtents(v115)
			local v117 = bodyAssetMasksRenderer.opposingViewIds[v104]

			if v103[v117] then
				v103[v117] = v116:intersectExtents(v103[v117])
			else
				v103[v104] = v116
			end
		else
			v102 = v102:unionExtents(v114):unionExtents(v115)
		end
	end

	if getFFlagUGCValidateTinyTrianglesIntersectFix() then
		for _, v119 in v103 do
			v102 = v102:unionExtents(v119)
		end

		assert(v102:isValid())
	end

	return true, v102
end
local function worldSpacePositionFromPointInMeshPart(vector3: Vector3, p17) -- line: 336
	return p17.CFrame * (vector3 * (p17.Size / p17.MeshSize))
end
local function getHighestInflatingPointInEachAxis(p18, t6: {[any]: any}, t7: {[any]: any}, p19: ((...any) -> ...any), p20) -- line: 353
	-- upvalues: getMeshVerts (copy)
	local t8 = {
		X = {
			positive = {
				inflationScale = 0,
				furthestPointWorldSpace = nil
			},
			negative = {
				inflationScale = 0,
				furthestPointWorldSpace = nil
			}
		},
		Y = {
			positive = {
				inflationScale = 0,
				furthestPointWorldSpace = nil
			},
			negative = {
				inflationScale = 0,
				furthestPointWorldSpace = nil
			}
		},
		Z = {
			positive = {
				inflationScale = 0,
				furthestPointWorldSpace = nil
			},
			negative = {
				inflationScale = 0,
				furthestPointWorldSpace = nil
			}
		}
	}
	local v128 = p18:size()

	for v129, v130 in t7 do
		local v131, v132, v133 = getMeshVerts({
			editableMesh = v130,
			fullName = v129
		}, p20)

		if not v131 then
			return false, v132
		end

		local v134 = t6[v129]

		for _, v136 in v133 do
			local v137 = v136 * v134.scale
			local v138 = v134.CFrame * v137
			local v139 = p19(v129)
			local v140 = v139.CFrame * (v136 * (v139.Size / v139.MeshSize))
			local v141 = (v138 - p18.max) / v128
			local v142 = (p18.min - v138) / v128

			for _, v144 in {
				"X",
				"Y",
				"Z"
			} do
				local v145 = t8[v144]
				local positive = v145.positive
				local v147 = v141[v144]

				if v147 > positive.inflationScale then
					positive.furthestPointWorldSpace = v140
					positive.inflationScale = v147
				end

				local negative = v145.negative
				local v149 = v142[v144]

				if v149 > negative.inflationScale then
					negative.furthestPointWorldSpace = v140
					negative.inflationScale = v149
				end
			end
		end
	end

	return true, t8
end
local function getBodyPartAssetEditableMeshes(p21, p22) -- line: 413
	-- upvalues: getEditableMeshFromContext (copy)
	local t9 = {}

	if p21:IsA("MeshPart") and p22.assetTypeEnum == Enum.AssetType.DynamicHead then
		table.insert(t9, p21)
	else
		for _, child in p21:GetChildren() do
			if child:IsA("MeshPart") then
				table.insert(t9, child)
			end
		end
	end

	local t10 = {}

	for _, v157 in t9 do
		local v158, v159 = getEditableMeshFromContext(v157, "MeshId", p22)

		if not v158 then
			local v160 = string.format("Failed to load mesh for MeshPart '%s'. Make sure mesh exists and try again.", v157.Name)

			if not p22.isServer then
				return false, { v160 }
			end

			error(v160)
		end

		t10[v157.Name] = v159
	end

	return true, t10
end
local function tryReportInflationError(t11: {[any]: any}, p23) -- line: 448
	-- upvalues: FailureReasonsAccumulator (copy), validateAccurateBoundingBoxFlags (copy)
	local v163 = FailureReasonsAccumulator.new()
	local v164 = validateAccurateBoundingBoxFlags.AssetTypeToAxisThresholds[p23]

	for _, v166 in {
		"X",
		"Y",
		"Z"
	} do
		local v167 = t11[v166]
		local v168 = v167.negative.inflationScale + v167.positive.inflationScale
		local v169 = v164[v166]

		if v169 < v168 then
			local t12 = {}

			if v167.positive.inflationScale > v169 * 0.2 then
				table.insert(t12, v167.positive.furthestPointWorldSpace)
			end

			if v167.negative.inflationScale > v169 * 0.2 then
				table.insert(t12, v167.negative.furthestPointWorldSpace)
			end

			local s1 = ""

			if #t12 > 0 then
				s1 = " near " .. string.format("{%.4f, %.4f, %.4f}", t12[1].X, t12[1].Y, t12[1].Z)

				if #t12 > 1 then
					s1 ..= string.format(", and {%.4f, %.4f, %.4f}", t12[2].X, t12[2].Y, t12[2].Z)
				end
			end

			local v172 = v168 * 100
			local v173 = v169 * 100

			v163:updateReasons(false, { string.format("Detected low visibility geometry%s that increases %s bounding box size by %.2f%% (threshold is %.2f%%) in the %s axis. Remove the geometry or increase its size so that it is more visible", s1, p23.Name, v172, v173, v166) })
		end
	end

	return v163
end

local t13 = {}
local t18 = nil

function t13.getBoundsViewsForAssetType(p24) -- line: 506
	-- upvalues: t18 (ref), bodyAssetMasksRenderer (copy)
	if not t18 then
		local t14 = {}

		for _, v177 in bodyAssetMasksRenderer.viewIds do
			t14[v177] = true
		end

		t14[bodyAssetMasksRenderer.viewIds.Left] = false
		t14[bodyAssetMasksRenderer.viewIds.Bottom] = false

		local t15 = {}

		for _, v180 in bodyAssetMasksRenderer.viewIds do
			t15[v180] = true
		end

		t15[bodyAssetMasksRenderer.viewIds.Right] = false
		t15[bodyAssetMasksRenderer.viewIds.Bottom] = false

		local t16 = {}

		for _, v183 in bodyAssetMasksRenderer.viewIds do
			t16[v183] = true
		end

		t16[bodyAssetMasksRenderer.viewIds.Left] = false
		t16[bodyAssetMasksRenderer.viewIds.Bottom] = false

		local t17 = {}

		for _, v186 in bodyAssetMasksRenderer.viewIds do
			t17[v186] = true
		end

		t17[bodyAssetMasksRenderer.viewIds.Right] = false
		t17[bodyAssetMasksRenderer.viewIds.Bottom] = false
		t18 = {
			[Enum.AssetType.DynamicHead] = nil,
			[Enum.AssetType.Torso] = nil,
			[Enum.AssetType.LeftArm] = t14,
			[Enum.AssetType.RightArm] = t15,
			[Enum.AssetType.LeftLeg] = t16,
			[Enum.AssetType.RightLeg] = t17
		}
	end

	return t18[p24]
end
function t13.validate(p25, p26, p27) -- line: 545
	-- upvalues: t13 (copy), validateAccurateBoundingBoxFlags (copy), getAttachmentCFrameInPartSpace (copy), bodyAssetMasksRenderer (copy), projectMeshLocalPointToImageRow (copy), cloneMaskZeroedBelowRow (copy), calculateValidBounds (copy), AssetCalculator (copy), getBodyPartAssetEditableMeshes (copy), getHighestInflatingPointInEachAxis (copy), tryReportInflationError (copy), Analytics (copy)
	local assetTypeEnum = p27.assetTypeEnum

	assert(assetTypeEnum)

	local function findMeshHandle(s2: string) -- line: 553
		-- upvalues: assetTypeEnum (copy), p25 (copy)
		if assetTypeEnum == Enum.AssetType.DynamicHead then
			return p25
		end

		return (p25:FindFirstChild(s2))
	end

	local v192 = t13.getBoundsViewsForAssetType(assetTypeEnum)
	local t19 = {}

	if v192 then
		for v194, v195 in v192 do
			if v195 then
				assert(p26.bodyAssetMasks[v194])
				t19[v194] = p26.bodyAssetMasks[v194]
			end
		end
	else
		t19 = p26.bodyAssetMasks
	end

	local t20 = {}

	if assetTypeEnum == Enum.AssetType.DynamicHead and validateAccurateBoundingBoxFlags.neckAttachmentCrop() then
		local NeckRigAttachment = p25:FindFirstChild("NeckRigAttachment", true)
		local v198

		if not NeckRigAttachment then
			v198 = nil
		else
			local v199 = getAttachmentCFrameInPartSpace(NeckRigAttachment)
			local v200 = p25.Size / p25.MeshSize

			v198 = v199.Position / v200
		end

		if v198 then
			local v201 = validateAccurateBoundingBoxFlags.neckAttachmentCropMargin()
			local t21 = {}

			for v203, v204 in t19 do
				if v203 ~= bodyAssetMasksRenderer.viewIds.Top and v203 ~= bodyAssetMasksRenderer.viewIds.Bottom then
					local v205 = projectMeshLocalPointToImageRow(v198, v204)
					local mask = v204.mask
					local v207 = v205 + v201 * (mask.Size.Y - 1) / 2
					local v208 = cloneMaskZeroedBelowRow(mask, v207)

					table.insert(t20, v208)
					t21[v203] = {
						mask = v208,
						view = v204.view,
						viewSpaceBounds = v204.viewSpaceBounds,
						viewId = v204.viewId
					}
				else
					t21[v203] = v204
				end
			end

			t19 = t21
		end
	end

	local v209, v210 = (function() -- line: 611
		-- upvalues: calculateValidBounds (copy), t19 (ref), p27 (copy), AssetCalculator (copy), p25 (copy), getBodyPartAssetEditableMeshes (copy), getHighestInflatingPointInEachAxis (copy), findMeshHandle (copy), tryReportInflationError (copy), assetTypeEnum (copy), Analytics (copy)
		local v233, v234 = calculateValidBounds(t19, p27)

		if not v233 then
			return false, v234
		end

		local v235 = AssetCalculator.getAssetMeshesValidationSpaceTransforms(p25, p27)
		local v236, v237 = getBodyPartAssetEditableMeshes(p25, p27)

		if not v236 then
			return false, v237
		end

		local v238, v239 = getHighestInflatingPointInEachAxis(v234, v235, v237, findMeshHandle, p27)

		if not v238 then
			return false, v239
		end

		local v240 = tryReportInflationError(v239, assetTypeEnum)

		if not v240:getFinalResults() then
			Analytics.reportFailure(Analytics.ErrorType.validateAccurateBoundingBox, nil, p27)
		end

		return v240:getFinalResults()
	end)()

	for _, v212 in t20 do
		v212:Destroy()
	end

	return v209, v210
end

return t13
