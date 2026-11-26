local TweenService = game:GetService("TweenService")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local animationCategoryCameraZoomRadius = require("@luauforge/bundled/dPt").Constants.AnimationCategoryCameraZoomRadius

local module = require("@luauforge/bundled/dFs")
local module2 = require("@luauforge/bundled/fCe")
local module3 = require("@luauforge/bundled/gJT")
local module4 = require("@luauforge/bundled/dPN")

local hardwareSafeAreaInsets = require("@game/CorePackages/Workspace/Packages/Responsive").HardwareSafeAreaInsets

local fFlagLuaAppSupportDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSupportDeviceSafeInsets
local module5 = require("@luauforge/bundled/dXA")
local shouldUseDeviceSafeInsets = module5.shouldUseDeviceSafeInsets
local module6 = require("@luauforge/bundled/ipx")

local defineFastFlag = game:DefineFastFlag("AXFixCameraManagerInitialization", false)

local fFlagAXIncreaseDefaultPeekViewHeight = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXIncreaseDefaultPeekViewHeight

local fFlagAXPhotoboothMomentsStableCamera = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsStableCamera
local defineFastFlag2 = game:DefineFastFlag("AXCameraDownwardTilt", false)
local defineFastFlag3 = game:DefineFastFlag("AXFixCameraFramingForDeviceSafeInsets", false)

local defineFastFlag4 = game:DefineFastFlag("AXCameraLevelHorizon", false)

local defineFastFlag5 = game:DefineFastFlag("AXRecalculateCameraZoomOnOrientationChange", false)

local fFlagIncreaseMarketplaceContentHeight = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagIncreaseMarketplaceContentHeight

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay

local splitPaneStore = if fFlagEnableSplitPaneAvatarOverlay then require("@luauforge/bundled/dIW").SplitPaneStore else nil

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)

local cframe = CFrame.new(Vector3.new(-3, 2.5, 1.5), Vector3.new(-2, 2.5, 1.5))

local v6 = {
	[deviceOrientationMode.Portrait] = {
		cameraCenterScreenPosition = UDim2.new(
			0,
			0,
			-0.5,
			fFlagIncreaseMarketplaceContentHeight and (fFlagAXIncreaseDefaultPeekViewHeight and -7 or 8) or fFlagAXIncreaseDefaultPeekViewHeight and 25 or 40
		),
		baseCameraOrigin = Vector3.new(19.24339867, 0, defineFastFlag4 and 0 or 0.594265997),
		landingPageCameraCenterScreenPosition = UDim2.new(0, 0, -0.4, 40),
		landingPageZoomToFocusHeightRatio = 6.188,
		landingPageZoomAdjustmentForFocusPart = fFlagAXIncreaseDefaultPeekViewHeight and 1 or nil,
		zoomToFocusHeightRatio = fFlagIncreaseMarketplaceContentHeight and 10.9 or fFlagAXIncreaseDefaultPeekViewHeight and 9.7 or 8.704,
		zoomAdjustmentForFocusPart = fFlagIncreaseMarketplaceContentHeight and 1.35 or fFlagAXIncreaseDefaultPeekViewHeight and 1.2 or nil,
		fullViewZoomToFocusHeightRatio = 4.5,
		defaultVerticalFocusScale = 0.4,
		minZoomRadius = 5,
		maxZoomRadius = fFlagIncreaseMarketplaceContentHeight and 40 or fFlagAXIncreaseDefaultPeekViewHeight and 35 or 30
	},
	[deviceOrientationMode.Landscape] = {
		cameraCenterScreenPosition = UDim2.new(
			fFlagEnableSplitPane and 0 or module4.LandscapeNavWidth,
			0,
			0,
			-30
		),
		baseCameraOrigin = Vector3.new(9.24339867, 0, defineFastFlag4 and 0 or 0.594265997),
		zoomToFocusHeightRatio = 3.84,
		supportPaneZoomToFocusHeightRatio = fFlagEnableSplitPaneAvatarOverlay and 4.3 or nil,
		zoomAdjustmentForFocusPart = fFlagAXIncreaseDefaultPeekViewHeight and 1 or nil,
		landingPageZoomAdjustmentForFocusPart = fFlagAXIncreaseDefaultPeekViewHeight and 1 or nil,
		fullViewZoomToFocusHeightRatio = 3.6,
		defaultVerticalFocusScale = 0.5,
		minZoomRadius = 3,
		maxZoomRadius = 20
	}
}

