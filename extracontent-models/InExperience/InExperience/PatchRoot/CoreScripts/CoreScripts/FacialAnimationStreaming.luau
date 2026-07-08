game:GetService("VRService")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

game:GetService("RobloxReplicatedStorage")

local RobloxGui = CoreGui.RobloxGui
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local v9 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local default = require(CorePackages.Workspace.Packages.CallProtocol).CallProtocol.default
local Enums = require(CorePackages.Workspace.Packages.CallProtocol).Enums
local EngineFeature = game:GetEngineFeature("LoadStreamAnimationReplaceErrorsWithTelemetryFeature")
local EngineFeature2 = game:GetEngineFeature("FaceAnimatorNotifyLODRecommendCameraInputDisable")
local v14 = game:DefineFastFlag("FacialAnimationStreamingClearTrackImprovementsV2", false)

game:DefineFastFlag("FacialAnimationStreamingValidateAnimatorBeforeRemoving", false)
game:DefineFastFlag("FacialAnimationStreamingSearchForReplacementWhenRemovingAnimator", false)
game:DefineFastFlag("StopStreamTrackOnDeath", false)
game:DefineFastFlag("FacialAnimationStreamingClearAllConnectionsFix2", false)
game:DefineFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C", false)
game:DefineFastFlag("FacialAnimationStreamingFixNilMutedCheck", false)

local GetFFlagAvatarChatServiceEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarChatServiceEnabled
local v16 = if not GetFFlagAvatarChatServiceEnabled() then nil else game:GetService("AvatarChatService")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local v18 = game:DefineFastFlag("UXForCameraPerformanceEnabled", false)
local v19 = game:DefineFastFlag("DisableCameraOnLowspecAndroidCalls", false)
local v20 = game:DefineFastInt("UXForCameraPerformanceSessionDelay", 300)
local v21 = game:DefineFastInt("UXForCameraPerformanceDeviceDelay", 43200)
local GetFFlagUXForCameraPerformanceIXPEnabled = require(RobloxGui.Modules.Flags.GetFFlagUXForCameraPerformanceIXPEnabled)
local GetFStringUXForCameraPerformanceIXPLayerName = require(RobloxGui.Modules.Flags.GetFStringUXForCameraPerformanceIXPLayerName)

local function u24() -- line: 48
	return true
end

if v19 then
	u24 = require(RobloxGui.Modules.Settings.isCamEnabledForUserAndPlace)
end

local FacialAnimationStreamingHeartbeatStats = require(RobloxGui.Modules.FacialAnimationStreaming.FacialAnimationStreamingHeartbeatStats)

if not FaceAnimatorService or not v16 then
	return
end

FaceAnimatorService.FlipHeadOrientation = true

local EmoteHelper = require(RobloxGui.Modules.Emote.EmoteHelper)
local TrackerMenu = require(RobloxGui.Modules.Tracker.TrackerMenu)
local TrackerPromptType = require(RobloxGui.Modules.Tracker.TrackerPromptType)
local default2 = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local t1 = {
	CharacterAdded = "CharacterAdded",
	CharacterRemoving = "CharacterRemoving",
	CharacterDescendantAdded = "CharacterDescendantAdded",
	CharacterDescendantRemoving = "CharacterDescendantRemoving",
	AnimatorDataModelReady = "AnimatorDataModelReady",
	PlayerEmoted = "PlayerEmoted",
	PlayerChatted = "PlayerChatted",
	EmoteFinished = "EmoteFinished",
	PlayerDied = "PlayerDied"
}

RobloxTranslator:FormatByKey("Feature.FaceChat.Message.PlaceUnavailable")

local u31 = false
local timestamp = os.time()
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}
local connection = nil
local connection2 = nil
local u41 = nil
local u42 = nil
local u43 = nil

local function playerTrace(p1, p2) -- line: 107
	-- upvalues: v9 (copy)
	local s1 = ""
	local s2 = ""

	if p2 then
		if p2.UserId then
			s1 = tostring(p2.UserId)
		end

		if p2.Name then
			s2 = p2.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", p1, s1, s2))
end
local function clearConnection(p3, p4) -- line: 121
	-- upvalues: t5 (copy)
	if t5[p3.UserId] and t5[p3.UserId][p4] then
		t5[p3.UserId][p4]:Disconnect()
		t5[p3.UserId][p4] = nil
	end
end
local function clearAllConnections(p5) -- line: 128
	-- upvalues: t1 (copy), t5 (copy)
	if game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") then
		for _, v in pairs(t1) do
			if t5[p5.UserId] and t5[p5.UserId][v] then
				t5[p5.UserId][v]:Disconnect()
				t5[p5.UserId][v] = nil
			end
		end
	else
		for _, v in ipairs(t1) do
			if t5[p5.UserId] and t5[p5.UserId][v] then
				t5[p5.UserId][v]:Disconnect()
				t5[p5.UserId][v] = nil
			end
		end
	end

	t5[p5.UserId] = {}
end
local function clearCharacterAnimations(p6) -- line: 142
	-- upvalues: v9 (copy), t4 (copy), v14 (copy)
	local s3 = ""
	local s4 = ""

	if p6 then
		if p6.UserId then
			s3 = tostring(p6.UserId)
		end

		if p6.Name then
			s4 = p6.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", "clearCharacterAnimations", s3, s4))

	if t4[p6.UserId] then
		if v14 then
			if t4[p6.UserId].animationTrack then
				t4[p6.UserId].animationTrack:Stop(0)
				t4[p6.UserId].animationTrack = nil
			end

			if t4[p6.UserId].animation then
				t4[p6.UserId].animation = nil
			end
		else
			if t4[p6.UserId].animation then
				t4[p6.UserId].animation:Destroy()
				t4[p6.UserId].animation = nil
			end

			if t4[p6.UserId].animationTrack then
				t4[p6.UserId].animationTrack:Stop(0)
				t4[p6.UserId].animationTrack:Destroy()
				t4[p6.UserId].animationTrack = nil
			end
		end

		t4[p6.UserId] = nil
	end
