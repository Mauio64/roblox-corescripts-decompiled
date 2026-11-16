local parent = script.Parent.Parent

local AssetCalculator = require(parent.util.AssetCalculator)

local CurveAnimationHierarchyUtils = {}

local bodyPartToParentMap = nil

function CurveAnimationHierarchyUtils.getBodyPartToParentMap()
	if not bodyPartToParentMap then
		bodyPartToParentMap = AssetCalculator.getBodyPartsToParents()
	end

	return bodyPartToParentMap
end

CurveAnimationHierarchyUtils.humanoidRootPartName = "HumanoidRootPart"
CurveAnimationHierarchyUtils.FaceControlsName = "FaceControls"

function CurveAnimationHierarchyUtils.folderHasAnimationTracks(instance)
	local position = instance:FindFirstChild("Position")
	local rotation = instance:FindFirstChild("Rotation")
	local v = position ~= nil and position:IsA("Vector3Curve")

	if not v then
		if rotation == nil then
			return false
		end

		return rotation:IsA("EulerRotationCurve") or rotation:IsA("RotationCurve")
	end

	return v
end

function CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(p: string): boolean
	return CurveAnimationHierarchyUtils.getBodyPartToParentMap()[p] ~= nil
		or p == CurveAnimationHierarchyUtils.humanoidRootPartName
end

function CurveAnimationHierarchyUtils.getBodyPartFolderRoot(instance)
	for _, folder in instance:GetChildren() do
		if folder:IsA("Folder") and CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(folder.Name) then
			return folder
		end
	end

	return nil
end

function CurveAnimationHierarchyUtils.areChildrenAcceptable(instance, list): boolean
	if not instance then
		return true
	end

	local function findAndRemoveMatching(child): boolean
		for k, item in list do
			if item.ClassName == child.ClassName and item.Name == child.Name then
				table.remove(list, k)
				return true
			end
		end

		return false
	end

	for _, child in instance:GetChildren() do
		if not findAndRemoveMatching(child) then
			return false
		end
	end

	return true
end

function CurveAnimationHierarchyUtils.calculateAcceptableChildBodyPartFolders(p: string)
	local acceptableChildBodyPartFolders = {}

	for k, v in CurveAnimationHierarchyUtils.getBodyPartToParentMap() do
		if v == p then
			table.insert(acceptableChildBodyPartFolders, { ClassName = "Folder", Name = k })
		end
	end

	return acceptableChildBodyPartFolders
end

function CurveAnimationHierarchyUtils.calculateAcceptableCurveChildrenArray()
	return {
		{ ClassName = "FloatCurve", Name = "X" },
		{ ClassName = "FloatCurve", Name = "Y" },
		{ ClassName = "FloatCurve", Name = "Z" }
	}
end

function CurveAnimationHierarchyUtils.containsGrandChildren(folder): boolean
	if folder then
		return #folder:GetDescendants() > #folder:GetChildren()
	end

	return false
end

return CurveAnimationHierarchyUtils
