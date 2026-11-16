local parent = script.Parent.Parent
require(parent.util.Types)
local calculateMinMax = require(parent.util.calculateMinMax)
local getExpectedPartSize = require(parent.util.getExpectedPartSize)
local ConstantsInterface = require(parent.ConstantsInterface)
local getPartNamesInHierarchyOrder = require(parent.util.getPartNamesInHierarchyOrder)
local R15plusUtils = require(parent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)
local AssetTraversalUtils = {}

function AssetTraversalUtils.calculateBounds(p, instance, cframe: CFrame, state, p2)
	if p2 then
		local expectedPartSize = getExpectedPartSize(instance, p2)
		local minMeshCorner, maxMeshCorner = calculateMinMax(
			state.minMeshCorner,
			state.maxMeshCorner,
			cframe:PointToWorldSpace(-(expectedPartSize / 2)),
			cframe:PointToWorldSpace(-(expectedPartSize / 2))
		)
		state.minMeshCorner = minMeshCorner
		state.maxMeshCorner = maxMeshCorner

		local minMeshCorner2, maxMeshCorner2 = calculateMinMax(
			state.minMeshCorner,
			state.maxMeshCorner,
			cframe:PointToWorldSpace(expectedPartSize / 2),
			cframe:PointToWorldSpace(expectedPartSize / 2)
		)
		state.minMeshCorner = minMeshCorner2
		state.maxMeshCorner = maxMeshCorner2
	else
		local minMeshCorner, maxMeshCorner = calculateMinMax(
			state.minMeshCorner,
			state.maxMeshCorner,
			cframe:PointToWorldSpace(-(instance.Size / 2)),
			cframe:PointToWorldSpace(-(instance.Size / 2))
		)
		state.minMeshCorner = minMeshCorner
		state.maxMeshCorner = maxMeshCorner

		local minMeshCorner2, maxMeshCorner2 = calculateMinMax(
			state.minMeshCorner,
			state.maxMeshCorner,
			cframe:PointToWorldSpace(instance.Size / 2),
			cframe:PointToWorldSpace(instance.Size / 2)
		)
		state.minMeshCorner = minMeshCorner2
		state.maxMeshCorner = maxMeshCorner2
	end

	for _, childName in ConstantsInterface.getAttachments(p, instance.Name) do
		local child = instance:FindFirstChild(childName, R15plusUtils.checkFlagEnabledForAllowHrd())
		assert(child)

		if string.match(child.Name, "RigAttachment$") == nil then
			continue
		end

		local v = cframe * getAttachmentCFrameInPartSpace(child)
		local minRigAttachment, maxRigAttachment = calculateMinMax(
			state.minRigAttachment,
			state.maxRigAttachment,
			v.Position,
			v.Position
		)
		state.minRigAttachment = minRigAttachment
		state.maxRigAttachment = maxRigAttachment
	end

	local minOverall, maxOverall = calculateMinMax(
		state.minOverall,
		state.maxOverall,
		state.minMeshCorner,
		state.maxMeshCorner
	)
	state.minOverall = minOverall
	state.maxOverall = maxOverall

	local minOverall2, maxOverall2 = calculateMinMax(
		state.minOverall,
		state.maxOverall,
		state.minRigAttachment,
		state.maxRigAttachment
	)
	state.minOverall = minOverall2
	state.maxOverall = maxOverall2
end

function AssetTraversalUtils.traverseHierarchy(p, instance, p2, childName: string?, cframe: CFrame, childName2: string, p3, p4, p5)
	assert((p ~= nil) ~= ((instance and p2) ~= nil))
	local v

	if p then
		v = p[childName2]
	else
		v = instance:FindFirstChild(childName2)
	end

	assert(v)
	local v2

	if childName then
		local v3

		if p then
			v3 = p[childName]
		else
			v3 = instance:FindFirstChild(childName)
		end

		assert(v3)

		local rigAttachmentToParent = ConstantsInterface.getRigAttachmentToParent(p2, childName2)

		local child = v3:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())
		assert(child)

		local child2 = v:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())
		assert(child2)

		v2 = cframe * getAttachmentCFrameInPartSpace(child) * getAttachmentCFrameInPartSpace(child2):Inverse()
	else
		v2 = CFrame.new()
	end

	AssetTraversalUtils.calculateBounds(p2, v, v2, p4, p5)

	if p3.children then
		for k, child in p3.children do
			AssetTraversalUtils.traverseHierarchy(p, instance, p2, childName2, v2, k, child, p4, p5)
		end
	end
end

local v = nil
local function initRigParentToChild()
	if v then
		return
	end

	v = {}

	for _, v2 in {
		Enum.AssetType.LeftArm,
		Enum.AssetType.RightArm,
		Enum.AssetType.LeftLeg,
		Enum.AssetType.RightLeg
	} do
		local partNamesInHierarchyOrder = getPartNamesInHierarchyOrder(v2)
		v[v2] = {}

		for i = 1, #partNamesInHierarchyOrder - 1 do
			v[v2][partNamesInHierarchyOrder[i]] = partNamesInHierarchyOrder[i + 1]
		end
	end
end

function AssetTraversalUtils.getAssetRigChild(p, p2: string)
	initRigParentToChild()

	return assert(v[p], "Invalid asset type")[p2]
end

AssetTraversalUtils.assetHierarchy = {
	[Enum.AssetType.DynamicHead] = { root = "Head" },
	[Enum.AssetType.Torso] = {
		root = "LowerTorso",
		children = { UpperTorso = {} }
	},
	[Enum.AssetType.LeftArm] = {
		root = "LeftUpperArm",
		children = {
			LeftLowerArm = {
				children = { LeftHand = {} }
			}
		}
	},
	[Enum.AssetType.RightArm] = {
		root = "RightUpperArm",
		children = {
			RightLowerArm = {
				children = { RightHand = {} }
			}
		}
	},
	[Enum.AssetType.LeftLeg] = {
		root = "LeftUpperLeg",
		children = {
			LeftLowerLeg = {
				children = { LeftFoot = {} }
			}
		}
	},
	[Enum.AssetType.RightLeg] = {
		root = "RightUpperLeg",
		children = {
			RightLowerLeg = {
				children = { RightFoot = {} }
			}
		}
	}
}

return AssetTraversalUtils
