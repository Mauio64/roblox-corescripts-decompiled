local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local Foundation = require(CorePackages.Packages.Foundation)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local VoiceIndicatorFunc = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicatorFunc)
local showVoiceRestrictionEndedSnackbar = require(RobloxGui.Modules.VoiceChat.Helpers.showVoiceRestrictionEndedSnackbar)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagProactiveVoiceRestrictionsUFR = SharedFlags.FFlagProactiveVoiceRestrictionsUFR
local FFlagReactiveVoiceRestrictionsUFR = SharedFlags.FFlagReactiveVoiceRestrictionsUFR
local VoiceAnalytics = require(RobloxGui.Modules.Settings.Analytics.VoiceAnalytics)
local GetFFlagEnableVoiceMuteAnalytics = require(RobloxGui.Modules.Flags.GetFFlagEnableVoiceMuteAnalytics)
local engineFeature = game:GetEngineFeature("AudioFocusManagement")
local defineFastFlag = game:DefineFastFlag("EnableChromeAudioFocusManagement", false)
local v = engineFeature and defineFastFlag

local defineFastFlag2 = game:DefineFastFlag("MicConsumerRegistry", false)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local isVoiceChatSupported = require(Chrome.Integrations.isVoiceChatSupported)
local RedVoiceDot = require(Chrome.Integrations.RedVoiceDot)
local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome3.UnibarStyle
local useIsPlaytestMode = require(Chrome.ChromeShared.Hooks.useIsPlaytestMode)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnablePlaytestModeUnibar = SharedFlags2.FFlagEnablePlaytestModeUnibar
local MappedSignal = ChromeUtils.MappedSignal
local isActivated

if FFlagProactiveVoiceRestrictionsUFR then
	isActivated = ChromeUtils.ObservableValue.new(false)
else
	isActivated = MappedSignal.new(default.muteChanged.Event, function(): boolean
		return default.localMuted == false
	end)
end

local Constants = require(Chrome.ChromeShared.Unibar.Constants)

local Analytics = require(RobloxGui.Modules.SelfView.Analytics)
local v2 = Analytics.new()
local v3

if GetFFlagEnableVoiceMuteAnalytics() then
	v3 = VoiceAnalytics.new(RbxAnalyticsService, "Chrome.Integrations.ToggleMic")
else
	v3 = nil
end

local function handleRestrictedActivation(): boolean -- 3 equivalent calls inferred from this helper
	local voiceRestrictionState = default:GetVoiceRestrictionState(false)

	if voiceRestrictionState == "restricted" then
		default:ShowVoiceRestriction()
	elseif FFlagReactiveVoiceRestrictionsUFR and voiceRestrictionState == "hiddenUntilRejoin" then
		showVoiceRestrictionEndedSnackbar()
	end

	return voiceRestrictionState ~= "normal"
end

local function fn(_)
	if FFlagProactiveVoiceRestrictionsUFR and handleRestrictedActivation() then -- inferred equivalent call
		return
	end

	if defineFastFlag2 then
		local micManager = default:GetMicManager()

		if micManager and not micManager:HasConsumer("voice_chat") and micManager:GetConsumerCount() > 0 then
			micManager:SetMicActiveForAllConsumers(micManager.localMuted ~= false, "ChromeIntegrationsToggleMic")
			v2:setLastCtx("SelfView")
			return
		end
	end

	default:ToggleMic("ChromeIntegrationsToggleMic")
	v2:setLastCtx("SelfView")

	if v3 then
		v3:onToggleMuteSelf(not default.localMuted)
	end
end

local function fn2(_)
	if FFlagProactiveVoiceRestrictionsUFR and handleRestrictedActivation() then -- inferred equivalent call
		return
	end

	default:RejoinPreviousChannel()
end

local function fn3(_)
	if FFlagProactiveVoiceRestrictionsUFR and handleRestrictedActivation() then -- inferred equivalent call
		return
	end

	default:ShowVoiceChatLoadingMessage()
