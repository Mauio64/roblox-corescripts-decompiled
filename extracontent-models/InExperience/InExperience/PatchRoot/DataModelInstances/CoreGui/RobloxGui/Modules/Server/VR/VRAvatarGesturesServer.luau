local CorePackages = game:GetService("CorePackages")

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AvatarUtil = require(CorePackages.Workspace.Packages.CoreScriptsCommon).AvatarUtil
local ConnectionUtil = require(CorePackages.Workspace.Packages.CoreScriptsCommon).ConnectionUtil
local v8 = game:DefineFastInt("VRAvatarGesturesAnalyticsThrottleHundrethsPercent", 0)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 20
	-- upvalues: t1 (copy), ConnectionUtil (copy), VRService (copy)
	local self = setmetatable({}, t1)

	self.connections = ConnectionUtil.new()
	self.VRPlayers = {}
	self.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function() -- line: 28
		-- upvalues: self (copy)
		self:onAvatarGesturesChanged()
	end)

	if VRService.AvatarGestures then
		self:onAvatarGesturesChanged()
	end

	return self
end
function cleanCharacter(p1) -- line: 35
	if p1.Character then
		local Humanoid = p1.Character:FindFirstChild("Humanoid")

		if Humanoid then
			for _, v in pairs({
				"TrackedIKLeftHand",
				"TrackedIKRightHand",
				"TrackedIKHead"
			}) do
				local v2 = Humanoid:FindFirstChild(v)

				if v2 then
					v2:Destroy()
				end
			end
		end

		for _, v in pairs({
			"TrackedLeftHand",
			"TrackedRightHand",
			"TrackedHead"
		}) do
			local v3 = p1.Character:FindFirstChild(v)

			if v3 then
				v3:Destroy()
			end
		end
	end
end
function t1.onPlayerChanged(p2, p3, p4) -- line: 62
	-- upvalues: AvatarUtil (copy)
	p2.VRPlayers[p3] = p4 or nil

	if p4 then
		if not p2.avatarUtil then
			p2.avatarUtil = AvatarUtil.new()
		end

		p2.avatarUtil:connectPlayerCharacterChanges(p3, function(p5) -- line: 71
			-- upvalues: p2 (copy)
			p2:onCharacterChanged(p5)
		end)

		return
	end

	cleanCharacter(p3)
end
function t1.onPlayerAdded(p6, p7) -- line: 79
	-- upvalues: RbxAnalyticsService (copy), v8 (copy)
	if next(p6.VRPlayers) ~= nil then
		RbxAnalyticsService:ReportInfluxSeries("VRAvatarGestures", {
			calledFrom = "ServerPlayerAddedWithVRPlayer",
			placeId = game.PlaceId,
			playerUserID = p7.UserId
		}, v8)
	end
end
function t1.onAvatarGesturesChanged(p8) -- line: 90
	-- upvalues: VRService (copy), RobloxReplicatedStorage (copy), Players (copy)
	if VRService.AvatarGestures then
		local AvatarGesturesVRPlayer = RobloxReplicatedStorage:FindFirstChild("AvatarGesturesVRPlayer")

		if not AvatarGesturesVRPlayer then
			AvatarGesturesVRPlayer = Instance.new("RemoteEvent")
			AvatarGesturesVRPlayer.Name = "AvatarGesturesVRPlayer"
			AvatarGesturesVRPlayer.Parent = RobloxReplicatedStorage
		end

		p8.connections:connect("VRPlayerOnServerEvent", AvatarGesturesVRPlayer.OnServerEvent, function(p9, p10) -- line: 101
			-- upvalues: p8 (copy)
			p8:onPlayerChanged(p9, p10)
		end)
		p8.connections:connect("PlayerAdded", Players.PlayerAdded, function(p11) -- line: 104
			-- upvalues: p8 (copy)
			p8:onPlayerAdded(p11)
		end)
		p8.connections:connect("PlayerRemoving", Players.PlayerRemoving, function(p12) -- line: 107
			-- upvalues: p8 (copy)
			p8:onPlayerChanged(p12, false)
		end)

		return
	end

	for k in pairs(p8.VRPlayers) do
		p8:onPlayerChanged(k, false)
	end

	p8.connections:disconnectAll()
	p8.connections:connect("AvatarGestures", VRService:GetPropertyChangedSignal("AvatarGestures"), function() -- line: 115
		-- upvalues: p8 (copy)
		p8:onAvatarGesturesChanged()
	end)
