local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local loadAsset = require(script.Parent.loadAsset)

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

function AvatarRig.playEmote(parent, p: number)
	local humanoid = parent:FindFirstChildOfClass("Humanoid")

	if humanoid == nil then
		return nil
	end

	local v = humanoid:FindFirstChildOfClass("Animator")

	if v == nil then
		v = Instance.new("Animator")
		v.Parent = humanoid
	end

	local live3DEmote = Instance.new("Animation")
	live3DEmote.Name = "Live3DEmote"

	live3DEmote.AnimationId = emoteAnimationId(p)
	live3DEmote.Parent = parent

	local v2 = nil

	staged(parent, ReplicatedStorage, function()
		local success, result = pcall(function()
			return v:LoadAnimation(live3DEmote)
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

AvatarRig.emoteAnimationId = emoteAnimationId
return AvatarRig
