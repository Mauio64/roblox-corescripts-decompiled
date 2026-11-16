game:GetService("VRService")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
game:GetService("RobloxReplicatedStorage")

local RobloxGui = CoreGui.RobloxGui
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local CallProtocol = require(CorePackages.Workspace.Packages.CallProtocol)
local default = CallProtocol.CallProtocol.default
local CallProtocol2 = require(CorePackages.Workspace.Packages.CallProtocol)
local Enums = CallProtocol2.Enums

local engineFeature = game:GetEngineFeature("LoadStreamAnimationReplaceErrorsWithTelemetryFeature")

local engineFeature2 = game:GetEngineFeature("FaceAnimatorNotifyLODRecommendCameraInputDisable")

local defineFastFlag = game:DefineFastFlag("FacialAnimationStreamingClearTrackImprovementsV2", false)
game:DefineFastFlag("FacialAnimationStreamingValidateAnimatorBeforeRemoving", false)
game:DefineFastFlag("FacialAnimationStreamingSearchForReplacementWhenRemovingAnimator", false)
game:DefineFastFlag("StopStreamTrackOnDeath", false)
game:DefineFastFlag("FacialAnimationStreamingClearAllConnectionsFix2", false)
game:DefineFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C", false)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags.GetFFlagAvatarChatServiceEnabled
local AvatarChatService

if GetFFlagAvatarChatServiceEnabled() then
	AvatarChatService = game:GetService("AvatarChatService")
else
	AvatarChatService = nil
end

local FaceAnimatorService = game:GetService("FaceAnimatorService")
local defineFastFlag2 = game:DefineFastFlag("UXForCameraPerformanceEnabled", false)
local defineFastFlag3 = game:DefineFastFlag("DisableCameraOnLowspecAndroidCalls", false)

local defineFastInt = game:DefineFastInt("UXForCameraPerformanceSessionDelay", 300)
local defineFastInt2 = game:DefineFastInt("UXForCameraPerformanceDeviceDelay", 43200)

local GetFFlagUXForCameraPerformanceIXPEnabled = require(RobloxGui.Modules.Flags.GetFFlagUXForCameraPerformanceIXPEnabled)

local GetFStringUXForCameraPerformanceIXPLayerName = require(RobloxGui.Modules.Flags.GetFStringUXForCameraPerformanceIXPLayerName)

local fn = not defineFastFlag3 and function(): boolean
	return true
end or require(RobloxGui.Modules.Settings.isCamEnabledForUserAndPlace)

local FacialAnimationStreamingHeartbeatStats = require(RobloxGui.Modules.FacialAnimationStreaming.FacialAnimationStreamingHeartbeatStats)

if not (FaceAnimatorService and AvatarChatService) then
	return
end

FaceAnimatorService.FlipHeadOrientation = true

local EmoteHelper = require(RobloxGui.Modules.Emote.EmoteHelper)
local TrackerMenu = require(RobloxGui.Modules.Tracker.TrackerMenu)
local TrackerPromptType = require(RobloxGui.Modules.Tracker.TrackerPromptType)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default2 = VoiceChatServiceManager.default