end

local FFlagChangeToggleMicText = require(Chrome.Flags.FFlagChangeToggleMicText)

local v4 = Service:register({
	id = "toggle_mic_mute",
	label = FFlagChangeToggleMicText and "CoreScripts.TopBar.Mic" or "CoreScripts.TopBar.ToggleMic",
	sideSheetPlacement = SideSheetPlacement.Unibar,
	activated = fn,
	isActivated = isActivated,
	components = {
		Icon = function(_)
			local ICON_SIZE

			if FFlagTokenizeUnibarConstantsWithStyleProvider then
				ICON_SIZE = UnibarStyle.use().ICON_SIZE
			else
				ICON_SIZE = Constants.ICON_SIZE
			end

			local v4

			if FFlagEnablePlaytestModeUnibar then
				v4 = useIsPlaytestMode()
			end

			local iconStyle = FFlagEnablePlaytestModeUnibar and v4 and "MicDark" or "MicLight"
			local v5 = nil

			if defineFastFlag2 then
				local micManager = default:GetMicManager()
				local v6 = not (micManager and micManager:HasConsumer("voice_chat"))
					and micManager
					and micManager:GetConsumerCount() > 0
				local v7

				if micManager then
					v7 = micManager.localMuted
				end

				local state, setState = React.useState(v7 ~= false)
				local v8, v9 = React.useBinding(0)
				local _, setState2 = React.useState(0)
				React.useEffect(function()
					if not micManager then
						return
					end

					local eventConnection = micManager.muteChanged.Event:Connect(function(p)
						setState(p ~= false)
					end)
					local eventConnection2 = micManager.levelChanged.Event:Connect(function(p)
						v9(p)
					end)
					local eventConnection3 = micManager.hasConsumersChanged.Event:Connect(function()
						setState2(function(p)
							return p + 1
						end)
					end)
					return function()
						eventConnection:Disconnect()
						eventConnection2:Disconnect()
						eventConnection3:Disconnect()
					end
				end, { micManager })
				local v10 = state and "Muted" or "Unmuted"
				local image = v8:map(function(p)
					return default:GetIcon(v10 .. tostring(p), iconStyle)
				end)

				if v6 then
					local createElement = React.createElement
					local v11 = {
						Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Image = 0
					}

					if state then
						image = default:GetIcon(v10, iconStyle)
					end

					v11.Image = image
					v5 = createElement("ImageLabel", v11)
				end
			end

			local v6 = not FFlagProactiveVoiceRestrictionsUFR and "normal" or SignalsReact.useSignalState(function(p)
				return default:GetVoiceRestrictionState(p)
			end)

			if FFlagProactiveVoiceRestrictionsUFR and v6 == "restricted" then
				return React.createElement(Foundation.Image, {
					Image = "icons/controls/microphoneMute",
					imageStyle = { Transparency = 0.5 },
					Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
				})
			end

			if FFlagReactiveVoiceRestrictionsUFR and v6 == "hiddenUntilRejoin" then
				return React.createElement("ImageLabel", {
					Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = default:GetIcon("Muted", iconStyle)
				})
			end

			if v5 then
				return v5
			end

			return React.createElement(
				"Frame",
				{
					Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
					BackgroundTransparency = 1
				},
				{
					React.createElement(VoiceIndicatorFunc, {
						userId = tostring(Players.LocalPlayer.UserId),
						hideOnError = false,
						iconStyle = iconStyle,
						selectable = false,
						size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
						showConnectingShimmer = true
					}),
					(React.createElement(RedVoiceDot, { position = UDim2.new(1, -7, 1, -7) }))
				}
			)
		end
	}
})

local function updateMicActivated(p: string)
	isActivated:set(p == "normal" and default.localMuted == false)
end

local function applyRestrictionState(): boolean -- 7 equivalent calls inferred from this helper
	if default:GetVoiceRestrictionState(false) == "normal" then
		return false
	end

	v4.activated = handleRestrictedActivation

	if FFlagReactiveVoiceRestrictionsUFR then
		v4.availability:pinned()
	else
		v4.availability:unavailable()
	end

	return true
