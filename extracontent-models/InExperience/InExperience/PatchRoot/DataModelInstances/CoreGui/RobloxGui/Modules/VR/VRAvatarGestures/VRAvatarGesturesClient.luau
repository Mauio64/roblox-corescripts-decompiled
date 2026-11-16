local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local ConnectionUtil = CoreScriptsCommon.ConnectionUtil
local AvatarUtil = CoreScriptsCommon.AvatarUtil

local defineFastFlag = game:DefineFastFlag("DebugImmersionModeNonVR", false)

local defineFastFlag2 = game:DefineFastFlag("VRAvatarGesturesFixFirstPersonHeadScale", false)

local defineFastInt = game:DefineFastInt("VRAvatarGesturesAnalyticsThrottleHundrethsPercent", 0)

local function isVRFirstPerson(currentCamera): boolean -- 3 equivalent calls inferred from this helper
	return (not defineFastFlag2 and 5 or 5 * currentCamera.HeadScale) >= (currentCamera.CFrame.Position - currentCamera.Focus.Position).Magnitude
end

local class = {}
class.__index = class

function class.new()
	local object = setmetatable({}, class)
	object.partCFrameMap = {}
	object.connections = ConnectionUtil.new()
	object.analyticsSendEnabled = true
	object.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function()
		object:onAvatarGesturesChanged()
	end)

	if VRService.AvatarGestures then
		object:onAvatarGesturesChanged()
	end

	return object
end

function class:onCharacterChanged(instance)
	local humanoid = instance:FindFirstChild("Humanoid")

	if not humanoid then
		return
	end

	for _, childName in pairs({ "TrackedIKLeftHand", "TrackedIKRightHand", "TrackedIKHead" }) do
		local child = humanoid:FindFirstChild(childName)

		if child then
			child.SmoothTime = 0
		end
	end

	local currentCamera = workspace.CurrentCamera

	if not currentCamera then
		return
	end

	local function updateSeated(p)
		local v = currentCamera.CameraSubject and currentCamera.CameraSubject:IsA("VehicleSeat")
		local vrFirstPerson = isVRFirstPerson(currentCamera) -- inferred equivalent call
		local trackedIKHead = humanoid:FindFirstChild("TrackedIKHead")

		if trackedIKHead then
			if p and not v and vrFirstPerson then
				trackedIKHead.Type = Enum.IKControlType.Transform
			else
				trackedIKHead.Type = Enum.IKControlType.Rotation
			end
		end
	end

	updateSeated(humanoid.Sit)
	self.connections:connect("Seated", humanoid.Seated, function(p)
		updateSeated(p)

		if p and isVRFirstPerson(currentCamera) then -- inferred equivalent call
			VRService:RecenterUserHeadCFrame()
		end
	end)
end

function class:onAvatarGesturesChanged()
	if VRService.AvatarGestures then
		if VRService.VREnabled or defineFastFlag then
			local avatarGesturesVRPlayer = RobloxReplicatedStorage:WaitForChild("AvatarGesturesVRPlayer", 5)

			if not avatarGesturesVRPlayer then
				warn("VRService.AvatarGestures failed to connect to server")
				return
			end

			avatarGesturesVRPlayer:FireServer(true)

			self:connectInputCFrames()

			if self.avatarUtil then
				if Players.LocalPlayer and Players.LocalPlayer.Character then
					self:onCharacterChanged(Players.LocalPlayer.Character)
				end
			else
				self.avatarUtil = AvatarUtil.new()
				self.avatarUtil:connectLocalCharacterChanges(function(p)
					self:onCharacterChanged(p)
				end)
			end

			if self.analyticsSendEnabled then
				self.analyticsSendEnabled = nil

				RbxAnalyticsService:ReportInfluxSeries(
					"VRAvatarGestures",
					{ placeId = game.PlaceId, calledFrom = "ClientJoined" },
					defineFastInt
				)
			end
		end
	else
		local avatarGesturesVRPlayer = (VRService.VREnabled or defineFastFlag)
			and RobloxReplicatedStorage:FindFirstChild("AvatarGesturesVRPlayer")

		if avatarGesturesVRPlayer then
			avatarGesturesVRPlayer:FireServer(false)
		end

		self.connections:disconnectAll()
		self.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function()
			self:onAvatarGesturesChanged()
		end)
	end
