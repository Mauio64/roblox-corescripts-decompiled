local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Otter = require(CorePackages.Packages.Otter)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local Utils = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local CFrameUtility = require(CorePackages.Packages.Thumbnailing).CFrameUtility
local CameraUtility = require(CorePackages.Packages.Thumbnailing).CameraUtility
local CharacterUtility = require(CorePackages.Packages.Thumbnailing).CharacterUtility
local SetFieldOfViewDeg = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetFieldOfViewDeg)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Display = require(CorePackages.Workspace.Packages.Display)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local t1 = {
	dampingRatio = 1,
	frequency = 1 / Constants.FullscreenTweenTimeSeconds
}
local t2 = {}

t2.__index = t2

function t2.new(p1, p2) -- line: 41
	-- upvalues: t2 (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3.started = false
	t3.store = p1
	t3.avatarRoute = p2
	t3.updateConnection = nil
	t3.camera = game.Workspace.CurrentCamera
	t3.toFullscreenFraction = 0
	t3.prevShowFullBodyPicture = t3:_showFullBodyPicture()
	t3.prevPage = t3.avatarRoute.opaque.name

	return t3
end
function t2._calculateCameraDetails(p3, _) -- line: 63
	-- upvalues: Constants (copy), SetFieldOfViewDeg (copy)
	local v26 = math.rad(Constants.CameraFieldOfViewDeg)
	local v27 = p3.screenHeightPix / 2 / math.tan(v26 / 2)

	p3.pixToCamera = v27
	p3.focusAngleAboveCenterRad = math.atan2(p3.screenHeightPix / 2 - (p3.topYPix + p3.viewportSizePix / 2), v27)

	local v28 = p3.screenHeightPix / 2 - p3.topYPix
	local v29 = v28 - p3.viewportSizePix

	p3.fieldOfViewForDistanceScale = math.deg(math.atan2(v28, v27) - math.atan2(v29, v27))
	p3.store:dispatch(SetFieldOfViewDeg(p3.fieldOfViewForDistanceScale))
end
function t2._handleCameraChange(p5) -- line: 84
	-- upvalues: CFrameUtility (copy), CharacterUtility (copy), Utils (copy), CameraUtility (copy), Otter (copy), t1 (copy)
	p5.showFullBodyPicture = p5:_showFullBodyPicture()

	if p5.prevShowFullBodyPicture ~= p5.showFullBodyPicture then
		p5.prevFieldOfViewForDistanceScale = p5.fieldOfViewForDistanceScale
		p5.prevXRotDeg = p5.xRotDeg
		p5.prevYRotDeg = p5.yRotDeg
		p5.prevCameraDistanceScale = p5.cameraDistanceScale
		p5.prevTargetCFrame = p5.targetCFrame
		p5.prevMinExtent = p5.minExtent
		p5.prevMaxExtent = p5.maxExtent
		p5.prevExtentScale = p5.extentScale
		p5.prevCameraCFrame = p5.camera.CFrame
	end

	local v31 = p5.store:getState()

	p5.finalPageViewMode = v31.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode
	p5.characterModelVersion = v31.AvatarExperience.AvatarScene.Character.CharacterModelVersion
	p5.lastSuccessfulPoseEmoteAssetId = v31.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId

	local CurrentCharacter = v31.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return
	end

	local Head = CurrentCharacter:FindFirstChild("Head")

	if not Head then
		return
	end

	local name = p5.avatarRoute.opaque.name
	local v35 = v31.AvatarExperience.ProfilePictureEditor.PeekabooLayoutDetails[name]

	if not v35 then
		return
	end

	p5.screenHeightPix = v35.screenHeightPix
	p5.topYPix = v35.topYPix
	p5.viewportSizePix = v35.viewportSizePix
	p5:_calculateCameraDetails(CurrentCharacter)

	if not p5.focusAngleAboveCenterRad then
		return
	end

	if p5.showFullBodyPicture then
		local v36 = CFrameUtility.CalculateTargetCFrame(Head.CFrame)

		p5.targetCFrame = v36 - v36.Position + CurrentCharacter:GetPrimaryPartCFrame().Position

		local v37, v38 = CharacterUtility.CalculateModelExtents(CurrentCharacter, p5.targetCFrame)

		p5.minExtent = v37
		p5.maxExtent = v38
	else
		p5.targetCFrame = CFrameUtility.CalculateTargetCFrame(Head.CFrame)

		local v39, v40 = CharacterUtility.CalculateHeadExtents(CurrentCharacter, p5.targetCFrame)

		p5.minExtent = v39
		p5.maxExtent = v40
	end

	local CameraSliders = v31.AvatarExperience.ProfilePictureEditor.CameraSliders

	p5.yRotDeg = 0
	p5.xRotDeg = 0
	p5.cameraDistanceScale = 1

	if CameraSliders then
		p5.zoomSliderValue = CameraSliders.zoomSliderValue
		p5.rotateSliderValue = CameraSliders.rotateSliderValue
		p5.yRotDeg = Utils.getYRotDegFromSliderValue(p5.rotateSliderValue)

		if p5.showFullBodyPicture then
			p5.xRotDeg = CameraUtility.XRotForFullBody
			p5.cameraDistanceScale = CameraUtility.DistanceScaleForFullBody
		else
			p5.cameraDistanceScale = Utils.getCameraDistanceScaleFromSliderValue(p5.zoomSliderValue)
		end
	end

	p5.extentScale = p5.showFullBodyPicture and CameraUtility.DefaultBodyMarginScale or CameraUtility.DefaultHeadMarginScale

	if p5.prevPage ~= p5.avatarRoute.opaque.name then
		p5.prevShowFullBodyPicture = false
		p5.prevPage = p5.avatarRoute.opaque.name
		p5.fullscreenTweenMotor:stop()
		p5.toFullscreenFraction = 0
	elseif p5.prevShowFullBodyPicture ~= p5.showFullBodyPicture then
		local v42 = not p5.showFullBodyPicture and 0 or 1

		p5.prevShowFullBodyPicture = p5.showFullBodyPicture
		p5.fullscreenTweenMotor:stop()
		p5.fullscreenTweenMotor:setGoal(Otter.spring(v42, t1))
		p5.fullscreenTweenMotor:start()
	end

	p5:onUpdateFullscreenFraction()
end

local function scaleBetween(p6, p7, p8) -- line: 190
	if not p8 then
		return p7
	end

	return p7 * (1 - p6) + p8 * p6
end
local function scaleCFrameBetween(p9, p10, p11) -- line: 197
	if not p11 then
		return p10
	end

	return p10:Lerp(p11, p9)
end

function t2.onUpdateFullscreenFraction(p12) -- line: 204
	-- upvalues: CameraUtility (copy), getSafeAreaSize (copy), FFlagEnableLeftNavOnConsole (copy), Display (copy)
	local v50 = math.abs((not p12.showFullBodyPicture and 0 or 1) - p12.toFullscreenFraction)
	local t4 = {}
	local fieldOfViewForDistanceScale = p12.fieldOfViewForDistanceScale
	local prevFieldOfViewForDistanceScale = p12.prevFieldOfViewForDistanceScale

	t4.optFieldOfViewForDistanceScale = if prevFieldOfViewForDistanceScale then fieldOfViewForDistanceScale * (1 - v50) + prevFieldOfViewForDistanceScale * v50 else fieldOfViewForDistanceScale

	local xRotDeg = p12.xRotDeg
	local prevXRotDeg = p12.prevXRotDeg

	t4.optCameraXRot = if prevXRotDeg then xRotDeg * (1 - v50) + prevXRotDeg * v50 else xRotDeg

	local yRotDeg = p12.yRotDeg
	local prevYRotDeg = p12.prevYRotDeg

	t4.optCameraYRot = if prevYRotDeg then yRotDeg * (1 - v50) + prevYRotDeg * v50 else yRotDeg

	local cameraDistanceScale = p12.cameraDistanceScale
	local prevCameraDistanceScale = p12.prevCameraDistanceScale

	t4.optCameraDistanceScale = if prevCameraDistanceScale then cameraDistanceScale * (1 - v50) + prevCameraDistanceScale * v50 else cameraDistanceScale

	local targetCFrame = p12.targetCFrame
	local prevTargetCFrame = p12.prevTargetCFrame

	t4.targetCFrame = if prevTargetCFrame then targetCFrame:Lerp(prevTargetCFrame, v50) else targetCFrame

	local minExtent = p12.minExtent
	local prevMinExtent = p12.prevMinExtent

	t4.minExtent = if prevMinExtent then minExtent * (1 - v50) + prevMinExtent * v50 else minExtent

	local maxExtent = p12.maxExtent
	local prevMaxExtent = p12.prevMaxExtent

	t4.maxExtent = if prevMaxExtent then maxExtent * (1 - v50) + prevMaxExtent * v50 else maxExtent

	local extentScale = p12.extentScale
	local prevExtentScale = p12.prevExtentScale

	t4.extentScale = if prevExtentScale then extentScale * (1 - v50) + prevExtentScale * v50 else extentScale
	CameraUtility.SetupCamera(p12.camera, t4)

	local cFrame = CFrame.fromEulerAnglesXYZ(-p12.focusAngleAboveCenterRad, 0, 0)
	local v69 = p12.camera.CFrame * cFrame
	local GlobalGuiInset = p12.store:getState().GlobalGuiInset
	local ScreenSize = p12.store:getState().ScreenSize
	local v72 = getSafeAreaSize(ScreenSize, GlobalGuiInset)
	local v74

	if FFlagEnableLeftNavOnConsole then
		local v73 = Display.GetDisplayStore().getDeviceSafePadding()

		v74 = GlobalGuiInset.left + v73.left - GlobalGuiInset.right - v73.right
	else
		v74 = ScreenSize.X - v72.X.Offset
	end

	if v74 > 0 then
		local v75 = (v69.Position - t4.targetCFrame.Position).Magnitude * v74 / (2 * p12.pixToCamera)
		local v76 = -v69.RightVector * v75

		v69 = CFrame.new(v76.X, v76.Y, v76.Z) * v69
	end

	local camera = p12.camera
	local prevCameraCFrame = p12.prevCameraCFrame

	camera.CFrame = if prevCameraCFrame then v69:Lerp(prevCameraCFrame, v50) else v69
end
function t2._peekabooLayoutDetailsChanged(p13, p14) -- line: 255
	local name = p13.avatarRoute.opaque.name
	local v82 = p14.AvatarExperience.ProfilePictureEditor.PeekabooLayoutDetails[name]

	if not v82 then
		return false
	end

	return p13.screenHeightPix ~= v82.screenHeightPix or (p13.topYPix ~= v82.topYPix or p13.viewportSizePix ~= v82.viewportSizePix)
end
function t2._cameraSliderDetailsChanged(p15, p16) -- line: 267
	local CameraSliders = p16.AvatarExperience.ProfilePictureEditor.CameraSliders

	return p15.zoomSliderValue ~= CameraSliders.zoomSliderValue or p15.rotateSliderValue ~= CameraSliders.rotateSliderValue
end
function t2._finalPageViewModeChanged(p17, p18) -- line: 273
	return p18.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode ~= p17.finalPageViewMode
end
function t2._lastSuccessfulPoseEmoteAssetIdChanged(p19, p20) -- line: 278
	return p20.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId ~= p19.lastSuccessfulPoseEmoteAssetId
end
function t2._characterModelVersionChanged(p21, p22) -- line: 291
	return p22.AvatarExperience.AvatarScene.Character.CharacterModelVersion ~= p21.characterModelVersion
end
function t2._update(p23, p24) -- line: 296
	if p23:_peekabooLayoutDetailsChanged(p24) or (p23:_cameraSliderDetailsChanged(p24) or p23:_characterModelVersionChanged(p24) or p23:_finalPageViewModeChanged(p24) or p23:_lastSuccessfulPoseEmoteAssetIdChanged(p24)) then
		p23:_handleCameraChange()
	end
end
function t2._updateState(p25, p26, _) -- line: 308
	p25:_update(p26)
end
function t2._showFullBodyPicture(p28) -- line: 312
	-- upvalues: PPEThumbnailType (copy), AvatarScreen (copy)
	if p28.store:getState().AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode == PPEThumbnailType.FullBody and p28.avatarRoute.opaque.name == AvatarScreen.ProfilePictureEditorFinal then
		return true
	end

	return false
end
function t2.updateAvatarRoute(p29, p30, _) -- line: 324
	p29.avatarRoute = p30

	if p29.started then
		p29:_update((p29.store:getState()))
	end
end
function t2.watchCharacterToAdjustCamera(p32, p33) -- line: 332
	-- upvalues: RunService (copy)
	if p33 then
		p32.watchCharacterToolConnection = p33.DescendantAdded:Connect(function(descendant) -- line: 338
			-- upvalues: RunService (copy), p32 (copy)
			if descendant:IsA("Tool") then
				RunService.Heartbeat:Wait()
				p32:_handleCameraChange()
			end
		end)
	end
end
function t2.onPPEPoseChanged(p34) -- line: 347
	-- upvalues: RunService (copy)
	RunService.Heartbeat:Wait()
	p34:_handleCameraChange()
end
function t2.stopWatchingCharacter(p35) -- line: 352
	if p35.watchCharacterToolConnection then
		p35.watchCharacterToolConnection:Disconnect()
		p35.watchCharacterToolConnection = nil
	end
end
function t2.start(p36) -- line: 359
	-- upvalues: Otter (copy), Constants (copy)
	if p36.started then
		return
	end

	p36.started = true

	local v106 = p36.store:getState()

	p36.fullscreenTweenMotor = Otter.createSingleMotor(0)
	p36.fullscreenTweenMotor:onStep(function(p37) -- line: 368
		-- upvalues: p36 (copy)
		p36.toFullscreenFraction = p37
		p36:onUpdateFullscreenFraction()
	end)
	p36.updateConnection = p36.store.changed:connect(function(...) -- line: 373
		-- upvalues: p36 (copy)
		p36:_updateState(...)
	end)
	p36.camera.CameraType = Enum.CameraType.Scriptable
	p36.camera.FieldOfView = Constants.CameraFieldOfViewDeg

	local CurrentCharacter = v106.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if CurrentCharacter then
		p36:_handleCameraChange()
		p36:watchCharacterToAdjustCamera(CurrentCharacter)
	end
end
function t2.stop(p38) -- line: 391
	if not p38.started then
		return
	end

	p38.started = false
	p38:stopWatchingCharacter()

	if p38.fullscreenTweenMotor then
		p38.fullscreenTweenMotor:destroy()
		p38.fullscreenTweenMotor = nil
	end

	if p38.updateConnection then
		p38.updateConnection:disconnect()
		p38.updateConnection = nil
	end
end
function t2.onDestroy(_) -- line: 410
end

return t2
