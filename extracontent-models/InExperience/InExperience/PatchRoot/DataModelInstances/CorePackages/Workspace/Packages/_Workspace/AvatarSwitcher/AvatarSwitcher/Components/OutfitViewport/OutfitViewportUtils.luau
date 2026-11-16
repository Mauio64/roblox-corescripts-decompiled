local Players = game:GetService("Players")
local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local OutfitViewportUtils = {}

local defineFastString = game:DefineFastString("AvatarSwitcherEmoteIds", "3344650532,3344585679,5911729486")

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherAccurateAvatarWarning = AvatarExperienceFlags.FFlagAvatarSwitcherAccurateAvatarWarning
local defineFastFlag = game:DefineFastFlag("AvatarSwitcherMakeupSupport", false)

function OutfitViewportUtils.buildOutfitModel(p: number, p2)
	local conformToAvatarRulesAsync = AvatarEditorService:ConformToAvatarRulesAsync((Players:GetHumanoidDescriptionFromOutfitIdAsync(p)))
	local humanoidModelFromDescriptionAsync = Players:CreateHumanoidModelFromDescriptionAsync(
		conformToAvatarRulesAsync,
		p2
	)

	if FFlagAvatarSwitcherAccurateAvatarWarning then
		return humanoidModelFromDescriptionAsync, conformToAvatarRulesAsync
	end

	return humanoidModelFromDescriptionAsync
end

function OutfitViewportUtils.getCameraDistance(instance, p: number)
	local _, v = instance:GetBoundingBox()
	return (v / 2).Magnitude / math.sin((math.rad(p / 2)))
end

function OutfitViewportUtils.loadIdleAnimationForAvatar(instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

	if not animator then
		return nil
	end

	local animate = instance:FindFirstChild("Animate")

	if not animate then
		return nil
	end

	local idle = animate:FindFirstChild("idle")

	if not idle then
		return nil
	end

	local animation = idle:FindFirstChildOfClass("Animation")

	if not animation then
		return nil
	end

	local track = animator:LoadAnimation(animation)
	track.Looped = true
	return track
end

function OutfitViewportUtils.loadAnimationTrackForAvatar(p: string, instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

	if not animator then
		return nil
	end

	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. p
	return (animator:LoadAnimation(animation))
end

local v = nil
function OutfitViewportUtils.playRandomEmote(instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local v2 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15

	local success, result = pcall(function()
		return string.split(defineFastString)
	end)
	local v3

	if v2 and success and #result > 0 then
		local v4

		repeat
			v4 = result[math.random(#result)]
		until v4 ~= v or #result == 1

		v3 = OutfitViewportUtils.loadAnimationTrackForAvatar(v4, instance)
		v = v4
	else
		v3 = nil
	end

	task.spawn(function()
		if v3 then
			v3.Looped = false
			v3:Play()
			v3.Stopped:Wait()
		end

		if instance.Parent == nil then
			return
		end

		local idleAnimationForAvatar = OutfitViewportUtils.loadIdleAnimationForAvatar(instance)

		if idleAnimationForAvatar then
			idleAnimationForAvatar.Looped = true
			idleAnimationForAvatar:Play()
		end
	end)
end

function OutfitViewportUtils.hasMissingAccessoriesInHumanoid(object, object2): boolean
	local accessories = object2:GetAccessories(true)
	local accessories2 = object:GetAccessories()

	return #accessories > #accessories2
end

local function getAssetIdsInHumanoidDescription(instance)
	local assetIdsInHumanoidDescription = {}

	for _, v2 in instance:GetAccessories(true) do
		assetIdsInHumanoidDescription[v2.AssetId] = true
	end

	assetIdsInHumanoidDescription[instance.Face] = true
	assetIdsInHumanoidDescription[instance.Head] = true
	assetIdsInHumanoidDescription[instance.Torso] = true
	assetIdsInHumanoidDescription[instance.LeftArm] = true
	assetIdsInHumanoidDescription[instance.RightArm] = true
	assetIdsInHumanoidDescription[instance.LeftLeg] = true
	assetIdsInHumanoidDescription[instance.RightLeg] = true

	assetIdsInHumanoidDescription[instance.GraphicTShirt] = true
	assetIdsInHumanoidDescription[instance.Pants] = true
	assetIdsInHumanoidDescription[instance.Shirt] = true

	assetIdsInHumanoidDescription[instance.ClimbAnimation] = true
	assetIdsInHumanoidDescription[instance.FallAnimation] = true
	assetIdsInHumanoidDescription[instance.IdleAnimation] = true
	assetIdsInHumanoidDescription[instance.JumpAnimation] = true
	assetIdsInHumanoidDescription[instance.MoodAnimation] = true
	assetIdsInHumanoidDescription[instance.RunAnimation] = true
	assetIdsInHumanoidDescription[instance.SwimAnimation] = true
	assetIdsInHumanoidDescription[instance.WalkAnimation] = true

	if defineFastFlag then
		for _, makeupDescription in instance:GetChildren() do
			if makeupDescription:IsA("MakeupDescription") then
				assetIdsInHumanoidDescription[makeupDescription.AssetId] = true
			end
		end
	end

	return assetIdsInHumanoidDescription
end

function OutfitViewportUtils.hasMissingAssetsInDescription(p, items): boolean
	local assetIdsInHumanoidDescription = getAssetIdsInHumanoidDescription(p)

	for _, item in items do
		if not assetIdsInHumanoidDescription[item] then
			return true
		end
	end

	return false
end

return OutfitViewportUtils
