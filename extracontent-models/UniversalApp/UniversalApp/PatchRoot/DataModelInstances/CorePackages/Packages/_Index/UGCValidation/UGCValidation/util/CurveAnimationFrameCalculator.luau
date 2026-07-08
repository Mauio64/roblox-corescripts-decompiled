local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local CurveAnimationHierarchyUtils = require(ParentParent.util.CurveAnimationHierarchyUtils)
local flags = ParentParent.flags
local getFFlagUGCValidateDuplicatesInAnimation = require(flags.getFFlagUGCValidateDuplicatesInAnimation)
local getFIntUGCValidateMaxAnimationFPS = require(flags.getFIntUGCValidateMaxAnimationFPS)
local getFFlagUGCValidateCurveAnimFinalFrameBug = require(flags.getFFlagUGCValidateCurveAnimFinalFrameBug)
local t1 = {}
local FaceControlsName = CurveAnimationHierarchyUtils.FaceControlsName

local function createDefaultCharacter(b1: boolean) -- line: 23
	-- upvalues: Players (copy)
	local v17 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then game.Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15) else Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)

	for _, descendant in v17:GetDescendants() do
		if descendant:IsA("Decal") then
			descendant.Transparency = 1
		elseif descendant:IsA("MeshPart") then
			descendant.Transparency = 1
			descendant.CanCollide = false
		elseif descendant:IsA("Motor6D") and b1 then
			descendant:Destroy()
		end
	end

	return v17
