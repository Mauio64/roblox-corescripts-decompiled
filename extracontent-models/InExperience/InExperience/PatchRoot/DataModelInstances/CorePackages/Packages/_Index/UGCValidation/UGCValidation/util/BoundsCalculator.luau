local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ConstantsInterface = require(ParentParent.ConstantsInterface)
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local getPartNamesInHierarchyOrder = require(ParentParent.util.getPartNamesInHierarchyOrder)
local getMeshVerts = require(ParentParent.util.getMeshVerts)
local getMeshInfo = require(ParentParent.util.getMeshInfo)
local BoundsDataUtils = require(ParentParent.util.BoundsDataUtils)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local getFFlagUGCValidateLegFullBodySeparation = require(ParentParent.flags.getFFlagUGCValidateLegFullBodySeparation)
local getFFlagUGCValidateMigrateBodyPartBounds = require(ParentParent.flags.getFFlagUGCValidateMigrateBodyPartBounds)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local t1 = {}

local function orientSingleAssetToWorldAxes(t2: {[any]: any}, p1, p2: ((...any) -> ...any)) -- line: 34
	-- upvalues: AssetCalculator (copy)
	if p1 ~= Enum.AssetType.LeftArm and (p1 ~= Enum.AssetType.RightArm and p1 ~= Enum.AssetType.LeftLeg and p1 ~= Enum.AssetType.RightLeg) then
		return
	end

	for v25, v26 in (AssetCalculator.calculateStraightenedLimb(p1, t2, p2)) do
		t2[v25] = v26
	end
