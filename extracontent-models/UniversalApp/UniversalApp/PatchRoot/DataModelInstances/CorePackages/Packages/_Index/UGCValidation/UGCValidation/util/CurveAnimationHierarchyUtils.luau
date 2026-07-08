local ParentParent = script.Parent.Parent
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local flags = ParentParent.flags
local getFFlagUGCValidateDuplicatesInAnimation = require(flags.getFFlagUGCValidateDuplicatesInAnimation)
local getFFlagUGCValidateRestrictNumFaceControls = require(flags.getFFlagUGCValidateRestrictNumFaceControls)
local getFIntUGCValidateMaxTotalFaceControls = require(flags.getFIntUGCValidateMaxTotalFaceControls)
local t1 = {}
local u8 = nil

function t1.getBodyPartToParentMap() -- line: 14
	-- upvalues: u8 (ref), AssetCalculator (copy)
	if not u8 then
		u8 = AssetCalculator.getBodyPartsToParents()
	end

	return u8
end

t1.humanoidRootPartName = "HumanoidRootPart"
t1.FaceControlsName = "FaceControls"

function t1.folderHasAnimationTracks(p1) -- line: 24
	local Position = p1:FindFirstChild("Position")
	local Rotation = p1:FindFirstChild("Rotation")

	return Position ~= nil and Position:IsA("Vector3Curve") or Rotation ~= nil and (Rotation:IsA("EulerRotationCurve") or Rotation:IsA("RotationCurve"))
end
function t1.isBodyPartFolderNameValid(s1: string) -- line: 31
	-- upvalues: t1 (copy)
	return t1.getBodyPartToParentMap()[s1] ~= nil or s1 == t1.humanoidRootPartName
end
function t1.getBodyPartFolderRoot(p2) -- line: 36
	-- upvalues: t1 (copy)
	for _, child in p2:GetChildren() do
		if child:IsA("Folder") and t1.isBodyPartFolderNameValid(child.Name) then
			return child
		end
	end

	return nil
end
function t1.areChildrenAcceptable(p3, t2: {[any]: any}) -- line: 45
	if not p3 then
		return true
	end

	local function findAndRemoveMatching(p4) -- line: 50
		-- upvalues: t2 (copy)
		for v40, v41 in t2 do
			if v41.ClassName == p4.ClassName and v41.Name == p4.Name then
				table.remove(t2, v40)

				return true
			end
		end

		return false
	end

	for _, child in p3:GetChildren() do
		if not findAndRemoveMatching(child) then
			return false
		end
	end

	return true
end
function t1.calculateAcceptableChildBodyPartFolders(s2: string) -- line: 70
	-- upvalues: t1 (copy)
	local t3 = {}

	for v23, v24 in t1.getBodyPartToParentMap() do
		if v24 == s2 then
			table.insert(t3, {
				ClassName = "Folder",
				Name = v23
			})
		end
	end

	return t3
end
function t1.calculateAcceptableBodyPartFolderChildrenArray(p5, b1: boolean) -- line: 83
	-- upvalues: t1 (copy)
	local v27 = t1.calculateAcceptableChildBodyPartFolders(p5.Name)

	if p5.Name == t1.humanoidRootPartName then
		return v27
	end

	table.insert(v27, {
		ClassName = "Vector3Curve",
		Name = "Position"
	})
	table.insert(v27, {
		Name = "Rotation",
		ClassName = not b1 and "RotationCurve" or "EulerRotationCurve"
	})

	if p5.Name ~= "Head" then
		return v27
	end

	table.insert(v27, {
		ClassName = "Folder",
		Name = t1.FaceControlsName
	})

	return v27
end
function t1.calculateAcceptableCurveChildrenArray() -- line: 114
	return {
		{
			ClassName = "FloatCurve",
			Name = "X"
		},
		{
			ClassName = "FloatCurve",
			Name = "Y"
		},
		{
			ClassName = "FloatCurve",
			Name = "Z"
		}
	}
end
function t1.containsGrandChildren(p6) -- line: 131
	if not p6 then
		return false
	end

	return #p6:GetDescendants() > #p6:GetChildren()
end
function t1.validateBodyPartFolderChildren(p7) -- line: 138
	-- upvalues: t1 (copy), getFFlagUGCValidateRestrictNumFaceControls (copy), getFIntUGCValidateMaxTotalFaceControls (copy)
	local v30 = t1.calculateAcceptableBodyPartFolderChildrenArray(p7, true)

	if t1.areChildrenAcceptable(p7, v30) then
		local v31 = t1.calculateAcceptableCurveChildrenArray()

		if not t1.areChildrenAcceptable(p7:FindFirstChild("Position"), v31) then
			return false
		end

		local v32 = t1.calculateAcceptableCurveChildrenArray()

		if not t1.areChildrenAcceptable(p7:FindFirstChild("Rotation"), v32) then
			return false
		end

		local t1FaceControlsName = p7:FindFirstChild(t1.FaceControlsName)

		if t1FaceControlsName then
			local children = t1FaceControlsName:GetChildren()

			if getFFlagUGCValidateRestrictNumFaceControls() and #children > getFIntUGCValidateMaxTotalFaceControls() then
				return false
			end

			for _, v36 in children do
				if not v36:IsA("FloatCurve") then
					return false
				end
			end
		end

		if t1.containsGrandChildren(p7:FindFirstChild("Position")) then
			return false
		end

		if t1.containsGrandChildren(p7:FindFirstChild("Rotation")) then
			return false
		end

		if t1.containsGrandChildren(t1FaceControlsName) then
			return false
		end

		return true
	end

	return false
end
function t1.validateCurveAnimationBodyPartFolder(p8) -- line: 198
	-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), t1 (copy)
	local function validateBodyPartFolderInternal(p9) -- line: 199
		-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), t1 (copy), validateBodyPartFolderInternal (copy)
		if getFFlagUGCValidateDuplicatesInAnimation() then
			if not t1.validateBodyPartFolderChildren(p9) then
				return false
			end

			for _, child in p9:GetChildren() do
				if child:IsA("Folder") and child.Name ~= t1.FaceControlsName and not validateBodyPartFolderInternal(child) then
					return false
				end
			end

			return true
		end

		for _, child in p9:GetChildren() do
			if not child:IsA("Folder") then
				continue
			end

			if child.Name == t1.humanoidRootPartName then
				return false
			end

			local v47 = t1.getBodyPartToParentMap()[child.Name]

			if v47 then
				if v47 ~= p9.Name then
					return false
				end

				return validateBodyPartFolderInternal(child)
			end
		end

		return true
	end

	if not t1.isBodyPartFolderNameValid(p8.Name) then
		return true
	end

	return validateBodyPartFolderInternal(p8)
end

return t1