local function adjustCameraCenterPosition(landingPageCameraCenterScreenPosition, topBarHeightAvatarScene, p2)
	if fFlagEnableSplitPane then
		return landingPageCameraCenterScreenPosition + UDim2.new(
			p2 ~= deviceOrientationMode.Landscape and 0 or v5.getLandscapeNavWidth(),
			0,
			0,
			topBarHeightAvatarScene - 64
		)
	end

	return landingPageCameraCenterScreenPosition - UDim2.new(0, 0, 0, 64 - topBarHeightAvatarScene)
end

local function calculateRotationCFrame(p2, cameraOffsetAngles, p3)
	if not defineFastFlag4 then
		return CFrame.new(Vector3.new(), p2) * CFrame.Angles(p3, cameraOffsetAngles, 0)
	end

	local lookVector = (CFrame.new(Vector3.new(), p2) * CFrame.Angles(0, cameraOffsetAngles, 0) * CFrame.Angles(p3, 0, 0)).LookVector
	return CFrame.new(Vector3.new(), lookVector)
end

local function getCharacterAvatarType(instance, p2)
	local humanoid = if instance then instance:FindFirstChildOfClass("Humanoid") else nil

	if humanoid == nil then
		return p2
	end

	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		return module4.AvatarType.R6
	end

	return module4.AvatarType.R15
end

local function isTryingOnAnimationBundle(p2): boolean
	local lastToggledItem = p2.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}

	if lastToggledItem.isUnequipped then
		return false
	end

	local animations = module4.BundleTypeIdStrings.Animations
	return lastToggledItem.itemSubType == animations
end

local function calculateFocusPointOfCharacterParts(currentCharacter, list)
	local count = #list

	if count == 0 then
		return module4.DefaultRigPosition
	end

	local total = Vector3.new()

	for k, item in list do
		if item.Attachment then
			local v7 = module2.getAttachmentCFrame(currentCharacter, item.Part, item.Attachment)

			if v7 == nil then
				v7 = module2.getPartCFrame(currentCharacter, item.Part)
			end

			total += v7.Position
		else
			total += module2.getPartCFrame(currentCharacter, item.Part).Position
		end
	end

	return total / count
end

local v7 = memoize(function(items)
	local v8 = {}

	for k, item in items do
		for k2, v10 in item do
			table.insert(v8, k2)
		end
	end

	return " equippedAssets=" .. table.concat(v8, ", ")
end)

local function calculateModel2DBoundingSizeRelativeToCFrame(currentCharacter, cframe2, equippedAssets)
	local cframe3, v8 = currentCharacter:GetBoundingBox()

	if not module2.isBoundingBoxVectorSane(v8) then
		if module6() then
			local v9 = v7(equippedAssets)
			module("(Avatar Experience) size = " .. v8.X .. ", " .. v8.Y .. ", " .. v8.Z .. v9)
		end

		v8 = Vector3.new(4, 6, 2)
	end

	if not module2.isBoundingBoxCFrameSane(cframe3) then
		if module6() then
			local v9 = v7(equippedAssets)
			module("(Avatar Experience) orientation = " .. cframe3.X .. ", " .. cframe3.Y .. ", " .. cframe3.Z .. v9)
		end

		cframe3 = cframe
	end

	if module6() and not module2.isBoundingBoxCFrameSane(cframe2) then
		local v9 = v7(equippedAssets)
		module("(Avatar Experience) cframe = " .. cframe2.X .. ", " .. cframe2.Y .. ", " .. cframe2.Z .. v9)
	end

	local v9 = v8 / 2
	local v10 = {
		Vector3.new(-v9.X, -v9.Y, -v9.Z),
		Vector3.new(v9.X, -v9.Y, -v9.Z),
		Vector3.new(v9.X, v9.Y, -v9.Z),
		Vector3.new(-v9.X, v9.Y, -v9.Z),
		Vector3.new(-v9.X, -v9.Y, v9.Z),
		Vector3.new(v9.X, -v9.Y, v9.Z),
		Vector3.new(v9.X, v9.Y, v9.Z),
		(Vector3.new(-v9.X, v9.Y, v9.Z))
	}
	local minX = 1e999
	local minY = 1e999
	local maxX = -1e999
	local maxY = -1e999

	for i = 1, #v10 do
		local pointToObjectSpace = cframe2:PointToObjectSpace(cframe3:PointToWorldSpace(v10[i]))

		minX = math.min(minX, pointToObjectSpace.X)
		minY = math.min(minY, pointToObjectSpace.Y)
		maxX = math.max(maxX, pointToObjectSpace.X)
		maxY = math.max(maxY, pointToObjectSpace.Y)

		if not module6() then
			continue
		end

		if maxX < minX then
			module("(Avatar Experience) maxX = " .. maxX .. ", minX = " .. minX)
		end

		if maxY < minY then
			module("(Avatar Experience) maxY = " .. maxY .. ", minY = " .. minY)
		end
	end

	return Vector2.new(maxX - minX, maxY - minY)