end

local function observeMicPresentation()
	local effect = Signals.createEffect(function(p)
		isActivated:set(default:GetVoiceRestrictionState(p) == "normal" and default.localMuted == false)
		applyRestrictionState() -- inferred equivalent call
	end)

	local eventConnection = default.muteChanged.Event:Connect(function()
		isActivated:set(default:GetVoiceRestrictionState(false) == "normal" and default.localMuted == false)
	end)

	return function()
		effect()
		eventConnection:Disconnect()
	end
end

local function applyVoiceUIVisibility()
	if FFlagProactiveVoiceRestrictionsUFR and applyRestrictionState() then -- inferred equivalent call
		return
	end

	if default.voiceUIVisible then
		v4.availability:pinned()
	else
		v4.availability:unavailable()
	end
end

local function updateMicAvailabilityFromConsumers()
	if FFlagProactiveVoiceRestrictionsUFR and applyRestrictionState() then -- inferred equivalent call
		return
	end

	local micManager = default:GetMicManager()

	if micManager and micManager:GetConsumerCount() > 0 then
		v4.availability:pinned()
	elseif not default.voiceUIVisible then
		v4.availability:unavailable()
	end
end

local function updateVoiceState(_, p)
	if FFlagProactiveVoiceRestrictionsUFR and applyRestrictionState() then -- inferred equivalent call
		return
	end

	if p ~= Enum.VoiceChatState.Ended then
		if v then
			if FFlagProactiveVoiceRestrictionsUFR then
				if not applyRestrictionState() then -- inferred equivalent call
					if default.voiceUIVisible then
						v4.availability:pinned()
					else
						v4.availability:unavailable()
					end
				end
			elseif default.voiceUIVisible then
				v4.availability:pinned()
			else
				v4.availability:unavailable()
			end
		else
			v4.availability:pinned()
		end
	elseif defineFastFlag2 then
		updateMicAvailabilityFromConsumers()
	else
		v4.availability:unavailable()
	end

	local v5 = p == Enum.VoiceChatState.Failed
	local v6 = p == Enum.VoiceChatState.Joining or p == Enum.VoiceChatState.JoiningRetry

	if v5 then
		v4.activated = fn2
	elseif v6 then
		v4.activated = fn3
	else
		v4.activated = fn
	end
end

if isVoiceChatSupported() then
	if FFlagProactiveVoiceRestrictionsUFR then
		script.Destroying:Once(observeMicPresentation())
	end

	default:asyncInit():andThen(function()
		local service = default:getService()

		if service then
			service.StateChanged:Connect(updateVoiceState)
			default:SetupParticipantListeners()

			if v then
				default.showVoiceUI.Event:Connect(applyVoiceUIVisibility)
				default.hideVoiceUI.Event:Connect(applyVoiceUIVisibility)

				if FFlagProactiveVoiceRestrictionsUFR and applyRestrictionState() then -- inferred equivalent call
					return
				end

				if default.voiceUIVisible then
					v4.availability:pinned()
				else
					v4.availability:unavailable()
				end
			elseif FFlagProactiveVoiceRestrictionsUFR then
				if not applyRestrictionState() then -- inferred equivalent call
					v4.availability:pinned()
				end
			else
				v4.availability:pinned()
			end
		end
	end):catch(function() end)
end

if not defineFastFlag2 then
	return v4
end

local micManager = default:GetMicManager()

if micManager and micManager.hasConsumersChanged then
	micManager.hasConsumersChanged.Event:Connect(function()
		updateMicAvailabilityFromConsumers()
		micManager:SetMicIndicatorReady(micManager:GetConsumerCount() > 0)
	end)
	updateMicAvailabilityFromConsumers()
	micManager:SetMicIndicatorReady(micManager:GetConsumerCount() > 0)
end

return v4
