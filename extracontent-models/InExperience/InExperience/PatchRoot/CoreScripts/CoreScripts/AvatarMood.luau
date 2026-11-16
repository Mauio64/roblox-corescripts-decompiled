local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalPlayer = Players.LocalPlayer
local RobloxGui = CoreGui.RobloxGui

local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
CoreScriptsInitializer.CoreLogger:new(script.Name)

local v = nil
local track = nil
local priority = Enum.AnimationPriority.Core
local v2 = nil
local v3 = true
local v4 = false

local v5 = {}

local v6 = {
	EmoteStopped = "currentEmoteTrackStopped",
	EmoteKeyframeReached = "emoteKeyframeReached",
	AnimationInstanceChanged = "animationInstanceChanged",
	EmoteTriggered = "localEmote",
	AnimateScriptAdded = "animateScriptAdded",
	AnimateScriptMoodAdded = "animateScriptMoodAdded",
	AnimateScriptMoodRemoved = "animateScriptMoodRemoved",
	MoodChildAdded = "moodChildAdded",
	HeadChildAdded = "headChildAdded",
	CharacterHumanoidAdded = "characterHumanoidAdded",
	HumanoidAnimatorAdded = "humanoidAnimatorAdded",
	CharacterChildAdded = "characterChildAdded",
	CharacterChildRemoved = "characterChildRemoved",
	DescendantAdded = "DescendantAdded",
	DescendantRemoving = "DescendantRemoving",
	AnimationStreamTrackPlayed = "AnimationStreamTrackPlayed",
	StreamTrackStopped = "StreamTrackStopped"
}

