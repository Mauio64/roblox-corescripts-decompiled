local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local v3 = game:DefineFastInt("UGCEmoteSkinningDisableTranslationThresholdMillistuds", 100) * 0.001
local t1 = {}

local function getClipMetadata(s1: string) -- line: 15
	-- upvalues: t1 (copy), InsertService (copy)
	if t1[s1] then
		return t1[s1]
	end

	local num = tonumber(s1:match("%d+"))

	if not num then
		return nil
	end

	local ok, result = pcall(function() -- line: 25
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
local function setAllJointsSkinning(p1, b1: boolean) -- line: 52
	for _, descendant in p1:GetDescendants() do
		if descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") or descendant:IsA("BallSocketConstraint") or descendant:IsA("Weld") or descendant:IsA("RigidConstraint") then
			descendant.EnableSkinning = b1
		end
	end
end

local t3 = {}

local function clearActiveEmoteConnection(p2) -- line: 64
	-- upvalues: t3 (copy)
	if t3[p2] then
		t3[p2]:Disconnect()
		t3[p2] = nil
	end
end
local function onCharacterRemoving(p3) -- line: 71
	-- upvalues: t3 (copy)
	if t3[p3] then
		t3[p3]:Disconnect()
		t3[p3] = nil
	end
end
local function onAnimationPlayed(p4, p5) -- line: 75
	-- upvalues: getClipMetadata (copy), v3 (copy), t3 (copy), setAllJointsSkinning (copy)
	local Animation = p5.Animation

	if not Animation then
		return
	end

	local AnimationId = Animation.AnimationId

	if AnimationId == "" then
		return
	end

	task.spawn(function() -- line: 86
		-- upvalues: getClipMetadata (copy), AnimationId (copy), v3 (copy), p5 (copy), p4 (copy), t3 (copy), setAllJointsSkinning (copy)
		local v36 = getClipMetadata(AnimationId)

		if not v36 or not v36.isUGCEmote then
			return
		end

		if v36.maxTranslation <= v3 then
			return
		end

		if not p5.IsPlaying then
			return
		end

		local v37 = p4

		if t3[v37] then
			t3[v37]:Disconnect()
			t3[v37] = nil
		end

		setAllJointsSkinning(p4, false)
		t3[p4] = p5.Stopped:Connect(function() -- line: 102
			-- upvalues: setAllJointsSkinning (copy), p4 (copy), t3 (copy)
			setAllJointsSkinning(p4, true)

			local v46 = p4

			if t3[v46] then
				t3[v46]:Disconnect()
				t3[v46] = nil
			end
		end)
	end)
end
local function onCharacterAdded(p6) -- line: 109
	-- upvalues: getClipMetadata (copy), v3 (copy), t3 (copy), setAllJointsSkinning (copy)
	p6:WaitForChild("Humanoid"):WaitForChild("Animator").AnimationPlayed:Connect(function(animation) -- line: 113
		-- upvalues: p6 (copy), getClipMetadata (copy), v3 (copy), t3 (copy), setAllJointsSkinning (copy)
		local v39 = p6
		local Animation = animation.Animation

		if not Animation then
			return
		end

		local AnimationId = Animation.AnimationId

		if AnimationId == "" then
			return
		end

		task.spawn(function() -- line: 86
			-- upvalues: getClipMetadata (copy), AnimationId (copy), v3 (copy), animation (copy), v39 (copy), t3 (copy), setAllJointsSkinning (copy)
			local v47 = getClipMetadata(AnimationId)

			if not v47 or not v47.isUGCEmote then
				return
			end

			if v47.maxTranslation <= v3 then
				return
			end

			if not animation.IsPlaying then
				return
			end

			local v48 = v39

			if t3[v48] then
				t3[v48]:Disconnect()
				t3[v48] = nil
			end

			setAllJointsSkinning(v39, false)
			t3[v39] = animation.Stopped:Connect(function() -- line: 102
				-- upvalues: setAllJointsSkinning (copy), v39 (copy), t3 (copy)
				setAllJointsSkinning(v39, true)

				local v51 = v39

				if t3[v51] then
					t3[v51]:Disconnect()
					t3[v51] = nil
				end
			end)
		end)
	end)
end
local function onPlayerAdded(p7) -- line: 118
	-- upvalues: getClipMetadata (copy), v3 (copy), t3 (copy), setAllJointsSkinning (copy), onCharacterAdded (copy), onCharacterRemoving (copy)
	if p7.Character then
		local Character = p7.Character

		Character:WaitForChild("Humanoid"):WaitForChild("Animator").AnimationPlayed:Connect(function(animation) -- line: 113
			-- upvalues: Character (copy), getClipMetadata (copy), v3 (copy), t3 (copy), setAllJointsSkinning (copy)
			local v43 = Character
			local Animation = animation.Animation

			if not Animation then
				return
			end

			local AnimationId = Animation.AnimationId

			if AnimationId == "" then
				return
			end

			task.spawn(function() -- line: 86
				-- upvalues: getClipMetadata (copy), AnimationId (copy), v3 (copy), animation (copy), v43 (copy), t3 (copy), setAllJointsSkinning (copy)
				local v49 = getClipMetadata(AnimationId)

				if not v49 or not v49.isUGCEmote then
					return
				end

				if v49.maxTranslation <= v3 then
					return
				end

				if not animation.IsPlaying then
					return
				end

				local v50 = v43

				if t3[v50] then
					t3[v50]:Disconnect()
					t3[v50] = nil
				end

				setAllJointsSkinning(v43, false)
				t3[v43] = animation.Stopped:Connect(function() -- line: 102
					-- upvalues: setAllJointsSkinning (copy), v43 (copy), t3 (copy)
					setAllJointsSkinning(v43, true)

					local v52 = v43

					if t3[v52] then
						t3[v52]:Disconnect()
						t3[v52] = nil
					end
				end)
			end)
		end)
	end

	p7.CharacterAdded:Connect(onCharacterAdded)
	p7.CharacterRemoving:Connect(onCharacterRemoving)
end

for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
