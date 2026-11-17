local parent = script.Parent.Parent

local Constants = require(parent.Constants)
local AssetCalculator = require(parent.util.AssetCalculator)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)
local RigBuilder = require(parent.util.RigBuilder)

local flags = parent.flags
local getFIntUGCValidateMaxAnimationFPS = require(flags.getFIntUGCValidateMaxAnimationFPS)

local FaceControlsName = CurveAnimationHierarchyUtils.FaceControlsName

local function hasFloatCurveKeys(instance)
	local x = instance:FindFirstChild("X")
	local y = instance:FindFirstChild("Y")
	local z = instance:FindFirstChild("Z")
	local v

	if x then
		v = x:IsA("FloatCurve") and #x:GetKeys() > 0
	else
		v = false
	end

	if v then
		return v
	end

	if y then
		v = y:IsA("FloatCurve") and #y:GetKeys() > 0
	else
		v = false
	end

	if v then
		return v
	end

	if not z then
		v = false
		return false
	end

	v = z:IsA("FloatCurve")
	return v and #z:GetKeys() > 0
end

local function hasPositionKeys(vector3Curve)
	if not vector3Curve then
		return false
	end

	if vector3Curve:IsA("Vector3Curve") then
		return hasFloatCurveKeys(vector3Curve)
	end

	return false
end

local function hasRotationKeys(eulerRotationCurve)
	if not eulerRotationCurve then
		return false
	end

	if eulerRotationCurve:IsA("EulerRotationCurve") then
		return hasFloatCurveKeys(eulerRotationCurve)
	end

	return false
end

return {
	calculateAnimFramesAtOrigin = function(p)
		local v = 1 / getFIntUGCValidateMaxAnimationFPS()

		local function getCurveTracks()
			local bodyPartFolderRoot = CurveAnimationHierarchyUtils.getBodyPartFolderRoot(p)
			assert(
				bodyPartFolderRoot,
				"CurveAnimation must have one and only one body part Folder child or HumanoidRootPart child."
			)

			local descendants = bodyPartFolderRoot:GetDescendants()
			table.insert(descendants, bodyPartFolderRoot)
			local curveTracks = {}

			for _, folder in descendants do
				if not (folder:IsA("Folder") and CurveAnimationHierarchyUtils.getBodyPartToParentMap()[folder.Name]) then
					continue
				end

				local position = folder:FindFirstChild("Position")
				local rotation = folder:FindFirstChild("Rotation")
				local name = folder.Name
				local v2

				if position and position:IsA("Vector3Curve") then
					v2 = hasFloatCurveKeys(position)
				else
					v2 = false
				end

				if not v2 then
					position = nil
				end

				local v3

				if rotation and rotation:IsA("EulerRotationCurve") then
					v3 = hasFloatCurveKeys(rotation)
				else
					v3 = false
				end

				if not v3 then
					rotation = nil
				end

				local faceControls

				if folder.Name == Constants.NAMED_R15_BODY_PARTS.Head then
					faceControls = folder:FindFirstChild(FaceControlsName)
				end

				curveTracks[name] = { pos = position, rot = rotation, faceControls = faceControls }
			end

			return curveTracks
		end

		local function calculateCurveAnimLength(curveTracks)
			local maxTime = -1

			local function getMaxTimeFromFloatCurveChildren(instance)
				if not instance then
					return
				end

				for _, floatCurve in instance:GetChildren() do
					if not floatCurve:IsA("FloatCurve") then
						continue
					end

					for _, v2 in floatCurve:GetKeys() do
						maxTime = math.max(maxTime, v2.Time)
					end
				end
			end

			for _, item in curveTracks do
				getMaxTimeFromFloatCurveChildren(item.pos)
				getMaxTimeFromFloatCurveChildren(item.rot)
				getMaxTimeFromFloatCurveChildren(item.faceControls)
			end

			return maxTime
		end

		local function calculateTransformsAtTime(p2: number, curveTracks)
			local transformsAtTime = {}

			for k, item in curveTracks do
				local v2 = not item.pos and Vector3.new(0, 0, 0) or Vector3.new(unpack(item.pos:GetValueAtTime(p2)))
				local v3

				if item.rot then
					v3 = item.rot:GetRotationAtTime(p2)
				else
					v3 = CFrame.new()
				end

				transformsAtTime[k] = v3 + v2
			end

			return transformsAtTime
		end

		local function calculatePositionMagnitudeResultsAtTime(p2: number, curveTracks)
			local magnitudes = {}

			for k, item in curveTracks do
				if item.pos then
					magnitudes[k] = Vector3.new(unpack(item.pos:GetValueAtTime(p2))).Magnitude
				end
			end

			return magnitudes
		end

		local defaultCharacter = RigBuilder.createDefaultCharacter(false)
		local childrenByName = {}

		for _, child in defaultCharacter:GetChildren() do
			if CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(child.Name) then
				childrenByName[child.Name] = child
			end
		end

		local curveTracks = getCurveTracks()
		local v2 = calculateCurveAnimLength(curveTracks)

		local result = {}
		local result2 = {}

		local function addData(p2: number)
			local v3 = calculateTransformsAtTime(p2, curveTracks)

			local allTransformsForFullBody = AssetCalculator.calculateAllTransformsForFullBody(childrenByName, v3)
			table.insert(result, allTransformsForFullBody)

			table.insert(result2, calculatePositionMagnitudeResultsAtTime(p2, curveTracks))
		end

		local total = 0

		while total <= v2 do
			local v3 = calculateTransformsAtTime(total, curveTracks)

			table.insert(result, (AssetCalculator.calculateAllTransformsForFullBody(childrenByName, v3)))

			table.insert(result2, calculatePositionMagnitudeResultsAtTime(total, curveTracks))

			total += v
		end

		if v2 >= 0 then
			local v3 = calculateTransformsAtTime(v2, curveTracks)

			table.insert(result, (AssetCalculator.calculateAllTransformsForFullBody(childrenByName, v3)))

			table.insert(result2, calculatePositionMagnitudeResultsAtTime(v2, curveTracks))
		end

		defaultCharacter:Destroy()
		return result, v2, result2, curveTracks
	end
}
