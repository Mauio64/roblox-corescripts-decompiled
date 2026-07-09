local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Modules = CoreGui.RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local HardwareSafeAreaInsets = require(CorePackages.Workspace.Packages.Responsive).HardwareSafeAreaInsets
local GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport)
local GetAXCameraManagerErrorsEnabled = require(Modules.AvatarExperience.Flags.GetAXCameraManagerErrorsEnabled)
local v15 = game:DefineFastFlag("AXFixCameraManagerInitialization", false)
local FFlagAXIncreaseDefaultPeekViewHeight = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXIncreaseDefaultPeekViewHeight
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local v19 = game:DefineFastFlag("Fix10ftCameraSwitchRace", false)
local v20 = game:DefineFastFlag("AXCameraDownwardTilt", false)
local v21 = game:DefineFastFlag("AXCameraLevelHorizon", false)
local FFlagIncreaseMarketplaceContentHeight = require(CorePackages.Workspace.Packages.SharedFlags).FFlagIncreaseMarketplaceContentHeight
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
local cFrame = CFrame.new(Vector3.new(-3, 2.5, 1.5), (Vector3.new(-2, 2.5, 1.5)))
local t1 = {
	[DeviceOrientationMode.Portrait] = {
		landingPageZoomToFocusHeightRatio = 6.188,
		fullViewZoomToFocusHeightRatio = 4.5,
		defaultVerticalFocusScale = 0.4,
		minZoomRadius = 5,
		cameraCenterScreenPosition = UDim2.new(0, 0, -0.5, if not FFlagIncreaseMarketplaceContentHeight then not FFlagAXIncreaseDefaultPeekViewHeight and 40 or 25 else not FFlagAXIncreaseDefaultPeekViewHeight and 8 or -7),
		baseCameraOrigin = Vector3.new(19.24339867, 0, not v21 and 0.594265997 or 0),
		landingPageCameraCenterScreenPosition = UDim2.new(0, 0, -0.4, 40),
		landingPageZoomAdjustmentForFocusPart = if not FFlagAXIncreaseDefaultPeekViewHeight then nil else 1,
		zoomToFocusHeightRatio = if not FFlagIncreaseMarketplaceContentHeight then not FFlagAXIncreaseDefaultPeekViewHeight and 8.704 or 9.7 else 10.9,
		zoomAdjustmentForFocusPart = if not FFlagIncreaseMarketplaceContentHeight then if not FFlagAXIncreaseDefaultPeekViewHeight then nil else 1.2 else 1.35,
		maxZoomRadius = if not FFlagIncreaseMarketplaceContentHeight then not FFlagAXIncreaseDefaultPeekViewHeight and 30 or 35 else 40
	},
	[DeviceOrientationMode.Landscape] = {
		zoomToFocusHeightRatio = 3.84,
		fullViewZoomToFocusHeightRatio = 3.6,
		defaultVerticalFocusScale = 0.5,
		minZoomRadius = 3,
		maxZoomRadius = 20,
		cameraCenterScreenPosition = UDim2.new(Constants.LandscapeNavWidth, 0, 0, not FFlagAXRootSlotBasedEditorFlag and 10 or -30),
		baseCameraOrigin = Vector3.new(9.24339867, 0, not v21 and 0.594265997 or 0),
		zoomAdjustmentForFocusPart = if not FFlagAXIncreaseDefaultPeekViewHeight then nil else 1,
		landingPageZoomAdjustmentForFocusPart = if not FFlagAXIncreaseDefaultPeekViewHeight then nil else 1
	}
}

local function adjustCameraCenterPosition(p1, p2) -- line: 121
	return p1 - UDim2.new(0, 0, 0, 64 - p2)
