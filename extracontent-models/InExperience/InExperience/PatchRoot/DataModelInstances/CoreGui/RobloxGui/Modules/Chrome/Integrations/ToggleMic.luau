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
local useIsPlaytestMode = require(Chrome.ChromeShared.Hooks.useIsPlaytestMode)
local FFlagEnablePlaytestModeUnibar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlaytestModeUnibar
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local MappedSignal = ChromeUtils.MappedSignal
local v24 = if not FFlagChromeActivatedMappedSignal then nil else MappedSignal.new(default.muteChanged.Event, function() -- line: 35
	-- upvalues: default (copy)
	return default.localMuted == false
end)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local v26 = require(RobloxGui.Modules.SelfView.Analytics).new()
local u27 = nil

if GetFFlagEnableVoiceMuteAnalytics() then
	u27 = VoiceAnalytics.new(RbxAnalyticsService, "Chrome.Integrations.ToggleMic")
end

local function v28(_) -- line: 51
	-- upvalues: default (copy), v26 (copy), u27 (ref)
	default:ToggleMic("ChromeIntegrationsToggleMic")
	v26:setLastCtx("SelfView")

	if u27 then
		u27:onToggleMuteSelf(not default.localMuted)
	end
end
local function v29(_) -- line: 59
	-- upvalues: default (copy)
	default:RejoinPreviousChannel()
end
local function v30(_) -- line: 63
	-- upvalues: default (copy)
	default:ShowVoiceChatLoadingMessage()
end

local FFlagChangeToggleMicText = require(Chrome.Flags.FFlagChangeToggleMicText)
local u32 = Service:register({
	id = "toggle_mic_mute",
	label = not FFlagChangeToggleMicText and "CoreScripts.TopBar.ToggleMic" or "CoreScripts.TopBar.Mic",
	sideSheetPlacement = SideSheetPlacement.Unibar,
	activated = v28,
	isActivated = if not FFlagChromeActivatedMappedSignal then nil else v24,
	components = {
		Icon = function(_) -- line: 77
			-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), FFlagEnablePlaytestModeUnibar (copy), useIsPlaytestMode (copy), React (copy), VoiceIndicatorFunc (copy), Players (copy), RedVoiceDot (copy)
			local v39 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_SIZE else UnibarStyle.use().ICON_SIZE
			local v40 = if not FFlagEnablePlaytestModeUnibar then nil else useIsPlaytestMode()
			local v41 = (not FFlagEnablePlaytestModeUnibar or not v40) and "MicLight" or "MicDark"

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v39, 0, v39)
			}, {
				React.createElement(VoiceIndicatorFunc, {
					hideOnError = false,
					selectable = false,
					showConnectingShimmer = true,
					userId = tostring(Players.LocalPlayer.UserId),
					iconStyle = v41,
					size = UDim2.new(0, v39, 0, v39)
				}),
				(React.createElement(RedVoiceDot, {
					position = UDim2.new(1, -7, 1, -7)
				}))
			})
		end
	}
})

local function applyVoiceUIVisibility() -- line: 109
	-- upvalues: default (copy), u32 (ref)
	if default.voiceUIVisible then
		u32.availability:pinned()

		return
	end

	u32.availability:unavailable()
end
local function updateVoiceState(_, p6) -- line: 117
	-- upvalues: v13 (copy), default (copy), u32 (ref), v29 (copy), v30 (copy), v28 (copy)
	if p6 ~= Enum.VoiceChatState.Ended then
		if v13 then
			if default.voiceUIVisible then
				u32.availability:pinned()
			else
				u32.availability:unavailable()
			end
		else
			u32.availability:pinned()
		end
	else
		u32.availability:unavailable()
	end

	local v44 = p6 == Enum.VoiceChatState.Failed
	local v45 = p6 == Enum.VoiceChatState.Joining or p6 == Enum.VoiceChatState.JoiningRetry

	if v44 then
		u32.activated = v29

		return
	end

	if v45 then
		u32.activated = v30

		return
	end

	u32.activated = v28
end

if game:GetEngineFeature("VoiceChatSupported") then
	task.spawn(function() -- line: 143
		-- upvalues: default (copy), updateVoiceState (copy), v13 (copy), applyVoiceUIVisibility (copy), u32 (ref)
		default:asyncInit():andThen(function() -- line: 145
			-- upvalues: default (copy), updateVoiceState (copy), v13 (copy), applyVoiceUIVisibility (copy), u32 (ref)
			local v46 = default:getService()

			if v46 then
				v46.StateChanged:Connect(updateVoiceState)
				default:SetupParticipantListeners()

				if v13 then
					default.showVoiceUI.Event:Connect(applyVoiceUIVisibility)
					default.hideVoiceUI.Event:Connect(applyVoiceUIVisibility)

					if default.voiceUIVisible then
						u32.availability:pinned()

						return
					end

					u32.availability:unavailable()

					return
				end

				u32.availability:pinned()
			end
		end):catch(function() -- line: 159
		end)
	end)
end

return u32