end

local function hasInteractionEvents(p2): boolean
	if p2 == avatarScreen.AvatarExperienceLandingPage or module2.isAvatarBackground(p2) then
		return false
	end

	return true
end

local class = {}
class.__index = class

function class:calculateFocusPoint()
	local state = self.store:getState()
	local v8 = self:useCenteredSceneView(state, self.avatarRoute)

	local categoryInfoFromState = module2.getCategoryInfoFromState(state, self.avatarRoute)
	local currentCharacter = state.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local v9

	if
		fFlagAXPhotoboothMomentsStableCamera
		and self.avatarRoute.opaque.name == avatarScreen.PhotoboothMomentsPage
	then
		v9 = state.AvatarExperience.AvatarEditor.Character.AvatarType
		local humanoid = if currentCharacter then currentCharacter:FindFirstChildOfClass("Humanoid") else nil

		if humanoid ~= nil then
			if humanoid.RigType == Enum.HumanoidRigType.R6 then
				v9 = module4.AvatarType.R6
			else
				v9 = module4.AvatarType.R15
			end
		end
	else
		v9 = state.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	local v10 = if fFlagEnableSplitPane then module3(state) else state.DeviceOrientation
	local v11 = module4.AvatarTypeFocusGroups[v9][categoryInfoFromState.CameraFocus]

	if v11 and not v8 then
		return calculateFocusPointOfCharacterParts(currentCharacter, v11)
	end

	local v12 = calculateFocusPointOfCharacterParts(currentCharacter, {
		{ Part = "HumanoidRootPart" }
	})
	local y = (currentCharacter:GetExtentsSize() * v6[v10].defaultVerticalFocusScale).Y

	local head = currentCharacter:FindFirstChild("Head")

	if head then
		if categoryInfoFromState.CameraFocus == module4.PartName.Makeup then
			y = head.Position.Y
		else
			y = math.min(head.Position.Y, y)
		end
	end

	return (Vector3.new(v12.X, y, v12.Z))
end

