local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")

local PeopleService = script:FindFirstAncestor("PeopleService")
local parent = PeopleService.Parent

local Flags = require(PeopleService.Flags)

local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = Flags.FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local FFlagVoiceVolumeControlsPerUserPlayerListButton = Flags.FFlagVoiceVolumeControlsPerUserPlayerListButton
local FFlagVoiceVolumeControlsPerUserPlayerGridMenu = Flags.FFlagVoiceVolumeControlsPerUserPlayerGridMenu

local VoiceChatCore = require(parent.VoiceChatCore)
local VoiceVolumeControlsEligibility = VoiceChatCore.VoiceVolumeControlsEligibility

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local flag = false
local flag2 = false
local v = false
local v2 = nil
local fn
local playerRemovingConnection = nil

local function getVoiceChatServiceManager() -- 1 equivalent call inferred from this helper
	local robloxGui = CoreGui:WaitForChild("RobloxGui")
	local VoiceChatServiceManager = require(robloxGui:WaitForChild("Modules"):WaitForChild("VoiceChat"):WaitForChild("VoiceChatServiceManager"))
	return VoiceChatServiceManager.default
end

local function getPlaySessionId() -- 1 equivalent call inferred from this helper
	if engineFeature then
		return RbxAnalyticsService:GetPlaySessionId()
	end

	return nil
end

local function getVoiceSessionId(object) -- 1 equivalent call inferred from this helper
	local sessionId = nil

	if pcall(function()
		sessionId = object:GetSessionId()
	end) and sessionId ~= nil and sessionId ~= "" then
		return sessionId
	end

	return nil
end

local function beginSession(object) -- 2 equivalent calls inferred from this helper
	if flag2 then
		return
	end

	flag2 = true
	v = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)
	v2 = getVoiceSessionId(object) -- inferred equivalent call

	if v then
		local PeopleAnalyticsManager = require(PeopleService.Analytics.PeopleAnalyticsManager)
		PeopleAnalyticsManager:resetPerUserVoiceVolumeSession()
	end
end

local function flushSession() -- 2 equivalent calls inferred from this helper
	if not flag2 then
		return
	end

	flag2 = false

	if v then
		local PeopleAnalyticsManager = require(PeopleService.Analytics.PeopleAnalyticsManager)
		PeopleAnalyticsManager:flushPerUserVoiceVolumeSession(getPlaySessionId(), v2) -- inferred equivalent call

		v = false
		v2 = nil
	else
		v = false
		v2 = nil
	end
end

local function tryBeginIfJoined(voiceChatServiceManager) -- 1 equivalent call inferred from this helper
	local service = voiceChatServiceManager:getService()

	if (service and service.VoiceChatState) == Enum.VoiceChatState.Joined then
		beginSession(voiceChatServiceManager) -- inferred equivalent call
	end
end

return {
	ensureStarted = function()
		if
			flag
			or not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
			or not (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu)
			or not game:GetEngineFeature("VoiceChatSupported")
		then
			return
		end

		flag = true

		task.defer(function()
			local voiceChatServiceManager = getVoiceChatServiceManager() -- inferred equivalent call
			local localPlayer = Players.LocalPlayer

			if localPlayer then
				playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
					if player ~= localPlayer then
						return
					end

					flushSession() -- inferred equivalent call
				end)
			end

			voiceChatServiceManager:asyncInit():andThen(function()
				fn = function(_, p)
					if p == Enum.VoiceChatState.Joined then
						beginSession(voiceChatServiceManager) -- inferred equivalent call
					elseif p == Enum.VoiceChatState.Ended or p == Enum.VoiceChatState.Failed then
						flushSession() -- inferred equivalent call
					end
				end
				voiceChatServiceManager:subscribe("OnStateChanged", fn)
				tryBeginIfJoined(voiceChatServiceManager) -- inferred equivalent call
			end):catch(function() end)
		end)
	end
}
