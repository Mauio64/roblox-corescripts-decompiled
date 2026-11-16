local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local Thumbnailing = require(parent.Thumbnailing)
local CFrameUtility = Thumbnailing.CFrameUtility
local Thumbnailing2 = require(parent.Thumbnailing)
local CameraUtility = Thumbnailing2.CameraUtility
local Thumbnailing3 = require(parent.Thumbnailing)
local CharacterUtility = Thumbnailing3.CharacterUtility

local Constants = require(script.Parent.Parent.Constants)
local computeCutoutFieldOfViewDeg = require(script.Parent.computeCutoutFieldOfViewDeg)
local computeFocusAngleAboveCenterRad = require(script.Parent.computeFocusAngleAboveCenterRad)

local function frameCloseupPreviewCamera(data)
	local character = data.character
	local head = character:FindFirstChild("Head")

	if not (head and head:IsA("BasePart")) then
		return nil
	end

	local layout = data.layout
	local fieldOfViewDeg = data.fieldOfViewDeg or Constants.CameraFieldOfViewDeg
	local fieldOfViewForDistanceScaleDeg = data.fieldOfViewForDistanceScaleDeg
		or computeCutoutFieldOfViewDeg({
			viewportHeightPix = layout.viewportHeight,
			cutoutTopOffsetPix = layout.cutoutTopOffset,
			cutoutDiameterPix = layout.cutoutDiameter,
			cameraFieldOfViewDeg = fieldOfViewDeg
		})

	local v = computeFocusAngleAboveCenterRad({
		viewportHeightPix = layout.viewportHeight,
		cutoutTopOffsetPix = layout.cutoutTopOffset,
		cutoutDiameterPix = layout.cutoutDiameter,
		cameraFieldOfViewDeg = fieldOfViewDeg
	})

	local targetCFrame = CFrameUtility.CalculateTargetCFrame(head.CFrame)
	local headExtents, v2 = CharacterUtility.CalculateHeadExtents(character, targetCFrame)

	local v3 = CameraUtility.CalculateBaseDistanceToCamera(
		math.rad(fieldOfViewForDistanceScaleDeg),
		headExtents,
		v2,
		CameraUtility.DefaultHeadMarginScale
	) * data.distanceScale

	local v4 = targetCFrame + Vector3.new(0, (headExtents.Y + v2.Y) / 2, 0)
	local position = (v4 * CFrame.Angles(0, math.rad(data.yRotDeg), 0) * CFrame.new(0, 0, -v3)).Position

	return CFrame.lookAt(position, v4.Position) * CFrame.fromEulerAnglesXYZ(-v, 0, 0)
end

return frameCloseupPreviewCamera
