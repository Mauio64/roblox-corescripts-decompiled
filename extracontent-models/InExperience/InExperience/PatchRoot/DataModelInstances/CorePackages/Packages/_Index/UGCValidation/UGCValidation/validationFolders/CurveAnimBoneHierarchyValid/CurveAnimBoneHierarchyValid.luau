local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(ParentParent.util.CurveAnimationHierarchyUtils)
local CurveAnimBoneHierarchyUtils = require(ParentParent.util.CurveAnimBoneHierarchyUtils)
local getFFlagUGCValidateEmotesBonesAllowed = require(ParentParent.flags.getFFlagUGCValidateEmotesBonesAllowed)
local getFFlagUGCValidateDuplicatesInAnimation = require(ParentParent.flags.getFFlagUGCValidateDuplicatesInAnimation)
local getFFlagUGCValidateRestrictNumFaceControls = require(ParentParent.flags.getFFlagUGCValidateRestrictNumFaceControls)
local getFIntUGCValidateMaxTotalFaceControls = require(ParentParent.flags.getFIntUGCValidateMaxTotalFaceControls)
local getFFlagUGCValidateAnimBonesSupport = require(ParentParent.flags.getFFlagUGCValidateAnimBonesSupport)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidateAnimBonesSupport() and getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }
t1.conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData }

function t1.fflag() -- line: 26
	-- upvalues: getFFlagUGCValidateEmotesBonesAllowed (copy), getFFlagUGCValidateAnimBonesSupport (copy)
	return getFFlagUGCValidateEmotesBonesAllowed() or getFFlagUGCValidateAnimBonesSupport()
end

t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function buildAcceptableForFolder(p1, s1: string) -- line: 35
	-- upvalues: CurveAnimBoneHierarchyUtils (copy), CurveAnimationHierarchyUtils (copy)
	if CurveAnimBoneHierarchyUtils.isBoneFolderName(p1.Name) then
		local t2 = {}
		local v20 = CurveAnimBoneHierarchyUtils.getChildBoneNames(p1.Name)

		for _, v22 in v20 do
			table.insert(t2, {
				ClassName = "Folder",
				Name = v22
			})
		end

		local v23 = false

		if #v20 == 1 then
			local v24 = v20[1]

			for _, child in p1:GetChildren() do
				if child:IsA("Folder") and v24 == child.Name then
					v23 = true

					break
				end
			end
		end

		if not v23 then
			for _, v28 in CurveAnimationHierarchyUtils.calculateAcceptableChildBodyPartFolders(s1) do
				table.insert(t2, v28)
			end
		end

		table.insert(t2, {
			ClassName = "Vector3Curve",
			Name = "Position"
		})
		table.insert(t2, {
			ClassName = "EulerRotationCurve",
			Name = "Rotation"
		})

		return t2
	end

	local v29 = CurveAnimationHierarchyUtils.calculateAcceptableChildBodyPartFolders(p1.Name)

	for _, v31 in CurveAnimBoneHierarchyUtils.getRootBoneNamesForBodyPart(p1.Name) do
		table.insert(v29, {
			ClassName = "Folder",
			Name = v31
		})
	end

	if p1.Name == CurveAnimationHierarchyUtils.humanoidRootPartName then
		return v29
	end

	table.insert(v29, {
		ClassName = "Vector3Curve",
		Name = "Position"
	})
	table.insert(v29, {
		ClassName = "EulerRotationCurve",
		Name = "Rotation"
	})

	if p1.Name == "Head" then
		table.insert(v29, {
			ClassName = "Folder",
			Name = CurveAnimationHierarchyUtils.FaceControlsName
		})
	end

	return v29
end
local function getFirstUnacceptableChildDetail(p2, t3: {[any]: any}) -- line: 94
	if not p2 then
		return nil
	end

	for _, child in p2:GetChildren() do
		local v36 = false

		for v37, v38 in t3 do
			if v38.ClassName == child.ClassName and v38.Name == child.Name then
				table.remove(t3, v37)
				v36 = true

				break
			end
		end

		if not v36 then
			return `unexpected { child.ClassName } '{ child.Name }'`
		end
	end

	return nil
