local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Otter = require(CorePackages.Packages.Otter)

local module = require("@luauforge/bundled/fvv")
local module2 = require("@luauforge/bundled/dTh")
local module3 = require("@luauforge/bundled/fvu")
local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local cframeUtility = Thumbnailing.CFrameUtility
local Thumbnailing2 = require(CorePackages.Packages.Thumbnailing)
local cameraUtility = Thumbnailing2.CameraUtility
local Thumbnailing3 = require(CorePackages.Packages.Thumbnailing)
local characterUtility = Thumbnailing3.CharacterUtility
local module4 = require("@luauforge/bundled/dTc")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module5 = require("@luauforge/bundled/dUd")

local v5 = {
	frequency = 1 / module.FullscreenTweenTimeSeconds,
	dampingRatio = 1
}

local class = {}
class.__index = class

function class.new(store, avatarRoute)
	local class2 = {}
	setmetatable(class2, class)

	class2.started = false
	class2.store = store
	class2.avatarRoute = avatarRoute

	class2.updateConnection = nil

	class2.camera = game.Workspace.CurrentCamera

	class2.toFullscreenFraction = 0

	class2.prevShowFullBodyPicture = class2:_showFullBodyPicture()
	class2.prevPage = class2.avatarRoute.opaque.name

	return class2
end

function class:_calculateCameraDetails(p2)
	local cameraFieldOfViewDeg = math.rad(module.CameraFieldOfViewDeg)
	local v6 = self.screenHeightPix / 2 / math.tan(cameraFieldOfViewDeg / 2)
	self.pixToCamera = v6
	self.focusAngleAboveCenterRad = math.atan2(
		self.screenHeightPix / 2 - (self.topYPix + self.viewportSizePix / 2),
		v6
	)

	local v7 = self.screenHeightPix / 2 - self.topYPix
	local v8 = v7 - self.viewportSizePix
	self.fieldOfViewForDistanceScale = math.deg(math.atan2(v7, v6) - math.atan2(v8, v6))
	self.store:dispatch(module4(self.fieldOfViewForDistanceScale))
end

function class:_handleCameraChange()
	self.showFullBodyPicture = self:_showFullBodyPicture()

	if self.prevShowFullBodyPicture ~= self.showFullBodyPicture then
		self.prevFieldOfViewForDistanceScale = self.fieldOfViewForDistanceScale
		self.prevXRotDeg = self.xRotDeg
		self.prevYRotDeg = self.yRotDeg
		self.prevCameraDistanceScale = self.cameraDistanceScale
		self.prevTargetCFrame = self.targetCFrame
		self.prevMinExtent = self.minExtent
		self.prevMaxExtent = self.maxExtent
		self.prevExtentScale = self.extentScale
		self.prevCameraCFrame = self.camera.CFrame
	end

	local state = self.store:getState()

	self.finalPageViewMode = state.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode
	self.characterModelVersion = state.AvatarExperience.AvatarScene.Character.CharacterModelVersion
	self.lastSuccessfulPoseEmoteAssetId = state.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId

	local currentCharacter = state.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not currentCharacter then
		return
	end

	local head = currentCharacter:FindFirstChild("Head")

	if not head then
		return
	end

	local name = self.avatarRoute.opaque.name

	local peekabooLayoutDetail = state.AvatarExperience.ProfilePictureEditor.PeekabooLayoutDetails[name]

	if not peekabooLayoutDetail then
		return
	end

	self.screenHeightPix = peekabooLayoutDetail.screenHeightPix
	self.topYPix = peekabooLayoutDetail.topYPix
	self.viewportSizePix = peekabooLayoutDetail.viewportSizePix

	self:_calculateCameraDetails(currentCharacter)

	if not self.focusAngleAboveCenterRad then
		return
	end

	if self.showFullBodyPicture then
		local targetCFrame = cframeUtility.CalculateTargetCFrame(head.CFrame)
		self.targetCFrame = targetCFrame - targetCFrame.Position + currentCharacter:GetPrimaryPartCFrame().Position
		local modelExtents, v6 = characterUtility.CalculateModelExtents(currentCharacter, self.targetCFrame)
		self.minExtent = modelExtents
		self.maxExtent = v6
	else
		self.targetCFrame = cframeUtility.CalculateTargetCFrame(head.CFrame)
		local headExtents, v6 = characterUtility.CalculateHeadExtents(currentCharacter, self.targetCFrame)
		self.minExtent = headExtents
		self.maxExtent = v6
	end

	local cameraSliders = state.AvatarExperience.ProfilePictureEditor.CameraSliders
	self.yRotDeg = 0
	self.xRotDeg = 0
	self.cameraDistanceScale = 1

	if cameraSliders then
		self.zoomSliderValue = cameraSliders.zoomSliderValue
		self.rotateSliderValue = cameraSliders.rotateSliderValue

		self.yRotDeg = module3.getYRotDegFromSliderValue(self.rotateSliderValue)

		if self.showFullBodyPicture then
			self.xRotDeg = cameraUtility.XRotForFullBody
			self.cameraDistanceScale = cameraUtility.DistanceScaleForFullBody
		else
			self.cameraDistanceScale = module3.getCameraDistanceScaleFromSliderValue(self.zoomSliderValue)
		end
	end

	self.extentScale = self.showFullBodyPicture and cameraUtility.DefaultBodyMarginScale
		or cameraUtility.DefaultHeadMarginScale

	if self.prevPage == self.avatarRoute.opaque.name then
		if self.prevShowFullBodyPicture ~= self.showFullBodyPicture then
			local v6 = self.showFullBodyPicture and 1 or 0

			self.prevShowFullBodyPicture = self.showFullBodyPicture
			self.fullscreenTweenMotor:stop()
			self.fullscreenTweenMotor:setGoal(Otter.spring(v6, v5))
			self.fullscreenTweenMotor:start()
		end
	else
		self.prevShowFullBodyPicture = false
		self.prevPage = self.avatarRoute.opaque.name
		self.fullscreenTweenMotor:stop()
		self.toFullscreenFraction = 0
	end

	self:onUpdateFullscreenFraction()
