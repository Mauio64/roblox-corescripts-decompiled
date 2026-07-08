local Players = game:GetService("Players")
local AvatarEditorService = game:GetService("AvatarEditorService")
local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local t1 = {}
local v5 = game:DefineFastString("AvatarSwitcherEmoteIds", "3344650532,3344585679,5911729486")
local FFlagAvatarSwitcherAccurateAvatarWarning = require(Parent.AvatarExperienceFlags).FFlagAvatarSwitcherAccurateAvatarWarning
local v7 = game:DefineFastFlag("AvatarSwitcherMakeupSupport", false)

function t1.buildOutfitModel(n1: number, p1) -- line: 17
	-- upvalues: Players (copy), AvatarEditorService (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy)
	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		local HumanoidDescriptionFromOutfitIdAsync = Players:GetHumanoidDescriptionFromOutfitIdAsync(n1)
		local v13 = AvatarEditorService:ConformToAvatarRulesAsync(HumanoidDescriptionFromOutfitIdAsync)
		local v14 = Players:CreateHumanoidModelFromDescriptionAsync(v13, p1)

		if FFlagAvatarSwitcherAccurateAvatarWarning then
			return v14, v13
		end

		return v14
	end

	local HumanoidDescriptionFromOutfitId = Players:GetHumanoidDescriptionFromOutfitId(n1)
	local v16 = AvatarEditorService:ConformToAvatarRules(HumanoidDescriptionFromOutfitId)
	local v17 = Players:CreateHumanoidModelFromDescription(v16, p1)

	if FFlagAvatarSwitcherAccurateAvatarWarning then
		return v17, v16
	end

	return v17
end
function t1.getCameraDistance(p2, n2: number) -- line: 40
	local _, v21 = p2:GetBoundingBox()

	return (v21 / 2).Magnitude / math.sin((math.rad(n2 / 2)))
end
function t1.loadIdleAnimationForAvatar(p3) -- line: 48
	local Humanoid = p3:FindFirstChildOfClass("Humanoid")
	local v24 = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

	if not v24 then
		return nil
	end

	local Animate = p3:FindFirstChild("Animate")

	if not Animate then
		return nil
	end

	local idle = Animate:FindFirstChild("idle")

	if not idle then
		return nil
	end

	local Animation = idle:FindFirstChildOfClass("Animation")

	if not Animation then
		return nil
	end

	local track = v24:LoadAnimation(Animation)

	track.Looped = true

	return track
end
function t1.loadAnimationTrackForAvatar(s1: string, p4) -- line: 76
	local Humanoid = p4:FindFirstChildOfClass("Humanoid")
	local v32 = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

	if not v32 then
		return nil
	end

	local Animation = Instance.new("Animation")

	Animation.AnimationId = "rbxassetid://" .. s1

	return (v32:LoadAnimation(Animation))
end

local u8 = nil

function t1.playRandomEmote(p5) -- line: 91
	-- upvalues: v5 (copy), u8 (ref), t1 (copy)
	local Humanoid = p5:FindFirstChildOfClass("Humanoid")
	local v36 = Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R15
	local u37 = nil
	local ok, result = pcall(function() -- line: 96
		-- upvalues: v5 (copy)
		return string.split(v5)
	end)

	if v36 and (ok and #result > 0) then
		local v40

		repeat
			v40 = result[math.random(#result)]
		until v40 ~= u8 or #result == 1

		u37 = t1.loadAnimationTrackForAvatar(v40, p5)
		u8 = v40
	end

	task.spawn(function() -- line: 111
		-- upvalues: u37 (ref), p5 (copy), t1 (copy)
		if u37 then
			u37.Looped = false
			u37:Play()
			u37.Stopped:Wait()
		end

		if p5.Parent == nil then
			return
		end

		local v56 = t1.loadIdleAnimationForAvatar(p5)

		if v56 then
			v56.Looped = true
			v56:Play()
		end
	end)
end
function t1.hasMissingAccessoriesInHumanoid(p6, p7) -- line: 135
	local Accessories = p7:GetAccessories(true)
	local Accessories2 = p6:GetAccessories()

	return #Accessories > #Accessories2
end

local function getAssetIdsInHumanoidDescription(p8) -- line: 147
	-- upvalues: v7 (copy)
	local t2 = {}

	for _, v48 in p8:GetAccessories(true) do
		t2[v48.AssetId] = true
	end

	t2[p8.Face] = true
	t2[p8.Head] = true
	t2[p8.Torso] = true
	t2[p8.LeftArm] = true
	t2[p8.RightArm] = true
	t2[p8.LeftLeg] = true
	t2[p8.RightLeg] = true
	t2[p8.GraphicTShirt] = true
	t2[p8.Pants] = true
	t2[p8.Shirt] = true
	t2[p8.ClimbAnimation] = true
	t2[p8.FallAnimation] = true
	t2[p8.IdleAnimation] = true
	t2[p8.JumpAnimation] = true
	t2[p8.MoodAnimation] = true
	t2[p8.RunAnimation] = true
	t2[p8.SwimAnimation] = true
	t2[p8.WalkAnimation] = true

	if v7 then
		for _, child in p8:GetChildren() do
			if child:IsA("MakeupDescription") then
				t2[child.AssetId] = true
			end
		end
	end

	return t2
end

function t1.hasMissingAssetsInDescription(p9, t3: {[any]: any}) -- line: 188
	-- upvalues: getAssetIdsInHumanoidDescription (copy)
	local v53 = getAssetIdsInHumanoidDescription(p9)

	for _, v55 in t3 do
		if not v53[v55] then
			return true
		end
	end

	return false
end

return t1