end
local function calculateRotationCFrame(vector3: Vector3, n1: number, n2: number) -- line: 131
	-- upvalues: v21 (copy)
	if v21 then
		local LookVector = (CFrame.new(Vector3.new(), vector3) * CFrame.Angles(0, n1, 0) * CFrame.Angles(n2, 0, 0)).LookVector

		return CFrame.new(Vector3.new(), LookVector)
	end

	return CFrame.new(Vector3.new(), vector3) * CFrame.Angles(n2, n1, 0)
end
local function isTryingOnAnimationBundle(p3) -- line: 143
	-- upvalues: Constants (copy)
	local v41 = p3.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}

	if v41.isUnequipped then
		return false
	end

	return Constants.BundleTypeIdStrings.Animations == v41.itemSubType
end
local function calculateFocusPointOfCharacterParts(p4, p5) -- line: 153
	-- upvalues: Constants (copy), Utils (copy)
	local v44 = #p5

	if v44 == 0 then
		return Constants.DefaultRigPosition
	end

	local vector3 = Vector3.new()

	for _, v47 in p5 do
		if v47.Attachment then
			local v48 = Utils.getAttachmentCFrame(p4, v47.Part, v47.Attachment)

			if v48 == nil then
				v48 = Utils.getPartCFrame(p4, v47.Part)
			end

			vector3 += v48.Position
		else
			vector3 += Utils.getPartCFrame(p4, v47.Part).Position
		end
	end

	return vector3 / v44
end

local v30 = memoize(function(p6) -- line: 179
	local t2 = {}

	for _, v52 in p6 do
		for v53, _ in v52 do
			table.insert(t2, v53)
		end
	end

	return " equippedAssets=" .. table.concat(t2, ", ")
end)

local function calculateModel2DBoundingSizeRelativeToCFrame(p7, p8, p9) -- line: 191
	-- upvalues: Utils (copy), GetAXCameraManagerErrorsEnabled (copy), v30 (copy), mutedError (copy), cFrame (copy)
	local v58, v59 = p7:GetBoundingBox()

	if not Utils.isBoundingBoxVectorSane(v59) then
		if GetAXCameraManagerErrorsEnabled() then
			local v60 = v30(p9)

			mutedError("(Avatar Experience) size = " .. v59.X .. ", " .. v59.Y .. ", " .. v59.Z .. v60)
		end

		v59 = Vector3.new(4, 6, 2)
	end

	if not Utils.isBoundingBoxCFrameSane(v58) then
		if GetAXCameraManagerErrorsEnabled() then
			local v61 = v30(p9)

			mutedError("(Avatar Experience) orientation = " .. v58.X .. ", " .. v58.Y .. ", " .. v58.Z .. v61)
		end

		v58 = cFrame
	end

	if GetAXCameraManagerErrorsEnabled() and not Utils.isBoundingBoxCFrameSane(p8) then
		local v62 = v30(p9)

		mutedError("(Avatar Experience) cframe = " .. p8.X .. ", " .. p8.Y .. ", " .. p8.Z .. v62)
	end

	local v63 = v59 / 2
	local t3 = {
		Vector3.new(-v63.X, -v63.Y, -v63.Z),
		Vector3.new(v63.X, -v63.Y, -v63.Z),
		Vector3.new(v63.X, v63.Y, -v63.Z),
		Vector3.new(-v63.X, v63.Y, -v63.Z),
		Vector3.new(-v63.X, -v63.Y, v63.Z),
		Vector3.new(v63.X, -v63.Y, v63.Z),
		Vector3.new(v63.X, v63.Y, v63.Z),
		(Vector3.new(-v63.X, v63.Y, v63.Z))
	}
	local n3 = 1e999
	local n4 = 1e999
	local n5 = -1e999
	local n6 = -1e999

	for i = 1, #t3 do
		local v70 = p8:PointToObjectSpace(v58:PointToWorldSpace(t3[i]))

		n3 = math.min(n3, v70.X)
		n4 = math.min(n4, v70.Y)
		n5 = math.max(n5, v70.X)
		n6 = math.max(n6, v70.Y)

		if GetAXCameraManagerErrorsEnabled() then
			if n5 < n3 then
				mutedError("(Avatar Experience) maxX = " .. n5 .. ", minX = " .. n3)
			end

			if n6 < n4 then
				mutedError("(Avatar Experience) maxY = " .. n6 .. ", minY = " .. n4)
			end
		end
	end

	return Vector2.new(n5 - n3, n6 - n4)