end
local function orientFullBodyArmsLegsToWorldAxes(t3: {[any]: any}, p3: ((...any) -> ...any)) -- line: 55
	-- upvalues: orientSingleAssetToWorldAxes (copy), getPartNamesInHierarchyOrder (copy), ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
	local function orientAndMoveParts(p4, s1: string) -- line: 56
		-- upvalues: orientSingleAssetToWorldAxes (copy), t3 (copy), p3 (copy), getPartNamesInHierarchyOrder (copy), ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
		orientSingleAssetToWorldAxes(t3, p4, p3)

		local v139 = getPartNamesInHierarchyOrder(p4)
		local v140 = p3(v139[1])
		local v141 = ConstantsInterface.getRigAttachmentToParent(p4, v140.Name)
		local v142 = v140:FindFirstChild(v141, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(v142)

		local v143 = t3[v140.Name] * getAttachmentCFrameInPartSpace(v142)
		local v144 = p3(s1)

		assert(v144)

		local v145 = v144:FindFirstChild(v141, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(v145)

		local v146 = (t3[v144.Name] * getAttachmentCFrameInPartSpace(v145)).Position - v143.Position

		for _, v148 in v139 do
			t3[v148] = CFrame.new(t3[v148].Position + v146) * t3[v148].Rotation
		end
	end

	orientAndMoveParts(Enum.AssetType.LeftArm, "UpperTorso")
	orientAndMoveParts(Enum.AssetType.RightArm, "UpperTorso")
	orientAndMoveParts(Enum.AssetType.LeftLeg, "LowerTorso")
	orientAndMoveParts(Enum.AssetType.RightLeg, "LowerTorso")
end
local function calculateBoundsDataForPart(p5, p6, cFrame: CFrame, p7, p8) -- line: 91
	-- upvalues: getExpectedPartSize (copy), getMeshVerts (copy), BoundsDataUtils (copy), ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
	assert(p5 ~= nil ~= (p8 ~= nil))

	local MeshSize = p6.MeshSize
	local v36 = getExpectedPartSize(p6, p7) / MeshSize
	local v37 = nil

	if p8 then
		if p8.meshData and p8.meshData[p6.MeshId] then
			local verts = p8.meshData[p6.MeshId].verts

			if verts then
				v37 = verts
			end
		end

		if not v37 then
			return false, { "Verts not found in data cache" }
		end
	end

	if not v37 then
		local v39, v40

		v39, v40, v37 = getMeshVerts(p5, p7)

		if not v39 then
			return v39, v40
		end
	end

	local t4 = {}

	for _, v43 in v37 do
		BoundsDataUtils.expandMeshBounds(t4, cFrame:PointToWorldSpace(v43 * v36))
	end

	for _, v45 in ConstantsInterface.getAttachments(nil, p6.Name) do
		if string.match(v45, "RigAttachment$") ~= nil then
			local v46 = p6:FindFirstChild(v45, R15plusUtils.checkFlagEnabledForAllowHrd())

			assert(v46)

			local v47 = cFrame * getAttachmentCFrameInPartSpace(v46)

			BoundsDataUtils.expandRigAttachmentBounds(t4, v47.Position)
		end
	end

	BoundsDataUtils.setOverallBounds(t4)

	return true, nil, t4
end
local function buildValidationContextFromRenderMeshes(p9, p10, t5: {[any]: any}) -- line: 149
	local t6 = {}
	local descendants = p9:GetDescendants()

	table.insert(descendants, p9)

	for _, v54 in descendants do
		local v55 = t5[v54.Name]

		if v55 and v55.editable then
			t6[v54] = {
				MeshId = {
					instance = v55.editable,
					created = v55.createdInValidation or false
				}
			}
		end
	end

	return {
		assetTypeEnum = p10,
		editableMeshes = t6
	}
end
local function calculateAllPartsBoundsData(t7: {[any]: any}, p11: ((...any) -> ...any), p12, p13) -- line: 170
	-- upvalues: getMeshInfo (copy), Constants (copy), calculateBoundsDataForPart (copy)
	local t8 = {}

	for v61, v62 in t7 do
		local v63 = p11(v61)
		local v64 = nil

		if not p13 then
			local v65, v66

			v65, v66, v64 = getMeshInfo(v63, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p12)

			if not v65 then
				return v65, v66
			end
		end

		local v67, v68, v69 = calculateBoundsDataForPart(v64, v63, v62, p12, p13)

		if not v67 then
			return v67, v68
		end

		t8[v61] = v69
	end

	return true, nil, t8
end
local function calculateTotalBoundsForAsset(t9: {[any]: any}, p14: ((...any) -> ...any), p15) -- line: 201
	-- upvalues: calculateAllPartsBoundsData (copy), BoundsDataUtils (copy)
	local v73, v74, v75 = calculateAllPartsBoundsData(t9, p14, p15)

	if not v73 then
		return v73, v74
	end

	local t10 = {}

	for _, v78 in v75 do
		t10 = BoundsDataUtils.combineBounds(t10, v78)
	end

	return true, nil, t10
end
local function calculatePartBounds(p16, p17) -- line: 220
	-- upvalues: calculateTotalBoundsForAsset (copy)
	local t11 = {
		[p16.Name] = CFrame.new()
	}

	local function findMeshHandle(s2: string) -- line: 225
		-- upvalues: p16 (copy)
		assert(s2 == p16.Name)

		return p16
	end

	local v83, v84, v85 = calculateTotalBoundsForAsset(t11, findMeshHandle, p17)

	if not v83 then
		return v83, v84
	end

	return true, nil, v85
end

function t1.calculateAssetBounds(p18, p19) -- line: 239
	-- upvalues: calculatePartBounds (copy), AssetCalculator (copy), orientSingleAssetToWorldAxes (copy), calculateTotalBoundsForAsset (copy)
	local assetTypeEnum = p19.assetTypeEnum

	assert(assetTypeEnum)

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		return calculatePartBounds(p18, p19)
	end

	local v89 = AssetCalculator.calculateAllTransformsForAsset(assetTypeEnum, p18)

	local function findMeshHandle(s3: string) -- line: 252
		-- upvalues: p18 (copy)
		return (p18:FindFirstChild(s3))
	end

	orientSingleAssetToWorldAxes(v89, assetTypeEnum, findMeshHandle)

	local v91, v92, v93 = calculateTotalBoundsForAsset(v89, findMeshHandle, p19)

	if not v91 then
		return v91, v92
	end

	return true, nil, v93
end
function t1.calculateIndividualAssetPartsData(p20, p21) -- line: 268
	-- upvalues: AssetCalculator (copy), orientSingleAssetToWorldAxes (copy), calculateAllPartsBoundsData (copy)
	local assetTypeEnum = p21.assetTypeEnum

	assert(assetTypeEnum)

	local v97 = AssetCalculator.calculateAllTransformsForAsset(assetTypeEnum, p20)

	local function findMeshHandle(s4: string) -- line: 277
		-- upvalues: assetTypeEnum (copy), p20 (copy)
		if assetTypeEnum == Enum.AssetType.DynamicHead then
			return p20
		end

		return (p20:FindFirstChild(s4))
	end

	orientSingleAssetToWorldAxes(v97, assetTypeEnum, findMeshHandle)

	local v99, v100, v101 = calculateAllPartsBoundsData(v97, findMeshHandle, p21)

	if not v99 then
		return v99, v100
	end

	local t12 = {}

	for v103, v104 in v101 do
		t12[v103] = {
			boundsData = v104,
			cframe = v97[v103]
		}
	end

	return true, nil, t12
end
function t1.calculateIndividualFullBodyPartsData(p22, p23, p24, b1: boolean) -- line: 302
	-- upvalues: AssetCalculator (copy), getFFlagUGCValidateLegFullBodySeparation (copy), orientFullBodyArmsLegsToWorldAxes (copy), calculateAllPartsBoundsData (copy)
	local function findMeshHandle(s5: string) -- line: 308
		-- upvalues: p22 (copy)
		return p22[s5]
	end

	local v110 = AssetCalculator.calculateAllTransformsForFullBody(p22)

	if getFFlagUGCValidateLegFullBodySeparation() then
		if b1 then
			orientFullBodyArmsLegsToWorldAxes(v110, findMeshHandle)
		end
	else
		orientFullBodyArmsLegsToWorldAxes(v110, findMeshHandle)
	end

	local v111, v112, v113 = calculateAllPartsBoundsData(v110, findMeshHandle, p23, p24)

	if not v111 then
		return v111, v112
	end

	local t13 = {}

	for v115, v116 in v113 do
		t13[v115] = {
			boundsData = v116,
			cframe = v110[v115]
		}
	end

	return true, nil, t13
end
function t1.calculateFullBodyBounds(p25, p26) -- line: 335
	-- upvalues: AssetCalculator (copy), orientFullBodyArmsLegsToWorldAxes (copy), calculateTotalBoundsForAsset (copy)
	local function findMeshHandle(s6: string) -- line: 339
		-- upvalues: p25 (copy)
		return p25[s6]
	end

	local v120 = AssetCalculator.calculateAllTransformsForFullBody(p25)

	orientFullBodyArmsLegsToWorldAxes(v120, findMeshHandle)

	local v121, v122, v123 = calculateTotalBoundsForAsset(v120, findMeshHandle, p26)

	if not v121 then
		return v121, v122
	end

	return true, nil, v123
end
function t1.calculateAssetBoundsFromData(p27, p28, t14: {[any]: any}) -- line: 353
	-- upvalues: getFFlagUGCValidateMigrateBodyPartBounds (copy), buildValidationContextFromRenderMeshes (copy), t1 (copy)
	assert(getFFlagUGCValidateMigrateBodyPartBounds(), "calculateAssetBoundsFromData requires FFlagUGCValidateMigrateBodyPartBounds")

	local v127 = buildValidationContextFromRenderMeshes(p27, p28, t14)

	return t1.calculateAssetBounds(p27, v127)
end
function t1.calculateFullBodyBoundsFromData(p29, t15: {[any]: any}) -- line: 366
	-- upvalues: getFFlagUGCValidateMigrateBodyPartBounds (copy), buildValidationContextFromRenderMeshes (copy), t1 (copy)
	assert(getFFlagUGCValidateMigrateBodyPartBounds(), "calculateFullBodyBoundsFromData requires FFlagUGCValidateMigrateBodyPartBounds")

	local v130 = next(p29)

	if not v130 then
		return false, { "No body parts provided" }
	end

	local Parent = p29[v130].Parent
	local v132 = buildValidationContextFromRenderMeshes(Parent, nil, t15)

	return t1.calculateFullBodyBounds(p29, v132)
end
function t1.calculateIndividualAssetPartsDataFromData(p30, p31, t16: {[any]: any}) -- line: 383
	-- upvalues: getFFlagUGCValidateMigrateBodyPartBounds (copy), buildValidationContextFromRenderMeshes (copy), t1 (copy)
	assert(getFFlagUGCValidateMigrateBodyPartBounds(), "calculateIndividualAssetPartsDataFromData requires FFlagUGCValidateMigrateBodyPartBounds")

	local v136 = buildValidationContextFromRenderMeshes(p30, p31, t16)

	return t1.calculateIndividualAssetPartsData(p30, v136)
end

return t1
