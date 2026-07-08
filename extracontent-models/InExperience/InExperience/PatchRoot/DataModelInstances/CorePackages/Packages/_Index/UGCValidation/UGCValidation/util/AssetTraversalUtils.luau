local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local calculateMinMax = require(ParentParent.util.calculateMinMax)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local getPartNamesInHierarchyOrder = require(ParentParent.util.getPartNamesInHierarchyOrder)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local t1 = {
	calculateBounds = function(p1, p2, cFrame: CFrame, p3, p4) -- line: 25
		-- upvalues: getExpectedPartSize (copy), calculateMinMax (copy), ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
		if p4 then
			local v16 = getExpectedPartSize(p2, p4)
			local v17, v18 = calculateMinMax(p3.minMeshCorner, p3.maxMeshCorner, cFrame:PointToWorldSpace(-(v16 / 2)), cFrame:PointToWorldSpace(-(v16 / 2)))

			p3.minMeshCorner = v17
			p3.maxMeshCorner = v18

			local v19, v20 = calculateMinMax(p3.minMeshCorner, p3.maxMeshCorner, cFrame:PointToWorldSpace(v16 / 2), cFrame:PointToWorldSpace(v16 / 2))

			p3.minMeshCorner = v19
			p3.maxMeshCorner = v20
		else
			local v21, v22 = calculateMinMax(p3.minMeshCorner, p3.maxMeshCorner, cFrame:PointToWorldSpace(-(p2.Size / 2)), cFrame:PointToWorldSpace(-(p2.Size / 2)))

			p3.minMeshCorner = v21
			p3.maxMeshCorner = v22

			local v23, v24 = calculateMinMax(p3.minMeshCorner, p3.maxMeshCorner, cFrame:PointToWorldSpace(p2.Size / 2), cFrame:PointToWorldSpace(p2.Size / 2))

			p3.minMeshCorner = v23
			p3.maxMeshCorner = v24
		end

		for _, v26 in ConstantsInterface.getAttachments(p1, p2.Name) do
			local v27 = p2:FindFirstChild(v26, R15plusUtils.checkFlagEnabledForAllowHrd())

			assert(v27)

			if string.match(v27.Name, "RigAttachment$") ~= nil then
				local v28 = cFrame * getAttachmentCFrameInPartSpace(v27)
				local v29, v30 = calculateMinMax(p3.minRigAttachment, p3.maxRigAttachment, v28.Position, v28.Position)

				p3.minRigAttachment = v29
				p3.maxRigAttachment = v30
			end
		end

		local v31, v32 = calculateMinMax(p3.minOverall, p3.maxOverall, p3.minMeshCorner, p3.maxMeshCorner)

		p3.minOverall = v31
		p3.maxOverall = v32

		local v33, v34 = calculateMinMax(p3.minOverall, p3.maxOverall, p3.minRigAttachment, p3.maxRigAttachment)

		p3.minOverall = v33
		p3.maxOverall = v34
	end
}

function t1.traverseHierarchy(p5, p6, p7, s1: string?, cFrame: CFrame, s2: string, p8, p9, p10) -- line: 98
	-- upvalues: ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy), t1 (copy)
	local v44 = p6 and p7

	assert(p5 ~= nil ~= (v44 ~= nil))

	local v45 = if not p5 then p6:FindFirstChild(s2) else p5[s2]

	assert(v45)

	local v50

	if s1 then
		local v46 = if not p5 then p6:FindFirstChild(s1) else p5[s1]

		assert(v46)

		local v47 = ConstantsInterface.getRigAttachmentToParent(p7, s2)
		local v48 = v46:FindFirstChild(v47, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(v48)

		local v49 = v45:FindFirstChild(v47, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(v49)
		v50 = cFrame * getAttachmentCFrameInPartSpace(v48) * getAttachmentCFrameInPartSpace(v49):Inverse()
	else
		v50 = CFrame.new()
	end

	t1.calculateBounds(p7, v45, v50, p9, p10)

	if p8.children then
		for v51, v52 in p8.children do
			t1.traverseHierarchy(p5, p6, p7, s2, v50, v51, v52, p9, p10)
		end
	end
end

local t2 = nil

local function initRigParentToChild() -- line: 163
	-- upvalues: t2 (ref), getPartNamesInHierarchyOrder (copy)
	if t2 then
		return
	end

	t2 = {}

	for _, v54 in {
		Enum.AssetType.LeftArm,
		Enum.AssetType.RightArm,
		Enum.AssetType.LeftLeg,
		Enum.AssetType.RightLeg
	} do
		local v55 = getPartNamesInHierarchyOrder(v54)

		t2[v54] = {}

		for i = 1, #v55 - 1 do
			t2[v54][v55[i]] = v55[i + 1]
		end
	end
end

function t1.getAssetRigChild(p11, s3: string) -- line: 179
	-- upvalues: initRigParentToChild (copy), t2 (ref)
	initRigParentToChild()

	return assert(t2[p11], "Invalid asset type")[s3]
end

t1.assetHierarchy = {
	[Enum.AssetType.DynamicHead] = {
		root = "Head"
	},
	[Enum.AssetType.Torso] = {
		root = "LowerTorso",
		children = {
			UpperTorso = {}
		}
	},
	[Enum.AssetType.LeftArm] = {
		root = "LeftUpperArm",
		children = {
			LeftLowerArm = {
				children = {
					LeftHand = {}
				}
			}
		}
	},
	[Enum.AssetType.RightArm] = {
		root = "RightUpperArm",
		children = {
			RightLowerArm = {
				children = {
					RightHand = {}
				}
			}
		}
	},
	[Enum.AssetType.LeftLeg] = {
		root = "LeftUpperLeg",
		children = {
			LeftLowerLeg = {
				children = {
					LeftFoot = {}
				}
			}
		}
	},
	[Enum.AssetType.RightLeg] = {
		root = "RightUpperLeg",
		children = {
			RightLowerLeg = {
				children = {
					RightFoot = {}
				}
			}
		}
	}
}

return t1
