local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local ConnectionUtil = CoreScriptsCommon.ConnectionUtil
local AvatarUtil = CoreScriptsCommon.AvatarUtil
local v10 = game:DefineFastFlag("DebugImmersionModeNonVR", false)
local v11 = game:DefineFastInt("VRAvatarGesturesAnalyticsThrottleHundrethsPercent", 0)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 55
	-- upvalues: t1 (copy), ConnectionUtil (copy), VRService (copy)
	local self = setmetatable({}, t1)

	self.partCFrameMap = {}
	self.connections = ConnectionUtil.new()
	self.analyticsSendEnabled = true
	self.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function() -- line: 60
		-- upvalues: self (copy)
		self:onAvatarGesturesChanged()
	end)

	if VRService.AvatarGestures then
		self:onAvatarGesturesChanged()
	end

	return self
end
function t1.onCharacterChanged(p1, p2) -- line: 65
	-- upvalues: VRService (copy)
	local Humanoid = p2:FindFirstChild("Humanoid")

	if not Humanoid then
		return
	end

	for _, v in pairs({
		"TrackedIKLeftHand",
		"TrackedIKRightHand",
		"TrackedIKHead"
	}) do
		local v2 = Humanoid:FindFirstChild(v)

		if v2 then
			v2.SmoothTime = 0
		end
	end

	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local function updateSeated(p3) -- line: 86
		-- upvalues: CurrentCamera (copy), Humanoid (copy)
		local v49 = CurrentCamera.CameraSubject and CurrentCamera.CameraSubject:IsA("VehicleSeat")
		local v50 = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude <= 5
		local TrackedIKHead = Humanoid:FindFirstChild("TrackedIKHead")

		if TrackedIKHead then
			if p3 and not v49 and v50 then
				TrackedIKHead.Type = Enum.IKControlType.Transform

				return
			end

			TrackedIKHead.Type = Enum.IKControlType.Rotation
		end
	end

	updateSeated(Humanoid.Sit)
	p1.connections:connect("Seated", Humanoid.Seated, function(p4) -- line: 102
		-- upvalues: updateSeated (copy), CurrentCamera (copy), VRService (copy)
		updateSeated(p4)

		if p4 and (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude <= 5 then
			VRService:RecenterUserHeadCFrame()
		end
	end)
end
function t1.onAvatarGesturesChanged(p5) -- line: 111
	-- upvalues: VRService (copy), v10 (copy), RobloxReplicatedStorage (copy), AvatarUtil (copy), Players (copy), RbxAnalyticsService (copy), v11 (copy)
	if VRService.AvatarGestures then
		if VRService.VREnabled or v10 then
			local AvatarGesturesVRPlayer = RobloxReplicatedStorage:WaitForChild("AvatarGesturesVRPlayer", 5)

			if not AvatarGesturesVRPlayer then
				warn("VRService.AvatarGestures failed to connect to server")

				return
			end

			AvatarGesturesVRPlayer:FireServer(true)
			p5:connectInputCFrames()

			if not p5.avatarUtil then
				p5.avatarUtil = AvatarUtil.new()
				p5.avatarUtil:connectLocalCharacterChanges(function(p6) -- line: 128
					-- upvalues: p5 (copy)
					p5:onCharacterChanged(p6)
				end)
			elseif Players.LocalPlayer and Players.LocalPlayer.Character then
				p5:onCharacterChanged(Players.LocalPlayer.Character)
			end

			if p5.analyticsSendEnabled then
				p5.analyticsSendEnabled = nil
				RbxAnalyticsService:ReportInfluxSeries("VRAvatarGestures", {
					calledFrom = "ClientJoined",
					placeId = game.PlaceId
				}, v11)

				return
			end
		end
	else
		if VRService.VREnabled or v10 then
			local AvatarGesturesVRPlayer = RobloxReplicatedStorage:FindFirstChild("AvatarGesturesVRPlayer")

			if AvatarGesturesVRPlayer then
				AvatarGesturesVRPlayer:FireServer(false)
			end
		end

		p5.connections:disconnectAll()
		p5.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function() -- line: 157
			-- upvalues: p5 (copy)
			p5:onAvatarGesturesChanged()
		end)
	end