end
local function hasInteractionEvents(p10) -- line: 279
	-- upvalues: AvatarScreen (copy), Utils (copy)
	if p10 == AvatarScreen.AvatarExperienceLandingPage or Utils.isAvatarBackground(p10) then
		return false
	end

	return true
end

local t4 = {}

t4.__index = t4

function t4.calculateFocusPoint(p11) -- line: 291
	-- upvalues: Utils (copy), Constants (copy), calculateFocusPointOfCharacterParts (copy), t1 (copy), FFlagAXCustomizeMakeupSupport (copy)
	local v73 = p11.store:getState()
	local v74 = p11:useCenteredSceneView(v73, p11.avatarRoute)
	local v75 = Utils.getCategoryInfoFromState(v73, p11.avatarRoute)
	local AvatarType = v73.AvatarExperience.AvatarEditor.Character.AvatarType
	local CurrentCharacter = v73.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local DeviceOrientation = v73.DeviceOrientation
	local v79 = Constants.AvatarTypeFocusGroups[AvatarType][v75.CameraFocus]

	if v79 and not v74 then
		return (calculateFocusPointOfCharacterParts(CurrentCharacter, v79))
	end

	local v80 = calculateFocusPointOfCharacterParts(CurrentCharacter, {{
		Part = "HumanoidRootPart"
	}})
	local Y = (CurrentCharacter:GetExtentsSize() * t1[DeviceOrientation].defaultVerticalFocusScale).Y
	local Head = CurrentCharacter:FindFirstChild("Head")

	if Head then
		Y = if not FFlagAXCustomizeMakeupSupport or v75.CameraFocus ~= Constants.PartName.Makeup then math.min(Head.Position.Y, Y) else Head.Position.Y
	end

	return (Vector3.new(v80.X, Y, v80.Z))
end
function t4.calculateBaseZoomRadius(p12, p13) -- line: 326
	-- upvalues: t1 (copy), Utils (copy), AvatarScreen (copy), Constants (copy), FFlagAXIncreaseDefaultPeekViewHeight (copy)
	local v85 = p12.store:getState()
	local v86 = p12:useCenteredSceneView(v85, p12.avatarRoute)
	local DeviceOrientation = v85.DeviceOrientation

	if v86 then
		return (v85.AvatarExperience.AvatarScene.Character.CurrentCharacter:GetExtentsSize() * 0.5).Y * t1[DeviceOrientation].fullViewZoomToFocusHeightRatio
	end

	local name = p12.avatarRoute.current.name
	local v89 = Utils.getCategoryInfoFromState(v85, p12.avatarRoute)
	local AvatarType = v85.AvatarExperience.AvatarEditor.Character.AvatarType
	local v91 = name == AvatarScreen.AvatarExperienceLandingPage
	local v92 = Constants.AvatarTypeFocusGroups[AvatarType][v89.CameraFocus] or nil
	local v93 = v85.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}
	local v94 = if not (not v93.isUnequipped and Constants.BundleTypeIdStrings.Animations == v93.itemSubType) then v89.CameraZoomRadius or 0 else Constants.AnimationCategoryCameraZoomRadius

	if not v92 then
		local v95 = v91 and t1[DeviceOrientation].landingPageZoomToFocusHeightRatio or t1[DeviceOrientation].zoomToFocusHeightRatio

		v94 += p13.Y * v95
	end

	if FFlagAXIncreaseDefaultPeekViewHeight and v92 then
		local zoomAdjustmentForFocusPart = t1[DeviceOrientation].zoomAdjustmentForFocusPart

		if v91 then
			zoomAdjustmentForFocusPart = t1[DeviceOrientation].landingPageZoomAdjustmentForFocusPart
		end

		v94 *= zoomAdjustmentForFocusPart
	end

	return v94