end
local function getPlayerFaceControls(p7) -- line: 169
	if p7 and p7.Character then
		return p7.Character:FindFirstChildWhichIsA("FaceControls", true)
	end

	return nil
end
local function getPlayerHumanoid(p8) -- line: 177
	if p8.Character then
		return p8.Character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end
local function getPlayerAnimator(p9) -- line: 185
	local v87 = if not p9.Character then nil else p9.Character:FindFirstChildOfClass("Humanoid")

	if v87 then
		return v87:FindFirstChildOfClass("Animator")
	end

	return nil
end
local function pauseStreamingAnimationForPlayer(p10) -- line: 194
	-- upvalues: t4 (copy), v9 (copy)
	if t4[p10.UserId] and t4[p10.UserId].animationTrack then
		local s5 = ""
		local s6 = ""

		if p10 then
			if p10.UserId then
				s5 = tostring(p10.UserId)
			end

			if p10.Name then
				s6 = p10.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Pausing facial streaming animations...", s5, s6))
		t4[p10.UserId].animationTrack:AdjustWeight(0.1, 0.5)
	end
end
local function resumeStreamingAnimationForPlayer(p11) -- line: 205
	-- upvalues: t4 (copy), v9 (copy)
	if t4[p11.UserId] and t4[p11.UserId].animationTrack then
		local s7 = ""
		local s8 = ""

		if p11 then
			if p11.UserId then
				s7 = tostring(p11.UserId)
			end

			if p11.Name then
				s8 = p11.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Resuming facial streaming animations...", s7, s8))
		t4[p11.UserId].animationTrack:AdjustWeight(1, 0.5)
	end