local v7 = {
	wave = true,
	point = true,
	dance = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local function getPlayerHumanoid(player) -- 1 equivalent call inferred from this helper
	if player.Character then
		return player.Character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end

local function getPlayerAnimator(player) -- 2 equivalent calls inferred from this helper
	local playerHumanoid = getPlayerHumanoid(player) -- inferred equivalent call

	if playerHumanoid then
		return playerHumanoid:FindFirstChildOfClass("Animator")
	end

	return nil
end

local function switchPriority(p) -- 6 equivalent calls inferred from this helper
	priority = p

	if track then
		track.Priority = priority
	end
end

local function disconnectAndRemoveConnection(p) -- 47 equivalent calls inferred from this helper
	if v5[p] ~= nil then
		v5[p]:Disconnect()
		v5[p] = nil
	end
end

local function resumeMoodAfterEmote()
	v2 = nil

	if track ~= nil then
		track:Play()
	end

	disconnectAndRemoveConnection("currentEmoteTrackStopped") -- inferred equivalent call
	disconnectAndRemoveConnection("emoteKeyframeReached") -- inferred equivalent call
end

local function onEmoteTriggered(p, p2)
	if not v3 or track == nil then
		return
	end

	if p and p2 then
		track:Stop()
		v2 = p2
		v4 = true
		disconnectAndRemoveConnection("currentEmoteTrackStopped") -- inferred equivalent call
		disconnectAndRemoveConnection("emoteKeyframeReached") -- inferred equivalent call
		v5.currentEmoteTrackStopped = v2.Stopped:Connect(function()
			v2 = nil

			if track ~= nil then
				track:Play()
			end

			disconnectAndRemoveConnection(v6.EmoteStopped) -- inferred equivalent call
			disconnectAndRemoveConnection(v6.EmoteKeyframeReached) -- inferred equivalent call

			v4 = false
		end)

		v5.emoteKeyframeReached = v2.KeyframeReached:Connect(function(p3)
			if p3 == "End" and not v2.Looped then
				v2 = nil

				if track ~= nil then
					track:Play()
				end

				disconnectAndRemoveConnection(v6.EmoteStopped) -- inferred equivalent call
				disconnectAndRemoveConnection(v6.EmoteKeyframeReached) -- inferred equivalent call

				v4 = false
			end
		end)
	end
end

local function checkEmotePlaying(humanoid)
	local playingAnimationTracks = humanoid:GetPlayingAnimationTracks()
	local v8 = false

	for _, playingAnimationTrack in pairs(playingAnimationTracks) do
		if not (playingAnimationTrack.IsPlaying and playingAnimationTrack.Animation.Parent and v7[playingAnimationTrack.Animation.Parent.Name]) then
			continue
		end

		disconnectAndRemoveConnection("currentEmoteTrackStopped") -- inferred equivalent call
		disconnectAndRemoveConnection("emoteKeyframeReached") -- inferred equivalent call
		v2 = playingAnimationTrack
		v4 = false
		track:Stop()

		v5.currentEmoteTrackStopped = v2.Stopped:Connect(function()
			wait(0.3)

			if not (checkEmotePlaying(humanoid) or v4) then
				v2 = nil

				if track ~= nil then
					track:Play()
				end

				disconnectAndRemoveConnection(v6.EmoteStopped) -- inferred equivalent call
				disconnectAndRemoveConnection(v6.EmoteKeyframeReached) -- inferred equivalent call
			end
		end)

		v5.emoteKeyframeReached = v2.KeyframeReached:Connect(function(p)
			if p == "End" then
				wait(0.3)

				if not (checkEmotePlaying(humanoid) or v4) then
					v2 = nil

					if track ~= nil then
						track:Play()
					end

					disconnectAndRemoveConnection(v6.EmoteStopped) -- inferred equivalent call
					disconnectAndRemoveConnection(v6.EmoteKeyframeReached) -- inferred equivalent call
				end
			end
		end)
		v8 = true
	end

	return v8
end

LocalPlayer.Chatted:Connect(function(value)
	if not v3 or track == nil then
		return
	end

	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		local v8 = ""

		if string.sub(value, 1, 3) == "/e " then
			v8 = string.sub(value, 4)
		elseif string.sub(value, 1, 7) == "/emote " then
			v8 = string.sub(value, 8)
		end

		if v7[v8] then
			wait(0.3)
			checkEmotePlaying(humanoid)
		end
	end
end)

local function stopAndDestroyCurrentMoodTrack() -- 6 equivalent calls inferred from this helper
	if track ~= nil then
		track:Stop()
		track:Destroy()
		track = nil
	end
end

local function stopAndDestroyCurrentMoodTrackConnections()
	stopAndDestroyCurrentMoodTrack() -- inferred equivalent call
	disconnectAndRemoveConnection("currentEmoteTrackStopped") -- inferred equivalent call
	disconnectAndRemoveConnection("emoteKeyframeReached") -- inferred equivalent call
	disconnectAndRemoveConnection("animationInstanceChanged") -- inferred equivalent call
	disconnectAndRemoveConnection("localEmote") -- inferred equivalent call
	v = nil
end

local function updateCharacterMoodOnAnimatorAdded(_, _, instance, animator) -- 2 equivalent calls inferred from this helper
	track = animator:LoadAnimation(v)
	track.Priority = priority

	task.delay(0.1, function()
		if v2 == nil and v then
			if not track then
				track = animator:LoadAnimation(v)
			end

			if track then
				track.Priority = priority
				track:Play()
			end
		end

		disconnectAndRemoveConnection("localEmote") -- inferred equivalent call
		v5.localEmote = instance.EmoteTriggered:Connect(onEmoteTriggered)
	end)
end

local function updateCharacterMoodOnHumanoidAdded(instance, p, humanoid)
	local animator = humanoid:FindFirstChild("Animator")

	if animator then
		updateCharacterMoodOnAnimatorAdded(nil, nil, humanoid, animator) -- inferred equivalent call
	end

	if v5.humanoidAnimatorAdded then
		disconnectAndRemoveConnection("humanoidAnimatorAdded") -- inferred equivalent call
	end

	v5.humanoidAnimatorAdded = humanoid.ChildAdded:Connect(function(child)
		if child.Name == "Animator" then
			updateCharacterMoodOnAnimatorAdded(nil, nil, humanoid, child) -- inferred equivalent call
		end
	end)
end

local function updateCharacterMood(character, p)
	if character == nil or p == nil or not v3 then
		return
	end

	if v5.animationInstanceChanged then
		disconnectAndRemoveConnection("animationInstanceChanged") -- inferred equivalent call
	end

	if v5.characterHumanoidAdded then
		disconnectAndRemoveConnection("characterHumanoidAdded") -- inferred equivalent call
	end

	stopAndDestroyCurrentMoodTrack() -- inferred equivalent call
	v = p
	v5.animationInstanceChanged = v.Changed:Connect(function(_)
		updateCharacterMood(character, p)
	end)

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		updateCharacterMoodOnHumanoidAdded(character, p, humanoid)
	end

	v5.characterHumanoidAdded = character.ChildAdded:Connect(function(humanoid2)
		if humanoid2:IsA("Humanoid") then
			updateCharacterMoodOnHumanoidAdded(character, p, humanoid)
		end
	end)
end

function initAvatarMood(instance)
	local moodsEnabled = instance:FindFirstChild("MoodsEnabled")
	disconnectAndRemoveConnection("animateScriptMoodAdded") -- inferred equivalent call
	disconnectAndRemoveConnection("animateScriptMoodRemoved") -- inferred equivalent call

	if moodsEnabled then
		v3 = false
		return
	end

	local mood = instance:FindFirstChild("mood")

	if mood then
		if #mood:GetChildren() > 0 then
			updateCharacterMood(LocalPlayer.Character, mood:FindFirstChildWhichIsA("Animation"))
		end

		disconnectAndRemoveConnection("moodChildAdded") -- inferred equivalent call
		v5.moodChildAdded = mood.ChildAdded:Connect(function(animation)
			if animation:IsA("Animation") then
				updateCharacterMood(LocalPlayer.Character, animation)
			end
		end)
	else
		stopAndDestroyCurrentMoodTrack() -- inferred equivalent call
		disconnectAndRemoveConnection(v6.EmoteStopped) -- inferred equivalent call
		disconnectAndRemoveConnection(v6.EmoteKeyframeReached) -- inferred equivalent call
		disconnectAndRemoveConnection(v6.AnimationInstanceChanged) -- inferred equivalent call
		disconnectAndRemoveConnection(v6.EmoteTriggered) -- inferred equivalent call
		v = nil
	end

	v5.animateScriptMoodAdded = instance.ChildAdded:Connect(function(child)
		if child.Name == "mood" then
			if #child:GetChildren() > 0 then
				local v8 = child:GetChildren()[1]
				updateCharacterMood(LocalPlayer.Character, v8)
			end

			disconnectAndRemoveConnection("moodChildAdded") -- inferred equivalent call
			v5.moodChildAdded = child.ChildAdded:Connect(function(child2)
				updateCharacterMood(LocalPlayer.Character, child2)
			end)
		elseif child.Name == "MoodsEnabled" then
			v3 = false
		end
	end)

	v5.animateScriptMoodRemoved = instance.ChildRemoved:Connect(function(child)
		if child.Name == "mood" then
			local mood2 = instance:FindFirstChild("mood")

			if mood2 then
				updateCharacterMood(LocalPlayer.Character, mood2:FindFirstChildWhichIsA("Animation"))
				return
			end

			stopAndDestroyCurrentMoodTrack() -- inferred equivalent call
			disconnectAndRemoveConnection(v6.EmoteStopped) -- inferred equivalent call
			disconnectAndRemoveConnection(v6.EmoteKeyframeReached) -- inferred equivalent call
			disconnectAndRemoveConnection(v6.AnimationInstanceChanged) -- inferred equivalent call
			disconnectAndRemoveConnection(v6.EmoteTriggered) -- inferred equivalent call
			v = nil
		end
	end)
end

local function waitForAnimateScript()
	local animate = LocalPlayer.Character:FindFirstChild("Animate")

	if animate then
		initAvatarMood(animate)
	end

	disconnectAndRemoveConnection("animateScriptAdded") -- inferred equivalent call
	v5.animateScriptAdded = LocalPlayer.Character.ChildAdded:Connect(function(child)
		if child.Name == "Animate" then
			initAvatarMood(child)
		end
	end)
end

local function onHeadAdded(instance)
	if instance:FindFirstChildWhichIsA("FaceControls") then
		waitForAnimateScript()
	end

	disconnectAndRemoveConnection("headChildAdded") -- inferred equivalent call
	v5.headChildAdded = instance.ChildAdded:Connect(function(faceControls)
		if faceControls:IsA("FaceControls") then
			waitForAnimateScript()
		end
	end)
end

local function syncWithStreamTrack(p)
	disconnectAndRemoveConnection("StreamTrackStopped") -- inferred equivalent call
	switchPriority(Enum.AnimationPriority.Idle) -- inferred equivalent call

	v5.StreamTrackStopped = p.Stopped:Connect(function()
		disconnectAndRemoveConnection("StreamTrackStopped") -- inferred equivalent call
		priority = Enum.AnimationPriority.Core

		if track then
			track.Priority = priority
		end
	end)
end

local function onAnimatorAdded(object)
	disconnectAndRemoveConnection("AnimationStreamTrackPlayed") -- inferred equivalent call
	v5.AnimationStreamTrackPlayed = object.AnimationStreamTrackPlayed:Connect(function(p)
		disconnectAndRemoveConnection(v6.StreamTrackStopped) -- inferred equivalent call

		switchPriority(Enum.AnimationPriority.Idle) -- inferred equivalent call

		v5[v6.StreamTrackStopped] = p.Stopped:Connect(function()
			disconnectAndRemoveConnection("StreamTrackStopped") -- inferred equivalent call
			priority = Enum.AnimationPriority.Core

			if track then
				track.Priority = priority
			end
		end)
	end)

	local playingAnimationTracksCoreScript = object:GetPlayingAnimationTracksCoreScript()
	local v8 = nil

	for _, animationStreamTrack in playingAnimationTracksCoreScript do
		if animationStreamTrack:IsA("AnimationStreamTrack") then
			v8 = animationStreamTrack
			break
		end
	end

	if v8 then
		disconnectAndRemoveConnection(v6.StreamTrackStopped) -- inferred equivalent call

		switchPriority(Enum.AnimationPriority.Idle) -- inferred equivalent call

		v5[v6.StreamTrackStopped] = v8.Stopped:Connect(function()
			disconnectAndRemoveConnection("StreamTrackStopped") -- inferred equivalent call
			priority = Enum.AnimationPriority.Core

			if track then
				track.Priority = priority
			end
		end)
	else
		switchPriority(Enum.AnimationPriority.Core) -- inferred equivalent call
	end
end

local function onAnimatorRemoving(p, _)
	disconnectAndRemoveConnection("AnimationStreamTrackPlayed") -- inferred equivalent call
	disconnectAndRemoveConnection("StreamTrackStopped") -- inferred equivalent call
	switchPriority(Enum.AnimationPriority.Core) -- inferred equivalent call
	local playerAnimator = getPlayerAnimator(p) -- inferred equivalent call

	if playerAnimator then
		onAnimatorAdded(playerAnimator)
	end
end

local function onCharacterAdded(localPlayer, character)
	local head = character:FindFirstChild("Head")

	if head then
		onHeadAdded(head)
	end

	v5.characterChildAdded = character.ChildAdded:Connect(function(child)
		if child.Name == "Head" then
			onHeadAdded(child)
		end
	end)

	v5.characterChildRemoved = character.ChildRemoved:Connect(function(child)
		if child.Name == "Head" then
			stopAndDestroyCurrentMoodTrack() -- inferred equivalent call
			local head2 = character:FindFirstChild("Head")

			if head2 then
				onHeadAdded(head2)
			end
		end
	end)

	v5.DescendantAdded = character.DescendantAdded:Connect(function(animator)
		if animator:IsA("Animator") then
			onAnimatorAdded(animator)
		end
	end)
	local animator = character:FindFirstChildWhichIsA("Animator", true)

	if animator then
		onAnimatorAdded(animator)
	end

	v5.DescendantRemoving = character.DescendantRemoving:Connect(function(animator2)
		if animator2:IsA("Animator") then
			disconnectAndRemoveConnection(v6.AnimationStreamTrackPlayed) -- inferred equivalent call
			disconnectAndRemoveConnection(v6.StreamTrackStopped) -- inferred equivalent call

			switchPriority(Enum.AnimationPriority.Core) -- inferred equivalent call
			local playerAnimator = getPlayerAnimator(localPlayer) -- inferred equivalent call

			if playerAnimator then
				onAnimatorAdded(playerAnimator)
			end
		end
	end)
end

local function onCharacterRemoving(_)
	stopAndDestroyCurrentMoodTrack() -- inferred equivalent call

	for _, connection in pairs(v5) do
		if connection then
			connection:Disconnect()
		end
	end

	table.clear(v5)
end

if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)
	onCharacterAdded(LocalPlayer, character)
end)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)