end

function class:updateCFrames(childName, p)
	local localPlayer = Players.LocalPlayer

	if not Players.LocalPlayer then
		return
	end

	local character = localPlayer.Character

	if not localPlayer.Character then
		return
	end

	local child = character:FindFirstChild(childName)

	if not child then
		return
	end

	local currentCamera = workspace.CurrentCamera

	if not (currentCamera and child:FindFirstChild(childName .. "Attachment")) then
		return
	end

	local child2 = child:FindFirstChild(childName .. "AlignPosition")

	if not child2 then
		return
	end

	local child3 = child:FindFirstChild(childName .. "AlignOrientation")

	if not child3 then
		return
	end

	if VRService.VREnabled then
		local v = p.Rotation + p.Position * currentCamera.HeadScale
		local cframe3 = currentCamera.CFrame * v

		local head = character:FindFirstChild("Head")

		if isVRFirstPerson(currentCamera) or not head then -- inferred equivalent call
			child2.Position = cframe3.Position

			if childName == "TrackedHead" then
				child3.CFrame = cframe3
			else
				child3.CFrame = cframe3 * CFrame.Angles(1.5707963267948966, 0, 0)
			end
		else
			local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local v2 = userCFrame.Rotation + userCFrame.Position * currentCamera.HeadScale
			local cframe = currentCamera.CFrame * v2 * CFrame.new(0, 0, 0.5)

			if childName == "TrackedHead" then
				local cframe2 = character.PrimaryPart.CFrame
				child2.Position = (cframe2 * CFrame.new(0, cframe2.Position.Y * 0.25, -cframe2.Position.Y * 0.125)).Position

				child3.CFrame = cframe2 * v
			else
				local worldSpace = head.CFrame:ToWorldSpace(cframe:ToObjectSpace(cframe3))
				child2.Position = worldSpace.Position
				child3.CFrame = worldSpace * CFrame.Angles(1.5707963267948966, 0, 0)
			end
		end
	else
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local cframe

		if childName == "TrackedHead" then
			cframe = humanoidRootPart.CFrame * p
		else
			cframe = humanoidRootPart.CFrame * p * CFrame.Angles(0, 0, (math.rad(time() * 30))) * CFrame.new(1, 0, -0.5)
		end

		if humanoidRootPart then
			child2.Position = cframe.Position
			child3.CFrame = cframe
		end
	end

	child.CFrame = CFrame.new(child2.Position) * child3.CFrame.Rotation
end

function class:steppedCframes()
	for k, partCFrame in pairs(self.partCFrameMap) do
		self:updateCFrames(k, partCFrame)
	end
end

function class:connectInputCFrames()
	if VRService.VREnabled then
		self.connections:connect("UserCFrameChanged", VRService.UserCFrameChanged, function(p, p2)
			if p == Enum.UserCFrame.LeftHand then
				self.partCFrameMap.TrackedLeftHand = p2
			elseif p == Enum.UserCFrame.RightHand then
				self.partCFrameMap.TrackedRightHand = p2
			elseif p == Enum.UserCFrame.Head then
				self.partCFrameMap.TrackedHead = p2
			end
		end)
	elseif defineFastFlag then
		self.connections:connect("NonVRSimulateInput", RunService.RenderStepped, function(_)
			self.partCFrameMap.TrackedLeftHand = CFrame.new(-0.5, 0, -0.5)
			self.partCFrameMap.TrackedRightHand = CFrame.new(0.5, 0, -0.5)
			self.partCFrameMap.TrackedHead = CFrame.new(0, 1, 0)
		end)
	end

	if VRService.VREnabled or defineFastFlag then
		self.connections:connect("RenderStepped", RunService.RenderStepped, function(_)
			self:steppedCframes()
		end)
	end
end

return class.new()