end
local function updateStreamTrackStatus() -- line: 212
	-- upvalues: Players (copy), FaceAnimatorService (copy), t4 (copy), v9 (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return
	end

	if FaceAnimatorService.AudioAnimationEnabled or FaceAnimatorService.VideoAnimationEnabled then
		if t4[LocalPlayer.UserId] and t4[LocalPlayer.UserId].animationTrack then
			local s9 = ""
			local s10 = ""

			if LocalPlayer then
				if LocalPlayer.UserId then
					s9 = tostring(LocalPlayer.UserId)
				end

				if LocalPlayer.Name then
					s10 = LocalPlayer.Name
				end
			end

			v9:trace(string.format("%s {id: %s, name: %s}.", "Resuming facial streaming animations...", s9, s10))
			t4[LocalPlayer.UserId].animationTrack:AdjustWeight(1, 0.5)

			return
		end
	elseif t4[LocalPlayer.UserId] and t4[LocalPlayer.UserId].animationTrack then
		local s11 = ""
		local s12 = ""

		if LocalPlayer then
			if LocalPlayer.UserId then
				s11 = tostring(LocalPlayer.UserId)
			end

			if LocalPlayer.Name then
				s12 = LocalPlayer.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Pausing facial streaming animations...", s11, s12))
		t4[LocalPlayer.UserId].animationTrack:AdjustWeight(0.1, 0.5)
	end
end
local function handleEmote(p12, p13, p14) -- line: 226
	-- upvalues: v9 (copy), t1 (copy), t5 (copy), t4 (copy), EmoteHelper (copy), FaceAnimatorService (copy)
	local v102 = string.format("handleEmote {isChatTriggered:%s}", (tostring(p14)))
	local s13 = ""
	local s14 = ""

	if p12 then
		if p12.UserId then
			s13 = tostring(p12.UserId)
		end

		if p12.Name then
			s14 = p12.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", v102, s13, s14))

	if p13 then
		local EmoteFinished = t1.EmoteFinished

		if t5[p12.UserId] and t5[p12.UserId][EmoteFinished] then
			t5[p12.UserId][EmoteFinished]:Disconnect()
			t5[p12.UserId][EmoteFinished] = nil
		end

		if t4[p12.UserId] and t4[p12.UserId].animationTrack then
			local s15 = ""
			local s16 = ""

			if p12 then
				if p12.UserId then
					s15 = tostring(p12.UserId)
				end

				if p12.Name then
					s16 = p12.Name
				end
			end

			v9:trace(string.format("%s {id: %s, name: %s}.", "Pausing facial streaming animations...", s15, s16))
			t4[p12.UserId].animationTrack:AdjustWeight(0.1, 0.5)
		end

		t5[p12.UserId][t1.EmoteFinished] = EmoteHelper.createEmoteFinishEvent(p12, p13, p14):Connect(function() -- line: 241
			-- upvalues: p12 (copy), t1 (copy), t5 (copy), FaceAnimatorService (copy), t4 (copy), v9 (copy)
			local v196 = p12
			local EmoteFinished2 = t1.EmoteFinished

			if t5[v196.UserId] and t5[v196.UserId][EmoteFinished2] then
				t5[v196.UserId][EmoteFinished2]:Disconnect()
				t5[v196.UserId][EmoteFinished2] = nil
			end

			if FaceAnimatorService.AudioAnimationEnabled or FaceAnimatorService.VideoAnimationEnabled then
				local v198 = p12

				if t4[v198.UserId] and t4[v198.UserId].animationTrack then
					local s17 = ""
					local s18 = ""

					if v198 then
						if v198.UserId then
							s17 = tostring(v198.UserId)
						end

						if v198.Name then
							s18 = v198.Name
						end
					end

					v9:trace(string.format("%s {id: %s, name: %s}.", "Resuming facial streaming animations...", s17, s18))
					t4[v198.UserId].animationTrack:AdjustWeight(1, 0.5)

					return
				end
			else
				local v201 = p12

				if t4[v201.UserId] and t4[v201.UserId].animationTrack then
					local s19 = ""
					local s20 = ""

					if v201 then
						if v201.UserId then
							s19 = tostring(v201.UserId)
						end

						if v201.Name then
							s20 = v201.Name
						end
					end

					v9:trace(string.format("%s {id: %s, name: %s}.", "Pausing facial streaming animations...", s19, s20))
					t4[v201.UserId].animationTrack:AdjustWeight(0.1, 0.5)
				end
			end
		end)
	end
end
local function onPlayerChatted(p15, p16) -- line: 257
	-- upvalues: EmoteHelper (copy), handleEmote (copy)
	if if not p15.Character then nil else p15.Character:FindFirstChildOfClass("Humanoid") then
		local v110 = nil

		if string.sub(p16, 1, 3) == "/e " then
			v110 = string.sub(p16, 4)
		elseif string.sub(p16, 1, 7) == "/emote " then
			v110 = string.sub(p16, 8)
		end

		if v110 and EmoteHelper.LegacyDefaultEmotes[v110] then
			wait(EmoteHelper.EMOTE_LOOP_TRANSITION_WAIT_TIME)

			local v111 = EmoteHelper.getAnyActiveDefaultChatTriggeredEmoteTrack(p15)

			if v111 then
				handleEmote(p15, v111, true)
			end
		end
	end
end
local function onAnimatorAdded(p17, p18) -- line: 280
	-- upvalues: t4 (copy), v9 (copy), t1 (copy), t5 (copy), EngineFeature (copy), FaceAnimatorService (copy), Players (copy), t6 (copy)
	if not p18 then
		return
	end

	if not p18.Parent or not p18.Parent:IsA("Humanoid") then
		return
	end

	if t4[p17.UserId] then
		local s21 = ""
		local s22 = ""

		if p17 then
			if p17.UserId then
				s21 = tostring(p17.UserId)
			end

			if p17.Name then
				s22 = p17.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "onAnimatorAdded already done; skipping", s21, s22))

		return
	end

	local AnimatorDataModelReady = t1.AnimatorDataModelReady

	if t5[p17.UserId] and t5[p17.UserId][AnimatorDataModelReady] then
		t5[p17.UserId][AnimatorDataModelReady]:Disconnect()
		t5[p17.UserId][AnimatorDataModelReady] = nil
	end

	local function v117() -- line: 298
		-- upvalues: p18 (copy), p17 (copy), EngineFeature (copy), t4 (copy), FaceAnimatorService (copy), Players (copy), v9 (copy), t6 (copy)
		local t8 = {
			animation = Instance.new("TrackerStreamAnimation")
		}

		if game:GetEngineFeature("UseNewLoadStreamAnimationAPI") then
			t8.animationTrack = p18:LoadStreamAnimationV2(t8.animation, p17)
		else
			t8.animationTrack = p18:LoadStreamAnimation(t8.animation)
		end

		if EngineFeature and not t8.animationTrack then
			return
		end

		t8.animationTrack.Priority = Enum.AnimationPriority.Idle
		t8.animationTrack:Play(0.1, 1)
		t4[p17.UserId] = t8

		local v205 = FaceAnimatorService.AudioAnimationEnabled or FaceAnimatorService.VideoAnimationEnabled

		if p17 == Players.LocalPlayer and not v205 then
			local v206 = p17

			if t4[v206.UserId] and t4[v206.UserId].animationTrack then
				local s23 = ""
				local s24 = ""

				if v206 then
					if v206.UserId then
						s23 = tostring(v206.UserId)
					end

					if v206.Name then
						s24 = v206.Name
					end
				end

				v9:trace(string.format("%s {id: %s, name: %s}.", "Pausing facial streaming animations...", s23, s24))
				t4[v206.UserId].animationTrack:AdjustWeight(0.1, 0.5)
			end
		end

		if game:GetFastFlag("FacialAnimationStreamingValidateAnimatorBeforeRemoving") then
			t6[p17.UserId] = p18
		end
	end

	if p18:IsDescendantOf(game) then
		v117()

		return
	end

	t5[p17.UserId][t1.AnimatorDataModelReady] = p18.AncestryChanged:Connect(function(_, _) -- line: 336
		-- upvalues: p18 (copy), p17 (copy), t1 (copy), t5 (copy), v117 (copy)
		if p18:IsDescendantOf(game) then
			local v211 = p17
			local AnimatorDataModelReady2 = t1.AnimatorDataModelReady

			if t5[v211.UserId] and t5[v211.UserId][AnimatorDataModelReady2] then
				t5[v211.UserId][AnimatorDataModelReady2]:Disconnect()
				t5[v211.UserId][AnimatorDataModelReady2] = nil
			end

			v117()
		end
	end)
end
local function onHumanoidAdded(p21, p22) -- line: 348
	-- upvalues: t1 (copy), t5 (copy), handleEmote (copy), clearCharacterAnimations (copy)
	if not p22 then
		return
	end

	local PlayerEmoted = t1.PlayerEmoted

	if t5[p21.UserId] and t5[p21.UserId][PlayerEmoted] then
		t5[p21.UserId][PlayerEmoted]:Disconnect()
		t5[p21.UserId][PlayerEmoted] = nil
	end

	t5[p21.UserId][t1.PlayerEmoted] = p22.EmoteTriggered:Connect(function(p23, p24) -- line: 356
		-- upvalues: handleEmote (copy), p21 (copy)
		if p23 then
			handleEmote(p21, p24, false)
		end
	end)

	if game:GetFastFlag("StopStreamTrackOnDeath") then
		local PlayerDied = t1.PlayerDied

		if t5[p21.UserId] and t5[p21.UserId][PlayerDied] then
			t5[p21.UserId][PlayerDied]:Disconnect()
			t5[p21.UserId][PlayerDied] = nil
		end

		t5[p21.UserId][t1.PlayerDied] = p22.Died:Connect(function() -- line: 366
			-- upvalues: clearCharacterAnimations (copy), p21 (copy)
			clearCharacterAnimations(p21)
		end)
	end
