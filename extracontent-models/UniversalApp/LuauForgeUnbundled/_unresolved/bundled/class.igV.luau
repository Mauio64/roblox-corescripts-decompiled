local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local module = require("@luauforge/bundled/fuD")
local module2 = require("@luauforge/bundled/igW")
local module3 = require("@luauforge/bundled/fvu")
local module4 = require("@luauforge/bundled/igX")
local module5 = require("@luauforge/bundled/dMx")

local fFlagEnableSplitPaneAvatarOverlay = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPaneAvatarOverlay

local fFlagAXPauseSceneWhenSplitPaneCollapsed = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXPauseSceneWhenSplitPaneCollapsed

local splitPaneStore = if fFlagEnableSplitPaneAvatarOverlay then require("@luauforge/bundled/dFR").SplitPaneStore else nil

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0)

local function minAbs(p2, p3)
	if math.abs(p2) < math.abs(p3) then
		return p2
	end

	return p3
end

local function minDeltaAngle(p2)
	return (p2 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local class = {}
class.__index = class

local function normalizeAngle(p2)
	return (p2 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

function class:resetRotation(p2)
	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not currentCharacter then
		return
	end

	local orientation, v5, v6 = currentCharacter.HumanoidRootPart.CFrame:ToOrientation()
	local v7 = (v5 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local v8 = (orientation + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

	self:rotateByRadians(-(v7 + 1.5707963267948966), -v8, not p2)
end

function class:cancelCurrentTween()
	if self.currentTween then
		self.currentTween:Cancel()
		self.currentTween = nil
	end
end

function class:rotateByRadiansPreservingY(value, value2, flag)
	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not currentCharacter then
		return
	end

	local humanoidRootPart = currentCharacter.HumanoidRootPart

	if not humanoidRootPart then
		return
	end

	local eulerAnglesYXZ, v7, v8 = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
	local v9 = (v7 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local v10 = (eulerAnglesYXZ + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local vector2 = Vector2.new(
		(v9 + (value or 0) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793,
		(v10 + (value2 or 0) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	)

	if not self.angleTweenValues then
		self.angleTweenValues = Instance.new("NumberValue")
	end

	self.angleTweenValues.Value = v9

	if math.abs(v9 - vector2.X) < 0.001 then
		flag = false
	end

	if flag then
		self.yAngularVelocity = 0
		self:cancelCurrentTween()

		local v12 = { Value = vector2.X }

		local tween = TweenService:Create(self.angleTweenValues, tweenInfo, v12)
		self.currentTween = tween

		tween:Play()
		task.spawn(function()
			while tween.PlaybackState == Enum.PlaybackState.Playing do
				if not (humanoidRootPart and humanoidRootPart.Parent) then
					break
				end

				local value3 = self.angleTweenValues.Value

				local cframe = CFrame.fromEulerAnglesYXZ(v10, value3, 0)

				humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * cframe
				task.wait()
			end
		end)
	else
		humanoidRootPart.CFrame = CFrame.new(
			humanoidRootPart.Position.X,
			humanoidRootPart.Position.Y,
			humanoidRootPart.Position.Z
		) * CFrame.fromEulerAnglesYXZ(v10, vector2.X, 0)
	end

	if
		self.cameraManager
		and (not fFlagAXPauseSceneWhenSplitPaneCollapsed or self.cameraManager.started)
		and self.cameraManager:boundPanOffset()
		and not self.cameraManager.isTweening
	then
		self.cameraManager:handleCameraChange(true)
	end
end

function class:rotateByRadians(p2, p3, p4)
	self:rotateByRadiansPreservingY(p2, p3, p4)
end

function class:rotateByPixels(p2)
	if self.cameraManager then
		self:rotateByRadians(self.cameraManager:pixelOffsetToPositionOffset(Vector2.new(p2, 0)).X * 0.436)
	end
end

function class:setAngularVelocityByPixels(p2)
	if self.cameraManager then
		self.yAngularVelocity = math.clamp(
			self.cameraManager:pixelOffsetToPositionOffset(Vector2.new(p2, 0)).X * 0.436,
			-14.835298641951802,
			14.835298641951802
		)

		if self.yAngularVelocity ~= 0 and not self.renderSteppedConnection then
			self.renderSteppedConnection = RunService.RenderStepped:Connect(function(...)
				self:onRenderStepped(...)
			end)
		end
	end
end

function class:onRenderStepped(p2)
	local v5 = p2 * self.yAngularVelocity

	self.yAngularVelocity *= math.pow(0.010000000000000009, p2)

	if math.abs(self.yAngularVelocity) < 0.0001 then
		self.yAngularVelocity = 0
	end

	local v6 = ((self.store:getState().AvatarExperience.AvatarScene.Character.PlayingSwimAnimation and -1.0471975511965976 or 0) - self.angleOffset.X + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local v7 = math.sign(v6)
	local v8 = 2.0943951023931953 * p2 * v7

	if math.abs(v6) < math.abs(v8) then
		v8 = v6
	end

	if v8 ~= 0 or v5 ~= 0 then
		self:rotateByRadians(v5, v8)
	end

	if self.yAngularVelocity == 0 and math.abs(v6) < 0.0001 then
		self.renderSteppedConnection:Disconnect()
		self.renderSteppedConnection = nil
	end
end

function class:update(p2, p3, p4, p5, p6)
	if
		p2.AvatarExperience.AvatarScene.Character.PlayingSwimAnimation ~= p3.AvatarExperience.AvatarScene.Character.PlayingSwimAnimation
		and not self.renderSteppedConnection
	then
		self.renderSteppedConnection = RunService.RenderStepped:Connect(function(...)
			self:onRenderStepped(...)
		end)
	end

	local categoryInfoFromState = module.getCategoryInfoFromState(p2, p4)
	local categoryInfoFromState2 = module.getCategoryInfoFromState(p3, p5)

	if fFlagEnableSplitPaneAvatarOverlay then
		local splitEnabledNow = splitPaneStore.isSplitEnabledNow()
		local v5 = splitEnabledNow and not self.wasSupportPaneActive
		self.wasSupportPaneActive = splitEnabledNow

		if v5 then
			self:resetRotation()
			return
		end
	end

	if categoryInfoFromState ~= categoryInfoFromState2 then
		if
			fFlagEnableSplitPaneAvatarOverlay
			and (categoryInfoFromState and categoryInfoFromState.PageType == module5.PageType.Other or categoryInfoFromState2 and categoryInfoFromState2.PageType == module5.PageType.Other)
			and splitPaneStore.isSplitEnabledNow()
		then
			return
		end

		self:resetRotation()
	end
end

function class:updateState(p2, p3)
	local avatarRoute = self.avatarRoute
	self:update(p2, p3, avatarRoute, avatarRoute)
end

function class:updateAvatarRoute(avatarRoute, p2)
	if self.ppeCameraManager or self.cameraManager then
		self.ppeCameraManager:updateAvatarRoute(avatarRoute, p2)
		self.cameraManager:updateAvatarRoute(avatarRoute, p2)

		local ppeScreenUsingPeekabooWidget = module3.isPPEScreenUsingPeekabooWidget(avatarRoute.opaque.name)
		local ppeScreenUsingPeekabooWidget2 = module3.isPPEScreenUsingPeekabooWidget(p2.opaque.name)

		if ppeScreenUsingPeekabooWidget and not ppeScreenUsingPeekabooWidget2 then
			self:resetRotation(true)
			self.cameraManager:stop()
			self.ppeCameraManager:start()
		elseif not ppeScreenUsingPeekabooWidget and ppeScreenUsingPeekabooWidget2 then
			self.cameraManager:start()
			self.ppeCameraManager:stop()
		end
	end

	self.avatarRoute = avatarRoute
	local state = self.store:getState()
	self:update(state, state, avatarRoute, p2)
end

function class:updateCategorySelection()
	local state = self.store:getState()

	self:update(state, state, self.avatarRoute, self.avatarRoute)
end

function class:onPPEPoseChanged()
	if self.ppeCameraManager then
		self.ppeCameraManager:onPPEPoseChanged()
	end
end

function class.new(store, avatarExperienceAnalytics, avatarRoute, events, p2)
	local v5 = {}
	setmetatable(v5, class)

	v5.cameraManager = nil
	v5.ppeCameraManager = nil

	if p2 then
		v5.cameraManager = module4.new(store, avatarRoute, events)
		v5.ppeCameraManager = module2.new(store, avatarRoute)
	end

	v5.store = store
	v5.avatarExperienceAnalytics = avatarExperienceAnalytics
	v5.avatarRoute = avatarRoute
	v5.events = events

	v5.bulkConnections = {}

	v5.camera = game.Workspace.CurrentCamera
	v5.initialAngles = nil
	v5.angleOffset = Vector2.new()
	v5.yAngularVelocity = 0

	v5.currentTween = nil

	if fFlagEnableSplitPaneAvatarOverlay then
		v5.wasSupportPaneActive = splitPaneStore.isSplitEnabledNow()
	end

	return v5
end

function class:shouldUsePPECameraManager()
	return module.routeIsPPEStaticImagePage(self.avatarRoute)
end

function class:start()
	if self:shouldUsePPECameraManager() then
		if self.ppeCameraManager then
			self.ppeCameraManager:start()
		end
	elseif self.cameraManager then
		self.cameraManager:start()
	end

	table.insert(self.bulkConnections, self.store.changed:connect(function(...)
		self:updateState(...)
	end))

	table.insert(self.bulkConnections, self.events.rotateByRadians:Connect(function(...)
		self:rotateByRadians(...)
	end))

	table.insert(self.bulkConnections, self.events.rotateByPixels:Connect(function(...)
		self:rotateByPixels(...)
	end))

	table.insert(self.bulkConnections, self.events.setAngularVelocityByPixels:Connect(function(...)
		self:setAngularVelocityByPixels(...)
	end))

	self:resetRotation()
end

function class:stop()
	for k, bulkConnection in self.bulkConnections do
		bulkConnection:disconnect()
	end

	self.bulkConnections = {}

	if self.renderSteppedConnection then
		self.renderSteppedConnection:Disconnect()
		self.renderSteppedConnection = nil
	end

	if self.cameraManager then
		self.cameraManager:stop()
	end

	if self.ppeCameraManager then
		self.ppeCameraManager:stop()
	end

	self:cancelCurrentTween()
end

function class:onDestroy()
	if self.cameraManager then
		self.cameraManager:onDestroy()
	end
end

return class
