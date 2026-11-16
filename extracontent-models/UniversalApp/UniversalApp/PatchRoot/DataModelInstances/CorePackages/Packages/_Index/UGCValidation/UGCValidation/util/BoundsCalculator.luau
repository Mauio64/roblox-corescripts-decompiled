local parent = script.Parent.Parent
local Constants = require(parent.Constants)
require(parent.util.Types)
local ConstantsInterface = require(parent.ConstantsInterface)
local AssetCalculator = require(parent.util.AssetCalculator)
local getPartNamesInHierarchyOrder = require(parent.util.getPartNamesInHierarchyOrder)
local getMeshVerts = require(parent.util.getMeshVerts)
local getMeshInfo = require(parent.util.getMeshInfo)
local BoundsDataUtils = require(parent.util.BoundsDataUtils)
local getExpectedPartSize = require(parent.util.getExpectedPartSize)
local R15plusUtils = require(parent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)

local BoundsCalculator = {}

local function orientSingleAssetToWorldAxes(p, p2, callback)
	if
		p2 ~= Enum.AssetType.LeftArm
		and p2 ~= Enum.AssetType.RightArm
		and p2 ~= Enum.AssetType.LeftLeg
		and p2 ~= Enum.AssetType.RightLeg
	then
		return
	end

	local straightenedLimb = AssetCalculator.calculateStraightenedLimb(p2, p, callback)

	for k, v in straightenedLimb do
		p[k] = v
	end
end

local function orientFullBodyArmsLegsToWorldAxes(allTransformsForFullBody, findMeshHandle)
	local function orientAndMoveParts(p, p2: string)
		orientSingleAssetToWorldAxes(allTransformsForFullBody, p, findMeshHandle)

		local partNamesInHierarchyOrder = getPartNamesInHierarchyOrder(p)
		local v = findMeshHandle(partNamesInHierarchyOrder[1])

		local rigAttachmentToParent = ConstantsInterface.getRigAttachmentToParent(p, v.Name)

		local child = v:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())
		assert(child)
		local v2 = allTransformsForFullBody[v.Name] * getAttachmentCFrameInPartSpace(child)

		local v3 = findMeshHandle(p2)
		assert(v3)

		local child2 = v3:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())
		assert(child2)
		local v4 = (allTransformsForFullBody[v3.Name] * getAttachmentCFrameInPartSpace(child2)).Position - v2.Position

		for _, v5 in partNamesInHierarchyOrder do
			allTransformsForFullBody[v5] = CFrame.new(allTransformsForFullBody[v5].Position + v4) * allTransformsForFullBody[v5].Rotation
		end
	end

	orientAndMoveParts(Enum.AssetType.LeftArm, "UpperTorso")
	orientAndMoveParts(Enum.AssetType.RightArm, "UpperTorso")
	orientAndMoveParts(Enum.AssetType.LeftLeg, "LowerTorso")
	orientAndMoveParts(Enum.AssetType.RightLeg, "LowerTorso")
end

local function calculateBoundsDataForPart(p, instance, item: CFrame, p2, p3)
	assert((p ~= nil) ~= (p3 ~= nil))

	local meshSize = instance.MeshSize

	local v = getExpectedPartSize(instance, p2) / meshSize

	local v2 = nil

	if p3 then
		v2 = p3.meshData and p3.meshData[instance.MeshId] and p3.meshData[instance.MeshId].verts or v2

		if not v2 then
			return false, { "Verts not found in data cache" }
		end
	end

	if not v2 then
		local v3, v4
		v3, v4, v2 = getMeshVerts(p, p2)

		if not v3 then
			return v3, v4
		end
	end

	local v3 = {}

	for _, v4 in v2 do
		BoundsDataUtils.expandMeshBounds(v3, item:PointToWorldSpace(v4 * v))
	end

	for _, childName in ConstantsInterface.getAttachments(nil, instance.Name) do
		if string.match(childName, "RigAttachment$") == nil then
			continue
		end

		local child = instance:FindFirstChild(childName, R15plusUtils.checkFlagEnabledForAllowHrd())
		assert(child)

		local v4 = item * getAttachmentCFrameInPartSpace(child)
		BoundsDataUtils.expandRigAttachmentBounds(v3, v4.Position)
	end

	BoundsDataUtils.setOverallBounds(v3)
	return true, nil, v3
end

local function buildValidationContextFromRenderMeshes(folder, assetTypeEnum, p)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)
	local editableMeshes = {}

	for _, descendant in descendants do
		local v = p[descendant.Name]

		if v and v.editable then
			editableMeshes[descendant] = {
				MeshId = {
					instance = v.editable,
					created = v.createdInValidation or false
				}
			}
		end
	end

	return { assetTypeEnum = assetTypeEnum, editableMeshes = editableMeshes }
end

