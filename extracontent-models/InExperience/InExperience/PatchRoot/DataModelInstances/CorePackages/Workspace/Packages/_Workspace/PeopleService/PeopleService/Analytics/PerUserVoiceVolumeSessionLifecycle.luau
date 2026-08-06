local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local PeopleService = script:FindFirstAncestor("PeopleService")
local PeopleServiceParent = PeopleService.Parent
local Flags = require(PeopleService.Flags)
local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = Flags.FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local FFlagVoiceVolumeControlsPerUserPlayerListButton = Flags.FFlagVoiceVolumeControlsPerUserPlayerListButton
local FFlagVoiceVolumeControlsPerUserPlayerGridMenu = Flags.FFlagVoiceVolumeControlsPerUserPlayerGridMenu
local VoiceVolumeControlsEligibility = require(PeopleServiceParent.VoiceChatCore).VoiceVolumeControlsEligibility
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local u13 = false
local u14 = false
local u15 = false
local u16 = nil
local u17 = nil
local connection = nil

local function getVoiceChatServiceManager() -- line: 29
	-- upvalues: CoreGui (copy)
	local RobloxGui = CoreGui:WaitForChild("RobloxGui")

	return require(RobloxGui:WaitForChild("Modules"):WaitForChild("VoiceChat"):WaitForChild("VoiceChatServiceManager")).default
end
local function getPlaySessionId() -- line: 34
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy)
	if EngineFeature then
		return RbxAnalyticsService:GetPlaySessionId()
	end

	return nil
end
local function getVoiceSessionId(p1) -- line: 41
	local SessionId = nil

	if pcall(function() -- line: 43
		-- upvalues: SessionId (ref), p1 (copy)
		SessionId = p1:GetSessionId()
	end) and (SessionId ~= nil and SessionId ~= "") then
		return SessionId
	end

	return nil
end
local function beginSession(p2) -- line: 52
	-- upvalues: u14 (ref), u15 (ref), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), u16 (ref), PeopleService (copy)
	if u14 then
		return
	end

	u14 = true
	u15 = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)

	local SessionId = nil
	local v30

	if pcall(function() -- line: 43
		-- upvalues: SessionId (ref), p2 (copy)
		SessionId = p2:GetSessionId()
	end) and SessionId ~= nil and SessionId ~= "" then
		v30 = SessionId
	else
		v30 = nil
	end

	u16 = v30

	if u15 then
		require(PeopleService.Analytics.PeopleAnalyticsManager):resetPerUserVoiceVolumeSession()
	end
end
local function flushSession() -- line: 66
	-- upvalues: u14 (ref), u15 (ref), u16 (ref), PeopleService (copy), EngineFeature (copy), RbxAnalyticsService (copy)
	if not u14 then
		return
	end

	u14 = false

	if not u15 then
		u15 = false
		u16 = nil

		return
	end

	require(PeopleService.Analytics.PeopleAnalyticsManager):flushPerUserVoiceVolumeSession(if not EngineFeature then nil else RbxAnalyticsService:GetPlaySessionId(), u16)
	u15 = false
	u16 = nil
end
local function tryBeginIfJoined(p3) -- line: 85
	-- upvalues: u14 (ref), u15 (ref), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), u16 (ref), PeopleService (copy)
	local v32 = p3:getService()

	if (v32 and v32.VoiceChatState) == Enum.VoiceChatState.Joined then
		if u14 then
			return
		end

		u14 = true
		u15 = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)

		local SessionId = nil
		local v34

		if pcall(function() -- line: 43
			-- upvalues: SessionId (ref), p3 (copy)
			SessionId = p3:GetSessionId()
		end) and SessionId ~= nil and SessionId ~= "" then
			v34 = SessionId
		else
			v34 = nil
		end

		u16 = v34

		if u15 then
			require(PeopleService.Analytics.PeopleAnalyticsManager):resetPerUserVoiceVolumeSession()
		end
	end
end

