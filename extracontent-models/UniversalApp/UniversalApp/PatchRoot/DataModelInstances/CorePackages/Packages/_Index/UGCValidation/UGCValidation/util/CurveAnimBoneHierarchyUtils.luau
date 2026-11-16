local parent = script.Parent.Parent

local R15plusUtils = require(parent.util.R15plusUtils)

local CurveAnimBoneHierarchyUtils = {}

local v = { "Head", "UpperTorso", "LeftFoot", "RightFoot", "LeftHand", "RightHand" }

local v2 = nil
local v3 = nil
local v4 = nil

local function ensureCaches()
	if v4 then
		return
	end

	local set = {}
	local v5 = {}
	local v6 = {}
	local function traverse(items, p: string?, p2: string)
		for k, item in items do
			if item.ClassName ~= "Bone" then
				continue
			end

			set[k] = true

			if p == nil then
				if not v5[p2] then
					v5[p2] = {}
				end

				table.insert(v5[p2], k)
			else
				if not v6[p] then
					v6[p] = {}
				end

				table.insert(v6[p], k)
			end

			if item._children then
				traverse(item._children, k, p2)
			end
		end
	end

	for _, v7 in v do
		traverse(R15plusUtils.getAvatarBoneSchema(v7), nil, v7)
	end

	v2 = v5
	v3 = v6
	v4 = set
end

function CurveAnimBoneHierarchyUtils.hasBoneFolders(folder): boolean
	for _, folder2 in folder:GetDescendants() do
		if folder2:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(folder2.Name) then
			return true
		end
	end

	return false
end

function CurveAnimBoneHierarchyUtils.isBoneFolderName(p: string): boolean
	ensureCaches()
	return v4[p] == true
end

function CurveAnimBoneHierarchyUtils.getRootBoneNamesForBodyPart(p: string)
	ensureCaches()
	return v2[p] or {}
end

function CurveAnimBoneHierarchyUtils.getChildBoneNames(p: string)
	ensureCaches()
	return v3[p] or {}
end

return CurveAnimBoneHierarchyUtils