local v2 = {
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

local flag = false

local lastTime = os.time()

local v3 = {}

local v4 = {}

local v5 = {}
local v6 = {}
local v7 = {}
local v8 = {}

local trackerErrorConnection = nil
local trackerPromptConnection = nil
local eventConnection = nil

local audioAnimationEnabledChangedConnection = nil
local videoAnimationEnabledChangedConnection = nil

local function playerTrace(p, p2) -- 20 equivalent calls inferred from this helper
	local v9 = ""
	local v10 = ""

	if p2 then
		if p2.UserId then
			v9 = tostring(p2.UserId)
		end

		if p2.Name then
			v10 = p2.Name
		end
	end

	v:trace(string.format("%s {id: %s, name: %s}.", p, v9, v10))
end

local function clearConnection(p, p2) -- 16 equivalent calls inferred from this helper
	if v6[p.UserId] and v6[p.UserId][p2] then
		v6[p.UserId][p2]:Disconnect()
		v6[p.UserId][p2] = nil
	end
end

local function clearAllConnections(p)
	if game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") then
		for _, v9 in pairs(v2) do
			clearConnection(p, v9) -- inferred equivalent call
		end
	else
		for _, v9 in ipairs(v2) do
			clearConnection(p, v9) -- inferred equivalent call
		end
	end

	v6[p.UserId] = {}
end

local function clearCharacterAnimations(p)
	playerTrace("clearCharacterAnimations", p) -- inferred equivalent call

	if v5[p.UserId] then
		if defineFastFlag then
			if v5[p.UserId].animationTrack then
				v5[p.UserId].animationTrack:Stop(0)
				v5[p.UserId].animationTrack = nil
			end

			if v5[p.UserId].animation then
				v5[p.UserId].animation = nil
			end
		else
			if v5[p.UserId].animation then
				v5[p.UserId].animation:Destroy()
				v5[p.UserId].animation = nil
			end

			if v5[p.UserId].animationTrack then
				v5[p.UserId].animationTrack:Stop(0)
				v5[p.UserId].animationTrack:Destroy()
				v5[p.UserId].animationTrack = nil
			end
		end

		v5[p.UserId] = nil
	end
end

local function getPlayerFaceControls(player) -- 2 equivalent calls inferred from this helper
	if player and player.Character then
		return player.Character:FindFirstChildWhichIsA("FaceControls", true)
	end

	return nil
end

local function getPlayerHumanoid(player) -- 2 equivalent calls inferred from this helper
	if player.Character then
		return player.Character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end

local function getPlayerAnimator(player) -- 1 equivalent call inferred from this helper
	local playerHumanoid = getPlayerHumanoid(player) -- inferred equivalent call

	if playerHumanoid then
		return playerHumanoid:FindFirstChildOfClass("Animator")
	end

	return nil
end

local function pauseStreamingAnimationForPlayer(p) -- 4 equivalent calls inferred from this helper
	if v5[p.UserId] and v5[p.UserId].animationTrack then
		playerTrace("Pausing facial streaming animations...", p) -- inferred equivalent call
		v5[p.UserId].animationTrack:AdjustWeight(0.1, 0.5)
	end
end

local function resumeStreamingAnimationForPlayer(p) -- 2 equivalent calls inferred from this helper
	if v5[p.UserId] and v5[p.UserId].animationTrack then
		playerTrace("Resuming facial streaming animations...", p) -- inferred equivalent call
		v5[p.UserId].animationTrack:AdjustWeight(1, 0.5)
	end
end

local function updateStreamTrackStatus() -- 2 equivalent calls inferred from this helper
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return
	end

	if FaceAnimatorService.AudioAnimationEnabled or FaceAnimatorService.VideoAnimationEnabled then
		resumeStreamingAnimationForPlayer(localPlayer) -- inferred equivalent call
	else
		pauseStreamingAnimationForPlayer(localPlayer) -- inferred equivalent call
	end
end

local function handleEmote(p, p2, p3)
	playerTrace(string.format("handleEmote {isChatTriggered:%s}", (tostring(p3))), p) -- inferred equivalent call

	if p2 then
		clearConnection(p, v2.EmoteFinished) -- inferred equivalent call
		pauseStreamingAnimationForPlayer(p) -- inferred equivalent call
		v6[p.UserId][v2.EmoteFinished] = EmoteHelper.createEmoteFinishEvent(p, p2, p3):Connect(function()
			clearConnection(p, v2.EmoteFinished) -- inferred equivalent call

			if FaceAnimatorService.AudioAnimationEnabled or FaceAnimatorService.VideoAnimationEnabled then
				resumeStreamingAnimationForPlayer(p) -- inferred equivalent call
			else
				pauseStreamingAnimationForPlayer(p) -- inferred equivalent call
			end
		end)
	end
end

local function onPlayerChatted(player, value)
	if getPlayerHumanoid(player) then -- inferred equivalent call
		local v9 = nil

		if string.sub(value, 1, 3) == "/e " then
			v9 = string.sub(value, 4)
		elseif string.sub(value, 1, 7) == "/emote " then
			v9 = string.sub(value, 8)
		end

		if v9 and EmoteHelper.LegacyDefaultEmotes[v9] then
			wait(EmoteHelper.EMOTE_LOOP_TRANSITION_WAIT_TIME)
			local anyActiveDefaultChatTriggeredEmoteTrack = EmoteHelper.getAnyActiveDefaultChatTriggeredEmoteTrack(player)

			if anyActiveDefaultChatTriggeredEmoteTrack then
				handleEmote(player, anyActiveDefaultChatTriggeredEmoteTrack, true)
			end
		end
	end
end

local function onAnimatorAdded(p, instance)
	if not (instance and (instance.Parent and instance.Parent:IsA("Humanoid"))) then
		return
	end

	if v5[p.UserId] then
		playerTrace("onAnimatorAdded already done; skipping", p) -- inferred equivalent call
	else
		clearConnection(p, v2.AnimatorDataModelReady) -- inferred equivalent call

		local function fn2()
			local v9 = {}
			v9.animation = Instance.new("TrackerStreamAnimation")

			if game:GetEngineFeature("UseNewLoadStreamAnimationAPI") then
				v9.animationTrack = instance:LoadStreamAnimationV2(v9.animation, p)
			else
				v9.animationTrack = instance:LoadStreamAnimation(v9.animation)
			end

			if engineFeature and not v9.animationTrack then
				return
			end

			v9.animationTrack.Priority = Enum.AnimationPriority.Idle
			v9.animationTrack:Play(0.1, 1)

			v5[p.UserId] = v9
			local audioAnimationEnabled = FaceAnimatorService.AudioAnimationEnabled
				or FaceAnimatorService.VideoAnimationEnabled

			if p == Players.LocalPlayer and not audioAnimationEnabled then
				pauseStreamingAnimationForPlayer(p) -- inferred equivalent call
			end

			if game:GetFastFlag("FacialAnimationStreamingValidateAnimatorBeforeRemoving") then
				v7[p.UserId] = instance
			end
		end

		if instance:IsDescendantOf(game) then
			fn2()
		else
			v6[p.UserId][v2.AnimatorDataModelReady] = instance.AncestryChanged:Connect(function(_, _)
				if instance:IsDescendantOf(game) then
					clearConnection(p, v2.AnimatorDataModelReady) -- inferred equivalent call
					fn2()
				end
			end)
		end
	end
end

local function onHumanoidAdded(p, p2)
	if not p2 then
		return
	end

	clearConnection(p, v2.PlayerEmoted) -- inferred equivalent call
	v6[p.UserId][v2.PlayerEmoted] = p2.EmoteTriggered:Connect(function(p3, p4)
		if p3 then
			handleEmote(p, p4, false)
		end
	end)

	if game:GetFastFlag("StopStreamTrackOnDeath") then
		clearConnection(p, v2.PlayerDied) -- inferred equivalent call
		v6[p.UserId][v2.PlayerDied] = p2.Died:Connect(function()
			clearCharacterAnimations(p)
		end)
	end
end

local function onFaceControlsAdded(p, p2)
	assert(game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C"))

	if p ~= Players.LocalPlayer or v8[p.UserId] ~= nil and p2 == v8[p.UserId] then
		return
	end

	v8[p.UserId] = p2

	if v8[p.UserId] then
		if default2 and default2.localMuted == false then
			playerTrace("FaceControls found -> enabling A2C (Mic is ON)...", p) -- inferred equivalent call
			FaceAnimatorService.AudioAnimationEnabled = true
		else
			playerTrace("FaceControls found -> won't enable A2C (Mic is MUTED)...", p) -- inferred equivalent call
		end
	elseif FaceAnimatorService.AudioAnimationEnabled then
		playerTrace("FaceControls NOT found -> disabling A2C...", p) -- inferred equivalent call
		FaceAnimatorService.AudioAnimationEnabled = false
	else
		playerTrace("FaceControls NOT found -> won't disable A2C (already is disabled)...", p) -- inferred equivalent call
	end
end

local function onCharacterDescendantAdded(p, descendant)
	if descendant:IsDescendantOf(game) then
		if descendant:IsA("Animator") then
			onAnimatorAdded(p, descendant)
		elseif descendant:IsA("Humanoid") then
			onHumanoidAdded(p, descendant)
		elseif
			game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C")
			and descendant:IsA("MeshPart")
			and descendant.Name == "Head"
		then
			onFaceControlsAdded(p, getPlayerFaceControls(p))
		elseif
			game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C")
			and descendant:IsA("FaceControls")
		then
			onFaceControlsAdded(p, descendant)
		end
	end
end

local function onCharacterDescendantRemoving(p, descendant)
	if descendant:IsA("Animator") then
		if game:GetFastFlag("FacialAnimationStreamingValidateAnimatorBeforeRemoving") then
			if descendant == v7[p.UserId] then
				clearConnection(p, v2.AnimatorDataModelReady) -- inferred equivalent call
				clearCharacterAnimations(p)
				v7[p.UserId] = nil

				if game:GetFastFlag("FacialAnimationStreamingSearchForReplacementWhenRemovingAnimator") then
					local playerAnimator = getPlayerAnimator(p) -- inferred equivalent call

					if playerAnimator then
						onAnimatorAdded(p, playerAnimator)
					end
				end
			end
		else
			clearConnection(p, v2.AnimatorDataModelReady) -- inferred equivalent call
			clearCharacterAnimations(p)
		end
	elseif descendant:IsA("Humanoid") then
		clearConnection(p, v2.PlayerEmoted) -- inferred equivalent call

		if game:GetFastFlag("StopStreamTrackOnDeath") then
			clearConnection(p, v2.PlayerDied) -- inferred equivalent call
		end
	elseif
		game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C")
		and (descendant:IsA("MeshPart") and descendant.Name == "Head" or descendant:IsA("FaceControls"))
	then
		onFaceControlsAdded(p, getPlayerFaceControls(p))
	end
end

local function onCharacterAdded(player, character)
	playerTrace("Player character added", player) -- inferred equivalent call
	clearConnection(player, v2.CharacterDescendantAdded) -- inferred equivalent call
	clearConnection(player, v2.CharacterDescendantRemoving) -- inferred equivalent call

	v6[player.UserId][v2.CharacterDescendantAdded] = character.DescendantAdded:Connect(function(descendant)
		onCharacterDescendantAdded(player, descendant)
	end)

	v6[player.UserId][v2.CharacterDescendantRemoving] = character.DescendantRemoving:Connect(function(descendant)
		onCharacterDescendantRemoving(player, descendant)
	end)

	if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") then
		onFaceControlsAdded(player, getPlayerFaceControls(player))
	end

	onHumanoidAdded(player, getPlayerHumanoid(player))

	onAnimatorAdded(player, getPlayerAnimator(player))
end

local function onCharacterRemoving(player, _)
	playerTrace("Player character removing", player) -- inferred equivalent call

	if game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") then
		clearConnection(player, v2.CharacterDescendantAdded) -- inferred equivalent call
		clearConnection(player, v2.CharacterDescendantRemoving) -- inferred equivalent call
	else
		clearAllConnections(player)
	end

	clearCharacterAnimations(player)
end

local function playerUpdate(player)
	playerTrace("Player update", player) -- inferred equivalent call
	local v9 = v4[player.UserId]

	if game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") and v9 and v5[player.UserId] then
		playerTrace("Player already setup", player) -- inferred equivalent call
	else
		clearAllConnections(player)

		if v9 then
			if game:GetFastFlag("FacialAnimationStreamingClearAllConnectionsFix2") or not v5[player.UserId] then
				playerTrace("Player update - joined", player) -- inferred equivalent call

				if player.Character then
					onCharacterAdded(player, player.Character)
				end

				v6[player.UserId][v2.CharacterAdded] = player.CharacterAdded:Connect(function(character)
					onCharacterAdded(player, character)
				end)
				v6[player.UserId][v2.CharacterRemoving] = player.CharacterRemoving:Connect(function(character)
					onCharacterRemoving(player, character)
				end)

				v6[player.UserId][v2.PlayerChatted] = player.Chatted:Connect(function(p)
					onPlayerChatted(player, p)
				end)
			else
				playerTrace("Player already setup", player) -- inferred equivalent call
			end
		else
			playerTrace("Player update - left", player) -- inferred equivalent call
			clearCharacterAnimations(player)
		end
	end
end

local function toggleMute(p, isMutedLocally) -- 1 equivalent call inferred from this helper
	if v5[p] and v5[p].animationTrack then
		v5[p].animationTrack:TogglePause(isMutedLocally)
	end
end

local function JoinAllExistingPlayers()
	for _, v9 in ipairs(Players:GetPlayers()) do
		v4[v9.UserId] = true
		playerUpdate(v9)
	end

	Players.PlayerRemoving:Connect(function(player)
		playerTrace("Player leaving game", player) -- inferred equivalent call
		v4[player.UserId] = nil
		playerUpdate(player)
	end)

	Players.PlayerAdded:Connect(function(player)
		playerTrace("Player joining game", player) -- inferred equivalent call
		v4[player.UserId] = true
		playerUpdate(player)
	end)
end

local function ConnectStateChangeCallback()
	local service = default2:getService()

	local userId = Players.LocalPlayer.UserId
	default2.participantsUpdate.Event:Connect(function(items)
		for k, item in pairs(items) do
			local v9 = tonumber(k)

			if v9 ~= userId then
				toggleMute(v9, item.isMutedLocally) -- inferred equivalent call
			end
		end
	end)

	if service then
		service.ParticipantsStateChanged:Connect(function(list, list2, _)
			for _, item in ipairs(list) do
				local playerByUserId = Players:GetPlayerByUserId(item)

				if not playerByUserId then
					continue
				end

				playerTrace("Player leaving chat", playerByUserId) -- inferred equivalent call
				v3[playerByUserId.UserId] = nil
				playerUpdate(playerByUserId)
			end

			for _, item in ipairs(list2) do
				local playerByUserId = Players:GetPlayerByUserId(item)

				if not playerByUserId then
					continue
				end

				playerTrace("Player joining chat", playerByUserId) -- inferred equivalent call
				v3[playerByUserId.UserId] = true
				playerUpdate(playerByUserId)
			end
		end)
	else
		v:trace("Could not find VoiceChatService")
	end
end

local function AttemptToShowCameraPerformanceToast(p)
	if GetFFlagUXForCameraPerformanceIXPEnabled() then
		local success, result = pcall(function()
			return IXPServiceWrapper:GetLayerData(GetFStringUXForCameraPerformanceIXPLayerName())
		end)

		if not (success and result and result.UXForCameraPerformanceEnabled) then
			return
		end
	end

	local v9 = os.time() - lastTime

	if not p and v9 < defineFastInt then
		task.delay(defineFastInt - v9, function()
			AttemptToShowCameraPerformanceToast(true)
		end)
		return
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem("CameraPerformanceUXUnixTimestamp")
	end)

	if not success then
		return
	end

	local v10 = tonumber(result)

	if os.time() - v10 < defineFastInt2 then
		return
	end

	pcall(function()
		AppStorageService:SetItem("CameraPerformanceUXUnixTimestamp", (tostring(v10)))
		AppStorageService:Flush()

		TrackerMenu:showPrompt(TrackerPromptType.LODCameraRecommendDisable)

		RbxAnalyticsService:SendEventDeferred("client", "avatarChat", "UXForCameraPerformanceShown", {
			userId = Players.LocalPlayer.UserId,
			pid = tostring(game.PlaceId)
		})
	end)
end

function InitializeVoiceChat()
	local function fn2() -- 1 equivalent call inferred from this helper
		ConnectStateChangeCallback()
	end

	if not default2 then
		fn2() -- inferred equivalent call
		return
	end

	default2:asyncInit():catch(function(_)
		v:trace("VoiceChat:asyncInit failed (possibly denied mic permission)")
	end):finally(fn2)

	eventConnection = default2.muteChanged.Event:connect(function(p)
		if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") then
			local playerFaceControls = getPlayerFaceControls(Players.LocalPlayer) -- inferred equivalent call
			v:trace("Syncing audio processing with VoiceChat mute changed: muted=" .. tostring(p) .. " hasFaceControls=" .. tostring(playerFaceControls ~= nil))

			FaceAnimatorService.AudioAnimationEnabled = not p and playerFaceControls ~= nil
		else
			v:trace("Syncing audio processing with VoiceChat mute changed: muted=" .. tostring(p))
			FaceAnimatorService.AudioAnimationEnabled = not p
		end
	end)
	local audioAnimationEnabled

	if default2.localMuted == nil then
		audioAnimationEnabled = false
	else
		v:trace("Syncing audio processing with VoiceChat mute status: muted=" .. tostring(default2.localMuted))

		audioAnimationEnabled = not default2.localMuted
	end

	if game:GetFastFlag("FacialAnimationStreamingIfNoDynamicHeadDisableA2C") then
		local playerFaceControls = getPlayerFaceControls(Players.LocalPlayer) -- inferred equivalent call
		v:trace("Syncing audio processing with Dynamic Head status: hasFaceControls=" .. tostring(playerFaceControls ~= nil))
		audioAnimationEnabled = audioAnimationEnabled and playerFaceControls ~= nil
	end

	FaceAnimatorService.AudioAnimationEnabled = audioAnimationEnabled
end

function CleanupVoiceChat()
	if eventConnection then
		eventConnection:Disconnect()
		eventConnection = nil
	end
end

function InitializeFacialAnimationStreaming(p)
	if flag then
		return
	end

	flag = true

	trackerErrorConnection = FaceAnimatorService.TrackerError:Connect(function(p2)
		local v9 = string.format("TrackerError: %s", (tostring(p2)))
		v:trace(string.format("%s {id: %s, name: %s}.", v9, "", ""))

		if p2 == Enum.TrackerError.VideoNoPermission then
			TrackerMenu:showPrompt(TrackerPromptType.VideoNoPermission)
		elseif p2 == Enum.TrackerError.VideoUnsupported then
			TrackerMenu:showPrompt(TrackerPromptType.VideoUnsupported)
		elseif p2 == Enum.TrackerError.UnsupportedDevice then
			TrackerMenu:showPrompt(TrackerPromptType.UnsupportedDevice)
		else
			TrackerMenu:showPrompt(TrackerPromptType.NotAvailable)
		end
	end)

	if defineFastFlag3 and not fn() then
		v:trace("Camera is disabled for user and place")
		return
	end

	if GetFFlagAvatarChatServiceEnabled() then
		FaceAnimatorService:Init(
			AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserVideo),
			AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserAudio)
		)
	end

	if engineFeature2 then
		trackerPromptConnection = FaceAnimatorService.TrackerPrompt:Connect(function(p2)
			local v9 = string.format("TrackerPrompt: %s", (tostring(p2)))
			v:trace(string.format("%s {id: %s, name: %s}.", v9, "", ""))

			if p2 == Enum.TrackerPromptEvent.LODCameraRecommendDisable then
				if defineFastFlag2 then
					AttemptToShowCameraPerformanceToast()
				else
					TrackerMenu:showPrompt(TrackerPromptType.LODCameraRecommendDisable)
				end
			end
		end)
	end

	default:getCallState():andThen(function(p2)
		if not flag then
			return
		end

		if p2.status == Enums.CallStatus.Idle.rawValue() or p2.status == Enums.CallStatus.Ringing.rawValue() then
			FaceAnimatorService.VideoAnimationEnabled = false
		else
			FaceAnimatorService.VideoAnimationEnabled = p2.camEnabled
		end

		InitializeVoiceChat()

		JoinAllExistingPlayers()
		FacialAnimationStreamingHeartbeatStats.Initialize()
	end)
