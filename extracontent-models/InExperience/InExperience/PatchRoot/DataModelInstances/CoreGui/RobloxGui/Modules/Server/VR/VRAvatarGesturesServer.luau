local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local AvatarUtil = CoreScriptsCommon.AvatarUtil
local CoreScriptsCommon2 = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local ConnectionUtil = CoreScriptsCommon2.ConnectionUtil

local defineFastInt = game:DefineFastInt("VRAvatarGesturesAnalyticsThrottleHundrethsPercent", 0)

local defineFastFlag = game:DefineFastFlag("VRAvatarGesturesUseNilForHandChainRootRebuild", false)

local defineFastFlag2 = game:DefineFastFlag("VRAvatarGesturesFixJointLimits", false)

local v = { "UpperArm", "LowerArm", "Hand" }
local v2 = { "Left", "Right" }

local VRAvatarGesturesServer = {}
VRAvatarGesturesServer.__index = VRAvatarGesturesServer

local function isRagdollBallSocket(ballSocketConstraint) -- 1 equivalent call inferred from this helper
	return ballSocketConstraint:IsA("BallSocketConstraint")
		and string.sub(ballSocketConstraint.Name, -10) == "BallSocket"
end

local function forEachArmRagdollBallSocket(instance, p: string, fn)
	for _, v3 in ipairs(v) do
		local child = instance:FindFirstChild(p .. v3)

		if not child then
			continue
		end

		for _, child2 in ipairs(child:GetChildren()) do
			if isRagdollBallSocket(child2) then -- inferred equivalent call
				fn(child2)
			end
		end
	end
end

local function suppressArmRagdollLimits(p, p2: string)
	forEachArmRagdollBallSocket(p, p2, function(instance)
		if instance:GetAttribute("VRAvatarGesturesPriorLimitsEnabled") == nil then
			instance:SetAttribute("VRAvatarGesturesPriorLimitsEnabled", instance.LimitsEnabled)
			instance:SetAttribute("VRAvatarGesturesPriorTwistLimitsEnabled", instance.TwistLimitsEnabled)
		end

		instance.LimitsEnabled = false
		instance.TwistLimitsEnabled = false
	end)
end

local function restoreArmRagdollLimits(p, p2: string)
	forEachArmRagdollBallSocket(p, p2, function(instance)
		local vrAvatarGesturesPriorLimitsEnabled = instance:GetAttribute("VRAvatarGesturesPriorLimitsEnabled")

		if vrAvatarGesturesPriorLimitsEnabled ~= nil then
			instance.LimitsEnabled = vrAvatarGesturesPriorLimitsEnabled
			instance.TwistLimitsEnabled = instance:GetAttribute("VRAvatarGesturesPriorTwistLimitsEnabled")
			instance:SetAttribute("VRAvatarGesturesPriorLimitsEnabled", nil)
			instance:SetAttribute("VRAvatarGesturesPriorTwistLimitsEnabled", nil)
		end
	end)
end

function VRAvatarGesturesServer.new()
	local object = setmetatable({}, VRAvatarGesturesServer)

	object.connections = ConnectionUtil.new()

	object.VRPlayers = {}

	object.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function()
		object:onAvatarGesturesChanged()
	end)

	if VRService.AvatarGestures then
		object:onAvatarGesturesChanged()
	end

	return object
end

