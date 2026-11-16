local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")

local defineFastFlag = game:DefineFastFlag("EmoteSkinningDisableUseClassLookup", false)

local defineFastFlag2 = game:DefineFastFlag("EmoteSkinningDisableCleanupCharacterConnections", false)
local v = game:DefineFastInt("UGCEmoteSkinningDisableTranslationThresholdMillistuds", 100) * 0.001

local v2 = {}

local function getClipMetadata(animationId: string)
	if v2[animationId] then
		return v2[animationId]
	end

	local v3 = tonumber(animationId:match("%d+"))

	if not v3 then
		return nil
	end

	local success, result = pcall(function()
		return InsertService:LoadAsset(v3)
	end)

	if not (success and result) then
		return nil
	end

	local animationClip = result:FindFirstChildWhichIsA("AnimationClip", true)

	if not animationClip then
		result:Destroy()
		return nil
	end

	local isUGCEmote = animationClip:GetAttribute("isUGCEmote")
	local maxPartTranslation = animationClip:GetAttribute("maxPartTranslation")

	result:Destroy()

	local v4 = {
		isUGCEmote = isUGCEmote == true,
		maxTranslation = typeof(maxPartTranslation) == "number" and maxPartTranslation or 0
	}

	v2[animationId] = v4
	return v4
end

local function setAllJointsSkinning(folder, enableSkinning: boolean)
	for _, descendant in folder:GetDescendants() do
		if not (descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") or descendant:IsA("BallSocketConstraint") or descendant:IsA("Weld") or descendant:IsA("RigidConstraint")) then
			continue
		end

		descendant.EnableSkinning = enableSkinning
	end
end

local v3 = {}
local v4 = {}

local function clearActiveEmoteConnection(p) -- 3 equivalent calls inferred from this helper
	if v3[p] then
		v3[p]:Disconnect()
		v3[p] = nil
	end
end

local function clearAnimationPlayedConnection(p) -- 2 equivalent calls inferred from this helper
	if v4[p] then
		v4[p]:Disconnect()
		v4[p] = nil
	end
end

local function onCharacterRemoving(p)
	clearActiveEmoteConnection(p) -- inferred equivalent call

	if defineFastFlag2 then
		clearAnimationPlayedConnection(p) -- inferred equivalent call
	end
end

local function onAnimationPlayed(instance, data) -- 1 equivalent call inferred from this helper
	local animation = data.Animation

	if not animation then
		return
	end

	local animationId = animation.AnimationId

	if animationId == "" then
		return
	end

	task.spawn(function()
		local clipMetadata = getClipMetadata(animationId)

		if not (clipMetadata and clipMetadata.isUGCEmote) or clipMetadata.maxTranslation <= v or not data.IsPlaying then
			return
		end

		clearActiveEmoteConnection(instance) -- inferred equivalent call
		setAllJointsSkinning(instance, false)

		v3[instance] = data.Stopped:Connect(function()
			setAllJointsSkinning(instance, true)
			clearActiveEmoteConnection(instance) -- inferred equivalent call
		end)
	end)
end

local function onCharacterAdded(character)
	local animator

	if defineFastFlag then
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if not humanoid then
			return
		end

		animator = humanoid:FindFirstChildOfClass("Animator")

		if not animator then
			return
		end
	else
		animator = character:WaitForChild("Humanoid"):WaitForChild("Animator")
	end

	local animationPlayedConnection = animator.AnimationPlayed:Connect(function(data)
		onAnimationPlayed(character, data) -- inferred equivalent call
	end)

	if defineFastFlag2 then
		clearAnimationPlayedConnection(character) -- inferred equivalent call
		v4[character] = animationPlayedConnection
	end
end

local function onPlayerAdded(player)
	if player.Character then
		onCharacterAdded(player.Character)
	end

	player.CharacterAdded:Connect(onCharacterAdded)
	player.CharacterRemoving:Connect(onCharacterRemoving)
end

for _, v5 in Players:GetPlayers() do
	task.spawn(onPlayerAdded, v5)
end

Players.PlayerAdded:Connect(onPlayerAdded)
