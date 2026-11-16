local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)

local getFFlagUGCValidateRestrictNumFaceControls = require(parent.flags.getFFlagUGCValidateRestrictNumFaceControls)
local getFIntUGCValidateMaxTotalFaceControls = require(parent.flags.getFIntUGCValidateMaxTotalFaceControls)

local CurveAnimBoneHierarchyValid = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }
}

local function buildAcceptableForFolder(instance, p: string)
	if CurveAnimBoneHierarchyUtils.isBoneFolderName(instance.Name) then
		local childBoneNames = CurveAnimBoneHierarchyUtils.getChildBoneNames(instance.Name)
		local result = {}

		for _, childBoneName in childBoneNames do
			table.insert(result, { ClassName = "Folder", Name = childBoneName })
		end

		local v = false

		if #childBoneNames == 1 then
			local childBoneName = childBoneNames[1]

			for _, folder in instance:GetChildren() do
				if folder:IsA("Folder") and folder.Name == childBoneName then
					v = true
					break
				end
			end
		end

		if not v then
			for _, v2 in CurveAnimationHierarchyUtils.calculateAcceptableChildBodyPartFolders(p) do
				table.insert(result, v2)
			end
		end

		table.insert(result, { ClassName = "Vector3Curve", Name = "Position" })
		table.insert(result, { ClassName = "EulerRotationCurve", Name = "Rotation" })
		return result
	else
		local result = CurveAnimationHierarchyUtils.calculateAcceptableChildBodyPartFolders(instance.Name)

		for _, name in CurveAnimBoneHierarchyUtils.getRootBoneNamesForBodyPart(instance.Name) do
			table.insert(result, { ClassName = "Folder", Name = name })
		end

		if instance.Name == CurveAnimationHierarchyUtils.humanoidRootPartName then
			return result
		end

		table.insert(result, { ClassName = "Vector3Curve", Name = "Position" })
		table.insert(result, { ClassName = "EulerRotationCurve", Name = "Rotation" })

		if instance.Name == "Head" then
			table.insert(result, {
				ClassName = "Folder",
				Name = CurveAnimationHierarchyUtils.FaceControlsName
			})
		end

		return result
	end
end

local function getFirstUnacceptableChildDetail(instance, list)
	if not instance then
		return nil
	end

	for _, child in instance:GetChildren() do
		local v = false

		for k, item in list do
			if item.ClassName == child.ClassName and item.Name == child.Name then
				table.remove(list, k)
				v = true
				break
			end
		end

		if not v then
			return `unexpected {child.ClassName} '{child.Name}'`
		end
	end

	return nil
end

local function validateFolderStructure(instance, p: string, p2: string)
	local firstUnacceptableChildDetail = getFirstUnacceptableChildDetail(
		instance,
		buildAcceptableForFolder(instance, p2)
	)

	if firstUnacceptableChildDetail then
		return `{firstUnacceptableChildDetail} under '{p}'`
	end

	local acceptableCurveChildrenArray = CurveAnimationHierarchyUtils.calculateAcceptableCurveChildrenArray()
	local position = instance:FindFirstChild("Position")

	if not CurveAnimationHierarchyUtils.areChildrenAcceptable(position, acceptableCurveChildrenArray) then
		return `unexpected child under '{p}/Position'`
	end

	local acceptableCurveChildrenArray2 = CurveAnimationHierarchyUtils.calculateAcceptableCurveChildrenArray()
	local rotation = instance:FindFirstChild("Rotation")

	if not CurveAnimationHierarchyUtils.areChildrenAcceptable(rotation, acceptableCurveChildrenArray2) then
		return `unexpected child under '{p}/Rotation'`
	end

	local child = instance:FindFirstChild(CurveAnimationHierarchyUtils.FaceControlsName)

	if child then
		local children = child:GetChildren()

		if getFFlagUGCValidateRestrictNumFaceControls() and #children > getFIntUGCValidateMaxTotalFaceControls() then
			return `FaceControls under '{p}' exceeds max count ({#children})`
		end

		for _, floatCurve in children do
			if not floatCurve:IsA("FloatCurve") then
				return `unexpected {floatCurve.ClassName} '{floatCurve.Name}' under '{p}/FaceControls'`
			end
		end
	end

	if CurveAnimationHierarchyUtils.containsGrandChildren(position) then
		return `'{p}/Position' contains unexpected grandchildren`
	end

	if CurveAnimationHierarchyUtils.containsGrandChildren(rotation) then
		return `'{p}/Rotation' contains unexpected grandchildren`
	end

	if CurveAnimationHierarchyUtils.containsGrandChildren(child) then
		return `'{p}/FaceControls' contains unexpected grandchildren`
	end

	return nil
end

local function validateHierarchyTree(instance, name: string, name2: string, object)
	local detail = validateFolderStructure(instance, name, name2)

	if detail then
		object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidBodyPartHierarchyDetail, {
			folderName = instance.Name,
			detail = detail
		})

		return
	end

	for _, folder in instance:GetChildren() do
		if not (folder:IsA("Folder") and folder.Name ~= CurveAnimationHierarchyUtils.FaceControlsName) then
			continue
		end

		local v

		if CurveAnimBoneHierarchyUtils.isBoneFolderName(folder.Name) then
			v = name2
		else
			v = folder.Name
		end

		validateHierarchyTree(folder, `{name}/{folder.Name}`, v, object)
	end
end

function CurveAnimBoneHierarchyValid.run(p, p2)
	for _, curveAnimation in p2.curveAnimations do
		local bodyPartFolderRoots = {}
		local bodyPartFolderRoot = CurveAnimationHierarchyUtils.getBodyPartFolderRoot(curveAnimation)

		if bodyPartFolderRoot then
			table.insert(bodyPartFolderRoots, bodyPartFolderRoot)
		end

		for _, v in bodyPartFolderRoots do
			if CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(v.Name) then
				validateHierarchyTree(v, v.Name, v.Name, p)
			end
		end
	end
end

return CurveAnimBoneHierarchyValid