end
local function onFaceControlsAdded(p25, p26) -- line: 372
	-- upvalues: Players (copy), t7 (copy), default2 (copy), v9 (copy), FaceAnimatorService (copy)
	assert(game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C"))

	if p25 ~= Players.LocalPlayer then
		return
	end

	if t7[p25.UserId] ~= nil and p26 == t7[p25.UserId] then
		return
	end

	t7[p25.UserId] = p26

	if t7[p25.UserId] then
		if if not game:GetFastFlag("FacialAnimationStreamingFixNilMutedCheck") then default2 and not default2.localMuted else default2 and default2.localMuted == false then
			local s25 = ""
			local s26 = ""

			if p25 then
				if p25.UserId then
					s25 = tostring(p25.UserId)
				end

				if p25.Name then
					s26 = p25.Name
				end
			end

			v9:trace(string.format("%s {id: %s, name: %s}.", "FaceControls found -> enabling A2C (Mic is ON)...", s25, s26))
			FaceAnimatorService.AudioAnimationEnabled = true

			return
		end

		local s27 = ""
		local s28 = ""

		if p25 then
			if p25.UserId then
				s27 = tostring(p25.UserId)
			end

			if p25.Name then
				s28 = p25.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "FaceControls found -> won't enable A2C (Mic is MUTED)...", s27, s28))

		return
	end

	if FaceAnimatorService.AudioAnimationEnabled then
		local s29 = ""
		local s30 = ""

		if p25 then
			if p25.UserId then
				s29 = tostring(p25.UserId)
			end

			if p25.Name then
				s30 = p25.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "FaceControls NOT found -> disabling A2C...", s29, s30))
		FaceAnimatorService.AudioAnimationEnabled = false

		return
	end

	local s31 = ""
	local s32 = ""

	if p25 then
		if p25.UserId then
			s31 = tostring(p25.UserId)
		end

		if p25.Name then
			s32 = p25.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", "FaceControls NOT found -> won't disable A2C (already is disabled)...", s31, s32))
end
local function onCharacterDescendantAdded(p27, p28) -- line: 410
	-- upvalues: onAnimatorAdded (copy), onHumanoidAdded (copy), onFaceControlsAdded (copy), getPlayerFaceControls (copy)
	if p28:IsDescendantOf(game) then
		if p28:IsA("Animator") then
			onAnimatorAdded(p27, p28)

			return
		end

		if p28:IsA("Humanoid") then
			onHumanoidAdded(p27, p28)

			return
		end

		if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") and p28:IsA("MeshPart") and p28.Name == "Head" then
			onFaceControlsAdded(p27, getPlayerFaceControls(p27))

			return
		end

		if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") and p28:IsA("FaceControls") then
			onFaceControlsAdded(p27, p28)
		end
	end
end
local function onCharacterDescendantRemoving(p29, p30) -- line: 430
	-- upvalues: t6 (copy), t1 (copy), t5 (copy), clearCharacterAnimations (copy), onAnimatorAdded (copy), onFaceControlsAdded (copy), getPlayerFaceControls (copy)
	if p30:IsA("Animator") then
		if not game:GetFastFlag("FacialAnimationStreamingValidateAnimatorBeforeRemoving") then
			local AnimatorDataModelReady = t1.AnimatorDataModelReady

			if t5[p29.UserId] and t5[p29.UserId][AnimatorDataModelReady] then
				t5[p29.UserId][AnimatorDataModelReady]:Disconnect()
				t5[p29.UserId][AnimatorDataModelReady] = nil
			end

			clearCharacterAnimations(p29)

			return
		end

		if p30 == t6[p29.UserId] then
			local AnimatorDataModelReady = t1.AnimatorDataModelReady

			if t5[p29.UserId] and t5[p29.UserId][AnimatorDataModelReady] then
				t5[p29.UserId][AnimatorDataModelReady]:Disconnect()
				t5[p29.UserId][AnimatorDataModelReady] = nil
			end

			clearCharacterAnimations(p29)
			t6[p29.UserId] = nil

			if game:GetFastFlag("FacialAnimationStreamingSearchForReplacementWhenRemovingAnimator") then
				local v138 = if not p29.Character then nil else p29.Character:FindFirstChildOfClass("Humanoid")
				local v139 = if not v138 then nil else v138:FindFirstChildOfClass("Animator")

				if v139 then
					onAnimatorAdded(p29, v139)

					return
				end
			end
		end
	elseif p30:IsA("Humanoid") then
		local PlayerEmoted = t1.PlayerEmoted

		if t5[p29.UserId] and t5[p29.UserId][PlayerEmoted] then
			t5[p29.UserId][PlayerEmoted]:Disconnect()
			t5[p29.UserId][PlayerEmoted] = nil
		end

		if game:GetFastFlag("StopStreamTrackOnDeath") then
			local PlayerDied = t1.PlayerDied

			if t5[p29.UserId] and t5[p29.UserId][PlayerDied] then
				t5[p29.UserId][PlayerDied]:Disconnect()
				t5[p29.UserId][PlayerDied] = nil

				return
			end
		end
	elseif game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") and (p30:IsA("MeshPart") and p30.Name == "Head" or p30:IsA("FaceControls")) then
		onFaceControlsAdded(p29, getPlayerFaceControls(p29))
	end
