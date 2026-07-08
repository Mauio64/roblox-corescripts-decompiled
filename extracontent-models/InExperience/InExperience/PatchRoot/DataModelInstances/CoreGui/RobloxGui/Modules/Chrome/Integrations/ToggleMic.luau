local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local React = require(CorePackages.Packages.React)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local VoiceIndicatorFunc = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicatorFunc)
local VoiceAnalytics = require(RobloxGui.Modules.Settings.Analytics.VoiceAnalytics)
local GetFFlagEnableVoiceMuteAnalytics = require(RobloxGui.Modules.Flags.GetFFlagEnableVoiceMuteAnalytics)
local EngineFeature = game:GetEngineFeature("AudioFocusManagement")
local v12 = game:DefineFastFlag("EnableChromeAudioFocusManagement", false)
local v13 = EngineFeature and v12
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(Chrome.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local RedVoiceDot = require(Chrome.Integrations.RedVoiceDot)
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local MappedSignal = ChromeUtils.MappedSignal
local v22 = if not FFlagChromeActivatedMappedSignal then nil else MappedSignal.new(default.muteChanged.Event, function() -- line: 33
	-- upvalues: default (copy)
	return default.localMuted == false
end)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local v24 = require(RobloxGui.Modules.SelfView.Analytics).new()
local u25 = nil

if GetFFlagEnableVoiceMuteAnalytics() then
	u25 = VoiceAnalytics.new(RbxAnalyticsService, "Chrome.Integrations.ToggleMic")
end

local function v26(_) -- line: 49
	-- upvalues: default (copy), v24 (copy), u25 (ref)
	default:ToggleMic("ChromeIntegrationsToggleMic")
	v24:setLastCtx("SelfView")

	if u25 then
		u25:onToggleMuteSelf(not default.localMuted)
	end
end
local function v27(_) -- line: 57
	-- upvalues: default (copy)
	default:RejoinPreviousChannel()
end
local function v28(_) -- line: 61
	-- upvalues: default (copy)
	default:ShowVoiceChatLoadingMessage()
end

local FFlagChangeToggleMicText = require(Chrome.Flags.FFlagChangeToggleMicText)
local u30 = Service:register({
	id = "toggle_mic_mute",
	label = not FFlagChangeToggleMicText and "CoreScripts.TopBar.ToggleMic" or "CoreScripts.TopBar.Mic",
	sideSheetPlacement = SideSheetPlacement.Unibar,
	activated = v26,
	isActivated = if not FFlagChromeActivatedMappedSignal then nil else v22,
	components = {
		Icon = function(_) -- line: 75
			-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), VoiceIndicatorFunc (copy), Players (copy), RedVoiceDot (copy)
			local v37 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_SIZE else UnibarStyle.use().ICON_SIZE

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v37, 0, v37)
			}, {
				React.createElement(VoiceIndicatorFunc, {
					hideOnError = false,
					iconStyle = "MicLight",
					selectable = false,
					showConnectingShimmer = true,
					userId = tostring(Players.LocalPlayer.UserId),
					size = UDim2.new(0, v37, 0, v37)
				}),
				(React.createElement(RedVoiceDot, {
					position = UDim2.new(1, -7, 1, -7)
				}))
			})
		end
	}
})

local function applyVoiceUIVisibility() -- line: 104
	-- upvalues: default (copy), u30 (ref)
	if default.voiceUIVisible then
		u30.availability:pinned()

		return
	end

	u30.availability:unavailable()
end
local function updateVoiceState(_, p6) -- line: 112
	-- upvalues: v13 (copy), default (copy), u30 (ref), v27 (copy), v28 (copy), v26 (copy)
	if p6 ~= Enum.VoiceChatState.Ended then
		if v13 then
			if default.voiceUIVisible then
				u30.availability:pinned()
			else
				u30.availability:unavailable()
			end
		else
			u30.availability:pinned()
		end
	else
		u30.availability:unavailable()
	end

	local v40 = p6 == Enum.VoiceChatState.Failed
	local v41 = p6 == Enum.VoiceChatState.Joining or p6 == Enum.VoiceChatState.JoiningRetry

	if v40 then
		u30.activated = v27

		return
	end

	if v41 then
		u30.activated = v28

		return
	end

	u30.activated = v26
end

if game:GetEngineFeature("VoiceChatSupported") then
	task.spawn(function() -- line: 138
		-- upvalues: default (copy), updateVoiceState (copy), v13 (copy), applyVoiceUIVisibility (copy), u30 (ref)
		default:asyncInit():andThen(function() -- line: 140
			-- upvalues: default (copy), updateVoiceState (copy), v13 (copy), applyVoiceUIVisibility (copy), u30 (ref)
			local v42 = default:getService()

			if v42 then
				v42.StateChanged:Connect(updateVoiceState)
				default:SetupParticipantListeners()

				if v13 then
					default.showVoiceUI.Event:Connect(applyVoiceUIVisibility)
					default.hideVoiceUI.Event:Connect(applyVoiceUIVisibility)

					if default.voiceUIVisible then
						u30.availability:pinned()

						return
					end

					u30.availability:unavailable()

					return
				end

				u30.availability:pinned()
			end
		end):catch(function() -- line: 154
		end)
	end)
end

return u30