end
function t4.calculateZoomRadius(p14) -- line: 378
	return p14.cachedBaseZoomRadius + p14.zoomOffset
end
function t4.calculateCameraOrigin(p15, p16, p17) -- line: 382
	-- upvalues: t1 (copy), v20 (copy)
	local DeviceOrientation = p15.store:getState().DeviceOrientation
	local v102 = t1[DeviceOrientation].baseCameraOrigin - p16
	local v103 = p16 + Vector3.new(v102.x, 0, v102.z).Unit * p17

	if v20 then
		local v104 = t1[DeviceOrientation]
		local minZoomRadius = v104.minZoomRadius
		local maxZoomRadius = v104.maxZoomRadius

		v103 += Vector3.new(0, p17 * math.tan((not (minZoomRadius < maxZoomRadius) and 0 or math.clamp((p17 - minZoomRadius) / (maxZoomRadius - minZoomRadius), 0, 1)) * 0.11344640137963143 + 0), 0)
	end

	return v103
end
function t4.calculateHalfFieldsOfView(p18) -- line: 412
	-- upvalues: GetFFlagLuaAppFixStudioNotchSupport (copy), HardwareSafeAreaInsets (copy)
	local v108 = if not GetFFlagLuaAppFixStudioNotchSupport() then p18.camera.ViewportSize else HardwareSafeAreaInsets.fullscreenGui().AbsoluteSize
	local X = v108.X
	local Y = v108.Y

	return math.atan(0.4663076581549986 * X / Y), 0.4363323129985824
end
function t4.useCenteredSceneView(_, p20, p21) -- line: 425
	-- upvalues: AvatarScreen (copy), Utils (copy)
	return p21.opaque.name == AvatarScreen.TryOnItem or Utils.getIsSceneFullViewFromState(p20, p21)
end
function t4.getPeekViewHeight(p22) -- line: 433
	-- upvalues: PeekViewState (copy)
	local ItemDetailsPeekView = p22.store:getState().AvatarExperience.Common.ItemDetailsPeekView

	if ItemDetailsPeekView.viewState == PeekViewState.Brief and ItemDetailsPeekView.briefViewHeight then
		return ItemDetailsPeekView.briefViewHeight
	end

	return 0
end
function t4.calculateCameraOffsetAngles(p23) -- line: 444
	-- upvalues: Utils (copy), AvatarScreen (copy), t1 (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), HardwareSafeAreaInsets (copy)
	local v117 = p23.store:getState()

	if p23:useCenteredSceneView(v117, p23.avatarRoute) then
		return 0, 0
	end

	local DeviceOrientation = v117.DeviceOrientation
	local name = p23.avatarRoute.current.name
	local v120 = Utils.getTopBarHeightAvatarScene(v117)
	local v121 = (name == AvatarScreen.AvatarExperienceLandingPage and t1[DeviceOrientation].landingPageCameraCenterScreenPosition or t1[DeviceOrientation].cameraCenterScreenPosition) - UDim2.new(0, 0, 0, 64 - v120)
	local v122, v123 = p23:calculateHalfFieldsOfView()
	local v124 = if not GetFFlagLuaAppFixStudioNotchSupport() then p23.camera.ViewportSize else HardwareSafeAreaInsets.fullscreenGui().AbsoluteSize
	local X = v124.X
	local Y = v124.Y

	return math.atan(math.tan(v122) * (v121.X.Scale + 2 * v121.X.Offset / X)), (math.atan(math.tan(v123) * (v121.Y.Scale + 2 * v121.Y.Offset / Y)))
