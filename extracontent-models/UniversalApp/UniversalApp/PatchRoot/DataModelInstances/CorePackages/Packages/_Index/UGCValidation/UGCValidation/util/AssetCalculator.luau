local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Parent.Cryo)
local ConstantsInterface = require(ParentParent.ConstantsInterface)

require(ParentParent.util.Types)

local canBeNormalized = require(ParentParent.util.canBeNormalized)
local getPartNamesInHierarchyOrder = require(ParentParent.util.getPartNamesInHierarchyOrder)
local AssetTraversalUtils = require(ParentParent.util.AssetTraversalUtils)
local getMeshScales = require(ParentParent.util.getMeshScales)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local t1 = {
	root = "LowerTorso",
	children = {
		UpperTorso = {
			children = {
				Head = AssetTraversalUtils.assetHierarchy[Enum.AssetType.DynamicHead],
				LeftUpperArm = AssetTraversalUtils.assetHierarchy[Enum.AssetType.LeftArm],
				RightUpperArm = AssetTraversalUtils.assetHierarchy[Enum.AssetType.RightArm]
			}
		},
		LeftUpperLeg = AssetTraversalUtils.assetHierarchy[Enum.AssetType.LeftLeg],
		RightUpperLeg = AssetTraversalUtils.assetHierarchy[Enum.AssetType.RightLeg]
	}
}
local t2 = {
	root = "HumanoidRootPart",
	children = {
		LowerTorso = t1
	}
}
local t3 = {}

local function calculateCFrame(vector3: Vector3, vector3_2: Vector3) -- line: 60
	-- upvalues: canBeNormalized (copy)
	local v22 = vector3 - vector3_2

	if not canBeNormalized(v22) then
		return
	end

	local Unit = v22.Unit
	local Unit2 = Unit:Cross((Vector3.new(0, 0, 1))).Unit

	if not canBeNormalized(Unit2) then
		Unit2 = Unit:Cross((if not (Unit.Z < 0) then Vector3.new(-0, -1, -0) else Vector3.new(0, 1, 0))).Unit
	end

	local Unit3 = Unit2:Cross(Unit).Unit

	return CFrame.fromMatrix(vector3, Unit2, Unit, Unit3)