end

local function scaleBetween(p2, p3, p4)
	if p4 then
		return p3 * (1 - p2) + p4 * p2
	end

	return p3
end

local function scaleCFrameBetween(p2, p3, p4)
	if p4 then
		return p3:Lerp(p4, p2)
	end

	return p3
end

function class:onUpdateFullscreenFraction()
	local v6 = math.abs((self.showFullBodyPicture and 1 or 0) - self.toFullscreenFraction)

	local v8 = self.fieldOfViewForDistanceScale
	local prevFieldOfViewForDistanceScale = self.prevFieldOfViewForDistanceScale

	if prevFieldOfViewForDistanceScale then
		v8 = v8 * (1 - v6) + prevFieldOfViewForDistanceScale * v6
	end

	local v9 = self.xRotDeg
	local prevXRotDeg = self.prevXRotDeg

	if prevXRotDeg then
		v9 = v9 * (1 - v6) + prevXRotDeg * v6
	end

	local v10 = self.yRotDeg
	local prevYRotDeg = self.prevYRotDeg

	if prevYRotDeg then
		v10 = v10 * (1 - v6) + prevYRotDeg * v6
	end

	local v11 = self.cameraDistanceScale
	local prevCameraDistanceScale = self.prevCameraDistanceScale

	if prevCameraDistanceScale then
		v11 = v11 * (1 - v6) + prevCameraDistanceScale * v6
	end

	local targetCFrame = self.targetCFrame
	local prevTargetCFrame = self.prevTargetCFrame

	if prevTargetCFrame then
		targetCFrame = targetCFrame:Lerp(prevTargetCFrame, v6)
	end

	local v12 = self.minExtent
	local prevMinExtent = self.prevMinExtent

	if prevMinExtent then
		v12 = v12 * (1 - v6) + prevMinExtent * v6
	end

	local v13 = self.maxExtent
	local prevMaxExtent = self.prevMaxExtent

	if prevMaxExtent then
		v13 = v13 * (1 - v6) + prevMaxExtent * v6
	end

	local v14 = self.extentScale
	local prevExtentScale = self.prevExtentScale

	if prevExtentScale then
		v14 = v14 * (1 - v6) + prevExtentScale * v6
	end

	local v7 = {
		optFieldOfViewForDistanceScale = v8,
		optCameraXRot = v9,
		optCameraYRot = v10,
		optCameraDistanceScale = v11,
		targetCFrame = targetCFrame,
		minExtent = v12,
		maxExtent = v13,
		extentScale = v14
	}

	cameraUtility.SetupCamera(self.camera, v7)

	local cframe = CFrame.fromEulerAnglesXYZ(-self.focusAngleAboveCenterRad, 0, 0)
	local v15 = self.camera.CFrame * cframe

	local globalGuiInset = self.store:getState().GlobalGuiInset

	local deviceSafePadding = module5.GetDisplayStore().getDeviceSafePadding()
	local v16 = globalGuiInset.left + deviceSafePadding.left - globalGuiInset.right - deviceSafePadding.right

	if v16 > 0 then
		local v17 = (v15.Position - v7.targetCFrame.Position).Magnitude * v16 / (2 * self.pixToCamera)
		local v18 = -v15.RightVector * v17
		v15 = CFrame.new(v18.X, v18.Y, v18.Z) * v15
	end

	local camera = self.camera
	local prevCameraCFrame = self.prevCameraCFrame

	if prevCameraCFrame then
		v15 = v15:Lerp(prevCameraCFrame, v6)
	end

	camera.CFrame = v15