end
local function onCharacterAdded(p31, p32) -- line: 463
	-- upvalues: v9 (copy), t1 (copy), t5 (copy), onCharacterDescendantAdded (copy), onCharacterDescendantRemoving (copy), onFaceControlsAdded (copy), getPlayerFaceControls (copy), onHumanoidAdded (copy), getPlayerHumanoid (copy), onAnimatorAdded (copy), getPlayerAnimator (copy)
	local s33 = ""
	local s34 = ""

	if p31 then
		if p31.UserId then
			s33 = tostring(p31.UserId)
		end

		if p31.Name then
			s34 = p31.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", "Player character added", s33, s34))

	local CharacterDescendantAdded = t1.CharacterDescendantAdded

	if t5[p31.UserId] and t5[p31.UserId][CharacterDescendantAdded] then
		t5[p31.UserId][CharacterDescendantAdded]:Disconnect()
		t5[p31.UserId][CharacterDescendantAdded] = nil
	end

	local CharacterDescendantRemoving = t1.CharacterDescendantRemoving

	if t5[p31.UserId] and t5[p31.UserId][CharacterDescendantRemoving] then
		t5[p31.UserId][CharacterDescendantRemoving]:Disconnect()
		t5[p31.UserId][CharacterDescendantRemoving] = nil
	end

	t5[p31.UserId][t1.CharacterDescendantAdded] = p32.DescendantAdded:Connect(function(descendant) -- line: 472
		-- upvalues: onCharacterDescendantAdded (copy), p31 (copy)
		onCharacterDescendantAdded(p31, descendant)
	end)
	t5[p31.UserId][t1.CharacterDescendantRemoving] = p32.DescendantRemoving:Connect(function(descendant) -- line: 477
		-- upvalues: onCharacterDescendantRemoving (copy), p31 (copy)
		onCharacterDescendantRemoving(p31, descendant)
	end)

	if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") then
		onFaceControlsAdded(p31, getPlayerFaceControls(p31))
	end

	onHumanoidAdded(p31, getPlayerHumanoid(p31))
	onAnimatorAdded(p31, getPlayerAnimator(p31))
end
local function onCharacterRemoving(p33, _) -- line: 491
	-- upvalues: v9 (copy), t1 (copy), t5 (copy), clearAllConnections (copy), clearCharacterAnimations (copy)
	local s35 = ""
	local s36 = ""

	if p33 then
		if p33.UserId then
			s35 = tostring(p33.UserId)
		end

		if p33.Name then
			s36 = p33.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", "Player character removing", s35, s36))

	if game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") then
		local CharacterDescendantAdded = t1.CharacterDescendantAdded

		if t5[p33.UserId] and t5[p33.UserId][CharacterDescendantAdded] then
			t5[p33.UserId][CharacterDescendantAdded]:Disconnect()
			t5[p33.UserId][CharacterDescendantAdded] = nil
		end

		local CharacterDescendantRemoving = t1.CharacterDescendantRemoving

		if t5[p33.UserId] and t5[p33.UserId][CharacterDescendantRemoving] then
			t5[p33.UserId][CharacterDescendantRemoving]:Disconnect()
			t5[p33.UserId][CharacterDescendantRemoving] = nil
		end
	else
		clearAllConnections(p33)
	end

	clearCharacterAnimations(p33)
end
local function playerUpdate(p35) -- line: 505
	-- upvalues: v9 (copy), t3 (copy), t4 (copy), clearAllConnections (copy), onCharacterAdded (copy), t5 (copy), t1 (copy), onCharacterRemoving (copy), onPlayerChatted (copy), clearCharacterAnimations (copy)
	local s37 = ""
	local s38 = ""

	if p35 then
		if p35.UserId then
			s37 = tostring(p35.UserId)
		end

		if p35.Name then
			s38 = p35.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", "Player update", s37, s38))

	local v157 = t3[p35.UserId]

	if game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") and v157 and t4[p35.UserId] then
		local s39 = ""
		local s40 = ""

		if p35 then
			if p35.UserId then
				s39 = tostring(p35.UserId)
			end

			if p35.Name then
				s40 = p35.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Player already setup", s39, s40))

		return
	end

	clearAllConnections(p35)

	if v157 then
		if not game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") and t4[p35.UserId] then
			local s41 = ""
			local s42 = ""

			if p35 then
				if p35.UserId then
					s41 = tostring(p35.UserId)
				end

				if p35.Name then
					s42 = p35.Name
				end
			end

			v9:trace(string.format("%s {id: %s, name: %s}.", "Player already setup", s41, s42))

			return
		end

		local s43 = ""
		local s44 = ""

		if p35 then
			if p35.UserId then
				s43 = tostring(p35.UserId)
			end

			if p35.Name then
				s44 = p35.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Player update - joined", s43, s44))

		if p35.Character then
			onCharacterAdded(p35, p35.Character)
		end

		t5[p35.UserId][t1.CharacterAdded] = p35.CharacterAdded:Connect(function(character) -- line: 533
			-- upvalues: onCharacterAdded (copy), p35 (copy)
			onCharacterAdded(p35, character)
		end)
		t5[p35.UserId][t1.CharacterRemoving] = p35.CharacterRemoving:Connect(function(character) -- line: 537
			-- upvalues: onCharacterRemoving (copy), p35 (copy)
			onCharacterRemoving(p35, character)
		end)
		t5[p35.UserId][t1.PlayerChatted] = p35.Chatted:Connect(function(message) -- line: 541
			-- upvalues: onPlayerChatted (copy), p35 (copy)
			onPlayerChatted(p35, message)
		end)

		return
	end

	local s45 = ""
	local s46 = ""

	if p35 then
		if p35.UserId then
			s45 = tostring(p35.UserId)
		end

		if p35.Name then
			s46 = p35.Name
		end
	end

	v9:trace(string.format("%s {id: %s, name: %s}.", "Player update - left", s45, s46))
	clearCharacterAnimations(p35)
