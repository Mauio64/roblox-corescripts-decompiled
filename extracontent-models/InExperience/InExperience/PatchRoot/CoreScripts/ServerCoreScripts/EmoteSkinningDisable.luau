local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local v3 = game:DefineFastFlag("EmoteSkinningDisableUseClassLookup", false)
local v4 = game:DefineFastInt("UGCEmoteSkinningDisableTranslationThresholdMillistuds", 100) * 0.001
local t1 = {}

local function getClipMetadata(s1: string) -- line: 16
	-- upvalues: t1 (copy), InsertService (copy)
	if t1[s1] then
		return t1[s1]
	end

	local num = tonumber(s1:match("%d+"))

	if not num then
		return nil
	end

	local ok, result = pcall(function() -- line: 26
		-- upvalues: InsertService (copy), num (copy)
		return InsertService:LoadAsset(num)
	end)

	if not ok or not result then
		return nil
	end

	local AnimationClip = result:FindFirstChildWhichIsA("AnimationClip", true)

	if not AnimationClip then
		result:Destroy()

		return nil
	end

	local isUGCEmote = AnimationClip:GetAttribute("isUGCEmote")
	local maxPartTranslation = AnimationClip:GetAttribute("maxPartTranslation")

	result:Destroy()

	local t2 = {
		isUGCEmote = isUGCEmote == true,
		maxTranslation = typeof(maxPartTranslation) == "number" and maxPartTranslation or 0
	}

	t1[s1] = t2

	return t2
end
local function setAllJointsSkinning(p1, b1: boolean) -- line: 53
	for _, descendant in p1:GetDescendants() do
		if descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") or descendant:IsA("BallSocketConstraint") or descendant:IsA("Weld") or descendant:IsA("RigidConstraint") then
			descendant.EnableSkinning = b1
		end
	end
end

local t3 = {}

local function clearActiveEmoteConnection(p2) -- line: 65
	-- upvalues: t3 (copy)
	if t3[p2] then
		t3[p2]:Disconnect()
		t3[p2] = nil
	end
end
local function onCharacterRemoving(p3) -- line: 72
	-- upvalues: t3 (copy)
	if t3[p3] then
		t3[p3]:Disconnect()
		t3[p3] = nil
	end
end
local function onAnimationPlayed(p4, p5) -- line: 76
	-- upvalues: getClipMetadata (copy), v4 (copy), t3 (copy), setAllJointsSkinning (copy)
	local Animation = p5.Animation

	if not Animation then
		return
	end

	local AnimationId = Animation.AnimationId

	if AnimationId == "" then
		return
	end

	task.spawn(function() -- line: 87
		-- upvalues: getClipMetadata (copy), AnimationId (copy), v4 (copy), p5 (copy), p4 (copy), t3 (copy), setAllJointsSkinning (copy)
		local v38 = getClipMetadata(AnimationId)

		if not v38 or not v38.isUGCEmote then
			return
		end

		if v38.maxTranslation <= v4 then
			return
		end

		if not p5.IsPlaying then
			return
		end

		local v39 = p4

		if t3[v39] then
			t3[v39]:Disconnect()
			t3[v39] = nil
		end

		setAllJointsSkinning(p4, false)
		t3[p4] = p5.Stopped:Connect(function() -- line: 103
			-- upvalues: setAllJointsSkinning (copy), p4 (copy), t3 (copy)
			setAllJointsSkinning(p4, true)

			local v44 = p4

			if t3[v44] then
				t3[v44]:Disconnect()
				t3[v44] = nil
			end
		end)
	end)
end
local function onCharacterAdded(p6) -- line: 110
	-- upvalues: v3 (copy), getClipMetadata (copy), v4 (copy), t3 (copy), setAllJointsSkinning (copy)
	local Animator

	if v3 then
		local Humanoid = p6:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return
		end

		Animator = Humanoid:FindFirstChildOfClass("Animator")

		if not Animator then
			return
		end
	else
		Animator = p6:WaitForChild("Humanoid"):WaitForChild("Animator")
	end

	Animator.AnimationPlayed:Connect(function(animation) -- line: 127
		-- upvalues: p6 (copy), getClipMetadata (copy), v4 (copy), t3 (copy), setAllJointsSkinning (copy)
		local v41 = p6
		local Animation = animation.Animation

		if not Animation then
			return
		end

		local AnimationId = Animation.AnimationId

		if AnimationId == "" then
			return
		end

		task.spawn(function() -- line: 87
			-- upvalues: getClipMetadata (copy), AnimationId (copy), v4 (copy), animation (copy), v41 (copy), t3 (copy), setAllJointsSkinning (copy)
			local v45 = getClipMetadata(AnimationId)

			if not v45 or not v45.isUGCEmote then
				return
			end

			if v45.maxTranslation <= v4 then
				return
			end

			if not animation.IsPlaying then
				return
			end

			local v46 = v41

			if t3[v46] then
				t3[v46]:Disconnect()
				t3[v46] = nil
			end

			setAllJointsSkinning(v41, false)
			t3[v41] = animation.Stopped:Connect(function() -- line: 103
				-- upvalues: setAllJointsSkinning (copy), v41 (copy), t3 (copy)
				setAllJointsSkinning(v41, true)

				local v47 = v41

				if t3[v47] then
					t3[v47]:Disconnect()
					t3[v47] = nil
				end
			end)
		end)
	end)
end
local function onPlayerAdded(p7) -- line: 132
	-- upvalues: onCharacterAdded (copy), onCharacterRemoving (copy)
	if p7.Character then
		onCharacterAdded(p7.Character)
	end

	p7.CharacterAdded:Connect(onCharacterAdded)
	p7.CharacterRemoving:Connect(onCharacterRemoving)
end

for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