end
function t1.updateCFrames(_, p8, p9) -- line: 161
	-- upvalues: Players (copy), VRService (copy)
	local LocalPlayer = Players.LocalPlayer

	if not Players.LocalPlayer then
		return
	end

	local Character = LocalPlayer.Character

	if not LocalPlayer.Character then
		return
	end

	local p8_2 = Character:FindFirstChild(p8)

	if not p8_2 then
		return
	end

	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	if not p8_2:FindFirstChild(p8 .. "Attachment") then
		return
	end

	local v32 = p8_2:FindFirstChild(p8 .. "AlignPosition")

	if not v32 then
		return
	end

	local v33 = p8_2:FindFirstChild(p8 .. "AlignOrientation")

	if not v33 then
		return
	end

	if VRService.VREnabled then
		local v34 = p9.Rotation + p9.Position * CurrentCamera.HeadScale
		local v35 = CurrentCamera.CFrame * v34
		local Head = Character:FindFirstChild("Head")

		if (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude > 5 and Head then
			local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local v38 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
			local v39 = CurrentCamera.CFrame * v38 * CFrame.new(0, 0, 0.5)

			if p8 ~= "TrackedHead" then
				local v40 = Head.CFrame:ToWorldSpace(v39:ToObjectSpace(v35))

				v32.Position = v40.Position
				v33.CFrame = v40 * CFrame.Angles(1.5707963267948966, 0, 0)
			else
				local PrimaryPartCFrame = Character.PrimaryPart.CFrame

				v32.Position = (PrimaryPartCFrame * CFrame.new(0, PrimaryPartCFrame.Position.Y * 0.25, -PrimaryPartCFrame.Position.Y * 0.125)).Position
				v33.CFrame = PrimaryPartCFrame * v34
			end
		else
			v32.Position = v35.Position

			if p8 ~= "TrackedHead" then
				v33.CFrame = v35 * CFrame.Angles(1.5707963267948966, 0, 0)
			else
				v33.CFrame = v35
			end
		end
	else
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local v43 = if p8 == "TrackedHead" then HumanoidRootPart.CFrame * p9 else HumanoidRootPart.CFrame * p9 * CFrame.Angles(0, 0, (math.rad(time() * 30))) * CFrame.new(1, 0, -0.5)

		if HumanoidRootPart then
			v32.Position = v43.Position
			v33.CFrame = v43
		end
	end

	p8_2.CFrame = CFrame.new(v32.Position) * v33.CFrame.Rotation
end
function t1.steppedCframes(p10) -- line: 253
	for k, v in pairs(p10.partCFrameMap) do
		p10:updateCFrames(k, v)
	end
end
function t1.connectInputCFrames(p11) -- line: 259
	-- upvalues: VRService (copy), v10 (copy), RunService (copy)
	if VRService.VREnabled then
		p11.connections:connect("UserCFrameChanged", VRService.UserCFrameChanged, function(p12, p13) -- line: 261
			-- upvalues: p11 (copy)
			if p12 == Enum.UserCFrame.LeftHand then
				p11.partCFrameMap.TrackedLeftHand = p13

				return
			end

			if p12 == Enum.UserCFrame.RightHand then
				p11.partCFrameMap.TrackedRightHand = p13

				return
			end

			if p12 == Enum.UserCFrame.Head then
				p11.partCFrameMap.TrackedHead = p13
			end
		end)
	elseif v10 then
		p11.connections:connect("NonVRSimulateInput", RunService.RenderStepped, function(_) -- line: 271
			-- upvalues: p11 (copy)
			p11.partCFrameMap.TrackedLeftHand = CFrame.new(-0.5, 0, -0.5)
			p11.partCFrameMap.TrackedRightHand = CFrame.new(0.5, 0, -0.5)
			p11.partCFrameMap.TrackedHead = CFrame.new(0, 1, 0)
		end)
	end

	if VRService.VREnabled or v10 then
		p11.connections:connect("RenderStepped", RunService.RenderStepped, function(_) -- line: 279
			-- upvalues: p11 (copy)
			p11:steppedCframes()
		end)
	end
end

return t1.new()