end
local function validateFolderStructure(p3, s2: string, s3: string) -- line: 116
	-- upvalues: buildAcceptableForFolder (copy), getFirstUnacceptableChildDetail (copy), CurveAnimationHierarchyUtils (copy), getFFlagUGCValidateRestrictNumFaceControls (copy), getFIntUGCValidateMaxTotalFaceControls (copy)
	local v42 = buildAcceptableForFolder(p3, s3)
	local v43 = getFirstUnacceptableChildDetail(p3, v42)

	if v43 then
		return `{ v43 } under '{ s2 }'`
	end

	local v44 = CurveAnimationHierarchyUtils.calculateAcceptableCurveChildrenArray()
	local Position = p3:FindFirstChild("Position")

	if not CurveAnimationHierarchyUtils.areChildrenAcceptable(Position, v44) then
		return `unexpected child under '{ s2 }/Position'`
	end

	local v46 = CurveAnimationHierarchyUtils.calculateAcceptableCurveChildrenArray()
	local Rotation = p3:FindFirstChild("Rotation")

	if not CurveAnimationHierarchyUtils.areChildrenAcceptable(Rotation, v46) then
		return `unexpected child under '{ s2 }/Rotation'`
	end

	local CurveAnimationHierarchyUtilsFaceControlsName = p3:FindFirstChild(CurveAnimationHierarchyUtils.FaceControlsName)

	if CurveAnimationHierarchyUtilsFaceControlsName then
		local children = CurveAnimationHierarchyUtilsFaceControlsName:GetChildren()

		if getFFlagUGCValidateRestrictNumFaceControls() and #children > getFIntUGCValidateMaxTotalFaceControls() then
			return `FaceControls under '{ s2 }' exceeds max count ({ #children })`
		end

		for _, v51 in children do
			if not v51:IsA("FloatCurve") then
				return `unexpected { v51.ClassName } '{ v51.Name }' under '{ s2 }/FaceControls'`
			end
		end
	end

	if CurveAnimationHierarchyUtils.containsGrandChildren(Position) then
		return `'{ s2 }/Position' contains unexpected grandchildren`
	end

	if CurveAnimationHierarchyUtils.containsGrandChildren(Rotation) then
		return `'{ s2 }/Rotation' contains unexpected grandchildren`
	end

	if CurveAnimationHierarchyUtils.containsGrandChildren(CurveAnimationHierarchyUtilsFaceControlsName) then
		return `'{ s2 }/FaceControls' contains unexpected grandchildren`
	end

	return nil
end
local function validateHierarchyTree(p4, s4: string, s5: string, p5) -- line: 167
	-- upvalues: validateFolderStructure (copy), ErrorSourceStrings (copy), CurveAnimationHierarchyUtils (copy), CurveAnimBoneHierarchyUtils (copy), validateHierarchyTree (copy)
	local v56 = validateFolderStructure(p4, s4, s5)

	if v56 then
		p5:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidBodyPartHierarchyDetail, {
			folderName = p4.Name,
			detail = v56
		})

		return
	end

	for _, child in p4:GetChildren() do
		if child:IsA("Folder") and child.Name ~= CurveAnimationHierarchyUtils.FaceControlsName then
			local v59 = if not CurveAnimBoneHierarchyUtils.isBoneFolderName(child.Name) then child.Name else s5

			validateHierarchyTree(child, `{ s4 }/{ child.Name }`, v59, p5)
		end
	end
end

function t1.run(p6, p7) -- line: 192
	-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), CurveAnimationHierarchyUtils (copy), validateHierarchyTree (copy)
	for _, v63 in p7.curveAnimations do
		local t4 = {}

		if getFFlagUGCValidateDuplicatesInAnimation() then
			local v65 = CurveAnimationHierarchyUtils.getBodyPartFolderRoot(v63)

			if v65 then
				table.insert(t4, v65)
			end
		else
			for _, child in v63:GetChildren() do
				if child:IsA("Folder") and CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(child.Name) then
					table.insert(t4, child)
				end
			end
		end

		for _, v69 in t4 do
			if CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(v69.Name) then
				validateHierarchyTree(v69, v69.Name, v69.Name, p6)
			end
		end
	end
end

return t1