end
function t4.pixelOffsetToPositionOffset(p24, p25) -- line: 480
	-- upvalues: calculateRotationCFrame (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), HardwareSafeAreaInsets (copy)
	local v129, v130 = p24:calculateCameraOffsetAngles()
	local v131, v132 = p24:calculateHalfFieldsOfView()
	local cachedFocusPoint = p24.cachedFocusPoint
	local v134 = cachedFocusPoint - p24:calculateCameraOrigin(cachedFocusPoint, (p24:calculateZoomRadius()))
	local v135 = calculateRotationCFrame(v134, v129, v130):VectorToObjectSpace(v134)

	return p25 / (if not GetFFlagLuaAppFixStudioNotchSupport() then p24.camera.ViewportSize else HardwareSafeAreaInsets.fullscreenGui().AbsoluteSize) * Vector2.new(math.tan(v131), (math.tan(v132))) * -v135.Z * 2
end
function t4.tweenCameraIntoPlace(p26, p27, p28, p29) -- line: 501
	-- upvalues: calculateRotationCFrame (copy), TweenService (copy), tweenInfo (copy)
	local v140, v141 = p26:calculateCameraOffsetAngles()
	local v142 = p28 - p27
	local v143 = calculateRotationCFrame(v142, v140, v141)
	local panOffset = p26.panOffset
	local v145 = v143.LookVector:Cross((Vector3.new(0, 1, 0))).Unit * panOffset.X + Vector3.new(0, 1, 0) * panOffset.Y
	local v146 = CFrame.new(p27 + v145) * v143

	p26:cancelTween()

	if p29 then
		p26.camera.CFrame = v146

		return
	end

	local t5 = {
		CFrame = v146
	}

	p26.isTweening = true

	local tween = TweenService:Create(p26.camera, tweenInfo, t5)

	tween.Completed:Connect(function() -- line: 527
		-- upvalues: p26 (copy)
		p26.isTweening = false
		p26.tween = nil
	end)
	tween:Play()
	p26.tween = tween
end
function t4.boundPanOffset(p30) -- line: 537
	-- upvalues: calculateRotationCFrame (copy), calculateModel2DBoundingSizeRelativeToCFrame (copy), GetAXCameraManagerErrorsEnabled (copy), mutedError (copy)
	local v150 = p30.store:getState()
	local CurrentCharacter = v150.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return
	end

	local _, v153 = p30:calculateHalfFieldsOfView()
	local v154, v155 = p30:calculateCameraOffsetAngles()
	local cachedFocusPoint = p30.cachedFocusPoint
	local v157 = p30:calculateCameraOrigin(cachedFocusPoint, (p30:calculateZoomRadius()))
	local v158 = cachedFocusPoint - v157
	local v159 = calculateRotationCFrame(v158, v154, v155)
	local v160 = CFrame.new(v157) * v159
	local v161 = -p30.camera.NearPlaneZ
	local v162 = math.tan(v153) * v161
	local v163 = math.sqrt(v162 * v162 + v161 * v161)
	local v164 = math.sin(v153 + v155) * v163 - v157.Y + 0.01
	local EquippedAssets = v150.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v166 = calculateModel2DBoundingSizeRelativeToCFrame(CurrentCharacter, v160, EquippedAssets) / 2

	if GetAXCameraManagerErrorsEnabled() then
		if v166.X < 0 then
			mutedError("(Avatar Experience) characterHalf2DBoundingSize.X = " .. v166.X)
		end

		if v166.Y < 0 then
			mutedError("(Avatar Experience) characterHalf2DBoundingSize.Y = " .. v166.Y)
		end
	end

	local vector2 = Vector2.new(math.max(0, v166.X), (math.max(0, v166.Y)))
	local panOffset = p30.panOffset

	p30.panOffset = Vector3.new(math.clamp(p30.panOffset.X, -vector2.X, vector2.X), math.clamp(p30.panOffset.Y, math.max(v164, -vector2.Y), (math.max(v164, vector2.Y))), p30.panOffset.Z)

	return panOffset ~= p30.panOffset