end
local function toggleMute(p36, p37) -- line: 550
	-- upvalues: t4 (copy)
	if t4[p36] and t4[p36].animationTrack then
		t4[p36].animationTrack:TogglePause(p37)
	end
end
local function JoinAllExistingPlayers() -- line: 556
	-- upvalues: Players (copy), t3 (copy), playerUpdate (copy), v9 (copy)
	for _, player in ipairs(Players:GetPlayers()) do
		t3[player.UserId] = true
		playerUpdate(player)
	end

	Players.PlayerRemoving:Connect(function(player) -- line: 562
		-- upvalues: v9 (copy), t3 (copy), playerUpdate (copy)
		local s47 = ""
		local s48 = ""

		if player then
			if player.UserId then
				s47 = tostring(player.UserId)
			end

			if player.Name then
				s48 = player.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Player leaving game", s47, s48))
		t3[player.UserId] = nil
		playerUpdate(player)
	end)
	Players.PlayerAdded:Connect(function(player) -- line: 568
		-- upvalues: v9 (copy), t3 (copy), playerUpdate (copy)
		local s49 = ""
		local s50 = ""

		if player then
			if player.UserId then
				s49 = tostring(player.UserId)
			end

			if player.Name then
				s50 = player.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Player joining game", s49, s50))
		t3[player.UserId] = true
		playerUpdate(player)
	end)
end
local function ConnectStateChangeCallback() -- line: 575
	-- upvalues: default2 (copy), Players (copy), t4 (copy), v9 (copy), t2 (copy), playerUpdate (copy)
	local v170 = default2:getService()
	local UserId = Players.LocalPlayer.UserId

	default2.participantsUpdate.Event:Connect(function(p38) -- line: 579
		-- upvalues: UserId (copy), t4 (copy)
		for k, v in pairs(p38) do
			local num = tonumber(k)

			if num ~= UserId then
				local isMutedLocally = v.isMutedLocally

				if t4[num] and t4[num].animationTrack then
					t4[num].animationTrack:TogglePause(isMutedLocally)
				end
			end
		end
	end)

	if v170 then
		v170.ParticipantsStateChanged:Connect(function(p39, p40, _) -- line: 589
			-- upvalues: Players (copy), v9 (copy), t2 (copy), playerUpdate (copy)
			for _, v in ipairs(p39) do
				local PlayerByUserId = Players:GetPlayerByUserId(v)

				if PlayerByUserId then
					local s51 = ""
					local s52 = ""

					if PlayerByUserId then
						if PlayerByUserId.UserId then
							s51 = tostring(PlayerByUserId.UserId)
						end

						if PlayerByUserId.Name then
							s52 = PlayerByUserId.Name
						end
					end

					v9:trace(string.format("%s {id: %s, name: %s}.", "Player leaving chat", s51, s52))
					t2[PlayerByUserId.UserId] = nil
					playerUpdate(PlayerByUserId)
				end
			end

			for _, v in ipairs(p40) do
				local PlayerByUserId = Players:GetPlayerByUserId(v)

				if PlayerByUserId then
					local s53 = ""
					local s54 = ""

					if PlayerByUserId then
						if PlayerByUserId.UserId then
							s53 = tostring(PlayerByUserId.UserId)
						end

						if PlayerByUserId.Name then
							s54 = PlayerByUserId.Name
						end
					end

					v9:trace(string.format("%s {id: %s, name: %s}.", "Player joining chat", s53, s54))
					t2[PlayerByUserId.UserId] = true
					playerUpdate(PlayerByUserId)
				end
			end
		end)

		return
	end

	v9:trace("Could not find VoiceChatService")
end
local function AttemptToShowCameraPerformanceToast(p42) -- line: 615
	-- upvalues: GetFFlagUXForCameraPerformanceIXPEnabled (copy), IXPServiceWrapper (copy), GetFStringUXForCameraPerformanceIXPLayerName (copy), timestamp (copy), v20 (copy), AttemptToShowCameraPerformanceToast (copy), AppStorageService (copy), v21 (copy), TrackerMenu (copy), TrackerPromptType (copy), RbxAnalyticsService (copy), Players (copy)
	if GetFFlagUXForCameraPerformanceIXPEnabled() then
		local ok, result = pcall(function() -- line: 618
			-- upvalues: IXPServiceWrapper (copy), GetFStringUXForCameraPerformanceIXPLayerName (copy)
			return IXPServiceWrapper:GetLayerData(GetFStringUXForCameraPerformanceIXPLayerName())
		end)

		if not ok then
			return
		end

		if not result then
			return
		end

		if not result.UXForCameraPerformanceEnabled then
			return
		end
	end

	local v175 = os.time() - timestamp

	if not p42 and v175 < v20 then
		task.delay(v20 - v175, function() -- line: 639
			-- upvalues: AttemptToShowCameraPerformanceToast (copy)
			AttemptToShowCameraPerformanceToast(true)
		end)

		return
	end

	local ok, result = pcall(function() -- line: 647
		-- upvalues: AppStorageService (copy)
		return AppStorageService:GetItem("CameraPerformanceUXUnixTimestamp")
	end)

	if ok then
		local num = tonumber(result)

		if os.time() - num < v21 then
			return
		end

		pcall(function() -- line: 659
			-- upvalues: AppStorageService (copy), num (ref), TrackerMenu (copy), TrackerPromptType (copy), RbxAnalyticsService (copy), Players (copy)
			AppStorageService:SetItem("CameraPerformanceUXUnixTimestamp", (tostring(num)))
			AppStorageService:Flush()
			TrackerMenu:showPrompt(TrackerPromptType.LODCameraRecommendDisable)
			RbxAnalyticsService:SendEventDeferred("client", "avatarChat", "UXForCameraPerformanceShown", {
				userId = Players.LocalPlayer.UserId,
				pid = tostring(game.PlaceId)
			})
		end)

		return
	end