end
function t1.findOrCreateColliders(_, p14, p15) -- line: 121
	-- upvalues: Players (copy)
	local player = Players:GetPlayerFromCharacter(p15)
	local v31 = "Tracked" .. p14
	local v32 = p15:FindFirstChild(v31)

	if not v32 then
		v32 = Instance.new("Part")
		v32.Name = v31
		v32.Transparency = 1
		v32.CanCollide = false
		v32.Parent = p15
		v32:SetNetworkOwner(player)
	end

	local v33 = v32:FindFirstChild(v31 .. "Attachment")

	if not v33 then
		v33 = Instance.new("Attachment")
		v33.Name = v31 .. "Attachment"
		v33.Parent = v32
	end

	local v34 = v32:FindFirstChild(v31 .. "AlignPosition")

	if not v34 then
		v34 = Instance.new("AlignPosition")
		v34.Name = v31 .. "AlignPosition"
		v34.Mode = Enum.PositionAlignmentMode.OneAttachment
		v34.Attachment0 = v33
		v34.RigidityEnabled = true
		v34.Parent = v32
	end

	local v35 = v32:FindFirstChild(v31 .. "AlignOrientation")

	if not v35 then
		v35 = Instance.new("AlignOrientation")
		v35.Name = v31 .. "AlignOrientation"
		v35.Mode = Enum.OrientationAlignmentMode.OneAttachment
		v35.Attachment0 = v33
		v35.RigidityEnabled = true
		v35.Parent = v32
	end

	local p14_2 = p15:FindFirstChild(p14)

	if p14_2 then
		v32.Size = p14_2.Size
		v32.CFrame = p14_2.CFrame
		v34.Position = p14_2.Position
		v35.CFrame = p14_2.CFrame
	else
		v32.Size = Vector3.new(1, 1, 1)
		v32.CFrame = p15.WorldPivot
		v34.Position = p15.WorldPivot.Position
		v35.CFrame = p15.WorldPivot
	end

	local Humanoid = p15:FindFirstChild("Humanoid")

	if Humanoid then
		local v38 = "TrackedIK" .. p14
		local v39 = Humanoid:FindFirstChild(v38)

		if not v39 then
			v39 = Instance.new("IKControl")
			v39.Name = v38
		end

		v39.SmoothTime = 0.1
		v39.Parent = Humanoid
		v39.Target = v32
	end
end
function t1.createHandCollider(p16, p17, p18) -- line: 196
	p16:findOrCreateColliders(p17 .. "Hand", p18)

	local v43 = p18:FindFirstChild(p17 .. "Hand")
	local Humanoid = p18:FindFirstChild("Humanoid")

	if Humanoid then
		local v45 = Humanoid:FindFirstChild("TrackedIK" .. p17 .. "Hand")

		if v45 then
			v45.Type = Enum.IKControlType.Transform

			local v46 = p18:FindFirstChild(p17 .. "UpperArm")

			if v46 then
				v45.ChainRoot = v43
				coroutine.wrap(function() -- line: 213
					-- upvalues: v45 (copy), v46 (copy)
					task.wait(0.1)
					v45.ChainRoot = v46
				end)()
			end

			if v43 then
				v45.EndEffector = v43
			end

			v45.Priority = 1
		end
	end

	if v43 then
		local RagdollBallSocket = v43:FindFirstChild("RagdollBallSocket")

		if RagdollBallSocket then
			RagdollBallSocket.LimitsEnabled = false
		end
	end
end
function t1.createHeadCollider(p19, p20) -- line: 234
	p19:findOrCreateColliders("Head", p20)

	local Head = p20:FindFirstChild("Head")
	local Humanoid = p20:FindFirstChild("Humanoid")

	if Humanoid then
		local TrackedIKHead = Humanoid:FindFirstChild("TrackedIKHead")

		if TrackedIKHead then
			TrackedIKHead.Type = Enum.IKControlType.Rotation

			local UpperTorso = p20:FindFirstChild("UpperTorso")

			if UpperTorso then
				TrackedIKHead.ChainRoot = UpperTorso
			end

			if Head then
				TrackedIKHead.EndEffector = Head
			end
		end
	end
end
function t1.onCharacterChanged(p21, p22) -- line: 260
	-- upvalues: Players (copy), VRService (copy)
	local player = Players:GetPlayerFromCharacter(p22)

	if p21.VRPlayers[player] and VRService.AvatarGestures then
		p21:createHandCollider("Left", p22)
		p21:createHandCollider("Right", p22)
		p21:createHeadCollider(p22)
	end
end

return t1