end
function t4.calculateZoomOffsetBounds(p31) -- line: 601
	-- upvalues: t1 (copy)
	local v170 = t1[p31.store:getState().DeviceOrientation]
	local cachedBaseZoomRadius = p31.cachedBaseZoomRadius

	return v170.minZoomRadius - cachedBaseZoomRadius, v170.maxZoomRadius - cachedBaseZoomRadius
end
function t4.boundZoomOffset(p32, p33, p34) -- line: 614
	if not p33 or not p34 then
		p33, p34 = p32:calculateZoomOffsetBounds()
	end

	local zoomOffset = p32.zoomOffset

	p32.zoomOffset = math.clamp(p32.zoomOffset, p33, p34)

	return zoomOffset ~= p32.zoomOffset
end
function t4.handleCameraChange(p35, p36) -- line: 626
	if not p35.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter then
		return
	end

	local cachedFocusPoint = p35.cachedFocusPoint

	p35:tweenCameraIntoPlace(p35:calculateCameraOrigin(cachedFocusPoint, (p35:calculateZoomRadius())), cachedFocusPoint, p36)
end
function t4.panByDistance(p37, p38) -- line: 640
	p37.panOffset = Vector3.new(p37.panOffset.X + p38.X, p37.panOffset.Y + p38.Y, 0)
	p37:boundPanOffset()
	p37:handleCameraChange(true)
end
function t4.panByPixels(p39, p40) -- line: 646
	p39:panByDistance((p39:pixelOffsetToPositionOffset(p40)))
end
function t4.zoomStraight(p41, p42) -- line: 651
	p41.zoomOffset = p41.zoomOffset + p42
	p41:boundZoomOffset()
	p41:handleCameraChange(true)
end
function t4.zoomToPoint(p43, p44, p45) -- line: 657
	-- upvalues: calculateRotationCFrame (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), HardwareSafeAreaInsets (copy)
	local v188, v189 = p43:calculateCameraOffsetAngles()
	local cachedFocusPoint = p43.cachedFocusPoint
	local v191 = cachedFocusPoint - p43:calculateCameraOrigin(cachedFocusPoint, (p43:calculateZoomRadius()))
	local v192 = calculateRotationCFrame(v191, v188, v189)
	local v193 = v192:VectorToObjectSpace(v191)
	local v194 = (p45 - ((if not GetFFlagLuaAppFixStudioNotchSupport() then p43.camera.ViewportSize else HardwareSafeAreaInsets.fullscreenGui().AbsoluteSize)) / 2) * Vector2.new(1, -1)
	local v195 = p43:pixelOffsetToPositionOffset(v194)
	local v196 = Vector3.new(v195.X, v195.Y, v193.Z) - v193
	local v197, v198 = p43:calculateZoomOffsetBounds()

	p43.zoomOffset = p43.zoomOffset + p44
	p43:boundZoomOffset(v197, v198)

	local v199 = v192:VectorToObjectSpace(cachedFocusPoint - p43:calculateCameraOrigin(cachedFocusPoint, (p43:calculateZoomRadius())))
	local v200 = p43:pixelOffsetToPositionOffset(v194)
	local v201 = Vector3.new(v200.X, v200.Y, v193.Z) - v199

	p43.panOffset = p43.panOffset + v196 - v201
	p43:boundPanOffset()
	p43:handleCameraChange(true)