function class:calculateBaseZoomRadius(p2)
	local state = self.store:getState()

	local v8 = self:useCenteredSceneView(state, self.avatarRoute)

	local v9 = if fFlagEnableSplitPane then module3(state) else state.DeviceOrientation

	if v8 then
		return (state.AvatarExperience.AvatarScene.Character.CurrentCharacter:GetExtentsSize() * 0.5).Y * v6[v9].fullViewZoomToFocusHeightRatio
	end

	local name = self.avatarRoute.current.name

	local categoryInfoFromState = module2.getCategoryInfoFromState(state, self.avatarRoute)
	local v10

	if
		fFlagAXPhotoboothMomentsStableCamera
		and self.avatarRoute.opaque.name == avatarScreen.PhotoboothMomentsPage
	then
		local currentCharacter = state.AvatarExperience.AvatarScene.Character.CurrentCharacter
		v10 = state.AvatarExperience.AvatarEditor.Character.AvatarType
		local humanoid = if currentCharacter then currentCharacter:FindFirstChildOfClass("Humanoid") else nil

		if humanoid ~= nil then
			if humanoid.RigType == Enum.HumanoidRigType.R6 then
				v10 = module4.AvatarType.R6
			else
				v10 = module4.AvatarType.R15
			end
		end
	else
		v10 = state.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	local v11 = name == avatarScreen.AvatarExperienceLandingPage
	local v12 = module4.AvatarTypeFocusGroups[v10][categoryInfoFromState.CameraFocus] or nil
	local lastToggledItem = state.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}
	local v13

	if lastToggledItem.isUnequipped then
		v13 = false
	else
		local animations = module4.BundleTypeIdStrings.Animations
		v13 = lastToggledItem.itemSubType == animations
	end

	local v14

	if v13 then
		v14 = animationCategoryCameraZoomRadius
	else
		v14 = categoryInfoFromState.CameraZoomRadius or 0
	end

	if not v12 then
		local v15 = if fFlagEnableSplitPaneAvatarOverlay and splitPaneStore.isSplitEnabledNow() then v6[deviceOrientationMode.Landscape].supportPaneZoomToFocusHeightRatio else v11 and v6[v9].landingPageZoomToFocusHeightRatio or v6[v9].zoomToFocusHeightRatio

		v14 += p2.Y * v15
	end

	if fFlagAXIncreaseDefaultPeekViewHeight and v12 then
		local v15 = v6[v9].zoomAdjustmentForFocusPart

		if v11 then
			v15 = v6[v9].landingPageZoomAdjustmentForFocusPart
		end

		v14 *= v15
	end

	return v14
end

function class:calculateZoomRadius()
	return self.cachedBaseZoomRadius + self.zoomOffset
end

function class:calculateCameraOrigin(p3, p4)
	local state = self.store:getState()

	local v8 = if fFlagEnableSplitPane then module3(state) else state.DeviceOrientation
	local v9 = v6[v8].baseCameraOrigin - p3
	local cameraOrigin = p3 + Vector3.new(v9.x, 0, v9.z).Unit * p4

	if not defineFastFlag2 then
		return cameraOrigin
	end

	local v10 = v6[v8]
	local minZoomRadius = v10.minZoomRadius
	local maxZoomRadius = v10.maxZoomRadius
	cameraOrigin += Vector3.new(
		0,
		p4 * math.tan((not (minZoomRadius < maxZoomRadius) and 0 or math.clamp(
			(p4 - minZoomRadius) / (maxZoomRadius - minZoomRadius),
			0,
			1
		)) * 0.11344640137963143 + 0),
		0
	)

	return cameraOrigin
end

function class:calculateHalfFieldsOfView()
	local v8

	if fFlagLuaAppSupportDeviceSafeInsets then
		v8 = hardwareSafeAreaInsets.fullscreenGui().AbsoluteSize
	else
		v8 = self.camera.ViewportSize
	end

	local x = v8.X
	local y = v8.Y

	return math.atan(0.4663076581549986 * x / y), 0.4363323129985824
end

function class:useCenteredSceneView(p3, p4)
	return p4.opaque.name == avatarScreen.TryOnItem or module2.getIsSceneFullViewFromState(p3, p4)
end

function class.getPeekViewHeight(p2)
	local itemDetailsPeekView = p2.store:getState().AvatarExperience.Common.ItemDetailsPeekView

	if itemDetailsPeekView.viewState == peekViewState.Brief and itemDetailsPeekView.briefViewHeight then
		return itemDetailsPeekView.briefViewHeight
	end

	return 0
end