end

function InitializeVoiceChat() -- line: 681
	-- upvalues: ConnectStateChangeCallback (copy), default2 (copy), v9 (copy), u41 (ref), Players (copy), FaceAnimatorService (copy)
	if default2 then
		default2:asyncInit():catch(function(_) -- line: 688
			-- upvalues: v9 (copy)
			v9:trace("VoiceChat:asyncInit failed (possibly denied mic permission)")
		end):finally(function() -- line: 682
			-- upvalues: ConnectStateChangeCallback (copy)
			ConnectStateChangeCallback()
		end)
		u41 = default2.muteChanged.Event:connect(function(p44) -- line: 694
			-- upvalues: Players (copy), v9 (copy), FaceAnimatorService (copy)
			if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") then
				local LocalPlayer = Players.LocalPlayer
				local v247 = if not LocalPlayer or not LocalPlayer.Character then nil else LocalPlayer.Character:FindFirstChildWhichIsA("FaceControls", true)

				v9:trace("Syncing audio processing with VoiceChat mute changed: muted=" .. tostring(p44) .. " hasFaceControls=" .. tostring(v247 ~= nil))
				FaceAnimatorService.AudioAnimationEnabled = not p44 and v247 ~= nil

				return
			end

			v9:trace("Syncing audio processing with VoiceChat mute changed: muted=" .. tostring(p44))
			FaceAnimatorService.AudioAnimationEnabled = not p44
		end)

		local v179 = false

		if default2.localMuted ~= nil then
			v9:trace("Syncing audio processing with VoiceChat mute status: muted=" .. tostring(default2.localMuted))
			v179 = not default2.localMuted
		end

		if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") then
			local LocalPlayer = Players.LocalPlayer
			local v181 = if not LocalPlayer or not LocalPlayer.Character then nil else LocalPlayer.Character:FindFirstChildWhichIsA("FaceControls", true)

			v9:trace("Syncing audio processing with Dynamic Head status: hasFaceControls=" .. tostring(v181 ~= nil))
			v179 = v179 and v181 ~= nil
		end

		FaceAnimatorService.AudioAnimationEnabled = v179

		return
	end

	ConnectStateChangeCallback()
end
function CleanupVoiceChat() -- line: 732
	-- upvalues: u41 (ref)
	if u41 then
		u41:Disconnect()
		u41 = nil
	end
end
function InitializeFacialAnimationStreaming(p45) -- line: 739
	-- upvalues: u31 (ref), connection (ref), FaceAnimatorService (copy), v9 (copy), TrackerMenu (copy), TrackerPromptType (copy), v19 (copy), u24 (ref), GetFFlagAvatarChatServiceEnabled (copy), v16 (copy), EngineFeature2 (copy), connection2 (ref), v18 (copy), AttemptToShowCameraPerformanceToast (copy), default (copy), Enums (copy), JoinAllExistingPlayers (copy), FacialAnimationStreamingHeartbeatStats (copy)
	if u31 then
		return
	end

	u31 = true
	connection = FaceAnimatorService.TrackerError:Connect(function(p46) -- line: 747
		-- upvalues: v9 (copy), TrackerMenu (copy), TrackerPromptType (copy)
		local v249 = string.format("TrackerError: %s", (tostring(p46)))

		v9:trace(string.format("%s {id: %s, name: %s}.", v249, "", ""))

		if p46 == Enum.TrackerError.VideoNoPermission then
			TrackerMenu:showPrompt(TrackerPromptType.VideoNoPermission)

			return
		end

		if p46 == Enum.TrackerError.VideoUnsupported then
			TrackerMenu:showPrompt(TrackerPromptType.VideoUnsupported)

			return
		end

		if p46 == Enum.TrackerError.UnsupportedDevice then
			TrackerMenu:showPrompt(TrackerPromptType.UnsupportedDevice)

			return
		end

		TrackerMenu:showPrompt(TrackerPromptType.NotAvailable)
	end)

	if v19 and not u24() then
		v9:trace("Camera is disabled for user and place")

		return
	end

	if GetFFlagAvatarChatServiceEnabled() then
		FaceAnimatorService:Init(v16:IsEnabled(p45, Enum.AvatarChatServiceFeature.UserVideo), v16:IsEnabled(p45, Enum.AvatarChatServiceFeature.UserAudio))
	end

	if EngineFeature2 then
		connection2 = FaceAnimatorService.TrackerPrompt:Connect(function(p47) -- line: 774
			-- upvalues: v9 (copy), v18 (copy), AttemptToShowCameraPerformanceToast (copy), TrackerMenu (copy), TrackerPromptType (copy)
			local v251 = string.format("TrackerPrompt: %s", (tostring(p47)))

			v9:trace(string.format("%s {id: %s, name: %s}.", v251, "", ""))

			if p47 == Enum.TrackerPromptEvent.LODCameraRecommendDisable then
				if v18 then
					AttemptToShowCameraPerformanceToast()

					return
				end

				TrackerMenu:showPrompt(TrackerPromptType.LODCameraRecommendDisable)
			end
		end)
	end

	default:getCallState():andThen(function(p48) -- line: 787
		-- upvalues: u31 (ref), Enums (copy), FaceAnimatorService (copy), JoinAllExistingPlayers (copy), FacialAnimationStreamingHeartbeatStats (copy)
		if not u31 then
			return
		end

		if p48.status ~= Enums.CallStatus.Idle.rawValue() and p48.status ~= Enums.CallStatus.Ringing.rawValue() then
			FaceAnimatorService.VideoAnimationEnabled = p48.camEnabled
		else
			FaceAnimatorService.VideoAnimationEnabled = false
		end

		InitializeVoiceChat()
		JoinAllExistingPlayers()
		FacialAnimationStreamingHeartbeatStats.Initialize()
	end)