end
function t4.update(p46, p47, p48, p49, p50) -- line: 702
	-- upvalues: AvatarScreen (copy), Utils (copy), Constants (copy), FFlagAXCustomizeMakeupSupport (copy)
	local name = p49.current.name
	local name2 = p50.current.name
	local v209 = name ~= AvatarScreen.AvatarExperienceLandingPage and not Utils.isAvatarBackground(name)
	local v210 = name2 ~= AvatarScreen.AvatarExperienceLandingPage and not Utils.isAvatarBackground(name2)
	local v211 = not v209 and v210
	local v212 = v209 and not v210

	if v211 then
		if #p46.interactionConnections > 0 then
			p46:disconnectInteractionEvents()
		end
	elseif v212 and #p46.interactionConnections == 0 then
		p46:connectInteractionEvents()
	end

	local CurrentCharacter = p47.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local v214 = Utils.getCategoryInfoFromState(p47, p49)

	if not CurrentCharacter or not v214 then
		return
	end

	local v215 = p46:useCenteredSceneView(p47, p49)
	local v216 = p46:useCenteredSceneView(p48, p50)
	local v217 = Utils.getCategoryInfoFromState(p48, p50)
	local CharacterModelVersion = p47.AvatarExperience.AvatarScene.Character.CharacterModelVersion
	local CharacterModelVersion2 = p48.AvatarExperience.AvatarScene.Character.CharacterModelVersion
	local TryOnCharacterModelVersion = p47.AvatarExperience.AvatarScene.Character.TryOnCharacterModelVersion
	local TryOnCharacterModelVersion2 = p48.AvatarExperience.AvatarScene.Character.TryOnCharacterModelVersion
	local v222 = CharacterModelVersion ~= CharacterModelVersion2 or TryOnCharacterModelVersion ~= TryOnCharacterModelVersion2
	local CurrentCharacter2 = p48.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local v224 = Utils.getTopBarHeightAvatarScene(p47)
	local v225 = Utils.getTopBarHeightAvatarScene(p48)
	local v226 = p47.DeviceOrientation ~= p48.DeviceOrientation
	local v227 = p47.ScreenSize ~= p48.ScreenSize
	local v228 = p50.opaque.name == AvatarScreen.TryOnItem
	local v229 = p49.opaque.name == AvatarScreen.TryOnItem
	local v230 = not v228 and v229
	local AvatarType = p47.AvatarExperience.AvatarEditor.Character.AvatarType
	local v232 = Constants.AvatarTypeFocusGroups[AvatarType][v214.CameraFocus]
	local v233 = p47.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId ~= p48.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId
	local v234 = p46.lastCategoryInfo ~= nil and v214 ~= p46.lastCategoryInfo
	local v235 = v215 ~= v216 or (v214 ~= v217 or v234)

	if v235 then
		p46.panOffset = Vector3.new()
		p46.zoomOffset = 0
	end

	local v236 = v233 or (v235 or (CurrentCharacter ~= CurrentCharacter2 or not v232 and v222))

	if v236 then
		local cachedFocusPoint = p46.cachedFocusPoint

		p46.cachedFocusPoint = p46:calculateFocusPoint()

		local cachedBaseZoomRadius = p46.cachedBaseZoomRadius

		p46.cachedBaseZoomRadius = p46:calculateBaseZoomRadius(p46.cachedFocusPoint)

		if FFlagAXCustomizeMakeupSupport and v214.CameraFocus == Constants.PartName.Makeup then
			p46.cachedBaseZoomRadius = v214.CameraZoomRadius
		end

		if not v235 then
			if p46.panOffset ~= Vector3.new() then
				local v239 = p46.cachedFocusPoint - cachedFocusPoint

				p46.panOffset = p46.panOffset - v239
			end

			if p46.zoomOffset ~= 0 then
				local v240 = p46.cachedBaseZoomRadius - cachedBaseZoomRadius

				p46.zoomOffset = p46.zoomOffset - v240
			end
		end
	end

	if v236 or v226 or v227 or v224 ~= v225 then
		p46:boundPanOffset()
		p46:boundZoomOffset()
		p46:handleCameraChange(v226 or v230)
	end

	p46.lastCategoryInfo = v214
end
function t4.updateState(p51, p52, p53) -- line: 815
	local avatarRoute = p51.avatarRoute

	p51:update(p52, p53, avatarRoute, avatarRoute)
end
function t4.updateAvatarRoute(p54, p55, p56) -- line: 820
	p54.avatarRoute = p55

	if p54.started then
		local v248 = p54.store:getState()

		p54:update(v248, v248, p55, p56)
	end