local function calculateAllPartsBoundsData(items, callback, p, p2)
	local result = {}

	for k, item in items do
		local v = callback(k)
		local v2

		if not p2 then
			local v3, v4
			v3, v4, v2 = getMeshInfo(v, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p)

			if not v3 then
				return v3, v4
			end
		end

		local v3, v4, v5 = calculateBoundsDataForPart(v2, v, item, p, p2)

		if not v3 then
			return v3, v4
		end

		result[k] = v5
	end

	return true, nil, result
end

local function calculateTotalBoundsForAsset(p, findMeshHandle, p2)
	local v, v2, v3 = calculateAllPartsBoundsData(p, findMeshHandle, p2)

	if not v then
		return v, v2
	end

	local v4 = {}

	for _, v5 in v3 do
		v4 = BoundsDataUtils.combineBounds(v4, v5)
	end

	return true, nil, v4
end

local function calculatePartBounds(instance, p)
	local function findMeshHandle(p2: string)
		assert(p2 == instance.Name)
		return instance
	end

	local v, v2, v3 = calculateTotalBoundsForAsset({ [instance.Name] = CFrame.new() }, findMeshHandle, p)

	if v then
		return true, nil, v3
	end

	return v, v2
end

function BoundsCalculator.calculateAssetBounds(instance, p)
	local assetTypeEnum = p.assetTypeEnum
	assert(assetTypeEnum)

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		return calculatePartBounds(instance, p)
	end

	local allTransformsForAsset = AssetCalculator.calculateAllTransformsForAsset(assetTypeEnum, instance)

	local function findMeshHandle(childName: string)
		return (instance:FindFirstChild(childName))
	end

	orientSingleAssetToWorldAxes(allTransformsForAsset, assetTypeEnum, findMeshHandle)

	local v, v2, v3 = calculateTotalBoundsForAsset(allTransformsForAsset, findMeshHandle, p)

	if v then
		return true, nil, v3
	end

	return v, v2
end

function BoundsCalculator.calculateIndividualAssetPartsData(instance, p)
	local assetTypeEnum = p.assetTypeEnum
	assert(assetTypeEnum)

	local allTransformsForAsset = AssetCalculator.calculateAllTransformsForAsset(assetTypeEnum, instance)

	local function findMeshHandle(childName: string)
		if assetTypeEnum == Enum.AssetType.DynamicHead then
			return instance
		end

		return (instance:FindFirstChild(childName))
	end

	orientSingleAssetToWorldAxes(allTransformsForAsset, assetTypeEnum, findMeshHandle)

	local v, v2, v3 = calculateAllPartsBoundsData(allTransformsForAsset, findMeshHandle, p)

	if not v then
		return v, v2
	end

	local result = {}

	for k, boundsData in v3 do
		result[k] = { boundsData = boundsData, cframe = allTransformsForAsset[k] }
	end

	return true, nil, result
end

function BoundsCalculator.calculateIndividualFullBodyPartsData(p, p2, p3, flag: boolean)
	local function findMeshHandle(p4: string)
		return p[p4]
	end

	local allTransformsForFullBody = AssetCalculator.calculateAllTransformsForFullBody(p)

	if flag then
		orientFullBodyArmsLegsToWorldAxes(allTransformsForFullBody, findMeshHandle)
	end

	local v, v2, v3 = calculateAllPartsBoundsData(allTransformsForFullBody, findMeshHandle, p2, p3)

	if not v then
		return v, v2
	end

	local result = {}

	for k, boundsData in v3 do
		result[k] = { boundsData = boundsData, cframe = allTransformsForFullBody[k] }
	end

	return true, nil, result
end

function BoundsCalculator.calculateFullBodyBounds(p, p2)
	local function findMeshHandle(p3: string)
		return p[p3]
	end

	local allTransformsForFullBody = AssetCalculator.calculateAllTransformsForFullBody(p)
	orientFullBodyArmsLegsToWorldAxes(allTransformsForFullBody, findMeshHandle)

	local v, v2, v3 = calculateTotalBoundsForAsset(allTransformsForFullBody, findMeshHandle, p2)

	if v then
		return true, nil, v3
	end

	return v, v2
end

function BoundsCalculator.calculateAssetBoundsFromData(p, assetTypeEnum, p2)
	local validationContextFromRenderMeshes = buildValidationContextFromRenderMeshes(p, assetTypeEnum, p2)
	return BoundsCalculator.calculateAssetBounds(p, validationContextFromRenderMeshes)
end

function BoundsCalculator.calculateFullBodyBoundsFromData(items, p)
	local v = next(items)

	if not v then
		return false, { "No body parts provided" }
	end

	local validationContextFromRenderMeshes = buildValidationContextFromRenderMeshes(items[v].Parent, nil, p)
	return BoundsCalculator.calculateFullBodyBounds(items, validationContextFromRenderMeshes)
end

function BoundsCalculator.calculateIndividualAssetPartsDataFromData(p, assetTypeEnum, p2)
	local validationContextFromRenderMeshes = buildValidationContextFromRenderMeshes(p, assetTypeEnum, p2)
	return BoundsCalculator.calculateIndividualAssetPartsData(p, validationContextFromRenderMeshes)
end

return BoundsCalculator