end
local function calculatePartTransformInHierarchy(p1, s1: string?, cFrame: CFrame, p2: ((...any) -> ...any), t4: {[any]: any}?) -- line: 79
	-- upvalues: ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
	local v31 = if not t4 or not t4[p1.Name] then CFrame.new() else t4[p1.Name]

	if s1 then
		local v32 = p2(s1)

		assert(v32)

		local v33 = ConstantsInterface.getRigAttachmentToParent(nil, p1.Name)
		local v34 = v32:FindFirstChild(v33, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(v34)

		local v35 = p1:FindFirstChild(v33, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(v35)

		return cFrame * getAttachmentCFrameInPartSpace(v34) * v31 * getAttachmentCFrameInPartSpace(v35):Inverse()
	end

	return v31
end
local function calculateHierarchyTransforms(p3, p4: ((...any) -> ...any), t5: {[any]: any}?) -- line: 112
	-- upvalues: calculatePartTransformInHierarchy (copy)
	local t6 = {}

	local function calculateAllTransformsInternal(s2: string, s3: string?, p5, cFrame: CFrame) -- line: 119
		-- upvalues: p4 (copy), calculatePartTransformInHierarchy (copy), t5 (copy), t6 (copy), calculateAllTransformsInternal (copy)
		local v133 = p4(s2)

		assert(v133)

		local v134 = calculatePartTransformInHierarchy(v133, s3, cFrame, p4, t5)

		t6[v133.Name] = v134

		if not p5.children then
			return
		end

		for v135, v136 in p5.children do
			calculateAllTransformsInternal(v135, s2, v136, v134)
		end
	end

	calculateAllTransformsInternal(p3.root, nil, p3, CFrame.new())

	return t6
end
local function calculateLocalSpaceTransform(cFrame: CFrame, cFrame2: CFrame) -- line: 140
	local v43 = cFrame.Rotation:Inverse() * cFrame2.Rotation
	local v44 = cFrame.Rotation:Inverse() * (cFrame2.Position - cFrame.Position)

	return CFrame.new(v44) * v43
end
local function calculateAssetCFrameFromPartsCFrames(p6, t7: {[any]: any}) -- line: 147
	-- upvalues: getPartNamesInHierarchyOrder (copy), calculateCFrame (copy)
	local v47 = getPartNamesInHierarchyOrder(p6)
	local Position = t7[v47[1]].Position
	local Position2 = t7[v47[3]].Position

	return calculateCFrame(Position, Position2)
end
local function assertTypesToOrient(p7) -- line: 158
	assert(p7 == Enum.AssetType.LeftArm or (p7 == Enum.AssetType.RightArm or (p7 == Enum.AssetType.LeftLeg or p7 == Enum.AssetType.RightLeg)))
end
local function getAttachmentCFrame(p8, s4: string, cFrame: CFrame) -- line: 167
	-- upvalues: R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
	local s4_2 = p8:FindFirstChild(s4, R15plusUtils.checkFlagEnabledForAllowHrd())

	assert(s4_2)

	return cFrame * getAttachmentCFrameInPartSpace(s4_2)
end

function t3.calculatePartCFrameFromRigAttachments(p9, p10, cFrame: CFrame) -- line: 174
	-- upvalues: ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy), AssetTraversalUtils (copy), calculateCFrame (copy)
	assert(p9 == Enum.AssetType.LeftArm or (p9 == Enum.AssetType.RightArm or (p9 == Enum.AssetType.LeftLeg or p9 == Enum.AssetType.RightLeg)))

	local v58 = ConstantsInterface.getRigAttachmentToParent(p9, p10.Name)

	if v58 == "" then
		return
	end

	local v59 = p10:FindFirstChild(v58, R15plusUtils.checkFlagEnabledForAllowHrd())

	assert(v59)

	local v60 = cFrame * getAttachmentCFrameInPartSpace(v59)
	local v61 = AssetTraversalUtils.getAssetRigChild(p9, p10.Name)

	if not v61 then
		return
	end

	local v62 = p10:FindFirstChild(ConstantsInterface.getRigAttachmentToParent(p9, v61), R15plusUtils.checkFlagEnabledForAllowHrd())

	assert(v62)

	local v63 = cFrame * getAttachmentCFrameInPartSpace(v62)

	return calculateCFrame(v60.Position, v63.Position)
end
function t3.calculateStraightenedLimb(p11, t8: {[any]: any}, p12: ((...any) -> ...any)) -- line: 198
	-- upvalues: Cryo (copy), getPartNamesInHierarchyOrder (copy), AssetTraversalUtils (copy), t3 (copy), ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
	assert(p11 == Enum.AssetType.LeftArm or (p11 == Enum.AssetType.RightArm or (p11 == Enum.AssetType.LeftLeg or p11 == Enum.AssetType.RightLeg)))

	local v67 = Cryo.Dictionary.join(t8)
	local Position = nil
	local cFrame = CFrame.new()

	for _, v71 in getPartNamesInHierarchyOrder(p11) do
		local v72 = p12(v71)
		local v73 = cFrame
		local v74 = AssetTraversalUtils.getAssetRigChild(p11, v71)
		local v75 = v74 == nil

		if not v75 then
			v73 = t3.calculatePartCFrameFromRigAttachments(p11, v72, t8[v71]) or v73
		end

		local v76 = t8[v71]
		local v77 = v73.Rotation:Inverse() * v76.Rotation
		local v78 = v73.Rotation:Inverse() * (v76.Position - v73.Position)

		v67[v71] = CFrame.new(v78) * v77

		if Position then
			local v79 = ConstantsInterface.getRigAttachmentToParent(p11, v71)
			local v80 = v67[v71]
			local v81 = v72:FindFirstChild(v79, R15plusUtils.checkFlagEnabledForAllowHrd())

			assert(v81)

			local v82 = Position - (v80 * getAttachmentCFrameInPartSpace(v81)).Position

			v67[v71] = CFrame.new(v67[v71].Position + v82) * v67[v71].Rotation
		end

		if not v75 then
			cFrame = v73

			local v83 = ConstantsInterface.getRigAttachmentToParent(p11, v74)
			local v84 = v67[v71]
			local v85 = v72:FindFirstChild(v83, R15plusUtils.checkFlagEnabledForAllowHrd())

			assert(v85)
			Position = (v84 * getAttachmentCFrameInPartSpace(v85)).Position
		end
	end

	return v67
end
function t3.calculateAssetCFrame(p13, p14) -- line: 251
	-- upvalues: t3 (copy), calculateAssetCFrameFromPartsCFrames (copy)
	local v88 = t3.calculateAllTransformsForAsset(p13, p14)

	if p13 == Enum.AssetType.DynamicHead then
		return v88.Head
	end

	if p13 == Enum.AssetType.Torso then
		return v88.LowerTorso
	end

	return calculateAssetCFrameFromPartsCFrames(p13, v88)
end
function t3.calculateAllTransformsForAsset(p15, p16) -- line: 262
	-- upvalues: calculateHierarchyTransforms (copy), AssetTraversalUtils (copy)
	if p15 == Enum.AssetType.DynamicHead then
		return {
			Head = CFrame.new()
		}
	end

	local function findMeshHandle(s5: string) -- line: 267
		-- upvalues: p16 (copy)
		return (p16:FindFirstChild(s5))
	end

	return (calculateHierarchyTransforms(AssetTraversalUtils.assetHierarchy[p15], findMeshHandle))
end
function t3.calculateAllTransformsForFullBody(p17, t9: {[any]: any}?) -- line: 274
	-- upvalues: t2 (copy), t1 (copy), calculateHierarchyTransforms (copy)
	local function findMeshHandle(s6: string) -- line: 278
		-- upvalues: p17 (copy)
		return p17[s6]
	end

	local v95 = if not t9 then t1 else t2

	return (calculateHierarchyTransforms(v95, findMeshHandle, t9))
end
function t3.calculatePartsLocalToAsset(p18, t10: {[any]: any}) -- line: 286
	-- upvalues: getPartNamesInHierarchyOrder (copy), calculateCFrame (copy)
	assert(p18 == Enum.AssetType.LeftArm or (p18 == Enum.AssetType.RightArm or (p18 == Enum.AssetType.LeftLeg or p18 == Enum.AssetType.RightLeg)))

	local v98 = getPartNamesInHierarchyOrder(p18)
	local Position = t10[v98[1]].Position
	local Position3 = t10[v98[3]].Position
	local v101 = calculateCFrame(Position, Position3)
	local t11 = {}

	for _, v104 in getPartNamesInHierarchyOrder(p18) do
		local v108

		if v101 then
			local v105 = t10[v104]
			local v106 = v101.Rotation:Inverse() * v105.Rotation
			local v107 = v101.Rotation:Inverse() * (v105.Position - v101.Position)

			v108 = CFrame.new(v107) * v106
		else
			v108 = t10[v104]
		end

		t11[v104] = v108
	end

	return t11
end
function t3.getBodyPartsToParents() -- line: 308
	-- upvalues: t1 (copy)
	local t12 = {}

	local function calculateAllTransformsInternal(s7: string, s8: string?, p19) -- line: 311
		-- upvalues: t12 (copy), calculateAllTransformsInternal (copy)
		t12[s7] = s8 or "HumanoidRootPart"

		if not p19.children then
			return
		end

		for v142, v143 in p19.children do
			calculateAllTransformsInternal(v142, s7, v143)
		end
	end

	local root = t1.root
	local v112 = t1

	t12[root] = "HumanoidRootPart"

	if not v112.children then
		return t12
	end

	for v113, v114 in v112.children do
		calculateAllTransformsInternal(v113, root, v114)
	end

	return t12
end
function t3.getAssetMeshesValidationSpaceTransforms(p20, p21) -- line: 327
	-- upvalues: t3 (copy), getMeshScales (copy)
	local assetTypeEnum = p21.assetTypeEnum

	assert(assetTypeEnum)

	local t13 = {}

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		table.insert(t13, p20.Name)
	else
		for _, child in p20:GetChildren() do
			if child:IsA("MeshPart") then
				table.insert(t13, child.Name)
			end
		end
	end

	local v121 = t3.calculateAllTransformsForAsset(assetTypeEnum, p20)

	local function findMeshHandle(s9: string) -- line: 348
		-- upvalues: assetTypeEnum (copy), p20 (copy)
		if assetTypeEnum == Enum.AssetType.DynamicHead then
			return p20
		end

		return (p20:FindFirstChild(s9))
	end

	if assetTypeEnum ~= Enum.AssetType.DynamicHead and assetTypeEnum ~= Enum.AssetType.Torso then
		for v123, v124 in (t3.calculateStraightenedLimb(assetTypeEnum, v121, findMeshHandle)) do
			v121[v123] = v124
		end
	end

	local v125 = getMeshScales(t13, findMeshHandle, p21)
	local t14 = {}

	for _, v128 in t13 do
		t14[v128] = {
			CFrame = v121[v128],
			scale = v125[v128]
		}
	end

	return t14
end

return t3