function class:calculateCameraOffsetAngles()
	local state = self.store:getState()

	if self:useCenteredSceneView(state, self.avatarRoute) then
		return 0, 0
	end

	local v8 = if fFlagEnableSplitPane then module3(state) else state.DeviceOrientation
	local name = self.avatarRoute.current.name
	local topBarHeightAvatarScene = module2.getTopBarHeightAvatarScene(state)

	if defineFastFlag3 and shouldUseDeviceSafeInsets then
		topBarHeightAvatarScene += module5.GetDisplayStore().getDeviceSafePadding().top
	end

	local landingPageCameraCenterScreenPosition = name == avatarScreen.AvatarExperienceLandingPage
		and v6[v8].landingPageCameraCenterScreenPosition
		or v6[v8].cameraCenterScreenPosition

	local v9 = adjustCameraCenterPosition(
		landingPageCameraCenterScreenPosition,
		topBarHeightAvatarScene,
		v8
	)

	local halfFieldsOfView, v10 = self:calculateHalfFieldsOfView()
	local v11

	if fFlagLuaAppSupportDeviceSafeInsets then
		v11 = hardwareSafeAreaInsets.fullscreenGui().AbsoluteSize
	else
		v11 = self.camera.ViewportSize
	end

	local x = v11.X
	local y = v11.Y

	return
		math.atan(math.tan(halfFieldsOfView) * (v9.X.Scale + 2 * v9.X.Offset / x)),
		(math.atan(math.tan(v10) * (v9.Y.Scale + 2 * v9.Y.Offset / y)))
end

function class:pixelOffsetToPositionOffset(p2)
	local cameraOffsetAngles, v8 = self:calculateCameraOffsetAngles()
	local halfFieldsOfView, v9 = self:calculateHalfFieldsOfView()

	local cachedFocusPoint = self.cachedFocusPoint
	local v10 = cachedFocusPoint - self:calculateCameraOrigin(
		cachedFocusPoint,
		(self:calculateZoomRadius())
	)
	local vectorToObjectSpace = calculateRotationCFrame(v10, cameraOffsetAngles, v8):VectorToObjectSpace(v10)

	local v11 = if fFlagLuaAppSupportDeviceSafeInsets then hardwareSafeAreaInsets.fullscreenGui().AbsoluteSize else self.camera.ViewportSize
	return p2 / v11 * Vector2.new(math.tan(halfFieldsOfView), (math.tan(v9))) * -vectorToObjectSpace.Z * 2
end

function class:tweenCameraIntoPlace(p2, p3, p4)
	local cameraOffsetAngles, v8 = self:calculateCameraOffsetAngles()
	local v10 = calculateRotationCFrame(p3 - p2, cameraOffsetAngles, v8)

	local panOffset = self.panOffset

	local v11 = v10.LookVector:Cross(Vector3.new(0, 1, 0)).Unit * panOffset.X + Vector3.new(0, 1, 0) * panOffset.Y

	local v12 = CFrame.new(p2 + v11) * v10

	self:cancelTween()

	if p4 then
		self.camera.CFrame = v12
		return
	end

	self.isTweening = true
	local tween = TweenService:Create(self.camera, tweenInfo, { CFrame = v12 })
	tween.Completed:Connect(function()
		self.isTweening = false
		self.tween = nil
	end)
	tween:Play()
	self.tween = tween
end

function class:boundPanOffset()
	local state = self.store:getState()
	local currentCharacter = state.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not currentCharacter then
		return
	end

	local halfFieldsOfView, v8 = self:calculateHalfFieldsOfView()
	local cameraOffsetAngles, v9 = self:calculateCameraOffsetAngles()

	local cachedFocusPoint = self.cachedFocusPoint
	local cameraOrigin = self:calculateCameraOrigin(cachedFocusPoint, (self:calculateZoomRadius()))

	local v11 = calculateRotationCFrame(cachedFocusPoint - cameraOrigin, cameraOffsetAngles, v9)
	local v12 = CFrame.new(cameraOrigin) * v11

	local v13 = -self.camera.NearPlaneZ
	local v14 = math.tan(v8) * v13

	local v15 = math.sqrt(v14 * v14 + v13 * v13)
	local v16 = math.sin(v8 + v9) * v15 - cameraOrigin.Y + 0.01

	local v17 = calculateModel2DBoundingSizeRelativeToCFrame(
		currentCharacter,
		v12,
		state.AvatarExperience.AvatarEditor.Character.EquippedAssets
	) / 2

	if module6() then
		if v17.X < 0 then
			module("(Avatar Experience) characterHalf2DBoundingSize.X = " .. v17.X)
		end

		if v17.Y < 0 then
			module("(Avatar Experience) characterHalf2DBoundingSize.Y = " .. v17.Y)
		end
	end

	local vector2 = Vector2.new(math.max(0, v17.X), (math.max(0, v17.Y)))

	local panOffset = self.panOffset

	self.panOffset = Vector3.new(
		math.clamp(self.panOffset.X, -vector2.X, vector2.X),
		math.clamp(self.panOffset.Y, math.max(v16, -vector2.Y), (math.max(v16, vector2.Y))),
		self.panOffset.Z
	)

	return panOffset ~= self.panOffset
