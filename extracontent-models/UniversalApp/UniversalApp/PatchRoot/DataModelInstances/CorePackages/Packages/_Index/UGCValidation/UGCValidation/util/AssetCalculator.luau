local parent = script.Parent.Parent
local Cryo = require(parent.Parent.Cryo)

local ConstantsInterface = require(parent.ConstantsInterface)

require(parent.util.Types)
local canBeNormalized = require(parent.util.canBeNormalized)
local getPartNamesInHierarchyOrder = require(parent.util.getPartNamesInHierarchyOrder)
local AssetTraversalUtils = require(parent.util.AssetTraversalUtils)
local getMeshScales = require(parent.util.getMeshScales)
local R15plusUtils = require(parent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)

local lowerTorso = {
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

local v = {
	root = "HumanoidRootPart",
	children = { LowerTorso = lowerTorso }
}

local AssetCalculator = {}

local function calculateCFrame(position: Vector3, position2: Vector3)
	local v2 = position - position2

	if not canBeNormalized(v2) then
		return
	end

	local unit = v2.Unit

	local unit2 = unit:Cross(Vector3.new(0, 0, 1)).Unit

	if not canBeNormalized(unit2) then
		unit2 = unit:Cross(unit.Z < 0 and Vector3.new(0, 1, 0) or -Vector3.new(0, 1, 0)).Unit
	end

	local unit3 = unit2:Cross(unit).Unit

	return CFrame.fromMatrix(position, unit2, unit, unit3)
end

local function calculatePartTransformInHierarchy(instance, p: string?, cframe: CFrame, callback, p2)
	local v2

	if p2 and p2[instance.Name] then
		v2 = p2[instance.Name]
	else
		v2 = CFrame.new()
	end

	if not p then
		return v2
	end

	local v3 = callback(p)
	assert(v3)

	local rigAttachmentToParent = ConstantsInterface.getRigAttachmentToParent(nil, instance.Name)

	local child = v3:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())
	assert(child)

	local child2 = instance:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())
	assert(child2)

	return cframe * getAttachmentCFrameInPartSpace(child) * v2 * getAttachmentCFrameInPartSpace(child2):Inverse()
end

local function calculateHierarchyTransforms(p, findMeshHandle, p2)
	local hierarchyTransforms = {}
	local function calculateAllTransformsInternal(root: string, p3: string?, p4, cframe: CFrame)
		local v2 = findMeshHandle(root)
		assert(v2)

		local v3 = calculatePartTransformInHierarchy(v2, p3, cframe, findMeshHandle, p2)
		hierarchyTransforms[v2.Name] = v3

		if not p4.children then
			return
		end

		for k, child in p4.children do
			calculateAllTransformsInternal(k, root, child, v3)
		end
	end

	calculateAllTransformsInternal(p.root, nil, p, CFrame.new())
	return hierarchyTransforms
end

local function calculateLocalSpaceTransform(cframe: CFrame, cframe2: CFrame) -- 2 equivalent calls inferred from this helper
	local v2 = cframe.Rotation:Inverse() * cframe2.Rotation
	local v3 = cframe.Rotation:Inverse() * (cframe2.Position - cframe.Position)

	return CFrame.new(v3) * v2
end

local function calculateAssetCFrameFromPartsCFrames(p, allTransformsForAsset) -- 1 equivalent call inferred from this helper
	local partNamesInHierarchyOrder = getPartNamesInHierarchyOrder(p)
	return calculateCFrame(
		allTransformsForAsset[partNamesInHierarchyOrder[1]].Position,
		allTransformsForAsset[partNamesInHierarchyOrder[3]].Position
	)
end

local function assertTypesToOrient(p) -- 2 equivalent calls inferred from this helper
	assert(p == Enum.AssetType.LeftArm or p == Enum.AssetType.RightArm or p == Enum.AssetType.LeftLeg or p == Enum.AssetType.RightLeg)
end

local function getAttachmentCFrame(instance, childName: string, cframe: CFrame) -- 4 equivalent calls inferred from this helper
	local child = instance:FindFirstChild(childName, R15plusUtils.checkFlagEnabledForAllowHrd())
	assert(child)
	return cframe * getAttachmentCFrameInPartSpace(child)
end

function AssetCalculator.calculatePartCFrameFromRigAttachments(p, instance, cframe: CFrame)
	assertTypesToOrient(p) -- inferred equivalent call
	local rigAttachmentToParent = ConstantsInterface.getRigAttachmentToParent(p, instance.Name)

	if rigAttachmentToParent == "" then
		return
	end

	local attachmentCFrame = getAttachmentCFrame(instance, rigAttachmentToParent, cframe) -- inferred equivalent call
	local assetRigChild = AssetTraversalUtils.getAssetRigChild(p, instance.Name)

	if not assetRigChild then
		return
	end

	local attachmentCFrame2 = getAttachmentCFrame( -- inferred equivalent call
		instance,
		ConstantsInterface.getRigAttachmentToParent(p, assetRigChild),
		cframe
	)

	return calculateCFrame(attachmentCFrame.Position, attachmentCFrame2.Position)
end

