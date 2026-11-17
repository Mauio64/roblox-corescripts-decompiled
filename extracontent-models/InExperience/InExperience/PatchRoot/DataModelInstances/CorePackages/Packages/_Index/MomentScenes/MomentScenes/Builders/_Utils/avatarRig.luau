local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local loadAsset = require(script.Parent.loadAsset)

local c0 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)

local function staged(p, parent, fn)
	local parent2 = p.Parent
	local momentScenesStaging = Instance.new("Folder")
	momentScenesStaging.Name = "MomentScenesStaging"
	momentScenesStaging.Parent = parent
	p.Parent = momentScenesStaging

	local success, result = pcall(function(): nil
		fn()
		return nil
	end)

	p.Parent = parent2
	momentScenesStaging:Destroy()

	if not success then
		error(result)
	end
end

local function emoteAnimationId(p: number)
	local v = `rbxassetid://{p}`
	local success, result = pcall(loadAsset.loadAsset, p)

	if not success or result == nil or typeof(result) ~= "Instance" then
		return v
	end

	local animation = result:FindFirstChildWhichIsA("Animation")

	if animation ~= nil and animation.AnimationId ~= "" then
		v = animation.AnimationId
	end

	result:Destroy()
	return v
end

local function playAnimation(parent, name: string, animationId: string)
	local humanoid = parent:FindFirstChildOfClass("Humanoid")

	if humanoid == nil then
		return nil
	end

	local v = humanoid:FindFirstChildOfClass("Animator")

	if v == nil then
		v = Instance.new("Animator")
		v.Parent = humanoid
	end

	local animation = Instance.new("Animation")
	animation.Name = name
	animation.AnimationId = animationId
	animation.Parent = parent

	local v2 = nil

	staged(parent, ReplicatedStorage, function()
		local success, result = pcall(function()
			return v:LoadAnimation(animation)
		end)

		if not success or result == nil then
			return
		end

		result.Looped = true
		result:Play(0)
		local lastTime = os.clock()

		while result.Length == 0 do
			if RunService:IsRunning() then
				task.wait()
			else
				wait(0)
			end

			if os.clock() - lastTime > 2 then
				break
			end
		end

		result:AdjustSpeed(0)
		v2 = result
	end)
	return v2
end

local function equippedAnimationId(p): number -- 1 equivalent call inferred from this helper
	return if p == Enum.HumanoidRigType.R6 then 182393478 else 507768375
end

local function applyGearGrip(parent, tool, handle, p)
	local part = parent:FindFirstChild(p == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")

	if part == nil or not part:IsA("BasePart") then
		return
	end

	local rightGrip = part:FindFirstChild("RightGrip")

	if rightGrip == nil then
		local rightGripAttachment = part:FindFirstChild("RightGripAttachment")

		if rightGripAttachment == nil or not rightGripAttachment:IsA("Attachment") then
			return
		end

		rightGrip = Instance.new("Weld")
		rightGrip.Name = "RightGrip"
		rightGrip.Part0 = part
		local c0_2

		if p == Enum.HumanoidRigType.R6 then
			c0_2 = c0
		else
			c0_2 = rightGripAttachment.CFrame
		end

		rightGrip.C0 = c0_2
		rightGrip.Parent = part
	end

	if rightGrip ~= nil and rightGrip:IsA("JointInstance") then
		if p == Enum.HumanoidRigType.R6 then
			rightGrip.C0 = c0
		end

		rightGrip.Part1 = handle
		rightGrip.C1 = tool.Grip
	end
end

local AvatarRig = {}

function AvatarRig.createAvatar(p, p2)
	local success, result = pcall(function()
		return Players:CreateHumanoidModelFromDescriptionAsync(p, p2)
	end)

	if not success or result == nil then
		error(`avatarRig.createAvatar: CreateHumanoidModelFromDescriptionAsync failed: {result}`)
	end

	local humanoidRootPart = result:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart ~= nil and humanoidRootPart:IsA("BasePart") then
		humanoidRootPart.Anchored = true
		result.PrimaryPart = humanoidRootPart
	end

	staged(result, Workspace, function()
		for _, part in result:GetDescendants() do
			if part:IsA("BasePart") then
				local _cframe = part.CFrame
			end
		end
	end)

	return result
end

function AvatarRig.solveJoints(folder)
	staged(folder, Workspace, function()
		for _, part in folder:GetDescendants() do
			if part:IsA("BasePart") then
				local _cframe = part.CFrame
			end
		end
	end)
end

function AvatarRig.playEmote(instance, p: number)
	if instance:FindFirstChildOfClass("Humanoid") == nil then
		return nil
	end

	return playAnimation(instance, "Live3DEmote", emoteAnimationId(p))
end

AvatarRig.emoteAnimationId = emoteAnimationId

function AvatarRig.equipGear(parent, p: number, p2)
	local success, result = pcall(loadAsset.loadAsset, p)

	if not success then
		warn(`avatarRig.equipGear: Gear {p} failed to load ({result})`)
		return nil
	end

	if typeof(result) ~= "Instance" then
		warn(`avatarRig.equipGear: Gear {p} loaded a {typeof(result)}, expected an Instance`)
		return nil
	end

	local tool = result:FindFirstChildWhichIsA("Tool", true)

	if tool == nil then
		result:Destroy()
		return nil
	end

	local handle = tool:FindFirstChild("Handle")

	if handle == nil or not handle:IsA("BasePart") then
		result:Destroy()
		return nil
	end

	for _, luaSourceContainer in tool:GetDescendants() do
		if luaSourceContainer:IsA("LuaSourceContainer") then
			luaSourceContainer:Destroy()
		end
	end

	tool.Parent = parent
	applyGearGrip(parent, tool, handle, p2)
	result:Destroy()

	return playAnimation(parent, "Live3DGearEquipped", `rbxassetid://{equippedAnimationId(p2)}`) -- inferred equivalent call
end

AvatarRig.equippedAnimationId = equippedAnimationId
return AvatarRig