end
function t4.updateCategorySelection(p57) -- line: 828
	local v250 = p57.store:getState()

	p57:update(v250, v250, p57.avatarRoute, p57.avatarRoute)
end
function t4.connectInteractionEvents(p58) -- line: 834
	table.insert(p58.interactionConnections, p58.events.panByDistance:Connect(function(...) -- line: 837
		-- upvalues: p58 (copy)
		p58:panByDistance(...)
	end))
	table.insert(p58.interactionConnections, p58.events.panByPixels:Connect(function(...) -- line: 843
		-- upvalues: p58 (copy)
		p58:panByPixels(...)
	end))
	table.insert(p58.interactionConnections, p58.events.zoomStraight:Connect(function(...) -- line: 849
		-- upvalues: p58 (copy)
		p58:zoomStraight(...)
	end))
	table.insert(p58.interactionConnections, p58.events.zoomToPoint:Connect(function(...) -- line: 855
		-- upvalues: p58 (copy)
		p58:zoomToPoint(...)
	end))
end
function t4.disconnectInteractionEvents(p59) -- line: 861
	for _, v254 in p59.interactionConnections do
		v254:Disconnect()
	end

	p59.interactionConnections = {}
end
function t4.new(p60, p61, p62) -- line: 868
	-- upvalues: t4 (copy), v15 (copy)
	local t6 = {}

	setmetatable(t6, t4)
	t6.store = p60
	t6.avatarRoute = p61
	t6.events = p62
	t6.updateConnection = nil
	t6.interactionConnections = {}
	t6.camera = game.Workspace.CurrentCamera
	t6.isTweening = false
	t6.panOffset = Vector3.new()
	t6.zoomOffset = 0
	t6.cachedFocusPoint = if not v15 then nil else Vector3.new()
	t6.cachedBaseZoomRadius = if not v15 then nil else 0
	t6.started = false
	t6.lastCategoryInfo = nil

	return t6
end
function t4.start(p63) -- line: 895
	-- upvalues: v19 (copy), Utils (copy), AvatarScreen (copy)
	if p63.started then
		return
	end

	p63.started = true

	if v19 then
		p63.previousCFrame = p63.camera.CFrame
	end

	p63.cachedFocusPoint = p63:calculateFocusPoint()
	p63.cachedBaseZoomRadius = p63:calculateBaseZoomRadius(p63.cachedFocusPoint)

	local v260 = p63.store:getState()

	p63.lastCategoryInfo = Utils.getCategoryInfoFromState(v260, p63.avatarRoute)

	local name = p63.avatarRoute.current.name

	if name ~= AvatarScreen.AvatarExperienceLandingPage and not Utils.isAvatarBackground(name) then
		p63:connectInteractionEvents()
	end

	p63.updateConnection = p63.store.changed:connect(function(...) -- line: 917
		-- upvalues: p63 (copy)
		p63:updateState(...)
	end)
	p63.camera.CameraType = Enum.CameraType.Scriptable
	p63.camera.FieldOfView = 50

	if v260.AvatarExperience.AvatarScene.Character.CurrentCharacter then
		p63.cachedBaseZoomRadius = p63:calculateBaseZoomRadius(p63.cachedFocusPoint)
		p63:handleCameraChange(true)
	end
end
function t4.cancelTween(p64) -- line: 932
	if p64.tween then
		p64.tween:Cancel()
		p64.tween = nil
		p64.isTweening = false
	end
end
function t4.stop(p65) -- line: 940
	-- upvalues: v19 (copy)
	if not p65.started then
		return
	end

	p65.started = false
	p65:cancelTween()
	p65.updateConnection:disconnect()
	p65:disconnectInteractionEvents()

	if v19 then
		p65.camera.CFrame = p65.previousCFrame
	end
end
function t4.onDestroy(_) -- line: 953
end

return t4