end
local function hasFloatCurveKeys(p1) -- line: 53
	local X = p1:FindFirstChild("X")
	local Y = p1:FindFirstChild("Y")
	local Z = p1:FindFirstChild("Z")
	local v24 = not not X and (X:IsA("FloatCurve") and #X:GetKeys() > 0)

	if not v24 then
		v24 = not not Y and (Y:IsA("FloatCurve") and #Y:GetKeys() > 0)

		if not v24 then
			if Z then
				v24 = Z:IsA("FloatCurve")

				if v24 then
					return #Z:GetKeys() > 0
				end
			else
				v24 = false
			end
		end
	end

	return v24
end
local function hasPositionKeys(p2) -- line: 63
	-- upvalues: hasFloatCurveKeys (copy)
	if not p2 then
		return false
	end

	if not p2:IsA("Vector3Curve") then
		return false
	end

	return (hasFloatCurveKeys(p2))
end
local function hasRotationKeys(p3) -- line: 74
	-- upvalues: hasFloatCurveKeys (copy)
	if not p3 then
		return false
	end

	if not p3:IsA("EulerRotationCurve") then
		return false
	end

	return (hasFloatCurveKeys(p3))
end

function t1.calculateAnimFramesAtOrigin(p4) -- line: 85
	-- upvalues: getFIntUGCValidateMaxAnimationFPS (copy), getFFlagUGCValidateDuplicatesInAnimation (copy), CurveAnimationHierarchyUtils (copy), hasFloatCurveKeys (copy), Constants (copy), FaceControlsName (copy), createDefaultCharacter (copy), AssetCalculator (copy), getFFlagUGCValidateCurveAnimFinalFrameBug (copy)
	local v28 = 1 / getFIntUGCValidateMaxAnimationFPS()

	local function getCurveTracks() -- line: 92
		-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), CurveAnimationHierarchyUtils (copy), p4 (copy), hasFloatCurveKeys (copy), Constants (copy), FaceControlsName (copy)
		local t2 = {}
		local descendants

		if getFFlagUGCValidateDuplicatesInAnimation() then
			local v47 = CurveAnimationHierarchyUtils.getBodyPartFolderRoot(p4)

			assert(v47, "CurveAnimation must have one and only one body part Folder child or HumanoidRootPart child.")
			descendants = v47:GetDescendants()
			table.insert(descendants, v47)
		else
			descendants = p4:GetDescendants()
		end

		for _, v50 in descendants do
			if v50:IsA("Folder") and CurveAnimationHierarchyUtils.getBodyPartToParentMap()[v50.Name] then
				local Position = v50:FindFirstChild("Position")
				local Rotation = v50:FindFirstChild("Rotation")

				t2[v50.Name] = {
					pos = if not if Position then if Position:IsA("Vector3Curve") then hasFloatCurveKeys(Position) else false else false then nil else Position,
					rot = if not if Rotation then if Rotation:IsA("EulerRotationCurve") then hasFloatCurveKeys(Rotation) else false else false then nil else Rotation,
					faceControls = if v50.Name ~= Constants.NAMED_R15_BODY_PARTS.Head then nil else v50:FindFirstChild(FaceControlsName)
				}
			end
		end

		return t2
	end
	local function calculateCurveAnimLength(p5) -- line: 125
		local n1 = -1

		local function getMaxTimeFromFloatCurveChildren(p6) -- line: 128
			-- upvalues: n1 (ref)
			if not p6 then
				return
			end

			for _, child in p6:GetChildren() do
				if child:IsA("FloatCurve") then
					for _, v76 in child:GetKeys() do
						n1 = math.max(n1, v76.Time)
					end
				end
			end
		end

		for _, v57 in p5 do
			getMaxTimeFromFloatCurveChildren(v57.pos)
			getMaxTimeFromFloatCurveChildren(v57.rot)
			getMaxTimeFromFloatCurveChildren(v57.faceControls)
		end

		return n1
	end
	local function calculateTransformsAtTime(n2: number, p7) -- line: 151
		local t3 = {}

		for v61, v62 in p7 do
			local v63 = if not v62.pos then Vector3.new(0, 0, 0) else Vector3.new(unpack(v62.pos:GetValueAtTime(n2)))

			t3[v61] = ((if not v62.rot then CFrame.new() else v62.rot:GetRotationAtTime(n2))) + v63
		end

		return t3
	end
	local function calculatePositionMagnitudeResultsAtTime(n3: number, p8) -- line: 161
		local t4 = {}

		for v67, v68 in p8 do
			if v68.pos then
				t4[v67] = Vector3.new(unpack(v68.pos:GetValueAtTime(n3))).Magnitude
			end
		end

		return t4
	end

	local v33 = createDefaultCharacter(false)
	local t5 = {}

	for _, child in v33:GetChildren() do
		if CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(child.Name) then
			t5[child.Name] = child
		end
	end

	local v37 = getCurveTracks()
	local v38 = calculateCurveAnimLength(v37)
	local t6 = {}
	local t7 = {}

	local function addData(n4: number) -- line: 187
		-- upvalues: calculateTransformsAtTime (copy), v37 (copy), AssetCalculator (copy), t5 (copy), t6 (copy), t7 (copy), calculatePositionMagnitudeResultsAtTime (copy)
		local v70 = calculateTransformsAtTime(n4, v37)
		local v71 = AssetCalculator.calculateAllTransformsForFullBody(t5, v70)

		table.insert(t6, v71)
		table.insert(t7, (calculatePositionMagnitudeResultsAtTime(n4, v37)))
	end

	local n5 = 0

	while n5 <= v38 do
		if getFFlagUGCValidateCurveAnimFinalFrameBug() then
			local v43 = calculateTransformsAtTime(n5, v37)

			table.insert(t6, (AssetCalculator.calculateAllTransformsForFullBody(t5, v43)))
			table.insert(t7, (calculatePositionMagnitudeResultsAtTime(n5, v37)))
		else
			local v44 = calculateTransformsAtTime(n5, v37)

			table.insert(t6, (AssetCalculator.calculateAllTransformsForFullBody(t5, v44)))
			table.insert(t7, (calculatePositionMagnitudeResultsAtTime(n5, v37)))
		end

		n5 += v28
	end

	if getFFlagUGCValidateCurveAnimFinalFrameBug() and v38 >= 0 then
		local v45 = calculateTransformsAtTime(v38, v37)

		table.insert(t6, (AssetCalculator.calculateAllTransformsForFullBody(t5, v45)))
		table.insert(t7, (calculatePositionMagnitudeResultsAtTime(v38, v37)))
	end

	v33:Destroy()

	return t6, v38, t7, v37
end

return t1