end

function class:calculateZoomOffsetBounds()
	local state = self.store:getState()

	local v8 = if fFlagEnableSplitPane then module3(state) else state.DeviceOrientation
	local v9 = v6[v8]

	local cachedBaseZoomRadius = self.cachedBaseZoomRadius

	return v9.minZoomRadius - cachedBaseZoomRadius, v9.maxZoomRadius - cachedBaseZoomRadius
end

function class:boundZoomOffset(min, max): boolean
	if not (min and max) then
		min, max = self:calculateZoomOffsetBounds()
	end

	local zoomOffset = self.zoomOffset

	self.zoomOffset = math.clamp(self.zoomOffset, min, max)

	return zoomOffset ~= self.zoomOffset
end

function class:handleCameraChange(p2)
	if not self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter then
		return
	end

	local cachedFocusPoint = self.cachedFocusPoint
	self:tweenCameraIntoPlace(
		self:calculateCameraOrigin(cachedFocusPoint, (self:calculateZoomRadius())),
		cachedFocusPoint,
		p2
	)
end

function class:panByDistance(p2)
	self.panOffset = Vector3.new(self.panOffset.X + p2.X, self.panOffset.Y + p2.Y, 0)
	self:boundPanOffset()
	self:handleCameraChange(true)
end

function class:panByPixels(p2)
	self:panByDistance((self:pixelOffsetToPositionOffset(p2)))
end

function class:zoomStraight(p2)
	self.zoomOffset += p2
	self:boundZoomOffset()
	self:handleCameraChange(true)
end

function class:zoomToPoint(p2, p3)
	local cameraOffsetAngles, v8 = self:calculateCameraOffsetAngles()

	local cachedFocusPoint = self.cachedFocusPoint
	local v9 = cachedFocusPoint - self:calculateCameraOrigin(cachedFocusPoint, (self:calculateZoomRadius()))
	local cframe2 = calculateRotationCFrame(v9, cameraOffsetAngles, v8)
	local vectorToObjectSpace = cframe2:VectorToObjectSpace(v9)

	local v10 = if fFlagLuaAppSupportDeviceSafeInsets then hardwareSafeAreaInsets.fullscreenGui().AbsoluteSize else self.camera.ViewportSize
	local v11 = (p3 - v10 / 2) * Vector2.new(1, -1)
	local pixelOffsetToPositionOffset = self:pixelOffsetToPositionOffset(v11)

	local v12 = Vector3.new(
		pixelOffsetToPositionOffset.X,
		pixelOffsetToPositionOffset.Y,
		vectorToObjectSpace.Z
	) - vectorToObjectSpace

	local zoomOffsetBounds, v13 = self:calculateZoomOffsetBounds()
	self.zoomOffset += p2
	self:boundZoomOffset(zoomOffsetBounds, v13)

	local vectorToObjectSpace2 = cframe2:VectorToObjectSpace(cachedFocusPoint - self:calculateCameraOrigin(
		cachedFocusPoint,
		(self:calculateZoomRadius())
	))

	local pixelOffsetToPositionOffset2 = self:pixelOffsetToPositionOffset(v11)

	local v14 = Vector3.new(
		pixelOffsetToPositionOffset2.X,
		pixelOffsetToPositionOffset2.Y,
		vectorToObjectSpace.Z
	) - vectorToObjectSpace2

	self.panOffset = self.panOffset + v12 - v14
	self:boundPanOffset()

	self:handleCameraChange(true)
end