end
function CleanupFacialAnimationStreaming() -- line: 812
	-- upvalues: u31 (ref), FacialAnimationStreamingHeartbeatStats (copy), Players (copy), t3 (copy), playerUpdate (copy), connection (ref), u42 (ref), u43 (ref), EngineFeature2 (copy), connection2 (ref)
	if not u31 then
		return
	end

	u31 = false
	CleanupVoiceChat()
	FacialAnimationStreamingHeartbeatStats.Cleanup()

	for _, player in ipairs(Players:GetPlayers()) do
		t3[player.UserId] = nil
		playerUpdate(player)
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if u42 then
		u42:Disconnect()
		u42 = nil
	end

	if u43 then
		u43:Disconnect()
		u43 = nil
	end

	if EngineFeature2 and connection2 then
		connection2:Disconnect()
		connection2 = nil
	end
end

local function updateWithServiceState(p49) -- line: 850
	-- upvalues: v9 (copy), GetFFlagAvatarChatServiceEnabled (copy), v16 (copy)
	v9:trace(string.format("[updateWithServiceState] state: %s", (tostring(p49))))

	if GetFFlagAvatarChatServiceEnabled() then
		if (v16:IsEnabled(p49, Enum.AvatarChatServiceFeature.UserAudioEligible) or v16:IsEnabled(p49, Enum.AvatarChatServiceFeature.UserVideoEligible)) and v16:IsPlaceEnabled() then
			InitializeFacialAnimationStreaming(p49)

			return
		end

		CleanupFacialAnimationStreaming()

		return
	end

	CleanupFacialAnimationStreaming()
end

u42 = FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(function() -- line: 871
	-- upvalues: Players (copy), FaceAnimatorService (copy), t4 (copy), v9 (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return
	end

	if FaceAnimatorService.AudioAnimationEnabled or FaceAnimatorService.VideoAnimationEnabled then
		if t4[LocalPlayer.UserId] and t4[LocalPlayer.UserId].animationTrack then
			local s55 = ""
			local s56 = ""

			if LocalPlayer then
				if LocalPlayer.UserId then
					s55 = tostring(LocalPlayer.UserId)
				end

				if LocalPlayer.Name then
					s56 = LocalPlayer.Name
				end
			end

			v9:trace(string.format("%s {id: %s, name: %s}.", "Resuming facial streaming animations...", s55, s56))
			t4[LocalPlayer.UserId].animationTrack:AdjustWeight(1, 0.5)

			return
		end
	elseif t4[LocalPlayer.UserId] and t4[LocalPlayer.UserId].animationTrack then
		local s57 = ""
		local s58 = ""

		if LocalPlayer then
			if LocalPlayer.UserId then
				s57 = tostring(LocalPlayer.UserId)
			end

			if LocalPlayer.Name then
				s58 = LocalPlayer.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Pausing facial streaming animations...", s57, s58))
		t4[LocalPlayer.UserId].animationTrack:AdjustWeight(0.1, 0.5)
	end
end)
u43 = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(function() -- line: 875
	-- upvalues: Players (copy), FaceAnimatorService (copy), t4 (copy), v9 (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return
	end

	if FaceAnimatorService.AudioAnimationEnabled or FaceAnimatorService.VideoAnimationEnabled then
		if t4[LocalPlayer.UserId] and t4[LocalPlayer.UserId].animationTrack then
			local s59 = ""
			local s60 = ""

			if LocalPlayer then
				if LocalPlayer.UserId then
					s59 = tostring(LocalPlayer.UserId)
				end

				if LocalPlayer.Name then
					s60 = LocalPlayer.Name
				end
			end

			v9:trace(string.format("%s {id: %s, name: %s}.", "Resuming facial streaming animations...", s59, s60))
			t4[LocalPlayer.UserId].animationTrack:AdjustWeight(1, 0.5)

			return
		end
	elseif t4[LocalPlayer.UserId] and t4[LocalPlayer.UserId].animationTrack then
		local s61 = ""
		local s62 = ""

		if LocalPlayer then
			if LocalPlayer.UserId then
				s61 = tostring(LocalPlayer.UserId)
			end

			if LocalPlayer.Name then
				s62 = LocalPlayer.Name
			end
		end

		v9:trace(string.format("%s {id: %s, name: %s}.", "Pausing facial streaming animations...", s61, s62))
		t4[LocalPlayer.UserId].animationTrack:AdjustWeight(0.1, 0.5)
	end
end)

if GetFFlagAvatarChatServiceEnabled() then
	if v16.ClientFeaturesInitialized then
		updateWithServiceState(v16.ClientFeatures)
	else
		local connection3 = nil

		connection3 = v16:GetPropertyChangedSignal("ClientFeatures"):Connect(function() -- line: 885
			-- upvalues: updateWithServiceState (copy), v16 (copy), connection3 (ref)
			updateWithServiceState(v16.ClientFeatures)
			connection3:Disconnect()
		end)
	end
end
