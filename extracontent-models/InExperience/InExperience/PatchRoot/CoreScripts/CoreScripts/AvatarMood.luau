local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalPlayer = Players.LocalPlayer
local _ = CoreGui.RobloxGui

require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)

local u6 = nil
local u7 = nil
local Core = Enum.AnimationPriority.Core
local u9 = nil
local u10 = true
local u11 = false
local t1 = {}
local t2 = {
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
local t3 = {
	wave = true,
	point = true,
	dance = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local function getPlayerHumanoid(p1) -- line: 63
	if p1.Character then
		return p1.Character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end
local function getPlayerAnimator(p2) -- line: 71
	local v36 = if not p2.Character then nil else p2.Character:FindFirstChildOfClass("Humanoid")

	if v36 then
		return v36:FindFirstChildOfClass("Animator")
	end

	return nil
end
local function switchPriority(p3) -- line: 80
	-- upvalues: Core (ref), u7 (ref)
	Core = p3

	if u7 then
		u7.Priority = Core
	end
end
local function disconnectAndRemoveConnection(p4) -- line: 87
	-- upvalues: t1 (copy)
	if t1[p4] ~= nil then
		t1[p4]:Disconnect()
		t1[p4] = nil
	end
end
local function resumeMoodAfterEmote() -- line: 94
	-- upvalues: u9 (ref), u7 (ref), t1 (copy)
	u9 = nil

	if u7 ~= nil then
		u7:Play()
	end

	if t1.currentEmoteTrackStopped ~= nil then
		t1.currentEmoteTrackStopped:Disconnect()
		t1.currentEmoteTrackStopped = nil
	end

	if t1.emoteKeyframeReached ~= nil then
		t1.emoteKeyframeReached:Disconnect()
		t1.emoteKeyframeReached = nil
	end
end
local function onEmoteTriggered(p5, p6) -- line: 104
	-- upvalues: u10 (ref), u7 (ref), u9 (ref), u11 (ref), t1 (copy), t2 (copy)
	if not u10 or u7 == nil then
		return
	end

	if p5 and p6 then
		u7:Stop()
		u9 = p6
		u11 = true

		if t1.currentEmoteTrackStopped ~= nil then
			t1.currentEmoteTrackStopped:Disconnect()
			t1.currentEmoteTrackStopped = nil
		end

		if t1.emoteKeyframeReached ~= nil then
			t1.emoteKeyframeReached:Disconnect()
			t1.emoteKeyframeReached = nil
		end

		t1.currentEmoteTrackStopped = u9.Stopped:Connect(function() -- line: 116
			-- upvalues: u9 (ref), u7 (ref), t2 (copy), t1 (copy), u11 (ref)
			u9 = nil

			if u7 ~= nil then
				u7:Play()
			end

			local EmoteStopped = t2.EmoteStopped

			if t1[EmoteStopped] ~= nil then
				t1[EmoteStopped]:Disconnect()
				t1[EmoteStopped] = nil
			end

			local EmoteKeyframeReached = t2.EmoteKeyframeReached

			if t1[EmoteKeyframeReached] ~= nil then
				t1[EmoteKeyframeReached]:Disconnect()
				t1[EmoteKeyframeReached] = nil
			end

			u11 = false
		end)
		t1.emoteKeyframeReached = u9.KeyframeReached:Connect(function(keyframe) -- line: 122
			-- upvalues: u9 (ref), u7 (ref), t2 (copy), t1 (copy), u11 (ref)
			if keyframe == "End" and not u9.Looped then
				u9 = nil

				if u7 ~= nil then
					u7:Play()
				end

				local EmoteStopped = t2.EmoteStopped

				if t1[EmoteStopped] ~= nil then
					t1[EmoteStopped]:Disconnect()
					t1[EmoteStopped] = nil
				end

				local EmoteKeyframeReached = t2.EmoteKeyframeReached

				if t1[EmoteKeyframeReached] ~= nil then
					t1[EmoteKeyframeReached]:Disconnect()
					t1[EmoteKeyframeReached] = nil
				end

				u11 = false
			end
		end)
	end
end
local function checkEmotePlaying(p7) -- line: 131
	-- upvalues: t3 (copy), t1 (copy), u9 (ref), u11 (ref), u7 (ref), checkEmotePlaying (copy), t2 (copy)
	local PlayingAnimationTracks = p7:GetPlayingAnimationTracks()
	local v43 = false

	for _, v in pairs(PlayingAnimationTracks) do
		if v.IsPlaying and v.Animation.Parent and t3[v.Animation.Parent.Name] then
			if t1.currentEmoteTrackStopped ~= nil then
				t1.currentEmoteTrackStopped:Disconnect()
				t1.currentEmoteTrackStopped = nil
			end

			if t1.emoteKeyframeReached ~= nil then
				t1.emoteKeyframeReached:Disconnect()
				t1.emoteKeyframeReached = nil
			end

			u9 = v
			u11 = false
			u7:Stop()
			t1.currentEmoteTrackStopped = u9.Stopped:Connect(function() -- line: 150
				-- upvalues: checkEmotePlaying (copy), p7 (copy), u11 (ref), u9 (ref), u7 (ref), t2 (copy), t1 (copy)
				wait(0.3)

				if not checkEmotePlaying(p7) and not u11 then
					u9 = nil

					if u7 ~= nil then
						u7:Play()
					end

					local EmoteStopped = t2.EmoteStopped

					if t1[EmoteStopped] ~= nil then
						t1[EmoteStopped]:Disconnect()
						t1[EmoteStopped] = nil
					end

					local EmoteKeyframeReached = t2.EmoteKeyframeReached

					if t1[EmoteKeyframeReached] ~= nil then
						t1[EmoteKeyframeReached]:Disconnect()
						t1[EmoteKeyframeReached] = nil
					end
				end
			end)
			t1.emoteKeyframeReached = u9.KeyframeReached:Connect(function(keyframe) -- line: 159
				-- upvalues: checkEmotePlaying (copy), p7 (copy), u11 (ref), u9 (ref), u7 (ref), t2 (copy), t1 (copy)
				if keyframe == "End" then
					wait(0.3)

					if not checkEmotePlaying(p7) and not u11 then
						u9 = nil

						if u7 ~= nil then
							u7:Play()
						end

						local EmoteStopped = t2.EmoteStopped

						if t1[EmoteStopped] ~= nil then
							t1[EmoteStopped]:Disconnect()
							t1[EmoteStopped] = nil
						end

						local EmoteKeyframeReached = t2.EmoteKeyframeReached

						if t1[EmoteKeyframeReached] ~= nil then
							t1[EmoteKeyframeReached]:Disconnect()
							t1[EmoteKeyframeReached] = nil
						end
					end
				end
			end)
			v43 = true
		end
	end

	return v43
end

LocalPlayer.Chatted:Connect(function(message) -- line: 175
	-- upvalues: u10 (ref), u7 (ref), LocalPlayer (copy), t3 (copy), checkEmotePlaying (copy)
	if not u10 or u7 == nil then
		return
	end

	if LocalPlayer.Character then
		local Humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")

		if Humanoid then
			local s1 = ""

			if string.sub(message, 1, 3) == "/e " then
				s1 = string.sub(message, 4)
			elseif string.sub(message, 1, 7) == "/emote " then
				s1 = string.sub(message, 8)
			end

			if t3[s1] then
				wait(0.3)
				checkEmotePlaying(Humanoid)
			end
		end
	end
end)

local function stopAndDestroyCurrentMoodTrack() -- line: 198
	-- upvalues: u7 (ref)
	if u7 ~= nil then
		u7:Stop()
		u7:Destroy()
		u7 = nil
	end
end
local function stopAndDestroyCurrentMoodTrackConnections() -- line: 206
	-- upvalues: u7 (ref), t1 (copy), u6 (ref)
	if u7 ~= nil then
		u7:Stop()
		u7:Destroy()
		u7 = nil
	end

	if t1.currentEmoteTrackStopped ~= nil then
		t1.currentEmoteTrackStopped:Disconnect()
		t1.currentEmoteTrackStopped = nil
	end

	if t1.emoteKeyframeReached ~= nil then
		t1.emoteKeyframeReached:Disconnect()
		t1.emoteKeyframeReached = nil
	end

	if t1.animationInstanceChanged ~= nil then
		t1.animationInstanceChanged:Disconnect()
		t1.animationInstanceChanged = nil
	end

	if t1.localEmote ~= nil then
		t1.localEmote:Disconnect()
		t1.localEmote = nil
	end

	u6 = nil
end
local function updateCharacterMoodOnAnimatorAdded(_, _, p10, p11) -- line: 215
	-- upvalues: u7 (ref), u6 (ref), Core (ref), u9 (ref), t1 (copy), onEmoteTriggered (copy)
	u7 = p11:LoadAnimation(u6)
	u7.Priority = Core
	task.delay(0.1, function() -- line: 222
		-- upvalues: u9 (ref), u6 (ref), u7 (ref), p11 (copy), Core (ref), t1 (copy), p10 (copy), onEmoteTriggered (copy)
		if u9 == nil and u6 then
			if not u7 then
				u7 = p11:LoadAnimation(u6)
			end

			if u7 then
				u7.Priority = Core
				u7:Play()
			end
		end

		if t1.localEmote ~= nil then
			t1.localEmote:Disconnect()
			t1.localEmote = nil
		end

		t1.localEmote = p10.EmoteTriggered:Connect(onEmoteTriggered)
	end)
end
local function updateCharacterMoodOnHumanoidAdded(p12, p13, p14) -- line: 242
	-- upvalues: u7 (ref), u6 (ref), Core (ref), u9 (ref), t1 (copy), onEmoteTriggered (copy)
	local Animator = p14:FindFirstChild("Animator")

	if Animator then
		u7 = Animator:LoadAnimation(u6)
		u7.Priority = Core
		task.delay(0.1, function() -- line: 222
			-- upvalues: u9 (ref), u6 (ref), u7 (ref), Animator (copy), Core (ref), t1 (copy), p14 (copy), onEmoteTriggered (copy)
			if u9 == nil and u6 then
				if not u7 then
					u7 = Animator:LoadAnimation(u6)
				end

				if u7 then
					u7.Priority = Core
					u7:Play()
				end
			end

			if t1.localEmote ~= nil then
				t1.localEmote:Disconnect()
				t1.localEmote = nil
			end

			t1.localEmote = p14.EmoteTriggered:Connect(onEmoteTriggered)
		end)
	end

	if t1.humanoidAnimatorAdded and t1.humanoidAnimatorAdded ~= nil then
		t1.humanoidAnimatorAdded:Disconnect()
		t1.humanoidAnimatorAdded = nil
	end

	t1.humanoidAnimatorAdded = p14.ChildAdded:Connect(function(child) -- line: 252
		-- upvalues: p12 (copy), p13 (copy), p14 (copy), u7 (ref), u6 (ref), Core (ref), u9 (ref), t1 (copy), onEmoteTriggered (copy)
		if child.Name == "Animator" then
			local _ = p12
			local _ = p13
			local v100 = p14

			u7 = child:LoadAnimation(u6)
			u7.Priority = Core
			task.delay(0.1, function() -- line: 222
				-- upvalues: u9 (ref), u6 (ref), u7 (ref), child (copy), Core (ref), t1 (copy), v100 (copy), onEmoteTriggered (copy)
				if u9 == nil and u6 then
					if not u7 then
						u7 = child:LoadAnimation(u6)
					end

					if u7 then
						u7.Priority = Core
						u7:Play()
					end
				end

				if t1.localEmote ~= nil then
					t1.localEmote:Disconnect()
					t1.localEmote = nil
				end

				t1.localEmote = v100.EmoteTriggered:Connect(onEmoteTriggered)
			end)
		end
	end)
end
local function updateCharacterMood(p15, p16) -- line: 259
	-- upvalues: u10 (ref), t1 (copy), u7 (ref), u6 (ref), updateCharacterMood (copy), updateCharacterMoodOnHumanoidAdded (copy)
	if p15 == nil or (p16 == nil or not u10) then
		return
	end

	if t1.animationInstanceChanged and t1.animationInstanceChanged ~= nil then
		t1.animationInstanceChanged:Disconnect()
		t1.animationInstanceChanged = nil
	end

	if t1.characterHumanoidAdded and t1.characterHumanoidAdded ~= nil then
		t1.characterHumanoidAdded:Disconnect()
		t1.characterHumanoidAdded = nil
	end

	if u7 ~= nil then
		u7:Stop()
		u7:Destroy()
		u7 = nil
	end

	u6 = p16
	t1.animationInstanceChanged = u6.Changed:Connect(function(_) -- line: 275
		-- upvalues: updateCharacterMood (copy), p15 (copy), p16 (copy)
		updateCharacterMood(p15, p16)
	end)

	local Humanoid = p15:FindFirstChildWhichIsA("Humanoid")

	if Humanoid then
		updateCharacterMoodOnHumanoidAdded(p15, p16, Humanoid)
	end

	t1.characterHumanoidAdded = p15.ChildAdded:Connect(function(child) -- line: 284
		-- upvalues: updateCharacterMoodOnHumanoidAdded (copy), p15 (copy), p16 (copy), Humanoid (copy)
		if child:IsA("Humanoid") then
			updateCharacterMoodOnHumanoidAdded(p15, p16, Humanoid)
		end
	end)
end

function initAvatarMood(p18) -- line: 291
	-- upvalues: t1 (copy), u10 (ref), updateCharacterMood (copy), LocalPlayer (copy), u7 (ref), t2 (copy), u6 (ref)
	local MoodsEnabled = p18:FindFirstChild("MoodsEnabled")

	if t1.animateScriptMoodAdded ~= nil then
		t1.animateScriptMoodAdded:Disconnect()
		t1.animateScriptMoodAdded = nil
	end

	if t1.animateScriptMoodRemoved ~= nil then
		t1.animateScriptMoodRemoved:Disconnect()
		t1.animateScriptMoodRemoved = nil
	end

	if MoodsEnabled then
		u10 = false

		return
	end

	local mood = p18:FindFirstChild("mood")

	if mood then
		if #mood:GetChildren() > 0 then
			updateCharacterMood(LocalPlayer.Character, mood:FindFirstChildWhichIsA("Animation"))
		end

		if t1.moodChildAdded ~= nil then
			t1.moodChildAdded:Disconnect()
			t1.moodChildAdded = nil
		end

		t1.moodChildAdded = mood.ChildAdded:Connect(function(child) -- line: 313
			-- upvalues: updateCharacterMood (copy), LocalPlayer (copy)
			if child:IsA("Animation") then
				updateCharacterMood(LocalPlayer.Character, child)
			end
		end)
	else
		if u7 ~= nil then
			u7:Stop()
			u7:Destroy()
			u7 = nil
		end

		local EmoteStopped = t2.EmoteStopped

		if t1[EmoteStopped] ~= nil then
			t1[EmoteStopped]:Disconnect()
			t1[EmoteStopped] = nil
		end

		local EmoteKeyframeReached = t2.EmoteKeyframeReached

		if t1[EmoteKeyframeReached] ~= nil then
			t1[EmoteKeyframeReached]:Disconnect()
			t1[EmoteKeyframeReached] = nil
		end

		local AnimationInstanceChanged = t2.AnimationInstanceChanged

		if t1[AnimationInstanceChanged] ~= nil then
			t1[AnimationInstanceChanged]:Disconnect()
			t1[AnimationInstanceChanged] = nil
		end

		local EmoteTriggered = t2.EmoteTriggered

		if t1[EmoteTriggered] ~= nil then
			t1[EmoteTriggered]:Disconnect()
			t1[EmoteTriggered] = nil
		end

		u6 = nil
	end

	t1.animateScriptMoodAdded = p18.ChildAdded:Connect(function(child) -- line: 322
		-- upvalues: updateCharacterMood (copy), LocalPlayer (copy), t1 (copy), u10 (ref)
		if child.Name == "mood" then
			if #child:GetChildren() > 0 then
				local v105 = child:GetChildren()[1]

				updateCharacterMood(LocalPlayer.Character, v105)
			end

			if t1.moodChildAdded ~= nil then
				t1.moodChildAdded:Disconnect()
				t1.moodChildAdded = nil
			end

			t1.moodChildAdded = child.ChildAdded:Connect(function(child2) -- line: 332
				-- upvalues: updateCharacterMood (copy), LocalPlayer (copy)
				updateCharacterMood(LocalPlayer.Character, child2)
			end)

			return
		end

		if child.Name == "MoodsEnabled" then
			u10 = false
		end
	end)
	t1.animateScriptMoodRemoved = p18.ChildRemoved:Connect(function(child) -- line: 340
		-- upvalues: p18 (copy), updateCharacterMood (copy), LocalPlayer (copy), u7 (ref), t2 (copy), t1 (copy), u6 (ref)
		if child.Name == "mood" then
			local mood2 = p18:FindFirstChild("mood")

			if mood2 then
				updateCharacterMood(LocalPlayer.Character, mood2:FindFirstChildWhichIsA("Animation"))

				return
			end

			if u7 ~= nil then
				u7:Stop()
				u7:Destroy()
				u7 = nil
			end

			local EmoteStopped = t2.EmoteStopped

			if t1[EmoteStopped] ~= nil then
				t1[EmoteStopped]:Disconnect()
				t1[EmoteStopped] = nil
			end

			local EmoteKeyframeReached = t2.EmoteKeyframeReached

			if t1[EmoteKeyframeReached] ~= nil then
				t1[EmoteKeyframeReached]:Disconnect()
				t1[EmoteKeyframeReached] = nil
			end

			local AnimationInstanceChanged = t2.AnimationInstanceChanged

			if t1[AnimationInstanceChanged] ~= nil then
				t1[AnimationInstanceChanged]:Disconnect()
				t1[AnimationInstanceChanged] = nil
			end

			local EmoteTriggered = t2.EmoteTriggered

			if t1[EmoteTriggered] ~= nil then
				t1[EmoteTriggered]:Disconnect()
				t1[EmoteTriggered] = nil
			end

			u6 = nil
		end
	end)
end

local function waitForAnimateScript() -- line: 352
	-- upvalues: LocalPlayer (copy), t1 (copy)
	local Animate = LocalPlayer.Character:FindFirstChild("Animate")

	if Animate then
		initAvatarMood(Animate)
	end

	if t1.animateScriptAdded ~= nil then
		t1.animateScriptAdded:Disconnect()
		t1.animateScriptAdded = nil
	end

	t1.animateScriptAdded = LocalPlayer.Character.ChildAdded:Connect(function(child) -- line: 359
		if child.Name == "Animate" then
			initAvatarMood(child)
		end
	end)
end
local function onHeadAdded(p19) -- line: 367
	-- upvalues: waitForAnimateScript (copy), t1 (copy)
	if p19:FindFirstChildWhichIsA("FaceControls") then
		waitForAnimateScript()
	end

	if t1.headChildAdded ~= nil then
		t1.headChildAdded:Disconnect()
		t1.headChildAdded = nil
	end

	t1.headChildAdded = p19.ChildAdded:Connect(function(child) -- line: 374
		-- upvalues: waitForAnimateScript (copy)
		if child:IsA("FaceControls") then
			waitForAnimateScript()
		end
	end)
end
local function syncWithStreamTrack(p20) -- line: 381
	-- upvalues: t1 (copy), Core (ref), u7 (ref)
	if t1.StreamTrackStopped ~= nil then
		t1.StreamTrackStopped:Disconnect()
		t1.StreamTrackStopped = nil
	end

	Core = Enum.AnimationPriority.Idle

	if u7 then
		u7.Priority = Core
	end

	t1.StreamTrackStopped = p20.Stopped:Connect(function() -- line: 389
		-- upvalues: t1 (copy), Core (ref), u7 (ref)
		if t1.StreamTrackStopped ~= nil then
			t1.StreamTrackStopped:Disconnect()
			t1.StreamTrackStopped = nil
		end

		Core = Enum.AnimationPriority.Core

		if u7 then
			u7.Priority = Core
		end
	end)
end
local function onAnimatorAdded(p21) -- line: 397
	-- upvalues: t1 (copy), t2 (copy), Core (ref), u7 (ref)
	if t1.AnimationStreamTrackPlayed ~= nil then
		t1.AnimationStreamTrackPlayed:Disconnect()
		t1.AnimationStreamTrackPlayed = nil
	end

	t1.AnimationStreamTrackPlayed = p21.AnimationStreamTrackPlayed:Connect(function(p22) -- line: 402
		-- upvalues: t2 (copy), t1 (copy), Core (ref), u7 (ref)
		local StreamTrackStopped = t2.StreamTrackStopped

		if t1[StreamTrackStopped] ~= nil then
			t1[StreamTrackStopped]:Disconnect()
			t1[StreamTrackStopped] = nil
		end

		Core = Enum.AnimationPriority.Idle

		if u7 then
			u7.Priority = Core
		end

		t1[t2.StreamTrackStopped] = p22.Stopped:Connect(function() -- line: 389
			-- upvalues: t1 (copy), Core (ref), u7 (ref)
			if t1.StreamTrackStopped ~= nil then
				t1.StreamTrackStopped:Disconnect()
				t1.StreamTrackStopped = nil
			end

			Core = Enum.AnimationPriority.Core

			if u7 then
				u7.Priority = Core
			end
		end)
	end)

	local v71 = nil

	for _, v73 in (p21:GetPlayingAnimationTracksCoreScript()) do
		if v73:IsA("AnimationStreamTrack") then
			v71 = v73

			break
		end
	end

	if v71 then
		local StreamTrackStopped = t2.StreamTrackStopped

		if t1[StreamTrackStopped] ~= nil then
			t1[StreamTrackStopped]:Disconnect()
			t1[StreamTrackStopped] = nil
		end

		Core = Enum.AnimationPriority.Idle

		if u7 then
			u7.Priority = Core
		end

		t1[t2.StreamTrackStopped] = v71.Stopped:Connect(function() -- line: 389
			-- upvalues: t1 (copy), Core (ref), u7 (ref)
			if t1.StreamTrackStopped ~= nil then
				t1.StreamTrackStopped:Disconnect()
				t1.StreamTrackStopped = nil
			end

			Core = Enum.AnimationPriority.Core

			if u7 then
				u7.Priority = Core
			end
		end)

		return
	end

	Core = Enum.AnimationPriority.Core

	if u7 then
		u7.Priority = Core
	end
end
local function onAnimatorRemoving(p23, _) -- line: 424
	-- upvalues: t1 (copy), Core (ref), u7 (ref), onAnimatorAdded (copy)
	if t1.AnimationStreamTrackPlayed ~= nil then
		t1.AnimationStreamTrackPlayed:Disconnect()
		t1.AnimationStreamTrackPlayed = nil
	end

	if t1.StreamTrackStopped ~= nil then
		t1.StreamTrackStopped:Disconnect()
		t1.StreamTrackStopped = nil
	end

	Core = Enum.AnimationPriority.Core

	if u7 then
		u7.Priority = Core
	end

	local v77 = if not p23.Character then nil else p23.Character:FindFirstChildOfClass("Humanoid")
	local v78 = if not v77 then nil else v77:FindFirstChildOfClass("Animator")

	if v78 then
		onAnimatorAdded(v78)
	end
end
local function onCharacterAdded(p25, p26) -- line: 439
	-- upvalues: onHeadAdded (copy), t1 (copy), u7 (ref), onAnimatorAdded (copy), t2 (copy), Core (ref)
	local Head = p26:FindFirstChild("Head")

	if Head then
		onHeadAdded(Head)
	end

	t1.characterChildAdded = p26.ChildAdded:Connect(function(child) -- line: 445
		-- upvalues: onHeadAdded (copy)
		if child.Name == "Head" then
			onHeadAdded(child)
		end
	end)
	t1.characterChildRemoved = p26.ChildRemoved:Connect(function(child) -- line: 451
		-- upvalues: u7 (ref), p26 (copy), onHeadAdded (copy)
		if child.Name == "Head" then
			if u7 ~= nil then
				u7:Stop()
				u7:Destroy()
				u7 = nil
			end

			local Head2 = p26:FindFirstChild("Head")

			if Head2 then
				onHeadAdded(Head2)
			end
		end
	end)
	t1.DescendantAdded = p26.DescendantAdded:Connect(function(descendant) -- line: 461
		-- upvalues: onAnimatorAdded (copy)
		if descendant:IsA("Animator") then
			onAnimatorAdded(descendant)
		end
	end)

	local Animator = p26:FindFirstChildWhichIsA("Animator", true)

	if Animator then
		onAnimatorAdded(Animator)
	end

	t1.DescendantRemoving = p26.DescendantRemoving:Connect(function(descendant) -- line: 471
		-- upvalues: p25 (copy), t2 (copy), t1 (copy), Core (ref), u7 (ref), onAnimatorAdded (copy)
		if descendant:IsA("Animator") then
			local v121 = p25
			local AnimationStreamTrackPlayed = t2.AnimationStreamTrackPlayed

			if t1[AnimationStreamTrackPlayed] ~= nil then
				t1[AnimationStreamTrackPlayed]:Disconnect()
				t1[AnimationStreamTrackPlayed] = nil
			end

			local StreamTrackStopped = t2.StreamTrackStopped

			if t1[StreamTrackStopped] ~= nil then
				t1[StreamTrackStopped]:Disconnect()
				t1[StreamTrackStopped] = nil
			end

			Core = Enum.AnimationPriority.Core

			if u7 then
				u7.Priority = Core
			end

			local v124 = if not v121.Character then nil else v121.Character:FindFirstChildOfClass("Humanoid")
			local v125 = if not v124 then nil else v124:FindFirstChildOfClass("Animator")

			if v125 then
				onAnimatorAdded(v125)
			end
		end
	end)
end
local function onCharacterRemoving(_) -- line: 478
	-- upvalues: u7 (ref), t1 (copy)
	if u7 ~= nil then
		u7:Stop()
		u7:Destroy()
		u7 = nil
	end

	for _, v in pairs(t1) do
		if v then
			v:Disconnect()
		end
	end

	table.clear(t1)
end

if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character) -- line: 492
	-- upvalues: onCharacterAdded (copy), LocalPlayer (copy)
	onCharacterAdded(LocalPlayer, character)
end)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)