function cleanCharacter(player)
	if player.Character then
		if defineFastFlag2 then
			for _, v3 in ipairs(v2) do
				forEachArmRagdollBallSocket(player.Character, v3, function(instance)
					local vrAvatarGesturesPriorLimitsEnabled = instance:GetAttribute("VRAvatarGesturesPriorLimitsEnabled")

					if vrAvatarGesturesPriorLimitsEnabled ~= nil then
						instance.LimitsEnabled = vrAvatarGesturesPriorLimitsEnabled
						instance.TwistLimitsEnabled = instance:GetAttribute("VRAvatarGesturesPriorTwistLimitsEnabled")
						instance:SetAttribute("VRAvatarGesturesPriorLimitsEnabled", nil)
						instance:SetAttribute("VRAvatarGesturesPriorTwistLimitsEnabled", nil)
					end
				end)
			end
		end

		local humanoid = player.Character:FindFirstChild("Humanoid")

		if humanoid then
			for _, childName in pairs({ "TrackedIKLeftHand", "TrackedIKRightHand", "TrackedIKHead" }) do
				local child = humanoid:FindFirstChild(childName)

				if child then
					child:Destroy()
				end
			end
		end

		for _, childName in pairs({ "TrackedLeftHand", "TrackedRightHand", "TrackedHead" }) do
			local child = player.Character:FindFirstChild(childName)

			if child then
				child:Destroy()
			end
		end
	end
end

function VRAvatarGesturesServer:onPlayerChanged(p, p2)
	self.VRPlayers[p] = p2 or nil

	if not p2 then
		cleanCharacter(p)

		return
	end

	if not self.avatarUtil then
		self.avatarUtil = AvatarUtil.new()
	end

	self.avatarUtil:connectPlayerCharacterChanges(p, function(p3)
		self:onCharacterChanged(p3)
	end)
end

function VRAvatarGesturesServer:onPlayerAdded(p)
	if next(self.VRPlayers) ~= nil then
		RbxAnalyticsService:ReportInfluxSeries(
			"VRAvatarGestures",
			{
				placeId = game.PlaceId,
				calledFrom = "ServerPlayerAddedWithVRPlayer",
				playerUserID = p.UserId
			},
			defineFastInt
		)
	end
end

function VRAvatarGesturesServer:onAvatarGesturesChanged()
	if VRService.AvatarGestures then
		local avatarGesturesVRPlayer = RobloxReplicatedStorage:FindFirstChild("AvatarGesturesVRPlayer")

		if not avatarGesturesVRPlayer then
			avatarGesturesVRPlayer = Instance.new("RemoteEvent")
			avatarGesturesVRPlayer.Name = "AvatarGesturesVRPlayer"
			avatarGesturesVRPlayer.Parent = RobloxReplicatedStorage
		end

		self.connections:connect("VRPlayerOnServerEvent", avatarGesturesVRPlayer.OnServerEvent, function(p, p2)
			self:onPlayerChanged(p, p2)
		end)

		self.connections:connect("PlayerAdded", Players.PlayerAdded, function(p)
			self:onPlayerAdded(p)
		end)

		self.connections:connect("PlayerRemoving", Players.PlayerRemoving, function(p)
			self:onPlayerChanged(p, false)
		end)
	else
		for k in pairs(self.VRPlayers) do
			self:onPlayerChanged(k, false)
		end

		self.connections:disconnectAll()
		self.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function()
			self:onAvatarGesturesChanged()
		end)
	end
end

function VRAvatarGesturesServer:findOrCreateColliders(childName, parent)
	local playerFromCharacter = Players:GetPlayerFromCharacter(parent)

	local name = "Tracked" .. childName
	local v3 = parent:FindFirstChild(name)

	if not v3 then
		v3 = Instance.new("Part")
		v3.Name = name
		v3.Transparency = 1
		v3.CanCollide = false
		v3.Parent = parent
		v3:SetNetworkOwner(playerFromCharacter)
	end

	local attachment = v3:FindFirstChild(name .. "Attachment")

	if not attachment then
		attachment = Instance.new("Attachment")
		attachment.Name = name .. "Attachment"

		attachment.Parent = v3
	end

	local v4 = v3:FindFirstChild(name .. "AlignPosition")

	if not v4 then
		v4 = Instance.new("AlignPosition")
		v4.Name = name .. "AlignPosition"
		v4.Mode = Enum.PositionAlignmentMode.OneAttachment
		v4.Attachment0 = attachment
		v4.RigidityEnabled = true
		v4.Parent = v3
	end

	local v5 = v3:FindFirstChild(name .. "AlignOrientation")

	if not v5 then
		v5 = Instance.new("AlignOrientation")
		v5.Name = name .. "AlignOrientation"
		v5.Mode = Enum.OrientationAlignmentMode.OneAttachment
		v5.Attachment0 = attachment
		v5.RigidityEnabled = true
		v5.Parent = v3
	end

	local child = parent:FindFirstChild(childName)

	if child then
		v3.Size = child.Size
		v3.CFrame = child.CFrame
		v4.Position = child.Position
		v5.CFrame = child.CFrame
	else
		v3.Size = Vector3.new(1, 1, 1)
		v3.CFrame = parent.WorldPivot
		v4.Position = parent.WorldPivot.Position
		v5.CFrame = parent.WorldPivot
	end

	local humanoid = parent:FindFirstChild("Humanoid")

	if humanoid then
		local name2 = "TrackedIK" .. childName
		local v6 = humanoid:FindFirstChild(name2)

		if not v6 then
			v6 = Instance.new("IKControl")
			v6.Name = name2
		end

		v6.SmoothTime = 0.1
		v6.Parent = humanoid
		v6.Target = v3
	end