end

function CleanupFacialAnimationStreaming()
	if not flag then
		return
	end

	flag = false

	CleanupVoiceChat()
	FacialAnimationStreamingHeartbeatStats.Cleanup()

	for _, v9 in ipairs(Players:GetPlayers()) do
		v4[v9.UserId] = nil
		playerUpdate(v9)
	end

	if trackerErrorConnection then
		trackerErrorConnection:Disconnect()
		trackerErrorConnection = nil
	end

	if audioAnimationEnabledChangedConnection then
		audioAnimationEnabledChangedConnection:Disconnect()
		audioAnimationEnabledChangedConnection = nil
	end

	if videoAnimationEnabledChangedConnection then
		videoAnimationEnabledChangedConnection:Disconnect()
		videoAnimationEnabledChangedConnection = nil
	end

	if engineFeature2 and trackerPromptConnection then
		trackerPromptConnection:Disconnect()
		trackerPromptConnection = nil
	end
end

local function updateWithServiceState(clientFeatures)
	v:trace(string.format("[updateWithServiceState] state: %s", (tostring(clientFeatures))))

	if not GetFFlagAvatarChatServiceEnabled() then
		CleanupFacialAnimationStreaming()
	elseif
		(AvatarChatService:IsEnabled(clientFeatures, Enum.AvatarChatServiceFeature.UserAudioEligible) or AvatarChatService:IsEnabled(
			clientFeatures,
			Enum.AvatarChatServiceFeature.UserVideoEligible
		))
		and AvatarChatService:IsPlaceEnabled()
	then
		InitializeFacialAnimationStreaming(clientFeatures)
	else
		CleanupFacialAnimationStreaming()
	end
end

audioAnimationEnabledChangedConnection = FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(function()
	updateStreamTrackStatus() -- inferred equivalent call
end)
videoAnimationEnabledChangedConnection = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(function()
	updateStreamTrackStatus() -- inferred equivalent call
end)

if GetFFlagAvatarChatServiceEnabled() then
	if AvatarChatService.ClientFeaturesInitialized then
		updateWithServiceState(AvatarChatService.ClientFeatures)
	else
		local clientFeaturesChangedConnection = nil
		clientFeaturesChangedConnection = AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Connect(function()
			updateWithServiceState(AvatarChatService.ClientFeatures)
			clientFeaturesChangedConnection:Disconnect()
		end)
	end
end
