local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local PPECameraManager = require(Modules.AvatarExperience.ProfilePictureEditor.Managers.PPECameraManager)
local Utils2 = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)
local CameraManager = require(Modules.AvatarExperience.Common.Managers.CameraManager)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0)

local function minAbs(p1, p2) -- line: 28
	if math.abs(p1) < math.abs(p2) then
		return p1
	end

	return p2
end
local function minDeltaAngle(p3) -- line: 39
	return (p3 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local t1 = {}

t1.__index = t1

local function normalizeAngle(p4) -- line: 47
	return (p4 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

function t1.resetRotation(p5, p6) -- line: 51
	local CurrentCharacter = p5.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return
	end

	local v22 = true

	if p6 then
		v22 = false
	end

	local v23, v24, _ = CurrentCharacter.HumanoidRootPart.CFrame:ToOrientation()
	local v26 = (v24 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local v27 = (v23 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

	p5:rotateByRadians(-(v26 + 1.5707963267948966), -v27, v22)
end
function t1.cancelCurrentTween(p7) -- line: 77
	if p7.currentTween then
		p7.currentTween:Cancel()
		p7.currentTween = nil
	end
end
function t1.rotateByRadiansPreservingY(p8, p9, p10, p11) -- line: 84
	-- upvalues: tweenInfo (copy), TweenService (copy)
	local v33 = p9 or 0
	local v34 = p10 or 0
	local CurrentCharacter = p8.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return
	end

	local HumanoidRootPart = CurrentCharacter.HumanoidRootPart

	if not HumanoidRootPart then
		return
	end

	local v37, v38, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
	local v40 = (v38 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local v41 = (v37 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local vector2 = Vector2.new((v40 + v33 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793, (v41 + v34 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793)

	if not p8.angleTweenValues then
		p8.angleTweenValues = Instance.new("NumberValue")
	end

	p8.angleTweenValues.Value = v40

	if math.abs(v40 - vector2.X) < 0.001 then
		p11 = false
	end

	if p11 then
		p8.yAngularVelocity = 0
		p8:cancelCurrentTween()

		local v43 = tweenInfo
		local t2 = {
			Value = vector2.X
		}
		local tween = TweenService:Create(p8.angleTweenValues, v43, t2)

		p8.currentTween = tween
		tween:Play()
		task.spawn(function() -- line: 133
			-- upvalues: tween (copy), HumanoidRootPart (copy), p8 (copy), v41 (copy)
			while tween.PlaybackState == Enum.PlaybackState.Playing do
				if not HumanoidRootPart or not HumanoidRootPart.Parent then
					return
				end

				local angleTweenValuesValue = p8.angleTweenValues.Value
				local cFrame = CFrame.fromEulerAnglesYXZ(v41, angleTweenValuesValue, 0)

				HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * cFrame
				task.wait()
			end
		end)
	else
		HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, HumanoidRootPart.Position.Z) * CFrame.fromEulerAnglesYXZ(v41, vector2.X, 0)
	end

	if p8.cameraManager and p8.cameraManager:boundPanOffset() and not p8.cameraManager.isTweening then
		p8.cameraManager:handleCameraChange(true)
	end
end
function t1.rotateByRadians(p12, p13, p14, p15) -- line: 170
	p12:rotateByRadiansPreservingY(p13, p14, p15)
end
function t1.rotateByPixels(p16, p17) -- line: 174
	if p16.cameraManager then
		p16:rotateByRadians(p16.cameraManager:pixelOffsetToPositionOffset(Vector2.new(p17, 0)).X * 0.436)
	end
end
function t1.setAngularVelocityByPixels(p18, p19) -- line: 181
	-- upvalues: RunService (copy)
	if p18.cameraManager then
		p18.yAngularVelocity = math.clamp(p18.cameraManager:pixelOffsetToPositionOffset(Vector2.new(p19, 0)).X * 0.436, -14.835298641951802, 14.835298641951802)

		if p18.yAngularVelocity ~= 0 and not p18.renderSteppedConnection then
			p18.renderSteppedConnection = RunService.RenderStepped:Connect(function(...) -- line: 188
				-- upvalues: p18 (copy)
				p18:onRenderStepped(...)
			end)
		end
	end
end
function t1.onRenderStepped(p20, p21) -- line: 195
	local v56 = p21 * p20.yAngularVelocity

	p20.yAngularVelocity = p20.yAngularVelocity * math.pow(0.010000000000000009, p21)

	if math.abs(p20.yAngularVelocity) < 0.0001 then
		p20.yAngularVelocity = 0
	end

	local v57 = ((not p20.store:getState().AvatarExperience.AvatarScene.Character.PlayingSwimAnimation and 0 or -1.0471975511965976) - p20.angleOffset.X + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	local v58 = math.sign(v57)
	local v59 = 2.0943951023931953 * p21 * v58
	local v60 = if not (math.abs(v57) < math.abs(v59)) then v59 else v57

	if v60 ~= 0 or v56 ~= 0 then
		p20:rotateByRadians(v56, v60)
	end

	if p20.yAngularVelocity == 0 and math.abs(v57) < 0.0001 then
		p20.renderSteppedConnection:Disconnect()
		p20.renderSteppedConnection = nil
	end
end
function t1.update(p22, p23, p24, p25, p26, _) -- line: 225
	-- upvalues: RunService (copy), Utils (copy)
	if p23.AvatarExperience.AvatarScene.Character.PlayingSwimAnimation ~= p24.AvatarExperience.AvatarScene.Character.PlayingSwimAnimation and not p22.renderSteppedConnection then
		p22.renderSteppedConnection = RunService.RenderStepped:Connect(function(...) -- line: 230
			-- upvalues: p22 (copy)
			p22:onRenderStepped(...)
		end)
	end

	if Utils.getCategoryInfoFromState(p23, p25) ~= Utils.getCategoryInfoFromState(p24, p26) then
		p22:resetRotation()
	end
end
function t1.updateState(p28, p29, p30) -- line: 243
	local avatarRoute = p28.avatarRoute

	p28:update(p29, p30, avatarRoute, avatarRoute)
end
function t1.updateAvatarRoute(p31, p32, p33) -- line: 248
	-- upvalues: Utils2 (copy)
	if p31.ppeCameraManager or p31.cameraManager then
		p31.ppeCameraManager:updateAvatarRoute(p32, p33)
		p31.cameraManager:updateAvatarRoute(p32, p33)

		local v74 = Utils2.isPPEScreenUsingPeekabooWidget(p32.opaque.name)
		local v75 = Utils2.isPPEScreenUsingPeekabooWidget(p33.opaque.name)

		if v74 and not v75 then
			p31:resetRotation(true)
			p31.cameraManager:stop()
			p31.ppeCameraManager:start()
		elseif not v74 and v75 then
			p31.cameraManager:start()
			p31.ppeCameraManager:stop()
		end
	end

	p31.avatarRoute = p32

	local v76 = p31.store:getState()

	p31:update(v76, v76, p32, p33)
end
function t1.updateCategorySelection(p34) -- line: 277
	local v78 = p34.store:getState()

	p34:update(v78, v78, p34.avatarRoute, p34.avatarRoute)
end
function t1.onPPEPoseChanged(p35) -- line: 283
	if p35.ppeCameraManager then
		p35.ppeCameraManager:onPPEPoseChanged()
	end
end
function t1.new(p36, p37, p38, p39, p40) -- line: 289
	-- upvalues: t1 (copy), CameraManager (copy), PPECameraManager (copy)
	local t3 = {}

	setmetatable(t3, t1)
	t3.cameraManager = nil
	t3.ppeCameraManager = nil

	if p40 then
		t3.cameraManager = CameraManager.new(p36, p38, p39)
		t3.ppeCameraManager = PPECameraManager.new(p36, p38)
	end

	t3.store = p36
	t3.avatarExperienceAnalytics = p37
	t3.avatarRoute = p38
	t3.events = p39
	t3.bulkConnections = {}
	t3.camera = game.Workspace.CurrentCamera
	t3.initialAngles = nil
	t3.angleOffset = Vector2.new()
	t3.yAngularVelocity = 0
	t3.currentTween = nil

	return t3
end
function t1.shouldUsePPECameraManager(p41) -- line: 317
	-- upvalues: Utils (copy)
	return Utils.routeIsPPEStaticImagePage(p41.avatarRoute)
end
function t1.start(p42) -- line: 321
	if p42:shouldUsePPECameraManager() then
		if p42.ppeCameraManager then
			p42.ppeCameraManager:start()
		end
	elseif p42.cameraManager then
		p42.cameraManager:start()
	end

	table.insert(p42.bulkConnections, p42.store.changed:connect(function(...) -- line: 334
		-- upvalues: p42 (copy)
		p42:updateState(...)
	end))
	table.insert(p42.bulkConnections, p42.events.rotateByRadians:Connect(function(...) -- line: 341
		-- upvalues: p42 (copy)
		p42:rotateByRadians(...)
	end))
	table.insert(p42.bulkConnections, p42.events.rotateByPixels:Connect(function(...) -- line: 347
		-- upvalues: p42 (copy)
		p42:rotateByPixels(...)
	end))
	table.insert(p42.bulkConnections, p42.events.setAngularVelocityByPixels:Connect(function(...) -- line: 353
		-- upvalues: p42 (copy)
		p42:setAngularVelocityByPixels(...)
	end))
	p42:resetRotation()
end
function t1.stop(p43) -- line: 361
	for _, v90 in p43.bulkConnections do
		v90:disconnect()
	end

	p43.bulkConnections = {}

	if p43.renderSteppedConnection then
		p43.renderSteppedConnection:Disconnect()
		p43.renderSteppedConnection = nil
	end

	if p43.cameraManager then
		p43.cameraManager:stop()
	end

	if p43.ppeCameraManager then
		p43.ppeCameraManager:stop()
	end

	p43:cancelCurrentTween()
end
function t1.onDestroy(p44) -- line: 381
	if p44.cameraManager then
		p44.cameraManager:onDestroy()
	end
end

return t1