end

function VRAvatarGesturesServer:createHandCollider(p, instance)
	self:findOrCreateColliders(p .. "Hand", instance)
	local child = instance:FindFirstChild(p .. "Hand")

	local humanoid = instance:FindFirstChild("Humanoid")

	local child2 = humanoid and humanoid:FindFirstChild("TrackedIK" .. p .. "Hand")

	if child2 then
		child2.Type = Enum.IKControlType.Transform

		local child3 = instance:FindFirstChild(p .. "UpperArm")

		if child3 then
			if defineFastFlag then
				child2.ChainRoot = nil
			else
				child2.ChainRoot = child
			end

			coroutine.wrap(function()
				task.wait(0.1)
				child2.ChainRoot = child3
			end)()
		end

		if child then
			child2.EndEffector = child
		end

		child2.Priority = 1
	end

	if defineFastFlag2 then
		forEachArmRagdollBallSocket(instance, p, function(instance2)
			if instance2:GetAttribute("VRAvatarGesturesPriorLimitsEnabled") == nil then
				instance2:SetAttribute("VRAvatarGesturesPriorLimitsEnabled", instance2.LimitsEnabled)
				instance2:SetAttribute("VRAvatarGesturesPriorTwistLimitsEnabled", instance2.TwistLimitsEnabled)
			end

			instance2.LimitsEnabled = false
			instance2.TwistLimitsEnabled = false
		end)
		return
	end

	local ragdollBallSocket = child and child:FindFirstChild("RagdollBallSocket")

	if ragdollBallSocket then
		ragdollBallSocket.LimitsEnabled = false
	end
end

function VRAvatarGesturesServer:createHeadCollider(instance)
	self:findOrCreateColliders("Head", instance)
	local head = instance:FindFirstChild("Head")

	local humanoid = instance:FindFirstChild("Humanoid")

	local trackedIKHead = humanoid and humanoid:FindFirstChild("TrackedIKHead")

	if trackedIKHead then
		trackedIKHead.Type = Enum.IKControlType.Rotation

		local upperTorso = instance:FindFirstChild("UpperTorso")

		if upperTorso then
			trackedIKHead.ChainRoot = upperTorso
		end

		if head then
			trackedIKHead.EndEffector = head
		end
	end
end

function VRAvatarGesturesServer:onCharacterChanged(character)
	local playerFromCharacter = Players:GetPlayerFromCharacter(character)

	if self.VRPlayers[playerFromCharacter] and VRService.AvatarGestures then
		self:createHandCollider("Left", character)
		self:createHandCollider("Right", character)
		self:createHeadCollider(character)
	end
end

VRAvatarGesturesServer._suppressArmRagdollLimits = suppressArmRagdollLimits
VRAvatarGesturesServer._restoreArmRagdollLimits = restoreArmRagdollLimits

return VRAvatarGesturesServer
