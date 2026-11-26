local cframeUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Thumbnailing").CFrameUtility
local cameraUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Thumbnailing").CameraUtility
local characterUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Thumbnailing").CharacterUtility

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
local computeCutoutFieldOfViewDeg = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/computeCutoutFieldOfViewDeg")
local computeFocusAngleAboveCenterRad = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/computeFocusAngleAboveCenterRad")

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

	local v5 = computeFocusAngleAboveCenterRad({
		viewportHeightPix = layout.viewportHeight,
		cutoutTopOffsetPix = layout.cutoutTopOffset,
		cutoutDiameterPix = layout.cutoutDiameter,
		cameraFieldOfViewDeg = fieldOfViewDeg
	})

	local targetCFrame = cframeUtility.CalculateTargetCFrame(head.CFrame)
	local headExtents, v6 = characterUtility.CalculateHeadExtents(character, targetCFrame)

	local v7 = cameraUtility.CalculateBaseDistanceToCamera(
		math.rad(fieldOfViewForDistanceScaleDeg),
		headExtents,
		v6,
		cameraUtility.DefaultHeadMarginScale
	) * data.distanceScale

	local v8 = targetCFrame + Vector3.new(0, (headExtents.Y + v6.Y) / 2, 0)
	local position = (v8 * CFrame.Angles(0, math.rad(data.yRotDeg), 0) * CFrame.new(0, 0, -v7)).Position

	return CFrame.lookAt(position, v8.Position) * CFrame.fromEulerAnglesXYZ(-v5, 0, 0)
end

return frameCloseupPreviewCamera