return {
	ensureStarted = function() -- line: 93
		-- upvalues: u13 (ref), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), CoreGui (copy), Players (copy), connection (ref), u14 (ref), u15 (ref), u16 (ref), PeopleService (copy), EngineFeature (copy), RbxAnalyticsService (copy), u17 (ref), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy)
		if u13 then
			return
		end

		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
			return
		end

		if not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
			return
		end

		if not game:GetEngineFeature("VoiceChatSupported") then
			return
		end

		u13 = true
		task.defer(function() -- line: 111
			-- upvalues: CoreGui (copy), Players (copy), connection (ref), u14 (ref), u15 (ref), u16 (ref), PeopleService (copy), EngineFeature (copy), RbxAnalyticsService (copy), u17 (ref), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy)
			local RobloxGui = CoreGui:WaitForChild("RobloxGui")
			local default = require(RobloxGui:WaitForChild("Modules"):WaitForChild("VoiceChat"):WaitForChild("VoiceChatServiceManager")).default
			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer then
				connection = Players.PlayerRemoving:Connect(function(player) -- line: 116
					-- upvalues: LocalPlayer (copy), u14 (ref), u15 (ref), u16 (ref), PeopleService (copy), EngineFeature (copy), RbxAnalyticsService (copy)
					if player ~= LocalPlayer then
						return
					end

					if not u14 then
						return
					end

					u14 = false

					if not u15 then
						u15 = false
						u16 = nil

						return
					end

					require(PeopleService.Analytics.PeopleAnalyticsManager):flushPerUserVoiceVolumeSession(if not EngineFeature then nil else RbxAnalyticsService:GetPlaySessionId(), u16)
					u15 = false
					u16 = nil
				end)
			end

			default:asyncInit():andThen(function() -- line: 125
				-- upvalues: u17 (ref), default (copy), u14 (ref), u15 (ref), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), u16 (ref), PeopleService (copy), EngineFeature (copy), RbxAnalyticsService (copy)
				function u17(_, p5) -- line: 126
					-- upvalues: default (copy), u14 (ref), u15 (ref), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), u16 (ref), PeopleService (copy), EngineFeature (copy), RbxAnalyticsService (copy)
					if p5 == Enum.VoiceChatState.Joined then
						local v45 = default

						if u14 then
							return
						end

						u14 = true
						u15 = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)

						local SessionId = nil
						local v47

						if pcall(function() -- line: 43
							-- upvalues: SessionId (ref), v45 (copy)
							SessionId = v45:GetSessionId()
						end) and SessionId ~= nil and SessionId ~= "" then
							v47 = SessionId
						else
							v47 = nil
						end

						u16 = v47

						if u15 then
							require(PeopleService.Analytics.PeopleAnalyticsManager):resetPerUserVoiceVolumeSession()

							return
						end
					elseif p5 == Enum.VoiceChatState.Ended or p5 == Enum.VoiceChatState.Failed then
						if not u14 then
							return
						end

						u14 = false

						if not u15 then
							u15 = false
							u16 = nil

							return
						end

						require(PeopleService.Analytics.PeopleAnalyticsManager):flushPerUserVoiceVolumeSession(if not EngineFeature then nil else RbxAnalyticsService:GetPlaySessionId(), u16)
						u15 = false
						u16 = nil
					end
				end

				default:subscribe("OnStateChanged", u17)

				local v39 = default
				local v40 = v39:getService()

				if (v40 and v40.VoiceChatState) == Enum.VoiceChatState.Joined then
					if u14 then
						return
					end

					u14 = true
					u15 = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)

					local SessionId = nil
					local v42

					if pcall(function() -- line: 43
						-- upvalues: SessionId (ref), v39 (copy)
						SessionId = v39:GetSessionId()
					end) and SessionId ~= nil and SessionId ~= "" then
						v42 = SessionId
					else
						v42 = nil
					end

					u16 = v42

					if u15 then
						require(PeopleService.Analytics.PeopleAnalyticsManager):resetPerUserVoiceVolumeSession()
					end
				end
			end):catch(function() -- line: 140
			end)
		end)
	end
}