function AssetCalculator.calculateStraightenedLimb(p, p2, callback)
	assertTypesToOrient(p) -- inferred equivalent call
	local joined = Cryo.Dictionary.join(p2)

	local v2 = CFrame.new()
	local position = nil

	for _, v3 in getPartNamesInHierarchyOrder(p) do
		local v4 = callback(v3)

		local assetRigChild = AssetTraversalUtils.getAssetRigChild(p, v3)
		local v5 = assetRigChild == nil
		local v6

		if v5 then
			v6 = v2
		else
			v6 = AssetCalculator.calculatePartCFrameFromRigAttachments(p, v4, p2[v3]) or v2
		end

		joined[v3] = calculateLocalSpaceTransform(v6, p2[v3]) -- inferred equivalent call

		if position then
			local v7 = position - getAttachmentCFrame( -- inferred equivalent call
				v4,
				ConstantsInterface.getRigAttachmentToParent(p, v3),
				joined[v3]
			).Position
			joined[v3] = CFrame.new(joined[v3].Position + v7) * joined[v3].Rotation
		end

		if v5 then
			continue
		end

		position = getAttachmentCFrame(v4, ConstantsInterface.getRigAttachmentToParent(p, assetRigChild), joined[v3]).Position -- inferred equivalent call
		v2 = v6
	end

	return joined
end

function AssetCalculator.calculateAssetCFrame(p, p2)
	local allTransformsForAsset = AssetCalculator.calculateAllTransformsForAsset(p, p2)

	if Enum.AssetType.DynamicHead == p then
		return allTransformsForAsset.Head
	end

	if Enum.AssetType.Torso == p then
		return allTransformsForAsset.LowerTorso
	end

	return calculateAssetCFrameFromPartsCFrames(p, allTransformsForAsset)
end

function AssetCalculator.calculateAllTransformsForAsset(p, instance)
	if Enum.AssetType.DynamicHead == p then
		return { Head = CFrame.new() }
	end

	local function findMeshHandle(childName: string)
		return (instance:FindFirstChild(childName))
	end

	return calculateHierarchyTransforms(AssetTraversalUtils.assetHierarchy[p], findMeshHandle)
end

function AssetCalculator.calculateAllTransformsForFullBody(p, p2)
	local function findMeshHandle(p3: string)
		return p[p3]
	end

	local v2 = if p2 then v else lowerTorso
	return calculateHierarchyTransforms(v2, findMeshHandle, p2)
end

function AssetCalculator.calculatePartsLocalToAsset(p, p2)
	assert(p == Enum.AssetType.LeftArm or p == Enum.AssetType.RightArm or p == Enum.AssetType.LeftLeg or p == Enum.AssetType.RightLeg)
	local assetCFrameFromPartsCFrames = calculateAssetCFrameFromPartsCFrames(p, p2) -- inferred equivalent call
	local partsLocalToAsset = {}

	for _, v2 in getPartNamesInHierarchyOrder(p) do
		local v3

		if assetCFrameFromPartsCFrames then
			v3 = calculateLocalSpaceTransform(assetCFrameFromPartsCFrames, p2[v2]) -- inferred equivalent call
		else
			v3 = p2[v2]
		end

		partsLocalToAsset[v2] = v3
	end

	return partsLocalToAsset
end

function AssetCalculator.getBodyPartsToParents()
	local bodyPartsToParents = {}
	local function calculateAllTransformsInternal(k: string, root: string?, child)
		bodyPartsToParents[k] = root or "HumanoidRootPart"

		if not child.children then
			return
		end

		for k2, child2 in child.children do
			calculateAllTransformsInternal(k2, k, child2)
		end
	end

	local root = lowerTorso.root
	local lowerTorso2 = lowerTorso
	bodyPartsToParents[root] = "HumanoidRootPart"

	if not lowerTorso2.children then
		return bodyPartsToParents
	end

	for k, child in lowerTorso2.children do
		calculateAllTransformsInternal(k, root, child)
	end

	return bodyPartsToParents
end

function AssetCalculator.getAssetMeshesValidationSpaceTransforms(instance, p)
	local assetTypeEnum = p.assetTypeEnum
	assert(assetTypeEnum)

	local names = {}

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		table.insert(names, instance.Name)
	else
		for _, part in instance:GetChildren() do
			if part:IsA("MeshPart") then
				table.insert(names, part.Name)
			end
		end
	end

	local allTransformsForAsset = AssetCalculator.calculateAllTransformsForAsset(assetTypeEnum, instance)

	local function findMeshHandle(childName: string)
		if assetTypeEnum == Enum.AssetType.DynamicHead then
			return instance
		end

		return (instance:FindFirstChild(childName))
	end

	if assetTypeEnum ~= Enum.AssetType.DynamicHead and assetTypeEnum ~= Enum.AssetType.Torso then
		local straightenedLimb = AssetCalculator.calculateStraightenedLimb(
			assetTypeEnum,
			allTransformsForAsset,
			findMeshHandle
		)

		for k, v2 in straightenedLimb do
			allTransformsForAsset[k] = v2
		end
	end

	local meshScales = getMeshScales(names, findMeshHandle, p)

	local assetMeshesValidationSpaceTransforms = {}

	for _, v2 in names do
		assetMeshesValidationSpaceTransforms[v2] = {
			CFrame = allTransformsForAsset[v2],
			scale = meshScales[v2]
		}
	end

	return assetMeshesValidationSpaceTransforms
end

return AssetCalculator