end

function class:_peekabooLayoutDetailsChanged(p2): boolean
	local name = self.avatarRoute.opaque.name

	local peekabooLayoutDetail = p2.AvatarExperience.ProfilePictureEditor.PeekabooLayoutDetails[name]

	if peekabooLayoutDetail then
		return self.screenHeightPix ~= peekabooLayoutDetail.screenHeightPix
			or self.topYPix ~= peekabooLayoutDetail.topYPix
			or self.viewportSizePix ~= peekabooLayoutDetail.viewportSizePix
	end

	return false
end

function class:_cameraSliderDetailsChanged(p3): boolean
	local cameraSliders = p3.AvatarExperience.ProfilePictureEditor.CameraSliders
	return self.zoomSliderValue ~= cameraSliders.zoomSliderValue
		or self.rotateSliderValue ~= cameraSliders.rotateSliderValue
end

function class:_finalPageViewModeChanged(p3): boolean
	local finalPageViewMode = p3.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode
	return self.finalPageViewMode ~= finalPageViewMode
end

function class:_lastSuccessfulPoseEmoteAssetIdChanged(p3): boolean
	local lastSuccessfulPoseEmoteAssetId = p3.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId
	return self.lastSuccessfulPoseEmoteAssetId ~= lastSuccessfulPoseEmoteAssetId
end

function class:_characterModelVersionChanged(p3): boolean
	local characterModelVersion = p3.AvatarExperience.AvatarScene.Character.CharacterModelVersion
	return self.characterModelVersion ~= characterModelVersion
end

function class:_update(p2)
	if
		self:_peekabooLayoutDetailsChanged(p2)
		or self:_cameraSliderDetailsChanged(p2)
		or self:_characterModelVersionChanged(p2)
		or self:_finalPageViewModeChanged(p2)
		or self:_lastSuccessfulPoseEmoteAssetIdChanged(p2)
	then
		self:_handleCameraChange()
	end
end

function class:_updateState(p2, p3)
	self:_update(p2)
end

function class:_showFullBodyPicture(): boolean
	return self.store:getState().AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode == module2.FullBody
		and self.avatarRoute.opaque.name == avatarScreen.ProfilePictureEditorFinal
end

function class:updateAvatarRoute(avatarRoute, p2)
	self.avatarRoute = avatarRoute

	if self.started then
		self:_update((self.store:getState()))
	end
end

function class:watchCharacterToAdjustCamera(instance)
	if instance then
		self.watchCharacterToolConnection = instance.DescendantAdded:Connect(function(tool)
			if tool:IsA("Tool") then
				RunService.Heartbeat:Wait()
				self:_handleCameraChange()
			end
		end)
	end
end

function class:onPPEPoseChanged()
	RunService.Heartbeat:Wait()
	self:_handleCameraChange()
end

function class:stopWatchingCharacter()
	if self.watchCharacterToolConnection then
		self.watchCharacterToolConnection:Disconnect()
		self.watchCharacterToolConnection = nil
	end
end

function class:start()
	if self.started then
		return
	end

	self.started = true
	local state = self.store:getState()

	self.fullscreenTweenMotor = Otter.createSingleMotor(0)
	self.fullscreenTweenMotor:onStep(function(toFullscreenFraction)
		self.toFullscreenFraction = toFullscreenFraction
		self:onUpdateFullscreenFraction()
	end)

	self.updateConnection = self.store.changed:connect(function(...)
		self:_updateState(...)
	end)

	self.camera.CameraType = Enum.CameraType.Scriptable

	self.camera.FieldOfView = module.CameraFieldOfViewDeg

	local currentCharacter = state.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if currentCharacter then
		self:_handleCameraChange()

		self:watchCharacterToAdjustCamera(currentCharacter)
	end
end

function class:stop()
	if not self.started then
		return
	end

	self.started = false
	self:stopWatchingCharacter()

	if self.fullscreenTweenMotor then
		self.fullscreenTweenMotor:destroy()
		self.fullscreenTweenMotor = nil
	end

	if self.updateConnection then
		self.updateConnection:disconnect()
		self.updateConnection = nil
	end
end

function class:onDestroy() end

return class