function class:update(data, data2, p2, p3)
	local name = p2.current.name
	local name2 = p3.current.name
	local v8 = name ~= avatarScreen.AvatarExperienceLandingPage and not module2.isAvatarBackground(name)
	local v9 = name2 ~= avatarScreen.AvatarExperienceLandingPage and not module2.isAvatarBackground(name2)
	local v10 = v8 and not v9

	if not v8 and v9 then
		if #self.interactionConnections > 0 then
			self:disconnectInteractionEvents()
		end
	elseif v10 and #self.interactionConnections == 0 then
		self:connectInteractionEvents()
	end

	local currentCharacter = data.AvatarExperience.AvatarScene.Character.CurrentCharacter

	local categoryInfoFromState = module2.getCategoryInfoFromState(data, p2)

	if not (currentCharacter and categoryInfoFromState) then
		return
	end

	local v11 = self:useCenteredSceneView(data, p2)
	local v12 = self:useCenteredSceneView(data2, p3)

	local categoryInfoFromState2 = module2.getCategoryInfoFromState(data2, p3)

	local characterModelVersion = data.AvatarExperience.AvatarScene.Character.CharacterModelVersion
	local characterModelVersion2 = data2.AvatarExperience.AvatarScene.Character.CharacterModelVersion
	local tryOnCharacterModelVersion = data.AvatarExperience.AvatarScene.Character.TryOnCharacterModelVersion
	local tryOnCharacterModelVersion2 = data2.AvatarExperience.AvatarScene.Character.TryOnCharacterModelVersion
	local v13 = characterModelVersion ~= characterModelVersion2
		or tryOnCharacterModelVersion ~= tryOnCharacterModelVersion2
	local currentCharacter2 = data2.AvatarExperience.AvatarScene.Character.CurrentCharacter

	local topBarHeightAvatarScene = module2.getTopBarHeightAvatarScene(data)
	local topBarHeightAvatarScene2 = module2.getTopBarHeightAvatarScene(data2)

	local v14 = data.DeviceOrientation ~= data2.DeviceOrientation
	local v15 = data.ScreenSize ~= data2.ScreenSize

	local v16 = p3.opaque.name == avatarScreen.TryOnItem
	local v17 = p2.opaque.name == avatarScreen.TryOnItem
	local v18 = not v16 and v17

	local v19 = fFlagAXPhotoboothMomentsStableCamera
		and p2.opaque.name == avatarScreen.PhotoboothMomentsPage
	local v20

	if v19 then
		v20 = data.AvatarExperience.AvatarEditor.Character.AvatarType
		local humanoid = if currentCharacter then currentCharacter:FindFirstChildOfClass("Humanoid") else nil

		if humanoid ~= nil then
			if humanoid.RigType == Enum.HumanoidRigType.R6 then
				v20 = module4.AvatarType.R6
			else
				v20 = module4.AvatarType.R15
			end
		end
	else
		v20 = data.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	local v21 = module4.AvatarTypeFocusGroups[v20][categoryInfoFromState.CameraFocus]

	local lastSuccessfulPoseEmoteAssetId = data.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId
	local v22 = data2.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId ~= lastSuccessfulPoseEmoteAssetId

	local v23 = self.lastCategoryInfo ~= nil and categoryInfoFromState ~= self.lastCategoryInfo
	local v24 = v11 ~= v12 or (categoryInfoFromState ~= categoryInfoFromState2 or v23)

	if v24 then
		self.panOffset = Vector3.new()
		self.zoomOffset = 0
	end

	local v25 = v19 and self.isAwaitingCharacterSwapApply and v13

	if v22 then
		v13 = v22
	elseif v24 then
		v13 = v24
	elseif currentCharacter == currentCharacter2 then
		if v21 or not v13 then
			v13 = defineFastFlag5 and v14 or v25
		end
	else
		v13 = true
	end

	if v19 then
		if currentCharacter == currentCharacter2 then
			if v25 then
				self.isAwaitingCharacterSwapApply = false
			end
		else
			self.isAwaitingCharacterSwapApply = true
		end
	end

	if v13 then
		local cachedFocusPoint = self.cachedFocusPoint
		self.cachedFocusPoint = self:calculateFocusPoint()

		local cachedBaseZoomRadius = self.cachedBaseZoomRadius
		self.cachedBaseZoomRadius = self:calculateBaseZoomRadius(self.cachedFocusPoint)

		if categoryInfoFromState.CameraFocus == module4.PartName.Makeup then
			self.cachedBaseZoomRadius = categoryInfoFromState.CameraZoomRadius
		end

		if not v24 then
			if self.panOffset ~= Vector3.new() then
				local v26 = self.cachedFocusPoint - cachedFocusPoint
				self.panOffset -= v26
			end

			if self.zoomOffset ~= 0 then
				local v26 = self.cachedBaseZoomRadius - cachedBaseZoomRadius
				self.zoomOffset -= v26
			end
		end
	end

	if v13 or v14 or v15 or topBarHeightAvatarScene ~= topBarHeightAvatarScene2 then
		self:boundPanOffset()
		self:boundZoomOffset()
		self:handleCameraChange(v14 or v18)
	end

	self.lastCategoryInfo = categoryInfoFromState
end

function class:updateState(p2, p3)
	local avatarRoute = self.avatarRoute
	self:update(p2, p3, avatarRoute, avatarRoute)
end

function class:updateAvatarRoute(avatarRoute, p2)
	self.avatarRoute = avatarRoute

	if self.started then
		local state = self.store:getState()
		self:update(state, state, avatarRoute, p2)
	end
end

function class:updateCategorySelection()
	local state = self.store:getState()

	self:update(state, state, self.avatarRoute, self.avatarRoute)
end

function class:connectInteractionEvents()
	table.insert(self.interactionConnections, self.events.panByDistance:Connect(function(...)
		self:panByDistance(...)
	end))

	table.insert(self.interactionConnections, self.events.panByPixels:Connect(function(...)
		self:panByPixels(...)
	end))

	table.insert(self.interactionConnections, self.events.zoomStraight:Connect(function(...)
		self:zoomStraight(...)
	end))

	table.insert(self.interactionConnections, self.events.zoomToPoint:Connect(function(...)
		self:zoomToPoint(...)
	end))
end

function class:disconnectInteractionEvents()
	for k, interactionConnection in self.interactionConnections do
		interactionConnection:Disconnect()
	end

	self.interactionConnections = {}
end

function class.new(store, avatarRoute, events)
	local v8 = {}
	setmetatable(v8, class)

	v8.store = store
	v8.avatarRoute = avatarRoute
	v8.events = events

	v8.updateConnection = nil
	v8.interactionConnections = {}

	v8.camera = game.Workspace.CurrentCamera
	v8.isTweening = false
	v8.isAwaitingCharacterSwapApply = false
	v8.panOffset = Vector3.new()
	v8.zoomOffset = 0

	local v9 = if defineFastFlag then Vector3.new() else nil
	v8.cachedFocusPoint = v9
	v8.cachedBaseZoomRadius = defineFastFlag and 0 or nil

	v8.started = false
	v8.lastCategoryInfo = nil

	return v8
end

function class:start()
	if self.started then
		return
	end

	self.started = true
	self.previousCFrame = self.camera.CFrame
	self.cachedFocusPoint = self:calculateFocusPoint()
	self.cachedBaseZoomRadius = self:calculateBaseZoomRadius(self.cachedFocusPoint)

	local state = self.store:getState()

	self.lastCategoryInfo = module2.getCategoryInfoFromState(state, self.avatarRoute)

	local name = self.avatarRoute.current.name

	if name ~= avatarScreen.AvatarExperienceLandingPage and not module2.isAvatarBackground(name) then
		self:connectInteractionEvents()
	end

	self.updateConnection = self.store.changed:connect(function(...)
		self:updateState(...)
	end)

	self.camera.CameraType = Enum.CameraType.Scriptable

	self.camera.FieldOfView = 50

	if state.AvatarExperience.AvatarScene.Character.CurrentCharacter then
		self.cachedBaseZoomRadius = self:calculateBaseZoomRadius(self.cachedFocusPoint)
		self:handleCameraChange(true)
	end
end

function class:cancelTween()
	if self.tween then
		self.tween:Cancel()
		self.tween = nil
		self.isTweening = false
	end
end

function class:stop()
	if not self.started then
		return
	end

	self.started = false
	self:cancelTween()
	self.updateConnection:disconnect()
	self:disconnectInteractionEvents()
	self.camera.CFrame = self.previousCFrame
end

function class:onDestroy() end

return class
